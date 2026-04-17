#import "../../00-templates/base_document.typ" as base-document
#import "../specifica_tecnica/st_lib.typ" as st

#let metadata = yaml(sys.inputs.meta-path)
#show figure.where(kind: table): set block(breakable: true)
#show table.cell: set par(justify: false)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Specifica tecnica della WebApp frontend: architettura, gestione autenticazione, integrazione API tramite OpenAPI generator, streaming SSE per telemetria e gestione dell'impersonazione.",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione

  La WebApp `notip-frontend` è l'interfaccia utente del sistema NoTIP, sviluppata in Angular 21 con architettura
  standalone. Il frontend ha il compito di presentare all'utente i dati di telemetria provenienti dai gateway IoT,
  consentire la gestione di tenant, utenti, gateway e sensori, configurare alert e soglie, consultare audit log e costi,
  e inviare comandi ai gateway. Supporta tre ruoli utente (system_admin, tenant_admin, tenant_user) con autorizzazione
  basata su rotte e meccanismi di impersonazione che permettono ai system admin di operare nel contesto di un tenant.

  Il frontend comunica con due backend distinti: `notip-management-api` per le operazioni di gestione e configurazione,
  e `notip-data-api` per le query e lo streaming di telemetria. L'autenticazione è gestita da Keycloak tramite PKCE, con
  supporto al rinnovo automatico del token e all'impersonazione.

  = Dipendenze e configurazione

  == Variabili d'ambiente

  La configurazione del frontend avviene principalmente tramite `app.config.ts`. Non sono presenti variabili `.env`
  obbligatorie nel codice applicativo: i parametri runtime principali sono costanti di bootstrap e path del reverse
  proxy.

  #figure(
    caption: [Configurazione del frontend `notip-frontend`],
  )[
    #table(
      columns: (auto, auto, auto, auto),
      [Campo], [Variabile/Config], [Default], [Obbligatorio],

      [KeycloakUrl], [Configurato in `app.config.ts` come `/auth`], [`/auth`], [Si],
      [KeycloakRealm], [Configurato in `app.config.ts`], [`notip`], [Si],
      [KeycloakClientId], [Configurato in `app.config.ts`], [`notip-frontend`], [Si],
      [SessionTimeout], [Configurato in `app.config.ts` come `10 * 60 * 1000`], [10 min], [No],
      [DataApiBasePath], [`/api/data`], [`/api/data`], [Si],
      [MgmtApiBasePath], [`/api/mgmt`], [`/api/mgmt`], [Si],
    )
  ]

  Il frontend è servito attraverso un reverse proxy (Nginx) che instrada le chiamate ai path `/api/data`, `/api/mgmt` e
  `/auth` verso i rispettivi backend. Non esiste una directory `src/environments/`: la configurazione è interamente
  gestita in `app.config.ts` e i path del reverse proxy sono iniettati a livello di infrastruttura Docker.

  == Sequenza di avvio

  La sequenza di inizializzazione dell'applicazione Angular è la seguente:

  #figure(
    caption: [Sequenza di avvio dell'applicazione frontend],
  )[
    #table(
      columns: (auto, auto, auto, auto),
      [Step], [Componente], [Azione], [Bloccante?],

      [0], [Bootstrap Angular], [Avvio del runtime Angular e caricamento di `app.config.ts`], [Si],

      [1], [KeycloakModule], [Inizializza Keycloak con `onLoad: 'login-required'` e PKCE S256], [Si],

      [2], [AutoRefreshTokenService], [Configura il rinnovo automatico del token con timeout di 10 minuti], [Si],

      [3], [HttpClientModule], [Registra gli interceptor `authInterceptor` e `errorInterceptor`], [Si],

      [4],
      [RouterModule],
      [Configura le rotte con guardie (AuthGuard, RoleGuard, HomeRedirectGuard) e resolver (DashboardResolver)],
      [Si],

      [5], [provideMgmtApi / provideDataApi], [Registra i client OpenAPI generati con i base path configurati], [Si],

      [6], [AuthService], [Registra i provider per `SESSION_LIFECYCLE` e `IMPERSONATION_STATUS`], [Si],

      [7],
      [AuthGuard],
      [Al primo accesso a una rotta protetta: verifica inizializzazione Keycloak e presenza token, avvia threshold
        prefetch],
      [Si],

      [8], [RoleGuard], [Verifica il ruolo dell'utente rispetto ai ruoli richiesti dalla rotta], [Si],

      [9], [Browser rendering], [Rendering del componente pagina risolto dalla route], [No],
    )
  ]

  = Architettura logica

  L’applicazione adotta un'architettura *Model-View* (nello specifico Model-View-ViewModel), tipica dell'ecosistema
  Angular, implementata attraverso componenti standalone senza l'uso di NgModules. Questo paradigma architetturale
  separa nettamente la logica di business dalla presentazione, assegnando responsabilità precise:

  - *Model:* Rappresenta i dati di dominio e la logica applicativa. È implementato attraverso i Service, le interfacce e
    le classi. Il Model è responsabile della gestione dei flussi di dati asincroni e della comunicazione con il backend
    (es. chiamate HTTP e connessioni SSE), avvalendosi in modo massiccio della libreria RxJS.
  - *View:* Costituisce l'interfaccia utente (template HTML e fogli di stile CSS). È un layer puramente presentazionale,
    reattivo e completamente disaccoppiato dalla logica complessa di recupero o manipolazione dei dati.
  - *ViewModel / Controller:* I componenti standalone agiscono da ponte (intermediari) tra il Model e la View.
    Interrogano i servizi per ottenere i dati e gestiscono lo stato locale avvalendosi dello state management basato sui
    segnali di Angular (signal(), computed(), effect()). Questo permette di esporre alla View uno stato reattivo
    facilmente consumabile e di gestire l'interazione dell'utente (Subject e comunicazioni inter-componente).

  A livello organizzativo e di file system, l'applicazione supporta questa architettura Model-View suddividendo il
  codice in tre aree orizzontali principali (Core, Features e Shared). Questo garantisce che la logica di business
  (Model, contenuta soprattutto nel Core e nei servizi Feature) sia ben isolata dalla presentazione, mantenendo
  dipendenze unidirezionali e impedendo che la View conosca i dettagli di implementazione dei dati.

  Lo state management è basato su *segnali Angular* (signal(), computed(), effect()) per lo stato locale dei componenti
  e dei servizi di feature, combinati con *RxJS* per la gestione di flussi asincroni (SSE, HTTP) e la comunicazione
  inter-componente tramite Subject.

  == Layout delle cartelle

  ```text
  notip-frontend/src/
  ├── app/
  │   ├── core/
  │   │   ├── auth/
  │   │   │   └── contracts.ts          # Interfacce SESSION_LIFECYCLE, IMPERSONATION_STATUS
  │   │   ├── guards/
  │   │   │   ├── auth.guard.ts          # Guardia di autenticazione
  │   │   │   ├── role.guard.ts          # Guardia basata sui ruoli
  │   │   │   └── *.spec.ts
  │   │   ├── interceptors/
  │   │   │   ├── auth.interceptor.ts    # Iniezione bearer token
  │   │   │   ├── error.interceptor.ts   # Gestione 401/403
  │   │   │   └── *.spec.ts
  │   │   ├── models/
  │   │   │   ├── enums.ts               # UserRole, TenantStatus, GatewayStatus, ecc.
  │   │   │   ├── gateway.ts             # Gateway, ObfuscatedGateway, AddGatewayParameters
  │   │   │   ├── measure.ts             # TelemetryEnvelope, DecryptedEnvelope, CheckedEnvelope
  │   │   │   ├── sensor.ts              # Sensor
  │   │   │   ├── tenant.ts              # Tenant, CreateTenantParameters
  │   │   │   ├── user.ts                # ViewUser, CreatedUser, UserParameters
  │   │   │   ├── alert.ts               # Alerts, AlertsConfig, AlertsFilter
  │   │   │   ├── threshold.ts           # Threshold, SensorThreshold, TypeThreshold
  │   │   │   ├── costs.ts               # Costs
  │   │   │   ├── command.ts             # Command types
  │   │   │   ├── client.ts              # API Client types
  │   │   │   └── audit.ts               # Logs, LogsFilter
  │   │   ├── resolvers/
  │   │   │   └── dashboard.resolver.ts  # Risolve dataMode (clear/obfuscated)
  │   │   └── services/
  │   │       ├── auth.service.ts        # Gestione Keycloak, impersonazione, sessione
  │   │       ├── threshold-prefetch.service.ts  # Prefetch periodico soglie
  │   │       ├── threshold.service.ts   # Cache soglie sensori
  │   │       ├── measure-bounds-evaluation.service.ts  # Valutazione bounds
  │   │       └── obfuscated-stream-manager.service.ts # Gestione SSE
  │   ├── features/
  │   │   ├── admin/
  │   │   │   ├── components/
  │   │   │   │   ├── admin-gateway-form/    # Form creazione gateway admin
  │   │   │   │   ├── admin-gateway-table/   # Tabella gateway admin
  │   │   │   │   ├── impersonate-button/    # Bottone impersonazione
  │   │   │   │   ├── tenant-form/           # Form creazione/modifica tenant
  │   │   │   │   ├── tenant-table/          # Tabella tenant
  │   │   │   │   └── tenant-user-list/      # Lista utenti tenant
  │   │   │   ├── pages/
  │   │   │   │   ├── tenant-manager/    # Gestione tenant (system_admin)
  │   │   │   │   └── tenant-detail/     # Dettaglio tenant con utenti
  │   │   │   └── pages/admin-gateway-list/  # Gateway admin
  │   │   ├── alerts/
  │   │   │   ├── components/
  │   │   │   │   ├── alert-config-form/   # Form config timeout alert
  │   │   │   │   └── alert-filter-panel/  # Pannello filtri alert
  │   │   │   ├── pages/
  │   │   │   │   ├── alert-list/        # Lista alert gateway offline
  │   │   │   │   └── alert-config/      # Configurazione timeout alert
  │   │   │   └── services/
  │   │   │       └── alert.service.ts
  │   │   ├── dashboard/
  │   │   │   ├── pages/data-dashboard/  # Dashboard telemetria principale
  │   │   │   ├── components/
  │   │   │   │   ├── filter-panel/      # Pannello filtri multi-select
  │   │   │   │   ├── telemetry-chart/   # Grafico Chart.js
  │   │   │   │   └── telemetry-table/   # Tabella dati telemetria
  │   │   │   └── services/
  │   │   │       ├── decrypted-measure.service.ts      # Decrittografia SDK
  │   │   │       ├── obfuscated-measure.service.ts     # Stream offuscato
  │   │   │       └── validated-measure-facade.service.ts # Validazione bounds
  │   │   ├── gateways/
  │   │   │   ├── pages/
  │   │   │   │   ├── gateway-list/      # Lista gateway tenant
  │   │   │   │   └── gateway-detail/    # Dettaglio gateway con comandi
  │   │   │   ├── components/
  │   │   │   │   ├── gateway-card/
  │   │   │   │   ├── gateway-actions/
  │   │   │   │   ├── gateway-rename-modal/
  │   │   │   │   └── command-modal/
  │   │   │   └── services/
  │   │   │       ├── gateway.service.ts
  │   │   │       └── command.service.ts
  │   │   ├── mgmt/
  │   │   │   ├── api-clients/
  │   │   │   │   ├── components/
  │   │   │   │   │   └── api-client-table/    # Tabella client API
  │   │   │   │   ├── pages/
  │   │   │   │   │   └── api-client-list/     # Lista client API
  │   │   │   │   └── services/
  │   │   │   │       └── clients.service.ts
  │   │   │   ├── audit/
  │   │   │   │   ├── components/
  │   │   │   │   │   ├── audit-filter-panel/  # Pannello filtri audit
  │   │   │   │   │   └── audit-log-table/     # Tabella audit log
  │   │   │   │   ├── pages/
  │   │   │   │   │   └── audit-log/           # Pagina audit log
  │   │   │   │   └── services/
  │   │   │   │       └── audit.service.ts
  │   │   │   ├── costs/
  │   │   │   │   ├── components/
  │   │   │   │   │   └── cost-card/           # Card costi tenant
  │   │   │   │   ├── pages/
  │   │   │   │   │   └── cost-dashboard/      # Dashboard costi
  │   │   │   │   └── services/
  │   │   │   │       └── costs.service.ts
  │   │   │   ├── thresholds/
  │   │   │   │   ├── components/
  │   │   │   │   │   ├── threshold-form/      # Form soglie
  │   │   │   │   │   └── threshold-table/     # Tabella soglie
  │   │   │   │   └── pages/
  │   │   │   │       └── threshold-settings/  # Configurazione soglie
  │   │   │   └── users/
  │   │   │       ├── components/
  │   │   │       │   ├── user-form/           # Form utente
  │   │   │       │   └── user-table/          # Tabella utenti
  │   │   │       ├── pages/
  │   │   │       │   └── user-list/           # Lista utenti tenant
  │   │   │       └── services/
  │   │   │           └── user.service.ts
  │   │   ├── sensors/
  │   │   │   ├── pages/
  │   │   │   │   ├── sensor-list/       # Lista sensori
  │   │   │   │   └── sensor-detail/     # Dettaglio sensore
  │   │   │   └── services/
  │   │   └── system/
  │   │       └── pages/error/           # Pagina di errore generica
  │   ├── generated/
  │   │   └── openapi/
  │   │       ├── notip-management-api-openapi/  # Client API management
  │   │       └── notip-data-api-openapi/        # Client API data
  │   └── shared/
  │       ├── components/
  │       │   ├── sidebar/               # Navigazione laterale role-based
  │       │   ├── modal-layer/           # Overlay modale generico
  │       │   ├── multi-select-dropdown/ # Dropdown multi-selezione con ricerca
  │       │   ├── status-badge/          # Badge colorati per stato
  │       │   ├── delete-confirm-modal/  # Modale conferma cancellazione
  │       │   ├── impersonation-tag/     # Tag "OBFUSCATED MODE"
  │       │   ├── logout-button/         # Bottone logout
  │       │   ├── profile-section/       # Sezione profilo utente
  │       ├── pipes/
  │       │   └── rome-date-time.pipe.ts  # Pipe per fuso orario Roma
  │       └── utils/
  │           └── rome-timezone.util.ts  # Utility conversione fuso orario
  ├── api-contracts/
  │   └── openapi/
  │       ├── notip-data-api-openapi.yaml
  │       └── notip-management-api-openapi.yaml
  ├── scripts/
  │   └── generate-openapi.sh
  ├── index.html
  ├── main.ts
  └── styles.css
  ```

  > *Nota:* Non esiste una directory `src/environments/`. La configurazione runtime è gestita interamente tramite
  `app.config.ts` e i path del reverse proxy Nginx (`/api/data`, `/api/mgmt`, `/auth`).

  == Strati architetturali

  #figure(
    caption: [Strati architetturali del frontend `notip-frontend`],
  )[
    #table(
      columns: (1fr, 1.5fr, 1.5fr, 2fr),
      [Strato], [Package], [Componenti], [Responsabilità],

      [Presentation],
      [`src/app/features/*/pages/`, `src/app/features/*/components/`, `src/app/shared/components/`,
        `src/app/shared/pipes/`],
      [Componenti Angular standalone, Template HTML, CSS, Pipe custom],
      [Rendering UI, gestione interazioni utente, composizione di componenti figli, binding con servizi tramite segnali
        e Observable. I componenti di pagina orchestrano la logica di feature, mentre i componenti shared sono
        riutilizzabili trasversalmente. Le pipe custom gestiscono la formattazione temporale con fuso orario Roma.],

      [Feature Services],
      [`src/app/features/*/services/`, `src/app/core/services/`],
      [Servizi Angular con stato locale (segnali), wrapper client API, gestione flussi di business logic di dominio],
      [Astrazione sui client API generati, gestione stato locale con segnali (`signal()`, `asReadonly()`),
        orchestrazione chiamate HTTP, trasformazione DTO in modelli di dominio, caching, polling per stato comandi.
        Servizi come `GatewayService`, `CommandService`, `DecryptedMeasureService` incapsulano la logica specifica di
        dominio.],

      [Generated API Clients],
      [`src/app/generated/openapi/notip-management-api-openapi/`, `src/app/generated/openapi/notip-data-api-openapi/`],
      [Client Angular auto-generati da OpenAPI Generator (`typescript-angular`)],
      [Tipizzazione forte delle chiamate HTTP verso management-api e data-api. Generati automaticamente dagli specchi
        OpenAPI tramite script `generate-openapi.sh`. Forniscono classi come `GatewaysService`, `MeasuresService`,
        `AdminTenantsService`, ecc. con metodi tipizzati e gestione error integrata.],

      [Core Infrastructure],
      [`src/app/core/guards/`, `src/app/core/interceptors/`, `src/app/core/auth/`, `src/app/core/resolvers/`,
        `src/app/core/models/`],
      [AuthGuard, RoleGuard, HomeRedirectGuard, authInterceptor, errorInterceptor, AuthService, DashboardResolver,
        modelli di dominio],
      [Autenticazione Keycloak con PKCE, iniezione automatica del bearer token, gestione errori HTTP (401 -> redirect
        /error, 403 -> forbidden), controllo accesso basato sui ruoli, risoluzione rotte condizionale, definizione
        contratti typed per l'intero dominio (Gateway, Sensor, Measure, Tenant, User, Alert, Threshold, Command, Audit,
        Cost).],
    )
  ]

  == Architettura dell'applicazione

  #figure(
    caption: [Architettura del frontend `notip-frontend`],
  )[
    #align(center)[
      #image("assets/01-app-architecture.svg")
    ]
  ]

  == Struttura delle rotte

  #figure(
    caption: [Tabella delle rotte dell'applicazione],
  )[
    #table(
      columns: (1.3fr, 2.2fr, 1fr, 1fr),
      [Path], [Componente], [Ruoli Richiesti], [Descrizione],

      [`/dashboard`],
      [DataDashboardPageComponent],
      [`tenant_user`, `tenant_admin`],
      [Dashboard telemetria con modalità stream e query],

      [`/gateways`], [GatewayListPageComponent], [`tenant_user`, `tenant_admin`], [Lista gateway del tenant con card],

      [`/gateways/:id`],
      [GatewayDetailPageComponent],
      [`tenant_user`, `tenant_admin`],
      [Dettaglio gateway, sensori, comandi, telemetria live],

      [`/sensors`], [SensorListPageComponent], [`tenant_user`, `tenant_admin`], [Lista sensori del tenant],

      [`/sensors/:id`],
      [SensorDetailPageComponent],
      [`tenant_user`, `tenant_admin`],
      [Dettaglio sensore con telemetria],

      [`/alerts`], [AlertListPageComponent], [`tenant_user`, `tenant_admin`], [Lista alert gateway offline],

      [`/alerts/config`],
      [AlertConfigPageComponent],
      [`tenant_user`, `tenant_admin`],
      [Configurazione timeout alert per gateway/tenant],

      [`/mgmt/users`], [UserListPageComponent], [`tenant_admin`], [Gestione utenti del tenant],

      [`/mgmt/limits`],
      [ThresholdSettingsPageComponent],
      [`tenant_user`, `tenant_admin`],
      [Configurazione soglie min/max per sensori],

      [`/mgmt/api`], [ApiClientListPageComponent], [`tenant_admin`], [Gestione client API del tenant],

      [`/mgmt/logs`], [AuditLogPageComponent], [`tenant_admin`], [Consultazione audit log tenant],

      [`/mgmt/costs`], [CostDashboardPageComponent], [`tenant_admin`], [Dashboard costi (storage e banda)],

      [`/admin/tenants`], [TenantManagerPageComponent], [`system_admin`], [Gestione tenant del sistema],

      [`/admin/tenants/:id/users`], [TenantDetailPageComponent], [`system_admin`], [Dettaglio tenant con lista utenti],

      [`/admin/gateways`], [AdminGatewayListPageComponent], [`system_admin`], [Gestione gateway a livello sistema],

      [`/error`], [ErrorPageComponent], [-], [Pagina di errore con reason e retryUrl],

      [`**`], [redirect], [-], [Redirect a `/error?reason=not-found`],
    )
  ]

  == Route Guards

  L'applicazione definisce tre route guards principali per proteggere le rotte e gestire l'accesso in base
  all'autenticazione e ai ruoli:

  #figure(
    caption: [Route guards del frontend],
  )[
    #table(
      columns: (auto, auto, auto),
      [Route guard], [Tipo], [Responsabilità],

      [AuthGuard],
      [`CanActivate`],
      [Verifica che Keycloak sia inizializzato e che l'utente possieda un token JWT valido. Se non autenticato,
        reindirizza al login di Keycloak. Al primo accesso valido, avvia il `ThresholdPrefetchService` per precaricare
        le soglie di validazione della telemetria.],

      [RoleGuard],
      [`CanActivate`],
      [Confronta il ruolo dell'utente (estratto dal JWT) con i ruoli richiesti dalla rotta (`data['roles']`). Se il
        ruolo non è autorizzato, reindirizza: i `system_admin` verso `/admin/tenants`, gli altri verso `/dashboard`.],

      [HomeRedirectGuard],
      [`CanActivate`],
      [Utilizzato sulla rotta vuota (`/`) per reindirizzare automaticamente in base al ruolo: `system_admin` verso
        `/admin/tenants`, tutti gli altri verso `/dashboard`.],
    )
  ]

  === AuthGuard

  #figure(caption: [Campi di AuthGuard])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`auth`], [`AuthService`], [Servizio di autenticazione iniettato],
      [`thresholdPrefetch`], [`ThresholdPrefetchService`], [Servizio di prefetch soglie iniettato],
    )
  ]

  #figure(caption: [Metodi pubblici di AuthGuard])[
    #table(
      columns: (auto, auto, auto),
      [Metodo], [Firma], [Comportamento],
      [`canActivate()`],
      [`(): Promise<boolean>`],
      [Verifica inizializzazione auth, richiede token valido e avvia `thresholdPrefetch.start()` al primo accesso
        valido. In caso di errore/autenticazione assente avvia `login()` e ritorna `false`.],
    )
  ]

  === RoleGuard e HomeRedirectGuard

  #figure(caption: [Campi di RoleGuard e HomeRedirectGuard])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`auth`], [`AuthService`], [Risoluzione ruolo effettivo dell'utente],
      [`router`], [`Router`], [Costruzione `UrlTree` di redirect],
    )
  ]

  #figure(caption: [Metodi pubblici di RoleGuard e HomeRedirectGuard])[
    #table(
      columns: (2fr, 1.7fr, 1.7fr),
      [Metodo], [Firma], [Comportamento],
      [`RoleGuard.canActivate(route)`],
      [`(route: ActivatedRouteSnapshot): boolean | UrlTree`],
      [Confronta `auth.getRole()` con `route.data['roles']`. Se il ruolo non e autorizzato, redirige `system_admin` a
        `/admin/tenants` e gli altri a `/dashboard`.],

      [`HomeRedirectGuard.canActivate()`],
      [`(): UrlTree`],
      [Redirezione automatica dalla home: `system_admin` su `/admin/tenants`, altri ruoli su `/dashboard`.],
    )
  ]

  = Autenticazione e autorizzazione

  == Keycloak integration

  L'autenticazione è gestita da Keycloak tramite la libreria `keycloak-angular`. La configurazione prevede:

  - *PKCE method*: S256 (Proof Key for Code Exchange)
  - *OnLoad*: `login-required` (l'utente deve autenticarsi per accedere)
  - *Check login iframe*: disabilitato (`false`)
  - *Auto-refresh token*: abilitato tramite `withAutoRefreshToken` con timeout di sessione di 10 minuti
  - *Inactivity timeout*: logout automatico al superamento del timeout (gestito da `UserActivityService`)

  I servizi `AutoRefreshTokenService` e `UserActivityService` sono registrati in `app.config.ts` come provider Keycloak
  e gestiscono il rinnovo automatico del token e il monitoraggio dell'attività utente.

  == AuthService

  Il servizio `AuthService` (`src/app/core/services/auth.service.ts`) è il fulcro della gestione identitaria e
  implementa le interfacce `SessionLifeCycle` e `ImpersonationStatus`. Le sue responsabilità includono:

  #figure(caption: [Campi principali di AuthService])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`keycloak`], [`Keycloak` (via `inject()`)], [Client Keycloak iniettato],
      [`keycloakEventSignal`], [`Signal<KeycloakEvent>`], [Signal eventi Keycloak],
      [`authApi`], [`AuthApiService` (via `inject()`)], [Client OpenAPI per endpoint auth management-api],
      [`logoutSubject`], [`Subject<void>`], [Canale interno per lifecycle di logout],
      [`impersonatingSignal`], [`Signal<boolean>`], [Stato impersonazione read-only verso i consumer],
      [`impersonationTokenSignal`], [`Signal<string | null>`], [Token impersonato corrente],
      [`impersonationPayloadSignal`], [`Signal<JwtPayload | null>`], [Payload JWT impersonato],
      [`STORAGE_KEY`], [`'impersonation'`], [Chiave `sessionStorage` per persistenza contesto],
    )
  ]

  #figure(caption: [Metodi pubblici di AuthService])[
    #table(
      columns: (2fr, 1.7fr, 1.7fr),
      [Metodo], [Firma], [Comportamento],
      [`init()`], [`(): Promise<boolean>`], [Verifica stato `keycloak.authenticated`],
      [`login()`], [`(): void`], [Redirect verso login Keycloak],
      [`logout()`], [`(): void`], [Pulizia contesto impersonazione, emit su `logout$`, logout Keycloak],
      [`getToken()`],
      [`(): Promise<string>`],
      [Ritorna token impersonato se presente, altrimenti token Keycloak con `updateToken(30)`],

      [`getUsername()`],
      [`(): Promise<string>`],
      [Risoluzione nome utente da claims `preferred_username|username|name`],

      [`getRole()`],
      [`(): UserRole`],
      [Mapping ruoli da JWT (`realm_access`, `resource_access`) con fallback `tenant_user`],

      [`getTenantId()`], [`(): string`], [Estrae claim `tenant_id`],
      [`getUserId()`], [`(): string`], [Estrae claim `sub`],
      [`setImpersonating(value)`],
      [`(value: boolean): void`],
      [Attiva/disattiva stato impersonazione e sincronizza storage],

      [`stopImpersonation()`], [`(): void`], [Disattiva impersonazione],
      [`startImpersonation(targetUserId)`],
      [`(targetUserId: string): Observable<string>`],
      [Chiama `/auth/impersonate`, salva token/payload e attiva segnali],
    )
  ]

  #figure(caption: [Metodi privati di AuthService])[
    #table(
      columns: (auto, auto),
      [Metodo], [Comportamento],
      [`saveImpersonationContext(token, payload)`], [Persistenza JSON in `sessionStorage`],
      [`clearImpersonationStorage()`], [Rimozione storage locale impersonazione],
      [`loadImpersonating()`], [Ripristina flag impersonazione da storage],
      [`loadImpersonationToken()`], [Ripristina token impersonazione],
      [`loadImpersonationPayload()`], [Ripristina payload impersonazione],
      [`collectRoles(payload)`], [Accorpa ruoli da claim multipli],
      [`decodeTokenPayload(token)`], [Decodifica base64url del payload JWT],
      [`decodeJwtPayload()`], [Risoluzione payload corrente (impersonato o keycloak)],
      [`clearImpersonationContext()`], [Reset segnali e storage],
    )
  ]

  == Impersonazione

  Il sistema supporta l'impersonazione: un `system_admin` può assumere l'identità di un utente tenant per operare nel
  suo contesto. Il flusso è:

  1. Il system admin seleziona un utente tenant dalla pagina di dettaglio del tenant;
  2. `AuthService.startImpersonation()` scambia il token (tramite OAuth2 Token Exchange lato management-api) e salva il
    contesto impersonato in `sessionStorage`;
    3. La pagina `TenantDetail` naviga verso `/dashboard`; `AuthService` ripristina lo stato da storage anche dopo
      refresh;
  4. `DashboardResolver` rileva lo stato di impersonazione e imposta `dataMode: 'obfuscated'`;
  5. Tutti i componenti che consumano telemetria usano endpoint e modalità offuscate;
    6. Le azioni sensibili sono limitate: la rinomina gateway è nascosta in UI e gli endpoint backend con
      `BlockImpersonationGuard` rifiutano operazioni bloccate;
  7. L'UI mostra un banner "Impersonation mode" e un tag "OBFUSCATED MODE";
    8. Lo stop impersonazione dalla sidebar chiude il contesto e riporta l'utente su `/admin/tenants`.

  = Interceptor HTTP

  L'applicazione registra due interceptors HTTP globali:

  == AuthInterceptor

  `authInterceptor` (`src/app/core/interceptors/auth.interceptor.ts`) intercetta ogni richiesta HTTP in uscita e:

  #figure(caption: [Struttura di AuthInterceptor])[
    #table(
      columns: (auto, auto),
      [Elemento], [Descrizione],
      [`Tipo`], [`HttpInterceptorFn`],
      [`Dipendenze`], [`AuthService` via `inject()`],
      [`Pipeline RxJS`], [`from(auth.getToken()) -> switchMap(...)`],
      [`Header gestito`], [`Authorization: Bearer <token>`],
    )
  ]

  == ErrorInterceptor

  `errorInterceptor` (`src/app/core/interceptors/error.interceptor.ts`) gestisce le risposte HTTP con errore:

  #figure(caption: [Regole di ErrorInterceptor])[
    #table(
      columns: (auto, auto),
      [Caso], [Comportamento],
      [`Errore non HTTP`], [Propaga errore originale con `throwError()`],
      [`401 Unauthorized`], [Redirect a `/error?reason=unauthorized&retryUrl=...` se non si e già sulla rotta `/error`],
      [`403 Forbidden`], [Redirect a `/error?reason=forbidden`],
      [`Altri status`], [Propagazione errore senza redirect aggiuntivo],
    )
  ]

  = Modelli di dominio

  I modelli di dominio sono definiti in `src/app/core/models/` e rappresentano i contratti typed tra i vari strati
  dell'applicazione.

  == Enums

  #figure(
    caption: [Enumerazioni del dominio],
  )[
    #table(
      columns: (auto, auto),
      [Enum], [Valori],

      [UserRole], [`system_admin`, `tenant_admin`, `tenant_user`],

      [TenantStatus], [`active`, `suspended`],

      [CommandStatus], [`queued`, `ack`, `nack`, `expired`, `timeout`],

      [AlertsType], [`GATEWAY_OFFLINE`],

      [GatewayStatus], [`online`, `paused`, `provisioning`, `offline`],

      [CmdGatewayStatus], [`online`, `paused`],
    )
  ]

  == Gateway

  #figure(caption: [Campi di Gateway])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`gatewayId`], [`string`], [Identificativo univoco del gateway],
      [`name`], [`string`], [Nome visualizzato del gateway],
      [`status`], [`GatewayStatus`], [Stato operativo corrente],
      [`lastSeenAt`], [`string | null`], [Ultimo timestamp di contatto (opzionale)],
      [`provisioned`], [`boolean`], [Indica se il provisioning e stato completato],
      [`firmwareVersion`], [`string | null`], [Versione firmware corrente (opzionale)],
      [`sendFrequencyMs`], [`number`], [Intervallo di invio telemetria in millisecondi],
    )
  ]

  #figure(caption: [Campi di ObfuscatedGateway])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`gatewayId`], [`string`], [Identificativo gateway],
      [`tenantId`], [`string`], [Tenant proprietario del gateway],
      [`model`], [`string`], [Modello hardware gateway],
      [`firmware`], [`string | null`], [Versione firmware in modalita offuscata (opzionale)],
      [`provisioned`], [`boolean`], [Stato di provisioning],
      [`factoryId`], [`string`], [Identificativo fabbrica/provisioning],
      [`createdAt`], [`string`], [Data di creazione del gateway],
    )
  ]

  #figure(caption: [Campi di AddGatewayParameters])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`factoryId`], [`string`], [Identificativo fabbrica del gateway da registrare],
      [`tenantId`], [`string`], [Tenant a cui associare il gateway],
      [`factoryKey`], [`string`], [Chiave di registrazione/provisioning],
      [`model`], [`string`], [Modello del gateway da registrare],
    )
  ]

  == Telemetria

  #figure(caption: [Campi di TelemetryEnvelope])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`gatewayId`], [`string`], [Gateway sorgente della misura],
      [`sensorId`], [`string`], [Sensore sorgente della misura],
      [`sensorType`], [`string`], [Tipo sensore (es. temperatura, umidita)],
      [`timestamp`], [`string`], [Timestamp ISO 8601 della rilevazione],
      [`keyVersion`], [`number`], [Versione chiave usata per la cifratura],
      [`encryptedData`], [`string`], [Payload cifrato],
      [`iv`], [`string`], [Initialization vector],
      [`authTag`], [`string`], [Tag di autenticazione GCM],
    )
  ]

  #figure(caption: [Campi di DecryptedEnvelope])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`gatewayId`], [`string`], [Gateway sorgente],
      [`sensorId`], [`string`], [Sensore sorgente],
      [`sensorType`], [`string`], [Tipo del sensore],
      [`timestamp`], [`string`], [Timestamp ISO 8601],
      [`value`], [`number`], [Valore numerico in chiaro],
      [`unit`], [`string`], [Unita di misura],
    )
  ]

  #figure(caption: [Campi di CheckedEnvelope])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`gatewayId`], [`string`], [Ereditato da `DecryptedEnvelope`],
      [`sensorId`], [`string`], [Ereditato da `DecryptedEnvelope`],
      [`sensorType`], [`string`], [Ereditato da `DecryptedEnvelope`],
      [`timestamp`], [`string`], [Ereditato da `DecryptedEnvelope`],
      [`value`], [`number`], [Ereditato da `DecryptedEnvelope`],
      [`unit`], [`string`], [Ereditato da `DecryptedEnvelope`],
      [`isOutofBounds`], [`boolean`], [Indica se il valore supera i bound configurati],
    )
  ]

  #figure(caption: [Campi di ObfuscatedEnvelope])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`gatewayId`], [`string`], [Gateway sorgente],
      [`sensorId`], [`string`], [Sensore sorgente],
      [`sensorType`], [`string`], [Tipo del sensore],
      [`timestamp`], [`string`], [Timestamp della misura in modalita offuscata],
    )
  ]

  == Tenant

  #figure(caption: [Campi di Tenant])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`tenantId`], [`string`], [Identificativo univoco tenant],
      [`name`], [`string`], [Nome tenant],
      [`status`], [`TenantStatus`], [Stato tenant (active/suspended)],
      [`suspensionIntervalDays`], [`number | null`], [Giorni prima della sospensione automatica (opzionale)],
      [`createdAt`], [`string`], [Data di creazione tenant],
    )
  ]

  == User

  #figure(caption: [Campi di ViewUser])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`userId`], [`string`], [Identificativo univoco utente],
      [`role`], [`UserRole`], [Ruolo applicativo],
      [`username`], [`string`], [Username visualizzato],
      [`email`], [`string`], [Email utente],
      [`lastAccess`], [`string | null`], [Ultimo accesso noto, null se assente],
    )
  ]

  = Servizi core

  I servizi singleton dell'applicazione forniscono funzionalità trasversali a tutte le feature.

  == ObfuscatedStreamManagerService

  #figure(caption: [Campi di ObfuscatedStreamManagerService])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`auth`], [`AuthService`], [Recupero token e login fallback],
      [`abortController`], [`AbortController | null`], [Gestione lifecycle stream SSE],
      [`channel`], [`ObservableChannel<TelemetryEnvelope> | null`], [Canale di emissione per subscriber],
      [`streamSessionId`], [`number`], [Protezione da stream stale concorrenti],
    )
  ]

  #figure(caption: [Metodi pubblici di ObfuscatedStreamManagerService])[
    #table(
      columns: (auto, auto, auto),
      [Metodo], [Firma], [Comportamento],
      [`openStream(sp)`],
      [`(sp: StreamParameters): Observable<TelemetryEnvelope>`],
      [Apre stream SSE, crea canale observabile e avvia sessione],

      [`closeStream()`], [`(): void`], [Chiude stream corrente, abortisce fetch e completa il canale],
    )
  ]

  #figure(caption: [Metodi privati di ObfuscatedStreamManagerService])[
    #table(
      columns: (auto, auto),
      [Metodo], [Comportamento],
      [`startStream(...)`], [Handshake SSE con bearer token e gestione callback `onopen/onmessage/onerror/onclose`],
      [`buildQuery(sp)`], [Costruzione querystring da filtri gateway/sensore/tipo],
      [`parseTelemetryEnvelope(raw)`], [Parsing JSON evento SSE e validazione payload],
      [`handleMalformedMessage(...)`], [Propaga errore e abort in caso payload invalido],
      [`isTokenExpiredEvent(value)`], [Rilevamento evento applicativo `token_expired`],
      [`isTelemetryEnvelope(value)`], [Type guard runtime su envelope],
    )
  ]

  == ThresholdPrefetchService

  #figure(caption: [Campi di ThresholdPrefetchService])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`REFRESH_INTERVAL_MS`], [`5 * 60 * 1000`], [Intervallo refresh soglie (5 minuti)],
      [`thresholdService`], [`ThresholdService`], [Servizio cache soglie],
      [`authService`], [`AuthService`], [Verifica ruolo/tenant e lifecycle logout],
      [`refreshSub`], [`Subscription | null`], [Subscription timer periodico],
    )
  ]

  #figure(caption: [Metodi pubblici di ThresholdPrefetchService])[
    #table(
      columns: (auto, auto, auto),
      [Metodo], [Firma], [Comportamento],
      [`start()`], [`(): void`], [Avvia timer immediato + periodico; evita duplicati e salta avvio se non eleggibile],
      [`stop()`], [`(): void`], [Arresta timer e azzera subscription],
    )
  ]

  #figure(caption: [Metodi privati di ThresholdPrefetchService])[
    #table(
      columns: (auto, auto),
      [Metodo], [Comportamento],
      [`shouldStart()`], [Ritorna `false` per `system_admin` o tenant assente],
    )
  ]

  == ThresholdService

  #figure(caption: [Campi di ThresholdService])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`thresholdsApi`], [`ThresholdsService (OpenAPI)`], [Client management-api per endpoint soglie],
      [`cache`], [`ThresholdConfig[]`], [Cache locale in memoria],
    )
  ]

  #figure(caption: [Metodi pubblici di ThresholdService])[
    #table(
      columns: (2fr, 2fr, 1.7fr),
      [Metodo], [Firma], [Comportamento],
      [`fetchThresholds()`],
      [`(): Observable<ThresholdConfig[]>`],
      [Carica soglie da API, normalizza payload e aggiorna cache],

      [`getCached()`], [`(): ThresholdConfig[]`], [Ritorna snapshot cache corrente],
      [`invalidateCache()`], [`(): void`], [Azzera cache],
      [`refreshThresholds()`], [`(): Observable<ThresholdConfig[]>`], [Invalidate + reload],
      [`setDefaultThreshold(...)`],
      [`(sensorType, minValue?, maxValue?): Observable<void>`],
      [Upsert soglia di default per tipo sensore],

      [`setSensorThreshold(...)`],
      [`(sensorId, sensorType, minValue?, maxValue?): Observable<void>`],
      [Upsert soglia specifica sensore],

      [`deleteSensorThreshold(sensorId)`], [`(sensorId: string): Observable<void>`], [Delete soglia sensore],
      [`deleteTypeThreshold(sensorType)`], [`(sensorType: string): Observable<void>`], [Delete soglia per tipo],
    )
  ]

  #figure(caption: [Metodi privati di ThresholdService])[
    #table(
      columns: (auto, auto),
      [Metodo], [Comportamento],
      [`resolveBounds(...)`], [Riutilizza bound cached in update parziale],
      [`toThresholds(rows)`], [Normalizza payload API snake_case/camelCase in `ThresholdConfig[]`],
      [`normalizeType(type)`], [Mapping tipo in `sensorId|sensorType`],
      [`toNullableNumber(value)`], [Parsing robusto numeri],
      [`toNonEmptyString(value)`], [Validazione stringhe non vuote],
    )
  ]

  == MeasureBoundsEvaluationService

  #figure(caption: [Campi di MeasureBoundsEvaluationService])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`thresholds`], [`ThresholdService`], [Accesso cache soglie],
    )
  ]

  #figure(caption: [Metodi pubblici di MeasureBoundsEvaluationService])[
    #table(
      columns: (auto, auto, auto),
      [Metodo], [Firma], [Comportamento],
      [`evaluate(envelope)`],
      [`(envelope: DecryptedEnvelope): boolean`],
      [Priorita match su `sensorId`, fallback `sensorType`, `true` solo se fuori bound],
    )
  ]

  #figure(
    caption: [Diagramma dei servizi core],
  )[
    #align(center)[
      #image("assets/05-core-services.svg")
    ]
  ]

  = Generazione codice OpenAPI

  I client API verso i backend sono generati automaticamente tramite OpenAPI Generator. Il workflow è definito in
  `scripts/generate-openapi.sh`:

  1. Recupera gli specchi OpenAPI (`openapi.json`) dai repository dei servizi produttori tramite GitHub API;
  2. Salva le specifiche in `api-contracts/openapi/`;
  3. Esegue OpenAPI Generator con generatore `typescript-angular`;
  4. Output in `src/app/generated/openapi/{notip-management-api-openapi, notip-data-api-openapi}/`;
  5. Applica Prettier al codice generato per uniformità di stile.

  I client generati forniscono:

  - *Management API* (`/api/mgmt`): classi come `GatewaysService`, `AdminTenantsService`, `AdminGatewaysService`,
    `AlertsService`, `AuditLogService`, `ApiClientService`, `CommandsService`, `CostsService`, `KeysService`,
    `ThresholdsService`, `UsersService`, `AuthService`;
  - *Data API* (`/api/data`): classi come `MeasuresService` (query, export, stream), `SensorsService`, `AppService`.

  Entrambi i set di client sono registrati in `app.config.ts` tramite `provideMgmtApi('/api/mgmt')` e
  `provideDataApi('/api/data')`, che configurano il base path per le chiamate.

  = Feature: Dashboard

  La dashboard telemetria è il componente principale dell'applicazione per gli utenti tenant. Supporta due modalità
  operative e diverse funzionalità di visualizzazione e interazione.

  == DataDashboardPageComponent

  `DataDashboardPageComponent` (`src/app/features/dashboard/pages/data-dashboard/`) è orchestrata dal resolver
  `DashboardResolver` che determina la modalità dati:

  - *`dataMode: 'clear'`*: telemetria decrittografata, modalità standard per utenti non in impersonazione;
  - *`dataMode: 'obfuscated'`*: telemetria offuscata, forzata durante l'impersonazione.

  La pagina supporta due view mode:

  - *Stream mode*: connessione SSE in tempo reale tramite `ObfuscatedStreamManagerService`. I dati vengono decrittati da
    `DecryptedMeasureService` (che usa `@notip/crypto-sdk`) e validati da `ValidatedMeasureFacadeService` che aggiunge
    il flag `isOutofBounds`. Il grafico è aggiornato in tempo reale con un cap di 20 righe;
  - *Query mode*: query paginata con cursore composito `(time, sensorId)`. Supporta filtri per gatewayIds, sensorTypes,
    sensorIds, e range temporale (con limite finestra 24h).

  == FilterPanelComponent

  `FilterPanelComponent` (`src/app/features/dashboard/components/filter-panel/`) fornisce i controlli di filtro:

  - Dropdown multi-select custom per `gatewayIds`, `sensorTypes`, `sensorIds` con ricerca locale;
  - Input datetime-local per range temporale (solo in query mode);
  - Validazione finestra temporale massima di 24h con clamping automatico;
  - Conversione datetime nel fuso orario Roma tramite pipe e utility dedicate;
  - Cross-filter dependency: la selezione di un gateway aggiorna i cataloghi di sensori disponibili;
  - Rimozione automatica delle selezioni incompatibili (es. sensore non appartenente al gateway selezionato);
  - Toggle singolo click per apertura/chiusura dropdown;
  - Chiusura dropdown su click esterno o tasto Escape.

  == TelemetryChartComponent

  `TelemetryChartComponent` (`src/app/features/dashboard/components/telemetry-chart/`) visualizza i dati telemetrici:

  - Utilizza Chart.js per rendering di grafici lineari;
  - Calcola sensori unici dai dati ricevuti;
  - Crea un dataset per sensore con colorazione distinta;
  - Cap a 120 punti per dataset per performance;
  - Formattazione timestamp in locale italiano;
  - Gestione fallback per timestamp invalidi;
  - Rilevamento modalità "obfuscated-only" e visualizzazione conteggio.

  == TelemetryTableComponent

  `TelemetryTableComponent` (`src/app/features/dashboard/components/telemetry-table/`) mostra i dati in formato tabella:

  - Colonne: Timestamp (Rome timezone pipe), Gateway, Sensor, Type, Value;
  - Ordine invertito (più recente in alto);
  - Valori offuscati: mascheramento con stringa `*** OBFUSCATED ***`;
  - Valori non numerici (`!Number.isFinite`): visualizzazione `n/a`;
  - Righe con valori out-of-bounds: evidenziazione con classe CSS `row-alert`;
  - Scroll orizzontale per tabelle larghe.

  == Pipeline di decrittografia telemetria

  Il flusso di elaborazione della telemetria segue una pipeline a tre stadi:

  1. *ObfuscatedStreamManagerService*: riceve eventi SSE grezzi (`TelemetryEnvelope` con `encryptedData`, `iv`,
    `authTag`);
  2. *DecryptedMeasureService*: utilizza `@notip/crypto-sdk` (`DataApiService`) per decrittografare con AES-256-GCM,
    producendo `DecryptedEnvelope` con `value` e `unit` in chiaro;
  3. *ValidatedMeasureFacadeService*: valuta `isOutofBounds` tramite `MeasureBoundsEvaluationService` contro le soglie
    cached, producendo `CheckedEnvelope`.

  La pipeline opera in entrambe le modalità:

  - *Stream (SSE)*: `ObfuscatedStreamManagerService.openStream()` -> `DecryptedMeasureService.openStream()` ->
    `ValidatedMeasureFacadeService.openStream()`;
  - *Query (paginata)*: `ObfuscatedMeasureService.query()` oppure `ValidatedMeasureFacadeService.query()`, con cursore
    composito;
  - *Export*: `ValidatedMeasureFacadeService.export()` in modalità clear, con limite finestra 24h.

  #figure(
    caption: [Diagramma della dashboard],
  )[
    #align(center)[
      #image("./assets/07-dashboard.svg")
    ]
  ]

  = Feature: Gateway

  La gestione dei gateway consente agli utenti tenant di visualizzare, rinominare, configurare e inviare comandi ai
  propri gateway IoT.

  == GatewayListPageComponent

  `GatewayListPageComponent` carica la lista gateway tramite `GatewayService` e renderizza card per ciascun gateway. La
  navigazione al dettaglio avviene tramite selezione della card.

  == GatewayDetailPageComponent

  `GatewayDetailPageComponent` è la pagina più complessa dell'applicazione. Fornisce:

  - *Riepilogo gateway*: nome, stato, ID, firmware, frequenza di invio;
  - *Azioni gateway* (solo `tenant_admin` o se `canManage`):
    - Rinomina (GatewayRenameModalComponent);
    - Invio comando configurazione (CommandModalComponent mode `config`);
    - Invio comando firmware (CommandModalComponent mode `firmware`);
    - Eliminazione gateway (DeleteConfirmModalComponent);
  - *Lista sensori*: sensori associati al gateway con navigazione al dettaglio;
  - *Telemetria live*: stream in tempo reale dei dati del gateway selezionato;
  - *Stato comandi*: polling dello stato dei comandi inviati con visualizzazione progresso.

  == GatewayService

  `GatewayService` (`src/app/features/gateways/services/gateway.service.ts`) gestisce lo stato e le operazioni sui
  gateway:

  #figure(caption: [Campi di GatewayService])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`gatewaysApi`], [`GatewaysApiService (OpenAPI)`], [Client management-api gateway],
      [`http`], [`HttpClient`], [Iniettato nel servizio],
      [`listSignal`], [`Signal<Gateway[]>`], [Stato lista gateway],
      [`selectedGatewaySignal`], [`Signal<Gateway | null>`], [Gateway selezionato],
      [`loadingSignal`], [`Signal<boolean>`], [Flag loading richieste],
    )
  ]

  #figure(caption: [Metodi pubblici di GatewayService])[
    #table(
      columns: (auto, auto, auto),
      [Metodo], [Firma], [Comportamento],
      [`getGateways()`], [`(): Observable<Gateway[]>`], [Fetch lista gateway, mapping DTO->model e update `listSignal`],
      [`getGatewayDetail(gatewayId)`],
      [`(gatewayId: string): Observable<Gateway>`],
      [Fetch dettaglio gateway e update `selectedGatewaySignal`],

      [`updateGatewayName(gatewayId, name)`],
      [`(gatewayId: string, name: string): Observable<GatewayUpdateResult>`],
      [Patch nome gateway e mapping risposta],

      [`deleteGateway(gatewayId)`],
      [`(gatewayId: string): Observable<string>`],
      [Delete gateway e ritorno id eliminato],

      [`list()`], [`(): Signal<Gateway[]>`], [Accessor read-only lista],
      [`selectedGateway()`], [`(): Signal<Gateway | null>`], [Accessor read-only selezione],
      [`isLoading()`], [`(): Signal<boolean>`], [Accessor read-only loading],
    )
  ]

  #figure(caption: [Metodi privati di GatewayService])[
    #table(
      columns: (auto, auto),
      [Metodo], [Comportamento],
      [`toGateway(dto)`], [Mapping robusto `GatewayResponseDto` in `Gateway`],
      [`toGatewayStatus(status)`], [Normalizzazione stato (uppercase/camelCase) con fallback `offline`],
      [`pickString/pickOptionalString`], [Utility estrazione stringhe],
      [`pickBoolean`], [Utility estrazione boolean],
      [`pickNumber`], [Utility coercion numeri con default `30000ms`],
    )
  ]

  == CommandService

  `CommandService` (`src/app/features/gateways/services/command.service.ts`) gestisce l'invio e il monitoraggio dei
  comandi:

  #figure(caption: [Costanti e campi di CommandService])[
    #table(
      columns: (auto, auto, auto),
      [Elemento], [Tipo], [Note],
      [`TERMINAL_STATUSES`], [`Set<CommandStatus>`], [Stati terminali (`ack`, `nack`, `expired`, `timeout`)],
      [`ALLOWED_CMD_GATEWAY_STATUSES`], [`Set<CmdGatewayStatus>`], [Stati gateway ammessi nei comandi config],
      [`commandsApi`], [`CommandsApiService (OpenAPI)`], [Client API comandi],
    )
  ]

  #figure(caption: [Metodi pubblici di CommandService])[
    #table(
      columns: (1.7fr, 2fr, 1.7fr),
      [Metodo], [Firma], [Comportamento],
      [`sendConfig(id, config)`],
      [`(id: string, config: GatewayConfig): Observable<CommandStatusUpdate>`],
      [Invio comando config con filtro campi non validi e chaining polling],

      [`sendFirmware(id, firmware)`],
      [`(id: string, firmware: GatewayFirmware): Observable<CommandStatusUpdate>`],
      [Invio comando firmware e chaining polling],

      [`pollStatus(gwId, cmdId, intervalMs?)`],
      [`(gwId: string, cmdId: string, intervalMs = 2000): Observable<CommandStatusUpdate>`],
      [Polling stato comando con timeout 5 minuti, gestione 304 e mapping 404/503 -> `timeout`],
    )
  ]

  #figure(caption: [Metodi privati di CommandService])[
    #table(
      columns: (auto, auto),
      [Metodo], [Comportamento],
      [`toCommandStatus(status)`], [Mapping string status API in enum `CommandStatus`],
      [`mapCommandResponse(response)`], [Validazione e mapping risposta invio comando],
      [`mapCommandStatusResponse(response)`], [Validazione e mapping risposta stato comando],
      [`isCmdGatewayStatus(status)`], [Type guard sugli stati gateway consentiti],
    )
  ]

  #figure(
    caption: [Diagramma della feature Gateway],
  )[
    #align(center)[
      #image("assets/09-gateways.svg")
    ]
  ]

  = Feature: Admin

  Le funzionalità di amministrazione sistema sono accessibili esclusivamente ai `system_admin`.

  La feature include anche componenti riutilizzabili sotto `admin/components/`: `AdminGatewayFormComponent`,
  `AdminGatewayTableComponent`, `ImpersonateButtonComponent`, `TenantFormComponent`, `TenantTableComponent`,
  `TenantUserListComponent`.

  == TenantManagerPageComponent

  #figure(caption: [Campi di TenantManagerPageComponent])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`tenantService`], [`TenantService`], [Servizio tenant iniettato],
      [`router`], [`Router`], [Navigazione verso dettaglio tenant],
      [`tenants`], [`Signal<Tenant[]>`], [Lista tenant caricata],
      [`showCreateForm`], [`Signal<boolean>`], [Toggle form creazione/modifica],
      [`editingTenant`], [`Signal<Tenant | null>`], [Tenant in editing],
      [`deletingTenantId`], [`Signal<string | null>`], [Tenant in conferma cancellazione],
      [`isLoading / isSaving`], [`Signal<boolean>`], [Stato caricamento/salvataggio],
      [`errorMessage / formErrorMessage`], [`Signal<string | null>`], [Messaggi errore UI],
    )
  ]

  #figure(caption: [Metodi pubblici di TenantManagerPageComponent])[
    #table(
      columns: (auto, auto, auto),
      [Metodo], [Firma], [Comportamento],
      [`ngOnInit()`], [`(): void`], [Innesca `loadTenants()`],
      [`onTenantSelected(id)`], [`(tenantId: string): void`], [Naviga a `/admin/tenants/:id/users`],
      [`onCreateRequested(payload)`], [`(payload): void`], [Crea tenant e ricarica lista],
      [`onUpdateRequested(payload)`], [`(payload): void`], [Aggiorna tenant e ricarica lista],
      [`confirmDeleteTenant()`], [`(): void`], [Elimina tenant selezionato e aggiorna stato locale],
      [`openCreateTenantForm()`], [`(): void`], [Toggle form con reset errori],
    )
  ]

  #figure(caption: [Metodi privati di TenantManagerPageComponent])[
    #table(
      columns: (auto, auto),
      [Metodo], [Comportamento],
      [`loadTenants()`], [Fetch tenant via `TenantService.getTenants()` con gestione loading/error],
    )
  ]

  == TenantDetailPageComponent

  #figure(caption: [Campi di TenantDetailPageComponent])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`route / router`], [`ActivatedRoute / Router`], [Risoluzione parametro `id` e redirect],
      [`adminUserService`], [`AdminUserService`], [Recupero utenti offuscati del tenant],
      [`tenantService`], [`TenantService`], [Recupero dettagli tenant],
      [`tenantId`], [`Signal<string>`], [Tenant corrente da route params],
      [`tenant`], [`Signal<Tenant | null>`], [Dettaglio tenant],
      [`users`], [`Signal<ObfuscatedUser[]>`], [Utenti tenant],
      [`feedbackMessage`], [`Signal<string | null>`], [Esito impersonazione],
    )
  ]

  #figure(caption: [Metodi pubblici di TenantDetailPageComponent])[
    #table(
      columns: (auto, auto, auto),
      [Metodo], [Firma], [Comportamento],
      [`ngOnInit()`], [`(): void`], [Sottoscrive route params e carica tenant + utenti],
      [`onImpersonationStarted(userId)`], [`(userId: string): void`], [Mostra feedback e naviga su `/dashboard`],
      [`onImpersonationFailed(message)`], [`(message: string): void`], [Mostra messaggio errore impersonazione],
    )
  ]

  == AdminGatewayListPageComponent

  #figure(caption: [Campi di AdminGatewayListPageComponent])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`adminGatewayService`], [`AdminGatewayService`], [Servizio gateway admin],
      [`tenantService`], [`TenantService`], [Recupero tenantId disponibili per filtro],
      [`gateways`], [`Signal<ObfuscatedGateway[]>`], [Lista gateway sistema],
      [`tenantOptions`], [`Signal<string[]>`], [Tenant disponibili nel filtro],
      [`selectedTenantIds / draftTenantIds`], [`Signal<string[]>`], [Filtro applicato vs bozza filtro],
      [`filteredGateways`], [`Computed<ObfuscatedGateway[]>`], [Lista filtrata per tenant],
      [`showCreateForm`], [`Signal<boolean>`], [Toggle creazione gateway],
    )
  ]

  #figure(caption: [Metodi pubblici di AdminGatewayListPageComponent])[
    #table(
      columns: (auto, auto, auto),
      [Metodo], [Firma], [Comportamento],
      [`ngOnInit()`], [`(): void`], [Carica gateway e opzioni tenant],
      [`onApplyFilter(event)`], [`(event: Event): void`], [Applica bozza filtro ai tenant selezionati],
      [`onResetFilter()`], [`(): void`], [Reset filtro tenant],
      [`onCreateGateway(payload)`],
      [`(payload: CreateAdminGatewayPayload): void`],
      [Crea gateway admin e ricarica lista],

      [`toggleCreateForm()`], [`(): void`], [Apre/chiude form creazione],
    )
  ]

  == Servizi Admin

  #figure(caption: [Metodi pubblici dei servizi Admin])[
    #table(
      columns: (auto, auto, auto),
      [Servizio], [Metodo], [Comportamento],
      [`TenantService`], [`getTenants()`], [Recupera lista tenant e mappa status/suspension interval],
      [`TenantService`], [`createTenant(c)`], [Crea tenant con payload admin bootstrap],
      [`TenantService`], [`updateTenant(id, u)`], [Aggiorna nome/stato/intervallo con normalizzazione input],
      [`TenantService`], [`deleteTenant(id)`], [Elimina tenant],
      [`AdminUserService`], [`getUsers(tenantId)`], [Recupera utenti tenant e mappa ruolo in `UserRole`],
      [`AdminGatewayService`], [`getGateways(tenantId?)`], [Lista gateway admin con mapping robusto dei campi],
      [`AdminGatewayService`], [`addGateway(params)`], [Provisioning gateway con `factory_id/factory_key/model`],
    )
  ]

  #figure(
    caption: [Diagramma della feature Admin],
  )[
    #align(center)[
      #image("assets/03-admin.svg")
    ]
  ]

  = Feature: Alerts

  La gestione degli alert consente di configurare e consultare gli alert di gateway offline.

  La feature include componenti sotto `alerts/components/`: `AlertConfigFormComponent`, `AlertFilterPanelComponent`.

  == AlertListPageComponent

  #figure(caption: [Campi di AlertListPageComponent])[
    #table(
      columns: (auto, auto, auto),
      [Campo], [Tipo], [Note],
      [`alertService`], [`AlertService`], [Caricamento alert con filtri],
      [`gatewayService`], [`GatewayService`], [Costruzione opzioni filtro gateway],
      [`authService`], [`AuthService`], [Valutazione permessi edit config],
      [`alerts`], [`Signal<Alerts[]>`], [Lista alert correnti],
      [`gatewayOptions`], [`Signal<string[]>`], [Gateway disponibili nel filtro],
      [`from / to`], [`Signal<string>`], [Intervallo temporale locale (Rome)],
      [`gatewayIds`], [`Signal<string[]>`], [Filtro gateway selezionato],
      [`canEditAlertsConfig`], [`boolean`], [True solo per `tenant_admin`],
    )
  ]

  #figure(caption: [Metodi pubblici di AlertListPageComponent])[
    #table(
      columns: (auto, auto, auto),
      [Metodo], [Firma], [Comportamento],
      [`ngOnInit()`], [`(): void`], [Carica opzioni gateway e alert iniziali],
      [`applyFilter(form)`], [`(form: AlertFilterFormValue): void`], [Applica filtri e ricarica alert],
      [`resetFilter()`], [`(): void`], [Ripristina finestra 24h e ricarica],
    )
  ]

  == AlertConfigPageComponent

  #figure(caption: [Metodi pubblici di AlertConfigPageComponent])[
    #table(
      columns: (auto, auto, auto),
      [Metodo], [Firma], [Comportamento],
      [`ngOnInit()`], [`(): void`], [Carica config alert e gateway disponibili],
      [`saveDefault(payload)`], [`(payload: DefaultTimeoutPayload): void`], [Aggiorna timeout default tenant],
      [`saveGateway(payload)`], [`(payload: GatewayTimeoutPayload): void`], [Salva override timeout per gateway],
      [`deleteGateway(gatewayId)`], [`(gatewayId: string): void`], [Rimuove override gateway],
      [`toggleForm()/closeForm()`], [`(): void`], [Gestione apertura/chiusura modale di configurazione],
    )
  ]

  #figure(caption: [Metodi pubblici di AlertService])[
    #table(
      columns: (2fr, 2fr, 1.7fr),
      [Metodo], [Firma], [Comportamento],
      [`getAlertsConfig()`], [`(): Observable<AlertsConfig>`], [Carica default + gateway overrides],
      [`setDefaultConfig(timeoutMs)`],
      [`(timeoutMs: number): Observable<DefaultAlertsConfig>`],
      [Aggiorna timeout default],

      [`sendGatewayConfig(gatewayId, timeoutMs)`],
      [`(...): Observable<GatewayAlertsConfig>`],
      [Imposta override gateway],

      [`deleteGatewayConfig(gatewayId)`], [`(gatewayId: string): Observable<void>`], [Cancella override gateway],
      [`getAlerts(filter)`],
      [`(af: AlertsFilter): Observable<Alerts[]>`],
      [Supporta multi-gateway con `forkJoin`, dedup e sort desc],
    )
  ]

  #figure(
    caption: [Diagramma della feature Alerts],
  )[
    #align(center)[
      #image("assets/04-alerts.svg")
    ]
  ]

  = Feature: Sensors

  == SensorListPageComponent

  #figure(caption: [Campi e metodi pubblici di SensorListPageComponent])[
    #table(
      columns: (auto, auto, auto),
      [Elemento], [Tipo/Firma], [Comportamento],
      [`sensors`], [`Signal<Sensor[]>`], [Lista sensori caricata],
      [`gatewayFilters / typeFilters`], [`Signal<string[]>`], [Filtri attivi per gateway e tipo],
      [`gatewayOptions / sensorTypeOptions`], [`Computed<string[]>`], [Opzioni deduplicate e ordinate],
      [`filteredSensors`], [`Computed<Sensor[]>`], [Filtro combinato su gateway + tipo],
      [`ngOnInit()`], [`(): void`], [Carica sensori],
      [`openSensorDetail(id)`], [`(sensorId: string): void`], [Naviga a `/sensors/:id`],
      [`onClearFilters()`], [`(): void`], [Reset filtri],
    )
  ]

  == SensorDetailPageComponent

  #figure(caption: [Metodi pubblici di SensorDetailPageComponent])[
    #table(
      columns: (auto, auto, auto),
      [Metodo], [Firma], [Comportamento],
      [`ngOnInit()`], [`(): void`], [Legge `sensorId` da route, carica dettaglio e avvia stream telemetria],
      [`ngOnDestroy()`], [`(): void`], [Ferma stream correnti e invalida run id],
    )
  ]

  #figure(caption: [Metodi pubblici di SensorService])[
    #table(
      columns: (auto, auto, auto),
      [Metodo], [Firma], [Comportamento],
      [`getAllSensors(refreshMs?)`],
      [`(refreshMs = 10000): Observable<Sensor[]>`],
      [Polling periodico sensori o fetch singolo],

      [`getGatewaySensors(id, refreshMs?)`],
      [`(id: string, refreshMs = 10000): Observable<Sensor[]>`],
      [Polling/fetch sensori filtrati per gateway],
    )
  ]

  #figure(
    caption: [Diagramma della feature Sensors],
  )[
    #align(center)[
      #image("assets/06-sensors.svg")
    ]
  ]

  = Feature: Management (Tenant Admin)

  Le funzionalità di gestione tenant sono accessibili ai `tenant_admin`.

  == UserListPageComponent

  #figure(caption: [Campi e metodi pubblici di UserListPageComponent])[
    #table(
      columns: (auto, auto, auto),
      [Elemento], [Tipo/Firma], [Comportamento],
      [`users`], [`Signal<ViewUser[]>`], [Lista utenti tenant],
      [`editingUserId / deletingUserId`], [`Signal<string | null>`], [Stato modali edit/delete],
      [`editingUser`], [`Computed<ViewUser | null>`], [Utente in editing],
      [`ngOnInit()`], [`(): void`], [Carica utenti],
      [`createUser(payload)`], [`(payload: CreateUserPayload): void`], [Crea utente e ricarica lista],
      [`updateUser(payload)`], [`(payload: UpdateUserPayload): void`], [Aggiorna utente e ricarica lista],
      [`confirmDelete()`], [`(): void`], [Delete utente selezionato via `deleteUsers([id])`],
    )
  ]

  #figure(caption: [Metodi pubblici di UserService])[
    #table(
      columns: (auto, auto, auto),
      [Metodo], [Firma], [Comportamento],
      [`getUsers()`], [`(): Observable<ViewUser[]>`], [Recupera utenti tenant e mappa `lastAccess`],
      [`createUser(params)`],
      [`(up: UserParameters): Observable<CreatedUser>`],
      [Crea utente con normalizzazione username e ruolo],

      [`updateUser(id, params)`],
      [`(userId: string, u: UpdateUserParameters): Observable<UpdatedUser>`],
      [Aggiorna utente],

      [`deleteUsers(ids)`],
      [`(userIds: string[]): Observable<DeleteUserFeedback>`],
      [Delete bulk con feedback deleted/failed],
    )
  ]

  == ThresholdSettingsPageComponent

  #figure(caption: [Metodi pubblici di ThresholdSettingsPageComponent])[
    #table(
      columns: (auto, auto, auto),
      [Metodo], [Firma], [Comportamento],
      [`ngOnInit()`], [`(): void`], [Carica soglie e opzioni sensori/tipi],
      [`saveTypeThreshold(payload)`], [`(payload: TypeThresholdPayload): void`], [Salva soglia per tipo],
      [`saveSensorThreshold(payload)`], [`(payload: SensorThresholdPayload): void`], [Salva override soglia sensore],
      [`confirmDeleteThreshold()`], [`(): void`], [Elimina soglia per tipo o sensore],
    )
  ]

  == ApiClientListPageComponent

  #figure(caption: [Metodi pubblici di ApiClientListPageComponent])[
    #table(
      columns: (auto, auto, auto),
      [Metodo], [Firma], [Comportamento],
      [`ngOnInit()`], [`(): void`], [Carica lista client],
      [`createClient(name)`], [`(name: string): void`], [Crea credenziali client e salva `lastCreated`],
      [`confirmDelete()`], [`(): void`], [Elimina client selezionato],
      [`toggleCreateForm()`], [`(): void`], [Apre/chiude form di creazione],
    )
  ]

  #figure(caption: [Metodi pubblici di ClientsService])[
    #table(
      columns: (auto, auto, auto),
      [Metodo], [Firma], [Comportamento],
      [`getClients()`], [`(): Observable<Client[]>`], [Recupera lista client API tenant],
      [`createClient(name)`], [`(name: string): Observable<SecretClient>`], [Crea client con secret iniziale],
      [`deleteClient(clientId)`], [`(clientId: string): Observable<void>`], [Cancella client],
    )
  ]

  == AuditLogPageComponent

  #figure(caption: [Metodi pubblici di AuditLogPageComponent])[
    #table(
      columns: (auto, auto, auto),
      [Metodo], [Firma], [Comportamento],
      [`ngOnInit()`], [`(): void`], [Carica log iniziali],
      [`applyFilters(form)`], [`(form: AuditFilterFormValue): void`], [Applica filtri e ricarica log],
      [`resetFilters()`], [`(): void`], [Reset intervallo 24h e filtri],
      [`onExportLogs()`], [`(): void`], [Export CSV lato client dei log correnti],
    )
  ]

  #figure(caption: [Metodi pubblici di AuditService])[
    #table(
      columns: (auto, auto, auto),
      [Metodo], [Firma], [Comportamento],
      [`getLogs(filter)`],
      [`(lf: LogsFilter): Observable<Logs[]>`],
      [Fetch audit log con join CSV di `userId/actions` e mapping payload],
    )
  ]

  == CostDashboardPageComponent

  #figure(caption: [Metodi pubblici di CostDashboardPageComponent e CostsService])[
    #table(
      columns: (2.5fr, 1.5fr, 1.5fr),
      [Elemento], [Firma], [Comportamento],
      [`CostDashboardPageComponent.ngOnInit()`], [`(): void`], [Carica costi tenant],
      [`CostDashboardPageComponent.loadCosts()`], [`private`], [Aggiorna `costs`, `isLoading`, `errorMessage`],
      [`CostsService.getTenantCosts()`],
      [`(): Observable<Costs>`],
      [Recupera `storage_gb` e `bandwidth_gb` con coercion numerica],
    )
  ]

  #figure(
    caption: [Diagramma della feature Management],
  )[
    #align(center)[
      #image("assets/02-management.svg")
    ]
  ]

  = Componenti shared

  I componenti shared sono riutilizzati trasversalmente nell'applicazione.

  #figure(
    caption: [Componenti shared principali],
  )[
    #table(
      columns: (auto, auto),
      [Componente], [Responsabilità],

      [SidebarComponent],
      [Navigazione laterale principale con voci di menu role-based. Mostra/rende disponibili le voci di menu in base al
        ruolo dell'utente (`tenant_user`, `tenant_admin`, `system_admin`). Durante l'impersonazione, mostra il banner e
        il bottone "Stop impersonation". Include ProfileSection e LogoutButton.],

      [ModalLayerComponent],
      [Overlay modale generico con backdrop. Utilizza elemento `<dialog>` HTML con proiezione `<ng-content>`. Supporta
        chiusura su click backdrop con rilevamento del target (previene chiusura accidentale su click all'interno).],

      [MultiSelectDropdownComponent],
      [Dropdown multi-selezione con ricerca integrata. Supporta apertura/chiusura tramite click su documento e tasto
        Escape. Opzioni filtrate per ricerca. Rimozione selezioni incompatibili. Stato disabled.],

      [StatusBadgeComponent],
      [Badge colorato per indicazione stato. Mappa valori di stato a classi CSS: `is-good` (verde), `is-warn` (giallo),
        `is-bad` (rosso), `is-neutral` (grigio).],

      [DeleteConfirmModalComponent],
      [Modale di conferma cancellazione con titolo e messaggio personalizzabili. Bottone confirm (pericolo, rosso) e
        cancel (ghost). Stato busy durante l'operazione.],

      [ImpersonationTagComponent], [Tag statico "OBFUSCATED MODE" visualizzato in contesti di dati offuscati.],

      [ProfileSectionComponent],
      [Sezione profilo utente con visualizzazione username e ruolo. Link opzionali per "Open profile" e "Change
        password".],

      [LogoutButtonComponent], [Bottone logout che emette evento click. Delega il logout ad AuthService.],
    )
  ]

  #figure(
    caption: [Diagramma dei componenti shared],
  )[
    #align(center)[
      #image("./assets/10-shared-components.svg")
    ]
  ]

  = Navigazione e sidebar

  La sidebar è il componente di navigazione principale. La struttura delle voci di menu è organizzata per ruolo:

  #figure(
    caption: [Voci di menu per ruolo],
  )[
    #table(
      columns: (auto, auto, auto),
      [Voce], [Ruoli Visibili], [Path],

      [Dashboard], [`tenant_user`, `tenant_admin`], [`/dashboard`],

      [Gateways], [`tenant_user`, `tenant_admin`], [`/gateways`],

      [Sensors], [`tenant_user`, `tenant_admin`], [`/sensors`],

      [Alerts], [`tenant_user`, `tenant_admin`], [`/alerts`],

      [Users], [`tenant_admin`], [`/mgmt/users`],

      [Limits], [`tenant_user`, `tenant_admin`], [`/mgmt/limits`],

      [API Clients], [`tenant_admin`], [`/mgmt/api`],

      [Audit Log], [`tenant_admin`], [`/mgmt/logs`],

      [Costs], [`tenant_admin`], [`/mgmt/costs`],

      [Tenants], [`system_admin`], [`/admin/tenants`],

      [Gateways (Admin)], [`system_admin`], [`/admin/gateways`],
    )
  ]

  La configurazione alert non è una voce di sidebar dedicata: è accessibile dal link inline presente nella pagina di
  lista alert.

  = Testing

  La strategia di testing del frontend si articola su due livelli principali, con soglia di copertura target dell'80%.

  == Unit Test

  I test unitari sono implementati con *Vitest* + *jsdom* + *\@analogjs/vite-plugin-angular* e coprono:

  - *Guards*: AuthGuard (inizializzazione Keycloak, token presence, login redirect, threshold prefetch trigger),
    RoleGuard (role matching, redirect per system_admin e altri ruoli, home redirect);
  - *Interceptors*: authInterceptor (token injection, empty token passthrough), errorInterceptor (401 con retryUrl, 403,
    non-HTTP errors);
  - *Core Services*:
    - `AuthService`: login/logout flows, token retrieval, JWT decoding, role mapping, impersonation start/stop,
      sessionStorage restoration;
    - `ThresholdPrefetchService`: immediate + periodic fetch, admin/tenant guards, error resilience, logout cleanup,
      duplicate start prevention;
    - `ThresholdService`: fetch/map/cache thresholds, type inference, refresh, null bounds, cached bound reuse,
      deletion;
    - `MeasureBoundsEvaluationService`: no match -> false, below-min -> true, above-max -> true, no bounds -> false,
      sensorId prioritized over sensorType;
    - `ObfuscatedStreamManagerService`: missing token -> login, valid envelopes emitted, malformed messages -> errors,
      handshake failures, token-expired events, empty payloads ignored;
  - *Feature Services*:
    - `GatewayService`: list loading, detail loading, obfuscated payloads, status normalization (uppercase/camelCase),
      paused/offline mapping, send frequency defaults, name update, deletion;
    - `CommandService`: config/firmware sending, disallowed status filtering, invalid field omission, polling until
      terminal status, 304 handling, 404/503 mapping, error rethrow, missing command ID rejection;
    - `DecryptedMeasureService`: query mapping, stream emission, export, empty filters, SDK error propagation, stream
      abortion, no-store fetch configuration, close safety;
    - `ObfuscatedMeasureService`: stream mapping to obfuscated batches, query page mapping with/without nextCursor,
      array-wrapped response handling, closeStream delegation;
    - `ValidatedMeasureFacadeService`: stream/query/export mapping to checked envelopes, cursor preservation;
  - *Dashboard Components*:
    - `DataDashboardPageComponent`: stream mode (20-row cap), query mode with cursor pagination, impersonation forcing
      obfuscated endpoints and disabling export;
    - `FilterPanelComponent`: filter emission, 24h window clamping (from/to), clear/reset, stream mode ignoring dates,
      single-click toggle, search filtering, dropdown open/close, outside click dismissal, cross-filter dependency,
      incompatible selection removal;
    - `TelemetryChartComponent`: unique sensor ID computation, dataset creation, chart update reuse, invalid timestamp
      fallback sorting, format/withAlpha edge cases, obfuscated-only detection;
    - `TelemetryTableComponent`: obfuscated value masking, finite value formatting, non-finite n/a fallback, row-alert
      class application;
  - *Gateway Components*: GatewayCard (detail emission, disabled state), GatewayActions (all four event emissions),
    GatewayRenameModal (close event, trimmed submit), CommandModal (close, config full/partial/empty payloads, trimmed
    firmware submit);
  - *Shared Components*: DeleteConfirmModal, MultiSelectDropdown, StatusBadge, ImpersonationBanner, ecc.

  == Configuration

  La configurazione di test è definita in `vitest.config.ts`:

  - Threshold di copertura: *80%* su branches, functions, lines, statements;
  - Ambiente: *jsdom* per simulazione DOM;
  - Plugin: *\@analogjs/vite-plugin-angular* per compilazione template Angular;
  - Setup: configurazioni specifiche per test di componenti con TestBed Angular.

  = Design rationale

  Di seguito le decisioni architetturali chiave e le relative motivazioni:

  #figure(
    caption: [Decisioni architetturali del frontend],
  )[
    #table(
      columns: (1fr, 2.5fr),
      [Decisione], [Motivazione],

      [Architettura Standalone (no NgModules)],
      [Angular 14+ introduce il modello standalone che semplifica la struttura dell'applicazione. Ogni componente,
        servizio e pipe è auto-contenuto con import espliciti. Questo riduce il boilerplate, migliora il tree-shaking e
        rende il codice più leggibile e manutenibile.],

      [Signal-based state management (no NgRx)],
      [I segnali Angular forniscono state management reattivo nativo senza librerie esterne. Per uno stato locale di
        feature (es. lista gateway, gateway selezionato, loading state), i segnali sono sufficienti e più semplici di
        NgRx. RxJS è mantenuto per flussi asincroni (SSE, HTTP) e Subject per comunicazione cross-componente.],

      [OpenAPI Generator per client API],
      [La generazione automatica dei client Angular da spec OpenAPI garantisce strong typing, consistenza con le API
        backend, e aggiornamento automatico quando le API cambiano. Lo script `generate-openapi.sh` automatizza il
        recupero delle specifiche e la generazione.],

      [SSE per streaming telemetria],
      [Server-Sent Events (SSE) è preferita a WebSocket per lo streaming di telemetria perché: è unidirezionale
        (server -> client), adatta al caso d'uso; gestita nativamente dal browser; più semplice da implementare e
        debuggare; compatibile con i proxy HTTP e i meccanismi di autenticazione basati su header.],

      [Decrittografia telemetria lato client],
      [La telemetria viene crittografata AES-256-GCM lato gateway e decrittografata lato client tramite
        `@notip/crypto-sdk`. Questo approccio (Rule Zero) garantisce che il server non veda mai i dati in chiaro,
        preservando la privacy end-to-end. Il frontend riceve `encryptedData`, `iv`, `authTag` e li decodifica
        localmente.],

      [Data mode: clear vs obfuscated],
      [Durante l'impersonazione, il frontend opera in modalità `obfuscated`: i dati non vengono decrittografati e
        vengono mostrati solo metadati (gatewayId, sensorId, timestamp). Questo protegge la privacy dei dati del tenant
        durante il debug e il supporto da parte dei system admin.],

      [Impersonation via sessionStorage],
      [Il token di impersonazione è memorizzato in `sessionStorage` (non `localStorage`) per isolamento di sicurezza:
        viene cancellato alla chiusura del tab/browser e non persiste tra sessioni. Lo stato viene ripristinato in modo
        trasparente dal servizio auth leggendo il contesto salvato.],

      [Cross-filter dependency nel FilterPanel],
      [I dropdown del filtro sono interdipendenti: la selezione di un gateway aggiorna i sensori disponibili. Questo
        previene selezioni incompatibili e migliora l'esperienza utente. Le selezioni incompatibili vengono rimosse
        automaticamente.],

      [24h query window limit],
      [Le query di telemetria sono limitate a una finestra temporale di 24 ore per prevenire query troppo onerose sul
        database TimescaleDB. Il FilterPanel applica clamping automatico sia sul "from" che sul "to".],

      [Rome timezone conversion],
      [Tutti i timestamp sono convertiti nel fuso orario Europa/Roma tramite pipe custom (`RomeDateTimePipe`) e utility
        dedicate. Questo assicura coerenza temporale per gli utenti italiani.],

      [Chart.js per visualizzazione dati],
      [Chart.js è leggero, ben mantenuto e sufficiente per i grafici lineari richiesti dalla dashboard. Un dataset per
        sensore con colorazione distinta permette di distinguere facilmente le serie temporali. Il cap a 120 punti per
        dataset previene degrado delle performance.],

      [Vitest over Karma/Jasmine],
      [Vitest è più veloce di Karma/Jasmine, supporta nativamente HMR, e si integra meglio con Vite (il bundler di
        Angular). jsdom fornisce un ambiente DOM headless sufficiente per i test di componenti.],
    )
  ]

  = Error handling

  La gestione degli errori nel frontend segue questi principi:

  #figure(
    caption: [Strategia di gestione errori],
  )[
    #table(
      columns: (1fr, 2.5fr),
      [Tipo Errore], [Gestione],

      [401 Unauthorized],
      [L'errorInterceptor reindirizza a `/error?reason=unauthorized&retryUrl=<currentUrl>`. L'utente può effettuare il
        re-login e tornare alla pagina precedente tramite il `retryUrl`. Il token Keycloak scaduto innesca il rinnovo
        automatico prima della scadenza.],

      [403 Forbidden],
      [L'errorInterceptor reindirizza a `/error?reason=forbidden`. Indica che l'utente non ha i permessi necessari per
        la risorsa richiesta.],

      [Errori di rete / offline],
      [Propagati come `HttpErrorResponse` con `status: 0`. Gestiti dai componenti feature con visualizzazione di
        messaggio di errore all'utente.],

      [Errori SSE (handshake, token expired)],
      [L'ObfuscatedStreamManagerService termina lo stream con errore esplicito e abort della sessione SSE. In caso di
        token mancante all'apertura, viene richiesto il login.],

      [Errori decrittografia SDK],
      [Propagati da `DecryptedMeasureService` come errori Observable. Il componente dashboard cattura l'errore e
        visualizza un messaggio appropriato.],

      [Errori comando timeout (404, 503)],
      [Il CommandService mappa `404` e `503` a `CommandStatus.timeout`. Il polling termina dopo 5 minuti di timeout con
        notifica all'utente.],

      [Errori soglia cache fallback],
      [Il `ThresholdPrefetchService` mantiene attivo lo scheduler anche in presenza di errori temporanei. La validazione
        utilizza lo stato cache corrente; se non sono presenti soglie, restituisce `false` (nessun out-of-bounds).],

      [Error page generica],
      [ErrorPageComponent visualizza messaggi di errore parametrizzati (`reason`, `retryUrl`). Supporta: `unauthorized`,
        `forbidden`, `not-found`. La rotta wildcard `**` reindirizza a `/error?reason=not-found`.],
    )
  ]

  = Osservabilità e metriche

  Sebbene il frontend non esponga endpoint Prometheus, contribuisce all'osservabilità del sistema tramite:

  - *Keycloak audit log*: ogni azione utente è registrata negli audit log del sistema tramite il management-api;
  - *Error tracking*: gli errori HTTP (401, 403, 5xx) sono registrati negli audit log con contesto utente;
  - *Audit log impersonazione*: le azioni eseguite in modalità impersonazione hanno il nome utente offuscato per
    privacy, ma sono tracciate con timestamp e azione.

  = Sicurezza

  Le misure di sicurezza implementate nel frontend includono:

  #figure(
    caption: [Misure di sicurezza del frontend],
  )[
    #table(
      columns: (1fr, 2.5fr),
      [Misure], [Dettaglio],

      [PKCE S256],
      [L'autenticazione Keycloak utilizza PKCE (Proof Key for Code Exchange) con metodo S256 per prevenire attacchi di
        authorization code interception.],

      [Auto-refresh token],
      [Il token JWT viene rinnovato automaticamente ogni 10 minuti tramite `withAutoRefreshToken` di `keycloak-angular`.
        I servizi `AutoRefreshTokenService` e `UserActivityService` monitorano l'attività utente e gestiscono il
        rinnovo. Il rinnovo fallito innesca il logout e il re-login.],

      [SessionStorage per impersonazione],
      [Il token di impersonazione è memorizzato in `sessionStorage`, non `localStorage`. Viene cancellato alla chiusura
        del tab e non persiste tra sessioni.],

      [Role-based routing],
      [Le guardie AuthGuard e RoleGuard prevengono l'accesso a rotte non autorizzate. I system admin vengono
        reindirizzati a `/admin/tenants`, gli altri a `/dashboard`.],

      [Bearer token injection],
      [L'authInterceptor inietta il token JWT in ogni richiesta HTTP. Le chiamate senza token sono permesse solo per
        endpoint pubblici.],

      [Impersonation guardrails],
      [Durante l'impersonazione: la rinomina gateway è nascosta in UI, le chiamate protette con
        `BlockImpersonationGuard` sono bloccate dal backend, la telemetria è offuscata.],

      [Whitelist validation],
      [I client OpenAPI generati applicano validazione automatica sui payload in ingresso/uscita. I form Angular
        utilizzano validazione built-in (required, minlength, maxlength, pattern).],

      [CSP (Content Security Policy)],
      [Applicata dal reverse proxy Nginx che serve il frontend. Limita le sorgenti di script, stili e connessioni.],
    )
  ]

  = Performance considerations

  #figure(
    caption: [Considerazioni sulle performance],
  )[
    #table(
      columns: (1fr, 2.5fr),
      [Aspetto], [Strategia],

      [Streaming SSE cap],
      [Lo stream SSE è limitato a 20 righe nella dashboard per prevenire accumulo di dati in memoria e degrado del
        rendering.],

      [Chart.js dataset cap],
      [I dataset Chart.js sono limitati a 120 punti per sensore per mantenere performance di rendering fluide.],

      [Cursor-based pagination],
      [Le query di telemetria utilizzano pagination con cursore composito `(time, sensorId)` invece di offset per query
        più efficienti su TimescaleDB.],

      [Threshold caching],
      [Le soglie di validazione sono cached e aggiornate ogni 5 minuti dal ThresholdPrefetchService. In caso di errore
        temporaneo, il ciclo di refresh resta attivo senza interrompere la UI.],

      [304 Not Modified caching],
      [Il CommandService gestisce risposte 304 durante il polling dei comandi per evitare elaborazioni ridondanti.],

      [Standalone tree-shaking],
      [L'architettura standalone Angular permette migliore tree-shaking rispetto ai NgModules, riducendo il bundle size
        finale.],

      [Lazy loading rotte],
      [Le rotte sono attualmente caricate in modo eager. La struttura feature-sliced è compatibile con una futura
        introduzione del lazy loading per ridurre ulteriormente il bundle iniziale.],
    )
  ]
]
