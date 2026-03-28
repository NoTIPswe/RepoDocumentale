#import "../../00-templates/base_document.typ" as base-document
#import "../specifica_tecnica/st_lib.typ" as st

#let metadata = yaml(sys.inputs.meta-path)


#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Specifica tecnica del microservizio notip-management-api: architettura interna, value object di dominio, definizione delle API, schema del database e metodologia di testing.",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione

  Questo documento illustra l'architettura interna e le scelte implementative del microservizio `notip-management-api`.
  Sviluppato in NestJS, questo componente è il fulcro del backend e ha la duplice funzione di fare da tramite tra
  frontend e servizi terzi come Keycloak e di salvare in Database le informazioni ricevute dagli altri microservizi
  attraverso NATS. Il microservizio espone molteplici endpoint divisi per ruolo e funzione principale.

  = Dipendenze e Configurazione

  == Variabili d'ambiente

  Tutte le variabili d'ambiente necessarie per il funzionamento del microservizio sono elencate di seguito, una
  eventuale mancanza di una di queste variabili comporterà un errore all'avvio del microservizio:

  #table(
    columns: (auto, auto, auto, auto),
    [Campo], [Variabile d'ambiente], [Default], [Obbligatorio],
    [KeycloakRealm], [KEYCLOAK_REALM], [-], [Si],
    [KeycloakClientId], [KEYCLOAK_MGMT_CLIENT_ID], [-], [Si],
    [KeycloakClientSecret], [KEYCLOAK_MGMT_CLIENT_SECRET], [-], [Si],
    [NATSUrl], [NATS_URL], [-], [No],
    [DBHost], [MGMT_DB_HOST], [—], [Sì],
    [DBPort], [MGMT_DB_PORT], [5432], [No],
    [DBName], [MGMT_DB_NAME], [—], [Sì],
    [DBUser], [MGMT_DB_USER], [—], [Sì],
    [DBPassword], [MGMT_DB_PASSWORD], [—], [Sì],
    [DBEncryptionKey], [MGMT_DB_ENCRYPTION_KEY], [-], [Si],
    [ApiPort], [MGMT_API_PORT], [3001], [No],
  )

  == Sequenza di avvio

  I passi bloccanti interrompono l'avvio del microservizio, pertanto è necessario assicurarsi che tutti i servizi
  esterni siano operativi prima di avviare `notip-management-api`. La sequenza di avvio è la seguente:
  #table(
    columns: (auto, 1.5fr, 2.5fr, auto),
    [Step], [Componente], [Azione], [Bloccante?],
    [0], [.env], [Carica le variabili d'ambiente del servizio], [Si],
    [1], [env.validation], [Verifica la validità delle variabili d'ambiente], [Si],
    [2], [bootstrap.nestjs], [Inizializza i moduli, controller e provider dell'applicazione NestJS], [Si],
    [3], [app.module], [Inizializza TypeORM], [Si],
    [4], [auth.module], [Registra guard, e servizi di autenticazione], [Si],
    [5], [jwt.strategy], [Configura la strategia JWT con Keycloak], [Si],
    [6], [keys.module], [Registra il modulo per la gestione delle chiavi], [Si],
    [7], [main], [Crea l’applicazione NestJS, registra pipe, filtri globali e documentazione Swagger.], [Si],
  )

  #pagebreak()

  = Architettura Logica

  Il servizio adotta una Layered Architecture con organizzazione interna di tipo Modular Monolith. All'interno dei vari
  moduli è utilizzato prevalentemente il pattern Controller-Service-Persistence, che consente una chiara separazione
  delle responsabilità tra esposizione API, logica di business e accesso ai dati. I componenti collaborano tramite
  Dependency Injection e, dove opportuno, tramite interfacce e contratti applicativi. La presenza di Business Models,
  DTO ed Entities ha portato all’introduzione di Mappers per la conversione dei dati tra i diversi livelli
  dell’applicazione.

  == Layout dei moduli
  Di seguito è riportata la struttura dei moduli interni al microservizio e delle cartelle di contorno, in particolare
  questa è la struttura del modulo `gateways`:

  ```text
  notip-management-api/
  ├── src/
  │   ├── gateways/
  │   │   ├── controller/         GatewaysController
  │   │   ├── services/           GatewaysService, GatewaysPersistenceService
  │   │   ├── models/             GatewayModel
  │   │   ├── entities/           GatewayEntity del relativo Repository TypeORM
  │   │   ├── interfaces/         controller-service-interfaces, service-persistence-interfaces
  │   │   ├── dto/                Tutti i request e response DTO relativi ai Gateway
  │   │   ├── enums/              Eventuali enumerazioni specifiche dei Gateway ad esempio GatewayStatus
  │   │   ├── gateways.module.ts
  │   │   └── gateways.mapper.ts
  │   │
  │   ├── common/                 Componenti condivisi tra i moduli, ad esempio decoratori, interceptor, pipe
  │   ├── test/                   Test unitari e di integrazione del servizio
  │   └── migrations/             TypeORM migrations per la gestione dello schema del database
  ```

  == Strati Architetturali
  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Strato], [Package], [Contenuto],
    [Presentation],
    [`src/*/controller`\ `src/auth`\ `src/common/decorators`\ `src/auth/guards`\ `src/common/interceptors`\
      `src/common/pipes`\ `src/common/filters`\ `src/*/dto`],
    [Gestione delle richieste HTTP, esposizione delle API REST, validazione dei payload, autenticazione e definizione
      dei contratti di ingresso/uscita dei dati.],

    [Business],
    [`src/*/services`\ `src/*/models`\ `src/*/interfaces`\ `src/*/enums`\ `src/*/*.mapper.ts`],
    [Logica di business, regole di dominio, orchestrazione dei processi, definizione dei modelli di dominio e delle
      interfacce tra i servizi, gestione delle richieste verso servizi esterni come Keycloak e NATS.],

    [Persistence],
    [`src/*/entities`\ `src/*/services/*.persistence.ts`\ `src/database`\ `src/migrations`],
    [Gestione dell'accesso ai dati tramite TypeORM, definizione delle entità e dei repository, gestione delle migrazioni
      del database, implementazione dei servizi di persistenza che interagiscono con il database PostgreSQL.],
  )

  = Design di Dettaglio

  == Moduli del microservizio
  I moduli principali all'interno del microservizio sono i seguenti:

  #table(
    columns: (0.5fr, 1fr),
    [Modulo], [Responsabilità],
    [AuthModule],
    [Gestione autenticazione e autorizzazione tramite Keycloak, implementazione della strategia JWT, definizione dei
      guard e delle policy di accesso agli endpoint.],

    [AdminModule],
    [Funzionalità amministrative di livello di sistema, in particolare gestione dei Tenant e di tutte le operazioni che
      richiedono privilegi elevati. Tra queste è inclusa la possibilità di impersonare un utente per conto del quale
      agire.],

    [GatewaysModule],
    [Gestisce le operazioni CRUD sui Gateway e gestisce gli endpoint accessibili agli utenti del Tenant.],

    [KeysModule],
    [Gestisce il provisioning, il recupero e la persistenza delle chiavi AES-256 associate ai gateway, inclusa la
      protezione del materiale sensibile nel database.],

    [UsersModule], [Gestisce le operazioni CRUD sugli utenti del Tenant, inclusa la sincronizzazione con Keycloak.],
    [CommandModule],
    [Gestisce l’invio dei comandi verso i gateway e l’integrazione con NATS/JetStream per la pubblicazione e il
      tracciamento dello stato dei comandi.],

    [AuditLogModule],
    [Gestisce la registrazione e la persistenza dei log di Audit delle operazioni eseguite dal microservizio.],

    [ApiClientModule], [Gestisce i client associati ai Tenant e la loro integrazione con Keycloak.],
    [AlertsModule],
    [Gestisce la configurazione e le operazioni relative agli alert sui Gateway, inclusa la definizione delle soglie di
      notifica.],

    [ThresholdsModule], [Gestisce le soglie applicative associate ai Gateway o ai Tenant.],
    [CostsModule], [ Gestisce le informazioni e la logica applicativa relative ai costi.],
    [CommonModule],
    [Contiene componenti trasversali come decoratori, filtri, intercettori, validazione configurazione e utility
      condivise.],
  )

  == Entità
  #table(
    columns: (1.5fr, 2fr),
    [Entità], [Campi],

    [TenantEntity],
    [`id`: `uuid v4`, `name`: `string`, `status`: `TenantStatus` `(enum)`, `suspensionIntervalDays`: `number | null`,
      `createdAt`: `Date`, `updatedAt`: `Date`],

    [UserEntity],
    [`id`: `uuid`, `tenantId`: `string`, `name`: `string`, `email`: `string`, `role`: `UsersRole` `(enum)`,
      `permissions`: `string[] | null`, `lastAccess`: `Date | null`, `createdAt`: `Date`],

    [GatewayEntity],
    [`id`: `uuid v4`, `tenantId`: `string`, `factoryId`: `string`, `factoryKeyHash`: `string | null`, `provisioned`:
      `boolean`, `model`: `string`, `firmwareVersion`: `string`, `createdAt`: `Date`, `updatedAt`: `Date`],

    [GatewayMetadataEntity],
    [`gatewayId`: `uuid`, `name`: `string`, `status`: `GatewayStatus` `(enum)`, `lastSeenAt`: `Date`, `sendFrequencyMs`:
      `number | null`],

    [KeyEntity],
    [`id`: `uuid v4`, `gatewayId`: `uuid`, `keyMaterial`: `Buffer`, `keyVersion`: `number`, `createdAt`: `Date`,
      `revokedAt`: `Date | null`],

    [AlertsEntity],
    [`id`: `uuid v4`, `tenantId`: `uuid`, `type`: `AlertType` `(enum)`, `gatewayId`: `uuid`, `details`: `jsonb`,
      `createdAt`: `Date`],

    [AlertsConfigEntity],
    [`id`: `uuid v4`, `tenantId`: `string`, `gatewayId`: `uuid | null`, `gatewayTimeoutMs`: `number`, `updatedAt`:
      `Date`],

    [ThresholdEntity],
    [`id`: `uuid v4`, `tenantId`: `uuid`, `sensorType`: `string | null`, `sensorId`: `uuid | null`, `minValue`:
      `number`, `maxValue`: `number`, `createdAt`: `Date`, `updatedAt`: `Date`],

    [AuditLogEntity],
    [`id`: `uuid v4`, `tenantId`: `uuid`, `userId`: `uuid`, `action`: `string`, `resource`: `string`, `details`:
      `jsonb`, `timestamp`: `Date`],

    [ApiClientEntity],
    [`id`: `string`, `tenantId`: `uuid`, `name`: `string`, `keycloakClientId`: `string`, `createdAt`: `Date`],

    [CommandEntity],
    [`id`: `uuid v4`, `gatewayId`: `uuid`, `tenantId`: `uuid`, `type`: `CommandType` `(enum)`, `status`: `CommandStatus`
      `(enum)`, `issuedAt`: `Date`, `ackReceivedAt`: `Date | null`, `createdAt`: `Date`],
  )

  == Endpoint API
  Di seguito è riportato l'elenco completo degli endpoint esposti dal microservizio divisi per area di interesse. Non
  tutti gli endpoint sono accessibili via frontend, alcuni sono utilizzati esclusivamente per la comunicazione tra
  microservizi o per operazioni di amministrazione via terminale:

  === Admin
  Questi endpoint sono accessibili solo agli utenti con ruolo `system_admin`:
  #table(
    columns: (1fr, auto, 2.2fr, 2.4fr, 2fr),
    align: (left, left, left, left, left),
    [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

    [`GET`],
    [`/admin/tenants`],
    [#par(justify: false)[
      #text(10pt)[Restituisce l’elenco dei Tenant]
    ]],
    [-],
    [#par(justify: false)[
      `[ { id: string, name: string, status: TenantStatus, created_at: Date } ]`
    ]],

    [`GET`],
    [`/admin/tenants/:id/users`],
    [#par(justify: false)[
      #text(10pt)[Restituisce gli utenti associati a uno specifico Tenant]
    ]],
    [-],
    [#par(justify: false)[
      `[ { user_id: string, role: string } ]`
    ]],

    [`POST`],
    [`/admin/tenants`],
    [#par(justify: false)[
      #text(10pt)[Crea un nuovo Tenant e il relativo amministratore]]],
    [#par(justify: false)[
      `name`: `string` \
      `admin_email`: `string` \
      `admin_name`: `string` \
      `admin_password`: `string`
    ]],
    [#par(justify: false)[
      `id`: `string` \
      `name`: `string` \
      `status`: `TenantStatus` \
      `created_at`: `Date`
    ]],

    [`PATCH`],
    [`/admin/tenants/:id`],
    [#par(justify: false)[
      #text(10pt)[Aggiorna i dati di un Tenant]
    ]],
    [#par(justify: false)[
      `name`: `string | null` \
      `status`: `TenantStatus | null` \
      `suspension_interval_days`: `number | null`
    ]],
    [#par(justify: false)[
      `id`: `string` \
      `name`: `string` \
      `status`: `TenantStatus` \
      `updated_at`: `Date`
    ]],

    [`DELETE`],
    [`/admin/tenants/:id`],
    [#text(10pt)[Elimina un Tenant]],
    [-],
    [#par(justify: false)[
      `message`: `string`
    ]],

    [`GET`],
    [`/admin/gateways`],
    [#par(justify: false)[
      #text(10pt)[Restituisce tutti i Gateway, con filtro opzionale per Tenant]
    ]],
    [-],
    [#par(justify: false)[
      `[ { id: string, tenant_id: string } ]`
    ]],

    [`POST`],
    [`/admin/gateways`],
    [#par(justify: false)[
      #text(10pt)[Registra un nuovo Gateway per un Tenant]
    ]],
    [#par(justify: false)[
      `factory_id`: `string` \
      `tenant_id`: `string` \
      `factory_key_hash`: `string`
    ]],
    [#par(justify: false)[
      `id`: `string`
    ]],
  )

  === Auth
  Questi endpoint sono accessibili agli utenti autenticati; l’endpoint di impersonazione è riservato agli utenti con
  ruolo `system_admin`:

  #table(
    columns: (1fr, auto, 2.2fr, 2.4fr, 2fr),
    align: (left, left, left, left, left),
    [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

    [`GET`],
    [`/auth/me`],
    [#par(justify: false)[
      #text(10pt)[Restituisce i dati dell’utente autenticato]
    ]],
    [-],
    [#par(justify: false)[
      `actorUserId`: `string` \
      `actorEmail`: `string | null` \
      `actorName`: `string | null` \
      `actorRole`: `UsersRole` \
      `actorTenantId`: `string | null` \
      `effectiveUserId`: `string` \
      `effectiveEmail`: `string | null` \
      `effectiveName`: `string | null` \
      `effectiveRole`: `UsersRole` \
      `effectiveTenantId`: `string | null` \
      `isImpersonating`: `boolean`
    ]],

    [`POST`],
    [`/auth/impersonate`],
    [#par(justify: false)[
      #text(10pt)[Genera un token di impersonazione per un utente]
    ]],
    [#par(justify: false)[
      `user_id`: `string`
    ]],
    [#par(justify: false)[
      `access_token`: `string` \
      `expires_in`: `number`
    ]],
  )

  === Gateways
  Questi endpoint sono accessibili agli utenti del Tenant; le operazioni di modifica sono riservate ai `tenant_admin`:

  #table(
    columns: (1fr, auto, 2.2fr, 2.4fr, 2fr),
    align: (left, left, left, left, left),
    [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

    [`GET`],
    [`/gateways`],
    [#par(justify: false)[
      #text(10pt)[Restituisce i Gateway del Tenant autenticato]
    ]],
    [-],
    [#par(justify: false)[
      `[ { id: string, name: string, status: GatewayStatus, last_seen_at: Date | null, provisioned: boolean, firmware_version: string | null, send_frequency_ms: number | null } ]`
    ]],

    [`GET`],
    [`/gateways/:id`],
    [#par(justify: false)[
      #text(10pt)[Restituisce il dettaglio di un Gateway]
    ]],
    [-],
    [#par(justify: false)[
      `id`: `string` \
      `name`: `string` \
      `status`: `GatewayStatus` \
      `last_seen_at`: `Date | null` \
      `provisioned`: `boolean` \
      `firmware_version`: `string | null` \
      `send_frequency_ms`: `number | null`
    ]],

    [`PATCH`],
    [`/gateways/:id`],
    [#par(justify: false)[
      #text(10pt)[Aggiorna il nome di un Gateway]
    ]],
    [#par(justify: false)[
      `name`: `string`
    ]],
    [#par(justify: false)[
      `id`: `string` \
      `name`: `string` \
      `status`: `GatewayStatus` \
      `updated_at`: `Date`
    ]],

    [`DELETE`],
    [`/gateways/:id`],
    [#par(justify: false)[
      #text(10pt)[Elimina un Gateway]
    ]],
    [-],
    [#par(justify: false)[
      `message`: `string`
    ]],
  )

  === Users
  Questi endpoint sono accessibili agli utenti con ruolo `tenant_admin`:

  #table(
    columns: (1fr, auto, 2.2fr, 2.4fr, 2fr),
    align: (left, left, left, left, left),
    [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

    [`GET`],
    [`/users`],
    [#par(justify: false)[
      #text(10pt)[Restituisce gli utenti del Tenant]
    ]],
    [-],
    [#par(justify: false)[
      `[ { id: string, name: string, email: string, role: UsersRole, last_access: Date | null } ]`
    ]],

    [`GET`],
    [`/users/:id`],
    [#par(justify: false)[
      #text(10pt)[Restituisce il dettaglio di un utente]
    ]],
    [-],
    [#par(justify: false)[
      `id`: `string` \
      `name`: `string` \
      `email`: `string` \
      `role`: `UsersRole` \
      `last_access`: `Date | null`
    ]],

    [`POST`],
    [`/users`],
    [#par(justify: false)[
      #text(10pt)[Crea un utente nel Tenant]
    ]],
    [#par(justify: false)[
      `name`: `string` \
      `email`: `string` \
      `role`: `UsersRole` \
      `password`: `string`
    ]],
    [#par(justify: false)[
      `id`: `string` \
      `name`: `string` \
      `email`: `string` \
      `role`: `UsersRole` \
      `created_at`: `Date`
    ]],

    [`PATCH`],
    [`/users/:id`],
    [#par(justify: false)[
      #text(10pt)[Aggiorna un utente del Tenant]
    ]],
    [#par(justify: false)[
      `name`: `string | null` \
      `email`: `string | null` \
      `role`: `UsersRole | null` \
      `permissions`: `string[] | null`
    ]],
    [#par(justify: false)[
      `id`: `string` \
      `name`: `string` \
      `email`: `string` \
      `role`: `UsersRole` \
      `updated_at`: `Date`
    ]],

    [`POST`],
    [`/users/bulk-delete`],
    [#par(justify: false)[
      #text(10pt)[Elimina più utenti in un’unica richiesta]
    ]],
    [#par(justify: false)[
      `ids`: `uuid[]`
    ]],
    [#par(justify: false)[
      `deleted`: `number` \
      `failed`: `string[]`
    ]],
  )

  === API Clients
  Questi endpoint sono accessibili agli utenti con ruolo `tenant_admin`:

  #table(
    columns: (1fr, auto, 2.2fr, 2.4fr, 2fr),
    align: (left, left, left, left, left),
    [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

    [`GET`],
    [`/api-clients`],
    [#par(justify: false)[
      #text(10pt)[Restituisce i client API del Tenant]
    ]],
    [-],
    [#par(justify: false)[
      `[ { id: string, name: string, client_id: string, created_at: Date } ]`
    ]],

    [`POST`],
    [`/api-clients`],
    [#par(justify: false)[
      #text(10pt)[Crea un nuovo client API]
    ]],
    [#par(justify: false)[
      `name`: `string`
    ]],
    [#par(justify: false)[
      `id`: `string` \
      `name`: `string` \
      `client_id`: `string` \
      `client_secret`: `string | null` \
      `created_at`: `Date`
    ]],

    [`DELETE`],
    [`/api-clients/:id`],
    [#par(justify: false)[
      #text(10pt)[Elimina un client API]
    ]],
    [-],
    [#par(justify: false)[
      `204 No Content`
    ]],
  )

  #pagebreak()

  === Keys e Provisioning
  Gli endpoint `/keys` sono accessibili agli utenti del Tenant, ma sono bloccati se è in corso una operazione di
  impersonazione; Gli endpoint di provisioning interno sono usati nel flusso di attivazione dei gateway e non sono
  esposti al frontend né destinati all’uso diretto da parte degli utenti.

  #table(
    columns: (1fr, auto, 2.2fr, 2.4fr, 2fr),
    align: (left, left, left, left, left),
    [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

    [`GET`],
    [`/keys?id=:gatewayId`],
    [#par(justify: false)[
      #text(10pt)[Restituisce le chiavi associate a un Gateway]
    ]],
    [-],
    [#par(justify: false)[
      `[ { gateway_id: string, key_material: Buffer, key_version: number } ]`
    ]],

    [`POST`],
    [`/internal/provisioning/validate`],
    [#par(justify: false)[
      #text(10pt)[Valida factory ID e factory key del Gateway]
    ]],
    [#par(justify: false)[
      `factory_id`: `string` \
      `factory_key`: `string`
    ]],
    [#par(justify: false)[
      `gateway_id`: `string` \
      `tenant_id`: `string`
    ]],

    [`POST`],
    [`/internal/provisioning/complete`],
    [#par(justify: false)[
      #text(10pt)[Completa il provisioning del Gateway]
    ]],
    [#par(justify: false)[
      `gateway_id`: `string` \
      `key_material`: `string` \
      `key_version`: `number`
    ]],
    [#par(justify: false)[
      `success`: `boolean`
    ]],
  )

  === Alerts
  Questi endpoint sono accessibili agli utenti del Tenant; le modifiche alla configurazione sono riservate ai
  `tenant_admin`:

  #table(
    columns: (1fr, 1.5fr, 2.2fr, auto, 2fr),
    align: (left, left, left, left, left),
    [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

    [`GET`],
    [`/alerts`],
    [#par(justify: false)[
      #text(10pt)[Restituisce gli alert del Tenant nel range temporale richiesto]
    ]],
    [-],
    [#par(justify: false)[
      `[ { id: string, gateway_id: string, type: AlertType, details: { last_seen: Date, timeout_configured: number }, created_at: Date } ]`
    ]],

    [`GET`],
    [`/alerts/config`],
    [#par(justify: false)[
      #text(10pt)[Restituisce la configurazione alert del Tenant]
    ]],
    [-],
    [#par(justify: false)[
      `default_timeout_ms`: `number` \
      `gateway_overrides`: `[{ gateway_id: string, timeout_ms: number }]`
    ]],

    [`PUT`],
    [`/alerts/config/default`],
    [#par(justify: false)[
      #text(10pt)[Imposta la configurazione alert di default del Tenant]
    ]],
    [#par(justify: false)[
      `tenant_unreachable_timeout_ms`: `number`
    ]],
    [#par(justify: false)[
      `tenant_id`: `string` \
      `default_timeout_ms`: `number` \
      `updated_at`: `Date`
    ]],

    [`PUT`],
    [#par(justify: false)[
      `/alerts/config/gateway/` \
      `:gatewayId`
    ]],
    [#par(justify: false)[
      #text(10pt)[Imposta la configurazione alert per uno specifico Gateway]
    ]],
    [#par(justify: false)[
      `gateway_unreachable_timeout_ms`: `number`
    ]],
    [#par(justify: false)[
      `gateway_id`: `string` \
      `timeout_ms`: `number` \
      `updated_at`: `Date`
    ]],

    [`DELETE`],
    [#par(justify: false)[
      `/alerts/config/gateway/` \
      `:gatewayId`
    ]],
    [#par(justify: false)[
      #text(10pt)[Elimina la configurazione alert specifica del Gateway]
    ]],
    [-],
    [#par(justify: false)[
      `message`: `string`
    ]],
  )

  #pagebreak()

  === Thresholds
  Questi endpoint sono accessibili agli utenti del Tenant; le modifiche sono riservate ai `tenant_admin`:

  #table(
    columns: (1fr, auto, 2.2fr, 2.4fr, 2fr),
    align: (left, left, left, left, left),
    [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

    [`GET`],
    [`/thresholds`],
    [#par(justify: false)[
      #text(10pt)[Restituisce le soglie del Tenant]
    ]],
    [-],
    [#par(justify: false)[
      `[ { sensor_type: string | null, sensor_id: string | null, min_value: number, max_value: number, updated_at: Date } ]`
    ]],

    [`PUT`],
    [`/thresholds/default`],
    [#par(justify: false)[
      #text(10pt)[Imposta la soglia di default per una tipologia di sensore]
    ]],
    [#par(justify: false)[
      `sensor_type`: `string` \
      `min_value`: `number` \
      `max_value`: `number`
    ]],
    [#par(justify: false)[
      `sensor_type`: `string | null` \
      `min_value`: `number` \
      `max_value`: `number` \
      `updated_at`: `Date`
    ]],

    [`PUT`],
    [`/thresholds/sensor/:sensorId`],
    [#par(justify: false)[
      #text(10pt)[Imposta la soglia per uno specifico sensore]
    ]],
    [#par(justify: false)[
      `min_value`: `number` \
      `max_value`: `number` \
      `sensor_type`: `string | null`
    ]],
    [#par(justify: false)[
      `sensor_id`: `string | null` \
      `sensor_type`: `string | null` \
      `min_value`: `number` \
      `max_value`: `number` \
      `updated_at`: `Date`
    ]],

    [`DELETE`],
    [`/thresholds/sensor/:sensorId`],
    [#par(justify: false)[
      #text(10pt)[Elimina la soglia associata a uno specifico sensore]
    ]],
    [-],
    [#par(justify: false)[
      `message`: `string`
    ]],

    [`DELETE`],
    [`/thresholds/type/:sensorType`],
    [#par(justify: false)[
      #text(10pt)[Elimina la soglia di default associata a una tipologia di sensore]
    ]],
    [-],
    [#par(justify: false)[
      `message`: `string`
    ]],
  )

  === Commands
  Questi endpoint sono accessibili agli utenti con ruolo `tenant_admin`:

  #table(
    columns: (1fr, auto, 2.2fr, 2.4fr, 2fr),
    align: (left, left, left, left, left),
    [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

    [`POST`],
    [`/cmd/:gatewayId/config`],
    [#par(justify: false)[
      #text(10pt)[Invia una configurazione a un Gateway]
    ]],
    [#par(justify: false)[
      `send_frequency_ms`: `number | null` \
      `status`: `string | null`
    ]],
    [#par(justify: false)[
      `command_id`: `string` \
      `status`: `CommandStatus` \
      `issued_at`: `Date`
    ]],

    [`POST`],
    [`/cmd/:gatewayId/firmware`],
    [#par(justify: false)[
      #text(10pt)[Invia un comando di aggiornamento firmware]
    ]],
    [#par(justify: false)[
      `firmware_version`: `string` \
      `download_url`: `string`
    ]],
    [#par(justify: false)[
      `command_id`: `string` \
      `status`: `CommandStatus` \
      `issued_at`: `Date`
    ]],

    [`GET`],
    [`/cmd/:gatewayId/status/:commandId`],
    [#par(justify: false)[
      #text(10pt)[Restituisce lo stato di esecuzione di un comando]
    ]],
    [-],
    [#par(justify: false)[
      `command_id`: `string` \
      `status`: `CommandStatus` \
      `timestamp`: `Date`
    ]],
  )

  #pagebreak()

  === Audit
  Questi endpoint sono accessibili agli utenti con ruolo `tenant_admin`:

  #table(
    columns: (1fr, auto, 2.2fr, 2.4fr, 2fr),
    align: (left, left, left, left, left),
    [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

    [`GET`],
    [`/audit?from=...&to=...`],
    [#par(justify: false)[
      #text(10pt)[Restituisce i log di audit del Tenant]
    ]],
    [-],
    [#par(justify: false)[
      `[ { id: string, user_id: string, action: string, resource: string, details: object, timestamp: Date } ]`
    ]],
  )

  === Costs
  Questi endpoint sono accessibili agli utenti con ruolo `tenant_admin`:

  #table(
    columns: (1fr, auto, 2.2fr, 2.4fr, 2fr),
    align: (left, left, left, left, left),
    [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

    [`GET`],
    [`/costs`],
    [#par(justify: false)[
      #text(10pt)[Restituisce i costi correnti del Tenant]
    ]],
    [-],
    [#par(justify: false)[
      `storage_gb`: `number` \
      `bandwidth_gb`: `number`
    ]],
  )

  === Errori
  #table(
    columns: (auto, auto, 2.2fr),
    align: (left, left, left),
    [Codice], [Errore], [Descrizione],
    [401], [Unauthorized], [Client non autorizzato.],
    [403],
    [Forbidden],
    [Accesso negato, mancanza di permessi necessari, oppure nei casi di endpoint bloccati a chi sta impersonando un
      altro utente.],

    [404],

    [Not Found], [Risorsa richiesta non trovata.], [409],
    [Conflict],
    [Conflitto nello stato della risorsa, ad esempio tentativo di creare un Gateway con factory_id già esistente.],

    [500], [Internal Server Error], [Errore generico del server, in caso di eccezioni non gestite o errori imprevisti.],
    [503], [Service Unavailable],

    [Il servizio non è disponibile, ad esempio in caso di problemi di connessione con NATS o a Keycloak.],
  )


  == Flussi di Esecuzione
  Di seguito sono descritti i principali flussi di esecuzione del microservizio, con particolare attenzione ai
  componenti coinvolti e alle interazioni con i servizi esterni.

  === Autenticazione
  Il client ottiene un token JWT da Keycloak e lo include nelle richieste inviate al microservizio. Il backend valida il
  token tramite la strategia JWT configurata nel modulo di autenticazione, verificando issuer, audience e chiavi
  pubbliche del realm. In caso di validazione positiva, le informazioni contenute nel token vengono trasformate in un
  utente autenticato applicativo, includendo ruolo effettivo, tenant di appartenenza ed eventuali informazioni di
  impersonazione. Tali informazioni vengono poi utilizzate dai guard e dalle policy di accesso per autorizzare o negare
  l’accesso agli endpoint.

  === Creazione di un Tenant
  Un utente con ruolo `system_admin` invia una richiesta di creazione di un tenant tramite l’endpoint amministrativo
  dedicato. Il controller delega l’operazione al service applicativo, che avvia una transazione sul database locale e
  crea l’entità del tenant. Successivamente il backend interagisce con Keycloak per creare l’utente amministratore del
  tenant, assegnargli il ruolo applicativo previsto e associargli gli attributi necessari, incluso il riferimento al
  tenant. Una volta completata la creazione remota, il microservizio persiste anche il corrispondente utente locale nel
  database applicativo. In caso di errore durante il flusso, vengono applicati meccanismi di rollback per ridurre il
  rischio di inconsistenze tra database locale e Keycloak.

  === Creazione di un Utente Tenant
  Un utente con ruolo `tenant_admin` invia una richiesta di creazione di un nuovo utente appartenente al proprio tenant.
  Il controller inoltra i dati al service applicativo, che coordina la creazione dell’utente sia nel database locale sia
  su Keycloak. Dopo la creazione remota, il backend salva le informazioni dell’utente nel database applicativo,
  mantenendo allineati il sistema locale e il provider di identità. Il ruolo applicativo assegnato all’utente viene
  sincronizzato con i ruoli configurati in Keycloak.

  === Impersonazione di un Utente
  Un utente con ruolo `system_admin` invia una richiesta di impersonazione tramite l’endpoint `/auth/impersonate`,
  specificando l’identificativo dell’utente target. Il microservizio estrae il token amministrativo della richiesta e
  delega a Keycloak l’operazione di token exchange. Keycloak restituisce un nuovo access token che rappresenta l’utente
  impersonato, mantenendo le informazioni necessarie a identificare anche l’attore originale. Il token risultante viene
  poi utilizzato nelle richieste successive verso il microservizio. Durante l’impersonazione, alcuni endpoint risultano
  bloccati tramite guard dedicati, così da impedire specifiche operazioni sensibili mentre si opera nel contesto di un
  altro utente.

  === Provisioning di un Gateway
  Il flusso di provisioning è esposto tramite endpoint interni dedicati. In una prima fase il sistema chiamante invia
  `factory_id` e `factory_key` all’endpoint di validazione; il microservizio verifica che il gateway esista, che non sia
  già provisioned e che la factory key fornita corrisponda al valore atteso. In caso di esito positivo, il backend
  restituisce l’identificativo del gateway e del tenant associato. In una seconda fase viene inviata la richiesta di
  completamento del provisioning, contenente il materiale della chiave e la relativa versione. Il microservizio persiste
  la nuova chiave associandola al gateway, applica la cifratura del materiale sensibile in fase di salvataggio e
  aggiorna lo stato del gateway come `provisioned`. A partire da questo momento il gateway viene considerato attivo dal
  punto di vista applicativo.

  === Recupero delle Chiavi di un Gateway
  Un utente autenticato del tenant richiede le chiavi associate a uno specifico gateway. Il controller inoltra
  l’identificativo del tenant e del gateway al service applicativo, che verifica preliminarmente che il gateway
  appartenga effettivamente al tenant chiamante. Dopo il controllo di autorizzazione, il layer di persistenza recupera
  le chiavi dal database. Il materiale crittografico viene decifrato automaticamente durante la lettura tramite il
  transformer associato all’entità, e i dati vengono infine convertiti nel formato di risposta esposto dall’API.

  === Creazione di un API Client
  Un utente con ruolo `tenant_admin` richiede la creazione di un nuovo API client associato al tenant. Il microservizio
  delega a Keycloak la creazione del client applicativo e del relativo secret, quindi persiste nel database locale le
  informazioni necessarie a rappresentarlo nel dominio applicativo. La risposta restituisce sia i dati del nuovo client
  sia, nel momento della creazione, il secret necessario per l’utilizzo da parte del chiamante.

  === Invio di un Comando a un Gateway
  Un utente con ruolo `tenant_admin` invia un comando verso un gateway, ad esempio per aggiornare la configurazione o
  avviare un aggiornamento firmware. Il controller raccoglie i dati della richiesta e li passa al service applicativo,
  che crea il record del comando nel database con stato iniziale coerente con il flusso di esecuzione. Successivamente
  il comando viene inoltrato al layer di integrazione con NATS/JetStream per la pubblicazione verso il sistema
  destinatario. Lo stato del comando può poi essere interrogato tramite l’endpoint dedicato, che restituisce le
  informazioni persistite sul relativo avanzamento.

  === Configurazione di Alert e Threshold
  Gli utenti del tenant possono consultare la configurazione degli alert e delle soglie, mentre le operazioni di
  modifica sono riservate agli utenti con privilegi amministrativi sul tenant. Le richieste vengono gestite dai
  rispettivi controller e inoltrate ai service applicativi, che verificano il contesto tenant e applicano le regole di
  autorizzazione. Le configurazioni possono essere definite a livello generale di tenant oppure, a seconda del caso
  d’uso, a livello specifico di gateway o sensore. Le modifiche vengono persistite nel database e restituite al
  chiamante in forma coerente con il contratto API.

  === Consultazione dei Log di Audit
  Un utente con ruolo `tenant_admin` può interrogare i log di audit specificando almeno un intervallo temporale di
  interesse. Il controller valida la presenza dei parametri obbligatori e inoltra la richiesta al service dedicato, che
  recupera dal database gli eventi registrati per il tenant. I risultati vengono quindi trasformati nel formato di
  risposta previsto e restituiti al chiamante. Questo flusso consente di tracciare le operazioni rilevanti eseguite nel
  sistema da utenti reali o impersonati.

  = Metodologie di Testing

  Il microservizio prevede test di unità e test di integrazione intra-service, con l’obiettivo di verificare la
  correttezza della logica applicativa, dei controlli di accesso, delle trasformazioni dei dati e delle interazioni con
  il layer di persistenza. Le attività di test sono orientate alla validazione del comportamento dei componenti e non
  alla semplice verifica della tecnologia utilizzata.

  == Test di unità

  I test di unità coprono i controller, i service applicativi, i guard, i mapper, i transformer e i componenti di
  supporto che implementano regole di business o di sicurezza. In particolare, devono essere verificati i seguenti
  aspetti:

  - corretta delega dei controller ai service applicativi;
  - corretta applicazione dei controlli di accesso basati su ruolo, tenant e stato di impersonazione;
  - corretta validazione e interpretazione delle informazioni estratte dal token JWT;
  - corretta gestione dei principali casi d’uso applicativi, inclusi tenant, utenti, gateway, chiavi, client API, alert,
    threshold e comandi;
  - corretta gestione delle condizioni di errore e delle eccezioni applicative;
  - corretta trasformazione tra DTO, model ed entity;
  - corretta cifratura e decifratura del materiale sensibile associato alle chiavi dei gateway;
  - corretta validazione della configurazione applicativa caricata all’avvio.

  == Test di integrazione intra-service

  I test di integrazione intra-service verificano il comportamento coordinato di più componenti interni al
  microservizio, con particolare attenzione alle interazioni tra logica applicativa, persistenza e configurazione. In
  particolare, devono essere coperti i seguenti aspetti:

  - corretta inizializzazione del bootstrap applicativo in presenza di configurazione valida;
  - corretto fallimento dell’avvio in presenza di configurazione mancante o invalida;
  - corretto comportamento dei componenti di persistenza verso il database di test;
  - corretta esecuzione delle transazioni nei flussi critici, come provisioning dei gateway e creazione dei tenant;
  - corretta persistenza e recupero delle entity applicative;
  - corretta integrazione del layer di autenticazione con il modello utente applicativo;
  - corretta integrazione dei componenti che interagiscono con Keycloak o con NATS, ove tali integrazioni siano simulate
    o testate tramite fixture dedicate.

  == Obiettivi di copertura funzionale

  Le attività di testing devono garantire che il microservizio sia verificato almeno rispetto ai seguenti ambiti
  funzionali:

  - autenticazione e autorizzazione;
  - segregazione multi-tenant;
  - gestione tenant e utenti;
  - gestione gateway e provisioning;
  - gestione delle chiavi e protezione del materiale sensibile;
  - gestione dei client API;
  - gestione alert e threshold;
  - invio e tracciamento dei comandi;
  - audit delle operazioni rilevanti;
  - corretto caricamento della configurazione e bootstrap del servizio.

]
