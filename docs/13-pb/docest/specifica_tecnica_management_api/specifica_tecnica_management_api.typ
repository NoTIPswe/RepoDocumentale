#import "../../00-templates/base_document.typ" as base-document
#import "../specifica_tecnica/st_lib.typ" as st

#let metadata = yaml("specifica_tecnica_management_api.meta.yaml")


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

  Tutte le variabili d'ambiente necessarie per il funzionamento del microservizio sono elencate di seguito, un'eventuale
  mancanza di una di queste variabili comporterà un errore all'avvio del microservizio:

  #figure(
    caption: [Variabili d'ambiente del microservizio `notip-management-api`],
  )[
    #table(
      columns: (auto, auto, auto, auto),
      [Campo], [Variabile d'ambiente], [Default], [Obbligatorio],
      [KeycloakRealm], [KEYCLOAK_REALM], [-], [Si],
      [KeycloakClientId], [KEYCLOAK_MGMT_CLIENT_ID], [-], [Si],
      [KeycloakClientSecret], [KEYCLOAK_MGMT_CLIENT_SECRET], [-], [Si],
      [KeycloakUrl], [KEYCLOAK_URL], [-], [Si],
      [NATSUrl], [NATS_URL], [-], [Si],
      [DBHost], [MGMT_DB_HOST], [—], [Sì],
      [DBPort], [MGMT_DB_PORT], [5432], [No],
      [DBName], [MGMT_DB_NAME], [—], [Sì],
      [DBUser], [MGMT_DB_USER], [—], [Sì],
      [DBPassword], [MGMT_DB_PASSWORD], [—], [Sì],
      [DBEncryptionKey], [DB_ENCRYPTION_KEY], [-], [Si],
      [ApiPort], [MGMT_API_PORT], [3000], [No],
      [NodeEnv], [NODE_ENV], [development], [No],
      [NatsServers], [NATS_SERVERS], [NATS_URL], [No],
      [NatsClientName], [NATS_CLIENT_NAME], [management-api], [No],
      [NatsDurablePrefix], [NATS_DURABLE_PREFIX], [management-api], [No],
      [NatsTlsCa], [NATS_TLS_CA], [-], [No],
      [NatsTlsCert], [NATS_TLS_CERT], [-], [No],
      [NatsTlsKey], [NATS_TLS_KEY], [-], [No],
      [NatsToken], [NATS_TOKEN], [-], [No],
      [NatsUser], [NATS_USER], [-], [No],
      [NatsPassword], [NATS_PASSWORD], [-], [No],
    )
  ]


  == Sequenza di avvio

  I passi bloccanti interrompono l'avvio del microservizio, pertanto è necessario assicurarsi che tutti i servizi
  esterni siano operativi prima di avviare `notip-management-api`. La sequenza di avvio è la seguente:

  #figure(
    caption: [Sequenza di avvio del microservizio `notip-management-api`],
  )[
    #table(
      columns: (auto, 1.5fr, 2.5fr, auto),
      [Step], [Componente], [Azione], [Bloccante?],
      [0], [.env], [Carica le variabili d'ambiente del servizio], [Si],
      [1], [env.validation], [Verifica la validità delle variabili d'ambiente], [Si],
      [2], [ConfigModule], [Carica e valida la configurazione globale del microservizio], [Si],
      [3], [app.module], [Registra i moduli applicativi, EventEmitter e il provider globale di audit], [Si],
      [4], [TypeORM], [Inizializza la connessione PostgreSQL, tranne in ambiente di test], [Si],
      [5],
      [auth.module],
      [Registra i guard globali di autenticazione, ruoli, policy di accesso e blocco impersonazione],
      [Si],

      [6], [jwt.strategy], [Configura la strategia JWT con Keycloak e JWKS], [Si],
      [7],
      [main],
      [Crea l’applicazione NestJS, registra ValidationPipe, filtri globali e documentazione Swagger su `/docs`.],
      [Si],

      [8], [http.server], [Avvia il listener HTTP sulla porta configurata], [Si],
    )
  ]

  = Architettura Logica

  Il servizio adotta una Layered Architecture con organizzazione interna di tipo Modular Monolith. All'interno dei vari
  moduli è utilizzato prevalentemente il pattern Controller-Service-Persistence, che consente una chiara separazione
  delle responsabilità tra esposizione API, logica di business e accesso ai dati. I componenti collaborano tramite
  Dependency Injection e, dove opportuno, tramite interfacce e contratti applicativi. La presenza di Business Models,
  DTO ed Entities ha portato all’introduzione di Mappers per la conversione dei dati tra i diversi livelli
  dell’applicazione.

  == Layout dei moduli
  Essendo il microservizio troppo grande per essere contenuto in un unico diagramma, di seguito è riportata la struttura
  dei moduli interni al microservizio e delle cartelle di contorno, in particolare questa è la struttura del modulo
  `gateways`:

  #figure(
    caption: [Architettura interna del modulo `Gateways`],
  )[
    #image("./assets/gatewaysDiagram.png", width: 90%)
  ]

  ```text
  notip-management-api/
  ├── src/
  │   ├── gateways/
  │   │   ├── controller/     GatewaysController
  │   │   ├── services/       GatewaysService, GatewaysPersistenceService
  │   │   ├── models/         GatewayModel
  │   │   ├── entities/       GatewayEntity del relativo Repository TypeORM
  │   │   ├── interfaces/     Controller-service-interfaces, service-persistence-interfaces
  │   │   ├── dto/            Tutti i request e response DTO relativi ai Gateway
  │   │   ├── enums/          Eventuali enumerazioni specifiche dei Gateway ad esempio GatewayStatus
  │   │   ├── gateways.module.ts
  │   │   └── gateways.mapper.ts
  │   │
  │   ├── common/             Componenti condivisi tra i moduli, ad esempio decoratori
  │   ├── test/               Test unitari e di integrazione del servizio
  │   └── migrations/         TypeORM migrations per la gestione dello schema del database
  ```
  == Strati Architetturali
  Di seguito è riportata la suddivisione in strati architetturali del microservizio, con l'indicazione delle cartelle e
  dei componenti principali:

  #figure(
    caption: [Strati architetturali del microservizio `notip-management-api`],
  )[
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
      [Gestione dell'accesso ai dati tramite TypeORM, definizione delle entità e dei repository, gestione delle
        migrazioni del database, implementazione dei servizi di persistenza che interagiscono con il database
        PostgreSQL.],
    )]

  = Design di Dettaglio
  == Moduli del microservizio
  I moduli principali all'interno del microservizio sono i seguenti:

  === AdminModule
  Funzionalità amministrative di livello di sistema, in particolare gestione dei Tenant e di tutte le operazioni che
  richiedono privilegi elevati. Tra queste è inclusa la possibilità di impersonare un utente per conto del quale agire.
  ==== Admin Tenants
  #figure(caption: "Diagramma del modulo AdminModule")[#image("assets/02-admin-tenants.svg")]

  Il sottosistema di gestione dei Tenant si occupa di tutte le operazioni amministrative relative ai tenant del sistema:
  creazione, modifica, sospensione, riattivazione ed eliminazione. È il punto di ingresso per la gestione del ciclo di
  vita dei tenant e dei loro utenti.

  ===== TenantsController

  Controller NestJS esposto sotto il prefisso `/admin/tenants`. Protetto dal decoratore `@AdminOnly()`, espone cinque
  endpoint REST. Delega ogni operazione a `TenantsService` e utilizza `TenantsMapper` per trasformare i risultati nei
  DTO di risposta appropriati.

  #table(
    columns: (1.2fr, 2.5fr, 2.3fr),
    [Metodo], [Endpoint], [Note],
    [`getTenants()`], [`GET /admin/tenants`], [Restituisce la lista di tutti i tenant con i relativi dettagli],

    [`getTenantUsers(id)`], [`GET /admin/tenants/:id/users`], [Restituisce gli utenti associati a un tenant specifico],

    [`createTenant(dto)`], [`POST /admin/tenants`], [Crea un nuovo tenant con il relativo utente amministratore],

    [`updateTenant(id, dto)`],
    [`PATCH /admin/tenants/:id`],
    [Aggiorna nome, stato o intervallo di sospensione di un tenant],

    [`deleteTenant(id)`], [`DELETE /admin/tenants/:id`], [Elimina un tenant e cascata tutti i dati associati],
  )

  ===== TenantsService

  Contiene la logica di business principale. Coordina `TenantsPersistenceService`, `KeycloakAdminService` e
  `ApiClientService`.

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`tenantsPersistenceService`], [`TenantsPersistenceService`], [Iniettato via constructor],
    [`keycloakAdminService`], [`KeycloakAdminService`], [Iniettato via constructor],
    [`apiClientService`], [`ApiClientService`], [Iniettato via constructor],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.6fr, 2fr),
    [Metodo], [Firma], [Note],
    [`getTenants()`],
    [`(): Promise<TenantsModel[]>`],
    [Recupera tutti i tenant dal database e li restituisce come array di modelli],

    [`getTenantUsers(tenantId)`],
    [`(tenantId: string): Promise<UserEntity[]>`],
    [Recupera gli utenti di un tenant specifico],

    [`createTenant(input)`],
    [`(input: CreateTenantInput): Promise<TenantsModel>`],
    [Crea un tenant in modo transazionale: entità DB, gruppo Keycloak, utente admin, client API. Rollback completo in
      caso di errore],

    [`updateTenant(input)`],
    [`(input: UpdateTenantInput): Promise<TenantsModel>`],
    [Aggiorna un tenant esistente; sincronizza il nome del gruppo su Keycloak se il nome è cambiato],

    [`deleteTenant(input)`],
    [`(input: DeleteTenantInput): Promise<void>`],
    [Elimina un tenant e tutti i dati correlati: utenti, gateway, gruppo Keycloak, client API],
  )

  _Metodi privati:_
  #table(
    columns: (2fr, 3.5fr),
    [Metodo], [Comportamento],
    [`isSuspensionExpired(tenant)`],
    [Verifica se un tenant sospeso ha superato il periodo di sospensione configurato confrontando `suspensionUntil` con
      la data corrente],

    [`reactivateTenantIfExpired(tenant)`],
    [Riattiva automaticamente un tenant il cui periodo di sospensione è scaduto, impostando lo stato ad `ACTIVE`],

    [`syncTenantUsersEnabledState(tenantId, status)`],
    [Sincronizza lo stato enabled/disabled di tutti gli utenti del tenant su Keycloak in base allo stato del tenant],
  )

  ===== KeycloakAdminService

  Servizio di integrazione con Keycloak IAM. Utilizza `ConfigService` per recuperare le credenziali di accesso e
  comunica con le API REST di Keycloak tramite `fetch()`.

  _Campi:_

  #table(
    columns: (2fr, 2.5fr, 2fr),
    [Campo], [Tipo], [Note],
    [`configService`], [`ConfigService`], [Iniettato; fornisce URL, realm, admin username/password],
  )

  _Metodi pubblici:_

  #table(
    columns: (2fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`createApiClient(name, tenantId)`],
    [`(name: string, tenantId: string): Promise<ClientRepresentation>`],
    [Crea un client OIDC su Keycloak per un tenant],

    [`deleteApiClient(clientUuid)`], [`(clientUuid: string): Promise<void>`], [Elimina un client OIDC da Keycloak],

    [`updateApiClient(clientUuid, name)`],
    [`(clientUuid: string, name: string): Promise<void>`],
    [Aggiorna il nome di un client OIDC],

    [`createTenantAdminUser(input)`],
    [`(input: CreateUserInput): Promise<string>`],
    [Crea l'utente amministratore del tenant su Keycloak; restituisce l'ID utente],

    [`createTenantUser(input)`],
    [`(input: CreateUserInput): Promise<string>`],
    [Crea un utente generico del tenant su Keycloak; restituisce l'ID utente],

    [`getClientCredentialsToken()`],
    [`(): Promise<string>`],
    [Ottiene un token di accesso tramite client credentials grant],

    [`deleteUser(userId)`], [`(userId: string): Promise<void>`], [Elimina un utente da Keycloak],

    [`syncUserApplicationRole(userId, role)`],
    [`(userId: string, role: string): Promise<void>`],
    [Assegna o rimuove il ruolo applicativo a un utente],

    [`updateUser(userId, updates)`],
    [`(userId: string, updates: UserRepresentation): Promise<void>`],
    [Aggiorna i dati di un utente su Keycloak],

    [`setUserEnabled(userId, enabled)`],
    [`(userId: string, enabled: boolean): Promise<void>`],
    [Abilita o disabilita un utente su Keycloak],

    [`updateTenantGroup(oldId, newId)`],
    [`(oldId: string, newId: string): Promise<void>`],
    [Rinomina il gruppo tenant su Keycloak],

    [`deleteTenantGroup(tenantId)`], [`(tenantId: string): Promise<void>`], [Elimina il gruppo tenant da Keycloak],
  )

  _Metodi privati:_

  #table(
    columns: (1.5fr, 3.5fr),
    [Metodo], [Comportamento],
    [`deleteUserWithToken(userId, token)`], [Elimina un utente utilizzando un token di accesso specifico],

    [`ensureExclusiveAppRole(token, userId, role)`],
    [Garantisce che l'utente abbia un solo ruolo applicativo, rimuovendo ruoli conflittuali],

    [`ensureTenantGroup(token, tenantId)`], [Verifica o crea il gruppo tenant su Keycloak; restituisce il gruppo ID],

    [`assignUserToGroup(token, userId, groupId)`], [Assegna un utente a un gruppo specifico su Keycloak],

    [`getAdminAccessToken()`], [Ottiene il token di accesso amministrativo tramite le credenziali configurate],

    [`getRequiredEnv(key)`], [Recupera una variabile d'ambiente obbligatoria; lancia se non presente],

    [`buildTenantGroupName(tenantId)`], [Costruisce il nome del gruppo tenant: `tenant-<tenantId>`],

    [`buildUserAttributes(input)`], [Costruisce la mappa degli attributi utente per Keycloak],
  )

  ===== TenantsPersistenceService

  Layer di accesso ai dati. Utilizza due repository separati gestiti tramite TypeORM: `tenantRepo` per `TenantEntity` e
  `userRepo` per `UserEntity`. Supporta le transazioni tramite `DataSource` (il parametro opzionale `manager` consente
  di partecipare a una transazione esterna).

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`tenantRepo`], [`Repository<TenantEntity>`], [Repository TypeORM, schema `common`],
    [`userRepo`], [`Repository<UserEntity>`], [Repository TypeORM, schema `users`],
    [`dataSource`], [`DataSource`], [Iniettato per supporto transazioni],
  )

  _Metodi pubblici:_

  #table(
    columns: (2fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`getTenants()`], [`(): Promise<TenantEntity[]>`], [Recupera tutti i tenant],

    [`createTenant(input, manager?)`],
    [`(input, manager?): Promise<TenantEntity>`],
    [Crea un tenant con supporto transazionale],

    [`updateTenant(input, manager?)`], [`(input, manager?): Promise<TenantEntity>`], [Aggiorna un tenant esistente],

    [`deleteTenant(input, manager?)`],
    [`(input, manager?): Promise<boolean>`],
    [Elimina un tenant; restituisce `true` se eliminato],

    [`createTenantAdminLocalUser(input, manager?)`],
    [`(input, manager?): Promise<UserEntity>`],
    [Crea l'utente amministratore locale nel database],

    [`getTenantAdminUsers(tenantId)`],
    [`(tenantId: string): Promise<UserEntity[]>`],
    [Recupera solo gli utenti admin di un tenant],

    [`getUsersByTenant(tenantId)`],
    [`(tenantId: string): Promise<UserEntity[]>`],
    [Recupera tutti gli utenti di un tenant],
  )

  _Metodi privati:_

  #table(
    columns: (1.5fr, 3.5fr),
    [Metodo], [Comportamento],
    [`getTenantRepo(manager?)`],
    [Restituisce il repository tenant: se `manager` è fornito usa il suo repository, altrimenti il default],

    [`getUserRepo(manager?)`],
    [Restituisce il repository user: se `manager` è fornito usa il suo repository, altrimenti il default],
  )

  ===== TenantsMapper

  Classe con metodi statici per la conversione tra i layer. Non ha dipendenze iniettate.

  #table(
    columns: (1.5fr, 3.5fr),
    [Metodo], [Comportamento],
    [`toModel(entity)`], [Converte `TenantEntity` in `TenantsModel`: mappa i campi uno-a-uno],

    [`toResponseDto(model)`], [Converte `TenantsModel` in `TenantsResponseDto`: adatta i nomi per la risposta HTTP],

    [`toUpdateResponseDto(model)`], [Converte `TenantsModel` in `UpdateTenantsResponseDto`: include `updatedAt`],

    [`toSuspensionIntervalDays(model)`], [Calcola i giorni di sospensione dal modello, gestendo il caso `null`],
  )

  ===== DTO e Input

  _CreateTenantRequestDto_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`name`], [`string`], [Nome del tenant],
    [`adminEmail`], [`string`], [Email dell'utente amministratore],
    [`adminUsername`], [`string`], [Username dell'utente amministratore],
    [`adminPassword`], [`string`], [Password iniziale dell'amministratore],
  )

  _UpdateTenantRequestDto_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`name`], [`string | null`], [Nuovo nome del tenant],
    [`status`], [`TenantStatus | null`], [Nuovo stato del tenant],
    [`suspensionIntervalDays`], [`number | null`], [Giorni prima della sospensione automatica],
  )

  _TenantsResponseDto_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`id`], [`string`], [Identificativo univoco del tenant],
    [`name`], [`string`], [Nome del tenant],
    [`status`], [`TenantStatus`], [Stato corrente del tenant],
    [`createdAt`], [`string`], [Data di creazione in formato ISO 8601],
    [`suspensionIntervalDays`], [`number`], [Giorni prima della sospensione automatica],
  )

  _UpdateTenantsResponseDto_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`id`], [`string`], [Identificativo univoco del tenant],
    [`name`], [`string`], [Nome del tenant],
    [`status`], [`TenantStatus`], [Stato corrente del tenant],
    [`updatedAt`], [`string`], [Data dell'ultimo aggiornamento in formato ISO 8601],
  )

  _DeleteTenantResponseDto_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`message`], [`string`], [Messaggio di conferma dell'eliminazione],
  )

  _CreateTenantInput_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`name`], [`string`], [Nome del tenant],
    [`adminEmail`], [`string`], [Email dell'utente amministratore],
    [`adminUsername`], [`string`], [Username dell'utente amministratore],
    [`adminPassword`], [`string`], [Password iniziale dell'amministratore],
  )

  _UpdateTenantInput_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`id`], [`string`], [Identificativo del tenant da aggiornare],
    [`name`], [`string | null`], [Nuovo nome del tenant],
    [`status`], [`TenantStatus | null`], [Nuovo stato del tenant],
    [`suspensionIntervalDays`], [`number | null`], [Giorni prima della sospensione automatica],
  )

  _DeleteTenantInput_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`id`], [`string`], [Identificativo del tenant da eliminare],
  )

  ===== Enum

  _TenantStatus_

  #table(
    columns: (1.5fr, 4fr),
    [Valore], [Descrizione],
    [`ACTIVE`], [Tenant operativo, tutti i servizi sono attivi],
    [`SUSPENDED`], [Tenant sospeso, gli utenti non possono accedere ai servizi],
  )

  _UsersRole_

  #table(
    columns: (1.5fr, 4fr),
    [Valore], [Descrizione],
    [`SYSTEM_ADMIN`], [Amministratore di sistema, accesso completo a tutti i tenant],
    [`TENANT_ADMIN`], [Amministratore del tenant, gestisce utenti e configurazione del proprio tenant],
    [`TENANT_USER`], [Utente standard del tenant, accesso limitato alle funzionalità concesse],
  )

  ===== Entità

  _TenantEntity_ (schema `common`)

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`id`], [`uuid v4`], [Identificativo univoco generato automaticamente],
    [`name`], [`string`], [Nome del tenant],
    [`status`], [`TenantStatus`], [Stato corrente del tenant],
    [`suspensionIntervalDays`], [`number | null`], [Giorni di sospensione],
    [`suspensionUntil`], [`Date | null`], [Data di sospensione programmata],
    [`createdAt`], [`Date`], [Timestamp di creazione del record],
    [`updatedAt`], [`Date`], [Timestamp dell'ultimo aggiornamento],
  )

  Relazioni: OneToMany con `UserEntity` (tramite `tenantId`), OneToMany con `GatewayEntity` (tramite `tenantId`).

  _UserEntity_ (schema `users`)

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`id`], [`uuid`], [Identificativo univoco dell'utente],
    [`tenantId`], [`string`], [FK verso `TenantEntity.id`],
    [`username`], [`string`], [Username dell'utente],
    [`email`], [`string`], [Email dell'utente],
    [`role`], [`UsersRole`], [Ruolo dell'utente nel sistema],
    [`permissions`], [`string[] | null`], [Permessi specifici aggiuntivi],
    [`lastAccess`], [`Date | null`], [Timestamp dell'ultimo accesso],
    [`createdAt`], [`Date`], [Timestamp di creazione del record],
  )

  ==== Admin Gateways
  #figure(caption: "Diagramma del modulo Admin Gateways")[#image("assets/03-admin-gateways.svg")]

  Il sottosistema di gestione dei Gateway amministrativi si occupa della registrazione e consultazione dei gateway
  associati ai tenant. Espone endpoint per elencare tutti i gateway (con filtro opzionale per tenant) e per registrare
  nuovi gateway a partire da un factory ID e una chiave di provisioning.

  ===== GatewaysController

  Controller NestJS esposto sotto il prefisso `/admin/gateways`. Protetto dal decoratore `@AdminOnly()`, espone due
  endpoint REST. Delega ogni operazione a `GatewaysService` e utilizza `GatewaysMapper` per trasformare i risultati nei
  DTO di risposta appropriati.

  #table(
    columns: (2fr, 2fr, 3fr),
    [Metodo], [Endpoint], [Note],
    [`getAdminGateways(tenantId?)`],
    [`GET /admin/gateways`],
    [Restituisce la lista di tutti i gateway, con filtro opzionale per tenantId],

    [`addGateway(input)`],
    [`POST /admin/gateways`],
    [Registra un nuovo gateway per un tenant a partire da factoryId, tenantId, factoryKey e model],
  )

  ===== GatewaysService

  Contiene la logica di business principale. Coordina `GatewaysPersistenceService` e utilizza il mapper per convertire
  tra DTO e modelli di dominio.

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`gatewaysPersistenceService`], [`GatewaysPersistenceService`], [Iniettato via constructor],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.2fr, 2.8fr, 2fr),
    [Metodo], [Firma], [Note],
    [`getGateways(input)`],
    [`(input: GetGatewaysInput): Promise<GatewayModel[]>`],
    [Recupera tutti i gateway dal database; se `tenantId` è fornito, filtra per tenant],

    [`addGateway(input)`],
    [`(input: AddGatewayInput): Promise<GatewayModel>`],
    [Registra un nuovo gateway: hash della factoryKey con bcrypt, crea l'entità nel database con metadata di default],
  )

  ===== GatewaysPersistenceService

  Layer di accesso ai dati. Utilizza due repository separati gestiti tramite TypeORM: `gatewayRepo` per `GatewayEntity`
  e `metadataRepo` per `GatewayMetadataEntity`. Supporta le transazioni tramite `DataSource`.

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`gatewayRepo`], [`Repository<GatewayEntity>`], [Repository TypeORM, schema `gateways`],
    [`metadataRepo`], [`Repository<GatewayMetadataEntity>`], [Repository TypeORM, schema `gateways`],
    [`dataSource`], [`DataSource`], [Iniettato per supporto transazioni],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.3fr, 2.8fr, 2fr),
    [Metodo], [Firma], [Note],
    [`getGateways(input)`],
    [`(input: GetGatewaysInput): Promise<GatewayEntity[]>`],
    [Recupera tutti i gateway; se `tenantId` è fornito, filtra con clausola WHERE],

    [`addGateway(input)`],
    [`(input: AddGatewayPersistenceInput): Promise<GatewayEntity>`],
    [Crea il gateway e il relativo metadata in modo transazionale],
  )

  ===== GatewaysMapper

  Classe con metodi statici per la conversione tra i layer. Non ha dipendenze iniettate.

  #table(
    columns: (1.5fr, 3.5fr),
    [Metodo], [Comportamento],
    [`toModel(entity)`], [Converte `GatewayEntity` in `GatewayModel`: mappa i campi uno-a-uno],

    [`toResponseDto(model)`], [Converte `GatewayModel` in `GatewayResponseDto`: adatta i nomi per la risposta HTTP],

    [`toAddGatewayInput(dto)`],
    [Converte `AddGatewayRequestDto` in `AddGatewayInput`: hash della factoryKey con bcrypt],

    [`toAddGatewayResponseDto(model)`], [Converte `GatewayModel` in `AddGatewayResponseDto`: restituisce solo l'`id`],
  )

  ===== DTO e Input

  _AddGatewayRequestDto_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`factoryId`], [`string`], [Identificativo del factory di produzione],
    [`tenantId`], [`string`], [Identificativo del tenant proprietario],
    [`factoryKey`], [`string`], [Chiave di provisioning del gateway],
    [`model`], [`string`], [Modello del gateway],
  )

  _AddGatewayResponseDto_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`id`], [`string`], [Identificativo univoco del gateway creato],
  )

  _GatewayResponseDto_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`id`], [`string`], [Identificativo univoco del gateway],
    [`tenantId`], [`string`], [Identificativo del tenant proprietario],
    [`factoryId`], [`string`], [Identificativo del factory di produzione],
    [`model`], [`string`], [Modello del gateway],
    [`provisioned`], [`boolean`], [Indica se il gateway è stato provisionato],
    [`firmwareVersion`], [`string | undefined`], [Versione del firmware installato],
    [`createdAt`], [`string`], [Data di creazione in formato ISO 8601],
  )

  _GetGatewaysInput_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`tenantId`], [`string | undefined`], [Filtro opzionale per tenant],
  )

  _AddGatewayInput_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`factoryId`], [`string`], [Identificativo del factory di produzione],
    [`tenantId`], [`string`], [Identificativo del tenant proprietario],
    [`factoryKey`], [`string`], [Chiave di provisioning (in chiaro, verrà hashata)],
    [`model`], [`string`], [Modello del gateway],
    [`firmwareVersion`], [`string | undefined`], [Versione del firmware (opzionale)],
  )

  _AddGatewayPersistenceInput_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`factoryId`], [`string`], [Identificativo del factory di produzione],
    [`tenantId`], [`string`], [Identificativo del tenant proprietario],
    [`factoryKeyHash`], [`string`], [Hash bcrypt della factoryKey],
    [`model`], [`string`], [Modello del gateway],
    [`firmwareVersion`], [`string | undefined`], [Versione del firmware (opzionale)],
  )

  ===== Enum

  _GatewayStatus_

  #table(
    columns: (1.5fr, 4fr),
    [Valore], [Descrizione],
    [`GATEWAY_ONLINE`], [Gateway attivo e comunicante],
    [`GATEWAY_OFFLINE`], [Gateway non raggiungibile],
    [`GATEWAY_SUSPENDED`], [Gateway sospeso manualmente o automaticamente],
  )

  ===== Entità

  _GatewayEntity_ (schema `gateways`)

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`id`], [`uuid v4`], [Identificativo univoco generato automaticamente],
    [`tenantId`], [`string`], [FK verso `TenantEntity.id`],
    [`factoryId`], [`string`], [Identificativo del factory di produzione],
    [`factoryKeyHash`], [`string`], [Hash bcrypt della chiave di provisioning; `select: false` per sicurezza],
    [`provisioned`], [`boolean`], [Indica se il gateway è stato provisionato],
    [`model`], [`string`], [Modello del gateway],
    [`firmwareVersion`], [`string`], [Versione del firmware installato],
    [`createdAt`], [`Date`], [Timestamp di creazione del record],
    [`updatedAt`], [`Date`], [Timestamp dell'ultimo aggiornamento],
  )

  Relazioni: ManyToOne con `TenantEntity` (tramite `tenantId`, cascade delete), OneToOne con `GatewayMetadataEntity`
  (cascade).

  _GatewayMetadataEntity_ (schema `gateways`)

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`gatewayId`], [`uuid`], [FK verso `GatewayEntity.id`, chiave primaria],
    [`name`], [`string`], [Nome descrittivo del gateway; offuscato alla vista dell'admin],
    [`status`], [`GatewayStatus`], [Stato corrente del gateway],
    [`lastSeenAt`], [`Date`], [Timestamp dell'ultima comunicazione ricevuta],
    [`sendFrequencyMs`], [`number`], [Frequenza di invio dati in millisecondi; default: 30000],
  )

  === AuthModule
  #figure(caption: "Diagramma del modulo Auth")[#image("assets/05-auth.png")]

  Il modulo di autenticazione gestisce la validazione JWT tramite Keycloak, il controllo degli accessi basato sui ruoli,
  la politica di accesso per endpoint e il meccanismo di impersonificazione utente.

  ==== AuthController

  Controller NestJS esposto sotto il prefisso `/auth`. Espone endpoint per consultare i dati dell'utente autenticato,
  verificare lo stato del tenant e generare token di impersonificazione.

  #table(
    columns: (1.2fr, 2.5fr, 2.3fr),
    [Metodo], [Endpoint], [Note],
    [`getMe(req)`],
    [`GET /auth/me`],
    [Restituisce i dati dell'utente autenticato come `AuthenticatedUser`; include informazioni su actor ed effective
      user],

    [`getTenantStatus(req)`],
    [`GET /auth/tenant-status`],
    [Restituisce lo stato del tenant corrente; riattiva automaticamente le sospensioni scadute],

    [`impersonate(body, req)`],
    [`POST /auth/impersonate`],
    [Genera un token di impersonificazione per un utente target; riservato ai `SYSTEM_ADMIN`; protetto da
      `@AdminOnly()`],
  )

  _Metodi privati:_

  #table(
    columns: (1.5fr, 3.5fr),
    [Metodo], [Comportamento],
    [`isSuspensionExpired(tenant)`], [Verifica se `status === SUSPENDED` e `suspensionUntil` è nel passato],

    [`reactivateTenantIfExpired(tenant)`],
    [Se la sospensione è scaduta: imposta `status = ACTIVE`, `suspensionIntervalDays = null`,
      `suspensionUntil = null`],
  )

  ==== ImpersonationService

  Servizio per il token exchange con Keycloak. Consente a un amministratore di sistema di ottenere un token JWT per
  impersonare un altro utente.

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`config`], [`ConfigService`], [Iniettato; fornisce credenziali Keycloak],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`impersonateUser(...)`],
    [`({ adminAccessToken, targetUserId }): Promise<{ access_token, expires_in }>`],
    [Esegue token exchange OAuth 2.0 con Keycloak; `grant_type: urn:ietf:params:oauth:grant-type:token-exchange`],
  )

  ==== JwtStrategy

  Strategia Passport per la validazione JWT. Verifica i token JWT provenienti da Keycloak tramite JWKS.

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`configService`], [`ConfigService`], [Iniettato; fornisce URL, realm, issuer, client ID],
    [`managementClientId`], [`string`], [Memorizzato per il matching dell'audience],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`validate(payload)`],
    [`(payload: JwtClaims): AuthenticatedUser`],
    [Estrae ruolo, tenant, informazioni di impersonazione dal payload JWT; costruisce `AuthenticatedUser`],
  )

  ==== Guards

  Il modulo registra quattro guard globali come `APP_GUARD`:

  _JwtAuthGuard_ — Estende `AuthGuard('jwt')`. Se la policy è `PUBLIC` (decoratore `@Public()`), bypassa la validazione
  JWT. Altrimenti delega a Passport per la validazione del token.

  _AccessPolicyGuard_ — Applica le policy di accesso: `ADMIN` richiede `SYSTEM_ADMIN`, `TENANT` richiede un
  `effectiveTenantId`. Se il tenant è `SUSPENDED`, solleva `ForbiddenException`. Riattiva automaticamente le sospensioni
  scadute.

  _RolesGuard_ — Verifica che `user.effectiveRole` sia presente nell'array di ruoli richiesto dal decoratore `@Roles()`.

  _BlockImpersonationGuard_ — Se il decoratore `@BlockImpersonation()` è impostato e l'utente sta impersonando, registra
  un evento audit `IMPERSONATION_BLOCKED` e solleva `ForbiddenException`.

  ==== Interfacce

  _AuthenticatedUser_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`actorUserId`], [`string`], [ID dell'utente che sta agendo (impersonante)],
    [`actorEmail`], [`string | undefined`], [Email dell'attore],
    [`actorName`], [`string | undefined`], [Nome dell'attore],
    [`actorRole`], [`UsersRole`], [Ruolo dell'attore],
    [`actorTenantId`], [`string | undefined`], [Tenant ID dell'attore],
    [`effectiveUserId`], [`string`], [ID dell'utente target (effettivo)],
    [`effectiveEmail`], [`string | undefined`], [Email dell'utente effettivo],
    [`effectiveName`], [`string | undefined`], [Nome dell'utente effettivo],
    [`effectiveRole`], [`UsersRole`], [Ruolo dell'utente effettivo],
    [`effectiveTenantId`], [`string | undefined`], [Tenant ID dell'utente effettivo],
    [`isImpersonating`], [`boolean`], [Indica se è attiva l'impersonificazione],
  )

  === KeysModule
  #figure(caption: "Diagramma del modulo KeysModule")[#image("assets/09-keys.svg")]

  Il modulo di gestione delle chiavi gestisce il provisioning delle chiavi AES-256 per i gateway, la validazione delle
  chiavi di fabbrica e il completamento del provisioning. Implementa crittografia trasparente a livello di persistenza.

  ==== KeysController

  Controller NestJS esposto sotto il prefisso `/keys`. Protetto da `@TenantScoped()` e `@BlockImpersonation()`.

  #table(
    columns: (1.2fr, 2.5fr, 2.3fr),
    [Metodo], [Endpoint], [Note],
    [`getKeys(tenantId, id)`],
    [`GET /keys?id=<gatewayId>`],
    [Restituisce tutte le chiavi per un gateway specifico; richiede `tenantId` dal contesto],
  )

  ==== ProvisioningController

  Controller pubblico per il provisioning interno. Protetto da `@Public()`.

  #table(
    columns: (1.2fr, 2.5fr, 2.3fr),
    [Metodo], [Endpoint], [Note],
    [`validate(dto)`],
    [`POST /internal/provisioning/validate`],
    [Valida una chiave di fabbrica; restituisce `gateway_id` e `tenant_id` se valida],

    [`complete(dto)`],
    [`POST /internal/provisioning/complete`],
    [Completa il provisioning con materiale crittografico; restituisce `{ success: true }`],
  )

  ==== KeysService

  Contiene la logica di business principale. Coordina `GatewaysKeysPersistenceService`, `GatewaysService` e
  `DataSource`.

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`gkp`], [`GatewaysKeysPersistenceService`], [Iniettato via constructor],
    [`gs`], [`GatewaysService`], [Iniettato via constructor],
    [`dataSource`], [`DataSource`], [Iniettato per supporto transazioni],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`getKeys(id, tenantId?)`],
    [`(id: string, tenantId?): Promise<KeyModel[]>`],
    [Verifica ownership del gateway; solleva `ForbiddenException` se tenantId non corrisponde; restituisce le chiavi],

    [`saveKeys(id, keyMaterial, keyVersion)`],
    [`(id, keyMaterial, keyVersion): Promise<KeyModel>`],
    [Persiste una nuova chiave per il gateway],

    [`validateFactoryKey(factoryId, factoryKey)`],
    [`(factoryId, factoryKey): Promise<{ gatewayId, tenantId }>`],
    [Cerca gateway per factoryId; verifica hash con bcrypt; solleva `UnauthorizedException` o `ConflictException`],

    [`completeProvisioning(...)`],
    [`(gatewayId, keyMaterial, keyVersion, sendFrequencyMs, firmwareVersion?): Promise<void>`],
    [Transazione: crea KeyEntity, aggiorna GatewayMetadata, imposta provisioned=true, factoryKeyHash=null],

    [`provisionGateway(...)`],
    [`(factoryId, factoryKey, keyMaterial, firmwareVersion, model): Promise<void>`],
    [Valida factory key, calcola nextVersion, salva nuova KeyEntity, aggiorna gateway],
  )

  ==== GatewaysKeysPersistenceService

  Layer di accesso ai dati per le chiavi.

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`r`], [`Repository<KeyEntity>`], [Repository TypeORM iniettato],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`getKeys(id)`], [`(id: string): Promise<KeyEntity[]>`], [Trova tutte le chiavi per `gatewayId`],

    [`saveKeys(id, keyMaterial, keyVersion)`],
    [`(id, keyMaterial, keyVersion): Promise<KeyEntity>`],
    [Crea e salva una nuova `KeyEntity`],
  )

  ==== Crittografia del Materiale Chiave

  Il file `key-material-encryption.ts` fornisce crittografia AES-256-GCM trasparente per la colonna `keyMaterial` di
  `KeyEntity` tramite un `ValueTransformer` TypeORM.

  _Costanti:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Costante], [Tipo], [Valore],
    [`ENCRYPTION_PREFIX`], [`Buffer`], [`Buffer.from('enc:v1:')` — 7 byte],
    [`IV_LENGTH`], [`number`], [12 byte],
    [`AUTH_TAG_LENGTH`], [`number`], [16 byte],
    [`AES_256_KEY_LENGTH`], [`number`], [32 byte],
  )

  _Funzioni esportate:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Funzione], [Firma], [Note],
    [`encryptKeyMaterial(value)`],
    [`(value: Buffer): Buffer`],
    [Genera IV casuale, cifra con AES-256-GCM, restituisce `[prefix | IV | authTag | encrypted]`],

    [`decryptKeyMaterial(value)`],
    [`(value: Buffer): Buffer`],
    [Se inizia con prefix: estrae IV, authTag, decripta. Altrimenti (legacy): restituisce unchanged],
  )

  _keyMaterialTransformer_ — Oggetto `ValueTransformer` TypeORM con metodi `to` (cripta in scrittura) e `from` (decripta
  in lettura). Applicato alla colonna `keyMaterial` di `KeyEntity`.

  _Funzioni helper (non esportate):_

  #table(
    columns: (1.5fr, 3.5fr),
    [Funzione], [Comportamento],
    [`normalizeKey(rawKey)`],
    [Normalizza la chiave di crittografia da `DB_ENCRYPTION_KEY`: accetta hex (64 char), base64, o UTF-8 (32 byte)],

    [`getEncryptionKey()`],
    [Legge `DB_ENCRYPTION_KEY` dall'env e chiama `normalizeKey()` per produrre il buffer a 32 byte],
  )

  ==== DTO e Input

  _ValidateFactoryKeyRequestDto_ — `factory_id: string`, `factory_key: string`.

  _ValidateFactoryKeyResponseDto_ — `gateway_id: string`, `tenant_id: string`.

  _ProvisioningCompleteRequestDto_ — `gateway_id: string`, `key_material: string`, `key_version: number`,
  `send_frequency_ms: number`, `firmware_version?: string`.

  _ProvisioningCompleteResponseDto_ — `success: boolean`.

  _KeysResponseDto_ — `gateway_id: string`, `key_material: string` (base64), `key_version: number`.

  ==== Entità

  _KeyEntity_ (tabella `keys`)

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`id`], [`uuid v4`], [Identificativo univoco generato automaticamente],
    [`gatewayId`], [`uuid`], [FK verso `GatewayEntity.id`; cascade delete],
    [`keyMaterial`], [`Buffer`], [Materiale crittografato con AES-256-GCM; trasformatore automatico],
    [`keyVersion`], [`number`], [Versione della chiave],
    [`createdAt`], [`Date`], [Timestamp di creazione],
    [`revokedAt`], [`Date | null`], [Timestamp di revoca (opzionale)],
  )

  === UsersModule
  #figure(caption: "Diagramma del modulo UsersModule")[#image("assets/12-users.svg")]

  Il modulo di gestione degli utenti gestisce le operazioni CRUD sugli utenti del tenant, inclusa la sincronizzazione
  con Keycloak per la creazione, l'aggiornamento dei ruoli e l'eliminazione.

  ==== UsersController

  Controller NestJS esposto sotto il prefisso `/users`. Protetto da `@TenantScoped()`. Tutti gli endpoint richiedono
  `TENANT_ADMIN`.

  #table(
    columns: (1.2fr, 2.5fr, 2.3fr),
    [Metodo], [Endpoint], [Note],
    [`getUsers(tenantId)`], [`GET /users`], [Restituisce la lista di tutti gli utenti del tenant],

    [`getUserById(tenantId, id)`], [`GET /users/:id`], [Restituisce il dettaglio di un singolo utente],

    [`createUser(tenantId, dto)`],
    [`POST /users`],
    [Crea un nuovo utente; protetto da `@Audit` e `@Roles(TENANT_ADMIN)`],

    [`updateUser(tenantId, id, dto)`],
    [`PATCH /users/:id`],
    [Aggiorna un utente esistente; sincronizza ruolo e dati con Keycloak],

    [`deleteUsers(tenantId, requesterId, requesterRole, dto)`],
    [`POST /users/bulk-delete`],
    [Eliminazione bulk di utenti; previene auto-eliminazione e protezione TENANT_ADMIN],
  )

  ==== UsersService

  Contiene la logica di business. Coordina `UsersPersistenceService` e `KeycloakAdminService`.

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`ps`], [`UsersPersistenceService`], [Iniettato via constructor],
    [`keycloakAdminService`], [`KeycloakAdminService`], [Iniettato via constructor],
    [`logger`], [`Logger`], [Logger interno],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`getUsers(input)`],
    [`(input: GetUsersInput): Promise<UserModel[]>`],
    [Recupera gli utenti del tenant; solleva `NotFoundException` se la lista è vuota],

    [`createUser(input)`],
    [`(input: CreateUserInput): Promise<UserModel>`],
    [Blocca `SYSTEM_ADMIN`; crea utente su Keycloak; salva nel DB; rollback Keycloak se il DB fallisce],

    [`updateUser(input)`],
    [`(input: UpdateUserInput): Promise<UserModel>`],
    [Blocca `SYSTEM_ADMIN`; aggiorna DB; sincronizza ruolo e dati con Keycloak se cambiati],

    [`deleteUsers(input)`],
    [`(input: DeleteUsersInput): Promise<number>`],
    [Filtra auto-eliminazione; blocca eliminazione TENANT_ADMIN da non-SYSTEM_ADMIN; cancella da Keycloak e DB],
  )

  _Metodi privati:_

  #table(
    columns: (1.5fr, 3.5fr),
    [Metodo], [Comportamento],
    [`normalizeUsername(username)`],
    [Trim, lowercase, capitalizza prima lettera; restituisce stringa vuota se risultato vuoto],
  )

  ==== UsersPersistenceService

  Layer di accesso ai dati per gli utenti.

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`r`], [`Repository<UserEntity>`], [Repository TypeORM iniettato],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`getUsers(tenantId)`], [`(tenantId: string): Promise<UserEntity[]>`], [Trova tutti gli utenti per `tenantId`],

    [`getTenantAdmins(tenantId)`], [`(tenantId: string): Promise<UserEntity[]>`], [Trova gli amministratori del tenant],

    [`createUser(input)`], [`(input): Promise<UserEntity>`], [Crea e salva un nuovo `UserEntity`],

    [`updateUser(input)`],
    [`(input): Promise<UserEntity | null>`],
    [Trova per `id + tenantId`; aggiorna solo i campi forniti; restituisce `null` se non trovato],

    [`getUsersByIds(ids, tenantId)`],
    [`(ids, tenantId): Promise<UserEntity[]>`],
    [Trova utenti per lista di ID con clausola `In(ids)`],

    [`touchLastAccess(userId, timestamp?)`],
    [`(userId, timestamp?): Promise<void>`],
    [Aggiorna `lastAccess` al timestamp corrente o fornito],

    [`deleteUsersByIds(ids, tenantId)`],
    [`(ids, tenantId): Promise<number>`],
    [Elimina utenti per lista di ID; restituisce il numero di righe eliminate],
  )

  ==== DTO

  _CreateUserRequestDto_ — `username: string`, `email: string`, `role: UsersRole`, `password: string`.

  _CreateUserResponseDto_ — `id: string`, `username: string`, `email: string`, `role: UsersRole`, `created_at: string`.

  _UpdateUserRequestDto_ — `username?: string`, `email?: string`, `role?: UsersRole`, `permissions?: string[]`.

  _UpdateUserResponseDto_ — `id: string`, `username: string`, `email: string`, `role: UsersRole`, `updated_at: string`.

  _DeleteUserRequestDto_ — `ids: string[]` (UUID v4).

  _DeleteUserResponseDto_ — `deleted: number`, `failed: string[]`.

  _UserResponseDto_ — `id: string`, `username: string`, `email: string`, `role: UsersRole`,
  `last_access: string | null`.

  ==== Entità

  _UserEntity_ (tabella `users`)

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`id`], [`uuid`], [Chiave primaria],
    [`tenantId`], [`string`], [FK verso `TenantEntity.id`; cascade delete],
    [`username`], [`string`], [Username dell'utente],
    [`email`], [`string`], [Email dell'utente],
    [`role`], [`UsersRole`], [Ruolo; default: `TENANT_USER`],
    [`permissions`], [`string[] | null`], [Permessi specifici in formato JSONB],
    [`lastAccess`], [`Date | null`], [Ultimo accesso],
    [`createdAt`], [`Date`], [Timestamp di creazione],
  )

  Relazione: ManyToOne con `TenantEntity` (tramite `tenantId`, cascade delete).

  === AlertsModule
  #figure(caption: "Diagramma del modulo AlertsModule")[#image("assets/04-alerts.svg")]

  Il modulo di gestione degli alert gestisce la configurazione dei timeout di irraggiungibilità dei gateway e la
  registrazione degli eventi di gateway offline. Supporta configurazioni di default per tenant e override per singolo
  gateway.

  ==== AlertsController

  Controller NestJS esposto sotto il prefisso `/alerts`. Protetto da `@TenantScoped()`.

  #table(
    columns: (1.2fr, 2.5fr, 2.3fr),
    [Metodo], [Endpoint], [Note],
    [`getAlerts(tenantId, from?, to?, gatewayId?)`],
    [`GET /alerts`],
    [Restituisce gli alert del tenant con filtri opzionali per data e gateway],

    [`getAlertsConfig(tenantId)`],
    [`GET /alerts/config`],
    [Restituisce la configurazione degli alert: timeout di default e override per gateway],

    [`setDefaultAlertsConfig(tenantId, dto)`],
    [`PUT /alerts/config/default`],
    [Imposta il timeout di default per il tenant; protetto da `@Audit` e `@Roles(TENANT_ADMIN)`],

    [`setGatewayAlertsConfig(tenantId, gatewayId, dto)`],
    [`PUT /alerts/config/gateway/:gatewayId`],
    [Imposta il timeout per un gateway specifico; protetto da `@Audit` e `@Roles(TENANT_ADMIN)`],

    [`deleteGatewayAlertsConfig(tenantId, gatewayId)`],
    [`DELETE /alerts/config/gateway/:gatewayId`],
    [Elimina la configurazione per un gateway; protetto da `@Audit` e `@Roles(TENANT_ADMIN)`],
  )

  ==== AlertsService

  Contiene la logica di business. Coordina `AlertsPersistenceService` e `GatewaysService`.

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`aps`], [`AlertsPersistenceService`], [Iniettato via constructor],
    [`gatewayService`], [`GatewaysService`], [Iniettato via constructor per validazione ownership],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`setGatewayAlertsConfig(input)`],
    [`(input): Promise<AlertsConfigEntity>`],
    [Verifica ownership gateway; solleva `NotFoundException` o `ForbiddenException`; upsert della configurazione],

    [`deleteGatewayAlertsConfig(tenantId, gatewayId)`],
    [`(tenantId, gatewayId): Promise<void>`],
    [Verifica ownership; elimina configurazione; solleva `NotFoundException` se non eliminata],

    [`setDefaultAlertsConfig(input)`],
    [`(input): Promise<AlertsConfigEntity>`],
    [Imposta o aggiorna il timeout di default per il tenant],

    [`getAlertsConfig(input)`],
    [`(input): Promise<AlertsConfigModel>`],
    [Recupera tutte le configurazioni del tenant; mappa in modello con default + override],

    [`getAlerts(input)`],
    [`(input): Promise<AlertsModel[]>`],
    [Recupera gli alert con filtri opzionali per data e gateway],
  )

  ==== AlertsPersistenceService

  Layer di accesso ai dati per alert e configurazioni.

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`r`], [`Repository<AlertsEntity>`], [Repository per gli alert],
    [`rac`], [`Repository<AlertsConfigEntity>`], [Repository per le configurazioni],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`setGatewayAlertsConfig(input)`],
    [`(input): Promise<AlertsConfigEntity>`],
    [Upsert su `['tenantId', 'gatewayId']`; restituisce l'entità aggiornata],

    [`deleteGatewayAlertsConfig(tenantId, gatewayId)`],
    [`(tenantId, gatewayId): Promise<boolean>`],
    [Elimina configurazione; restituisce `true` se righe eliminate],

    [`setDefaultAlertsConfig(input)`],
    [`(input): Promise<AlertsConfigEntity>`],
    [Trova l'ultimo default esistente; aggiorna o crea nuovo; elimina duplicati stale],

    [`getAlertsConfig(tenantId)`],
    [`(tenantId): Promise<AlertsConfigEntity[]>`],
    [Trova tutte le configurazioni del tenant con relazione gateway],

    [`findAllAlertConfigs()`],
    [`(): Promise<AlertsConfigEntity[]>`],
    [Trova tutte le configurazioni (usato dal NATS responder)],

    [`getAlerts(input)`],
    [`(input): Promise<AlertsEntity[]>`],
    [Filtra per `tenantId`, `createdAt` (range), `gatewayId`; ordina per `createdAt DESC`],

    [`countAlerts(tenantId)`], [`(tenantId): Promise<number>`], [Conta gli alert per un tenant],

    [`saveAlert(alert)`], [`(alert): Promise<AlertsEntity>`], [Crea e salva un nuovo alert],
  )

  ==== AlertsNatsService

  Servizio NATS per la ricezione degli alert. Implementa `OnModuleInit`. Si sottoscrive a due subject:
  `internal.mgmt.alert-configs.list` (request-reply per le configurazioni) e `alert.*.gw_offline` (JetStream per gli
  alert gateway offline).

  ==== DTO

  _AlertsResponseDto_ — `id: string`, `gateway_id: string`, `type: AlertType`,
  `details: { last_seen: string, timeout_configured: number }`, `created_at: string`.

  _AlertsConfigResponseDto_ — `default_timeout_ms: number`, `default_updated_at?: string`,
  `gateway_overrides: [{ gateway_id, timeout_ms, updated_at? }]`.

  _SetAlertsConfigDefaultRequestDto_ — `tenant_unreachable_timeout_ms: number`.

  _SetAlertsConfigDefaultResponseDto_ — `tenant_id: string`, `default_timeout_ms: number`, `default_updated_at: string`.

  _SetGatewayAlertsConfigRequestDto_ — `gateway_unreachable_timeout_ms: number`.

  _SetGatewayAlertsConfigResponseDto_ — `gateway_id: string`, `timeout_ms: number`, `updated_at: string`.

  ==== Enum

  _AlertType_

  #table(
    columns: (1.5fr, 4fr),
    [Valore], [Descrizione],
    [`GATEWAY_OFFLINE`], [Gateway non raggiungibile entro il timeout configurato],
  )

  ==== Entità

  _AlertsEntity_ (tabella `alerts`)

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`id`], [`uuid v4`], [Identificativo univoco],
    [`tenantId`], [`uuid`], [FK verso il tenant],
    [`type`], [`AlertType`], [Tipo di alert; default: `GATEWAY_OFFLINE`],
    [`gatewayId`], [`uuid`], [ID del gateway che ha generato l'alert],
    [`details`], [`jsonb`], [Dettagli: `lastSeen`, `timeoutConfigured`],
    [`createdAt`], [`Date`], [Timestamp di creazione],
  )

  _AlertsConfigEntity_ (tabella `alert_configs`)

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`id`], [`uuid v4`], [Identificativo univoco],
    [`tenantId`], [`string`], [FK verso `TenantEntity`; cascade delete],
    [`gatewayId`], [`string | null`], [FK verso `GatewayEntity`; `null` = configurazione di default],
    [`gatewayTimeoutMs`], [`number`], [Timeout in millisecondi; default: 60000],
    [`updatedAt`], [`Date`], [Timestamp dell'ultimo aggiornamento],
  )

  Indice composito unico su `['tenantId', 'gatewayId']`.

  === CommandModule
  #figure(caption: "Diagramma del modulo CommandModule")[#image("assets/06-command.svg")]

  Il modulo di gestione dei comandi gestisce l'invio di comandi ai gateway (configurazione e firmware) e il tracciamento
  dello stato attraverso ACK ricevuti via NATS JetStream.

  ==== CommandController

  Controller NestJS esposto sotto il prefisso `/cmd`. Protetto da `@TenantScoped()`.

  #table(
    columns: (1.2fr, 2.5fr, 2.3fr),
    [Metodo], [Endpoint], [Note],
    [`sendConfig(tenantId, gatewayId, dto)`],
    [`POST :gatewayId/config`],
    [Invia un comando di configurazione; protetto da `@Audit` e `@Roles(TENANT_ADMIN)`],

    [`sendFirmware(tenantId, gatewayId, dto)`],
    [`POST :gatewayId/firmware`],
    [Invia un comando di aggiornamento firmware; protetto da `@Audit` e `@Roles(TENANT_ADMIN)`],

    [`getStatus(tenantId, gatewayId, commandId)`],
    [`GET :gatewayId/status/:commandId`],
    [Restituisce lo stato di esecuzione di un comando],
  )

  ==== CommandService

  Contiene la logica di business. Coordina `CommandPersistenceService`, `GatewaysService` e `JetStreamClient`.

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`cps`], [`CommandPersistenceService`], [Iniettato via constructor],
    [`gatewaysService`], [`GatewaysService`], [Iniettato per validazione ownership],
    [`jetStreamClient`], [`JetStreamClient`], [Iniettato per pubblicazione NATS],
    [`logger`], [`Logger`], [Logger interno],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`sendConfig(input)`],
    [`(input): Promise<CommandModel>`],
    [Valida input; verifica ownership; coda comando; pubblica su NATS `command.gw.<tenantId>.<gatewayId>`],

    [`sendFirmware(input)`],
    [`(input): Promise<CommandModel>`],
    [Verifica ownership; coda comando con tipo `FIRMWARE`; pubblica su NATS],

    [`getStatus(input)`],
    [`(input): Promise<CommandModel>`],
    [Trova comando per ID; solleva `NotFoundException` se non trovato],
  )

  _Metodi privati:_

  #table(
    columns: (1.5fr, 3.5fr),
    [Metodo], [Comportamento],
    [`publishToNats(model, type, payload)`],
    [Costruisce subject `command.gw.<tenantId>.<gatewayId>`; pubblica JSON con `command_id`, `type`, `payload`,
      `issued_at`; non solleva errori in caso di fallimento],

    [`ensureGatewayOwnership(tenantId, gatewayId)`],
    [Delega a `gatewaysService.findById()`; solleva `NotFoundException` se il gateway non appartiene al tenant],
  )

  ==== CommandsAckConsumer

  Consumer NATS JetStream per gli ACK. Si sottoscrive a `command.ack.>`. Aggiorna lo stato del comando nel database e,
  se lo stato è `ACK`, applica gli effetti del comando sull'entità gateway.

  _Metodi privati:_

  #table(
    columns: (1.5fr, 3.5fr),
    [Metodo], [Comportamento],
    [`processMessage(message)`],
    [Parsa payload; risolve commandId (supporta `command_id` e `commandId`); normalizza stato; valida timestamp;
      aggiorna stato; se ACK applica effetti; ack del messaggio],

    [`parsePayload(buffer)`], [Decodifica buffer UTF-8 e pars JSON],

    [`resolveCommandId(payload)`], [Controlla `command_id` poi `commandId`; restituisce primo valore valido o `null`],

    [`normalizeStatus(value)`], [Mappa stringa a `CommandStatus` enum tramite tabella di normalizzazione],
  )

  ==== CommandWritingPersistenceService

  Servizio di scrittura per i comandi. Gestisce l'aggiornamento dello stato e l'applicazione degli effetti sui gateway.

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`updateStatus(input)`],
    [`(input): Promise<CommandEntity | null>`],
    [Trova comando per ID; aggiorna `status` e `ackReceivedAt`; restituisce `null` se non trovato],

    [`applyAckedCommandEffects(command)`],
    [`(command): Promise<void>`],
    [Se `ACK` e tipo `CONFIG`: aggiorna `sendFrequencyMs` e/o `status` su gateway metadata. Se `FIRMWARE`: aggiorna
      `firmwareVersion` su gateway. Salva solo se ci sono modifiche],
  )

  _Metodi privati:_

  #table(
    columns: (1.5fr, 3.5fr),
    [Metodo], [Comportamento],
    [`mapCommandGatewayStatus(status)`],
    [Mappa stringa a `GatewayStatus`: `online`/`gateway_online` → `GATEWAY_ONLINE`, `paused`/`suspended` →
      `GATEWAY_SUSPENDED`, `offline` → `GATEWAY_OFFLINE`],
  )

  ==== CommandPersistenceService

  Layer di accesso ai dati per i comandi (read/create).

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`queueCommand(input)`],
    [`(input): Promise<CommandEntity>`],
    [Crea e salva un nuovo `CommandEntity` con stato `QUEUED`],

    [`findCommand(input)`], [`(input): Promise<CommandEntity | null>`], [Trova comando per `id + tenantId + gatewayId`],

    [`countCommands(tenantId)`], [`(tenantId): Promise<number>`], [Conta i comandi per un tenant],
  )

  ==== Enum

  _CommandStatus_

  #table(
    columns: (1.5fr, 4fr),
    [Valore], [Descrizione],
    [`QUEUED`], [Comando accodato in attesa di invio],
    [`ACK`], [Comando confermato dal gateway],
    [`NACK`], [Comando negato dal gateway],
    [`EXPIRED`], [Comando scaduto],
    [`TIMEOUT`], [Timeout nella ricezione dell'ACK],
  )

  _CommandType_

  #table(
    columns: (1.5fr, 4fr),
    [Valore], [Descrizione],
    [`CONFIG`], [Aggiornamento configurazione: frequenza di invio, stato operativo],
    [`FIRMWARE`], [Aggiornamento firmware],
    [`SUSPEND`], [Sospensione del gateway],
  )

  ==== Entità

  _CommandEntity_ (tabella `commands`)

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`id`], [`uuid v4`], [Identificativo univoco],
    [`gatewayId`], [`uuid`], [FK verso `GatewayEntity`; cascade delete],
    [`tenantId`], [`uuid`], [FK verso `TenantEntity`; cascade delete],
    [`type`], [`CommandType`], [Tipo di comando],
    [`status`], [`CommandStatus`], [Stato corrente],
    [`issuedAt`], [`Date`], [Timestamp di emissione],
    [`ackReceivedAt`], [`Date | null`], [Timestamp di ricezione ACK],
    [`requestedSendFrequencyMs`], [`number | null`], [Frequenza richiesta (per comandi CONFIG)],
    [`requestedStatus`], [`string | null`], [Stato richiesto (per comandi CONFIG)],
    [`requestedFirmwareVersion`], [`string | null`], [Versione firmware richiesta (per comandi FIRMWARE)],
    [`createdAt`], [`Date`], [Timestamp di creazione],
  )

  ==== DTO

  _SendConfigRequestDto_ — `send_frequency_ms?: number` (min 0), `status?: string`.

  _SendFirmwareRequestDto_ — `firmware_version: string`, `download_url: string` (URL valido).

  _CommandResponseDto_ — `command_id: string`, `status: CommandStatus`, `issued_at: string`.

  _CommandStatusResponseDto_ — `command_id: string`, `status: CommandStatus`, `timestamp: string`.

  === AuditLogModule
  #figure(caption: "Diagramma del modulo AuditLogModule")[#image("assets/13-audit-log.svg")]

  Il modulo di audit log gestisce la registrazione e la consultazione delle operazioni eseguite sul microservizio.
  Supporta la registrazione di eventi provenienti da altri microservizi tramite NATS.

  ==== AuditLogController

  Controller NestJS esposto sotto il prefisso `/audit`. Protetto da `@TenantScoped()` e `@Roles(TENANT_ADMIN)`.

  #table(
    columns: (1.2fr, 2.5fr, 2.3fr),
    [Metodo], [Endpoint], [Note],
    [`getAuditLogs(tenantId, from, to, userId?, action?)`],
    [`GET /audit`],
    [Restituisce i log di audit del tenant con filtri per data, utente e azione; offusca i nomi dei gateway durante
      l'impersonificazione],
  )

  ==== AuditLogService

  Servizio di registrazione e consultazione dei log di audit.

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`alps`], [`AuditLogPersistenceService`], [Iniettato via constructor],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`getAuditLogs(input)`],
    [`(input): Promise<AuditLogModel[]>`],
    [Delega al persistence layer e mappa le entità in modelli],

    [`logAuditEvent(...)`],
    [`({ userId, action, resource, details, tenantId }): Promise<void>`],
    [Crea e salva un nuovo evento di audit],
  )

  ==== ProvisioningAuditConsumer

  Consumer NATS JetStream per gli eventi di audit provenienti da altri microservizi. Si sottoscrive a `log.audit.>`.
  Parsa i payload, valida i campi richiesti, risolve tenant ID e user ID, e registra l'evento.

  _Metodi privati:_

  #table(
    columns: (1.5fr, 3.5fr),
    [Metodo], [Comportamento],
    [`processMessage(message)`],
    [Parsa payload; valida action/resource/timestamp/tenantId; risolve userId; registra evento; ack del messaggio],

    [`resolveTenantId(subject, details)`],
    [Estrae tenant ID dal subject NATS o dall'oggetto details; valida formato UUID],

    [`resolveUserId(value)`], [Restituisce UUID string o `SYSTEM_USER_ID` (`00000000-0000-0000-0000-000000000000`)],

    [`parseTimestamp(value)`], [Parsa stringa in Date; restituisce `undefined` se non valida],

    [`toDetailsObject(value, subject)`], [Avvolge i dettagli; aggiunge `sourceSubject` se il subject esiste],
  )

  ==== AuditLogMapper

  _Metodi statici:_

  #table(
    columns: (1.5fr, 3.5fr),
    [Metodo], [Comportamento],
    [`toModel(entity)`], [Converte `AuditLogEntity` in `AuditLogModel`],

    [`toDto(model)`], [Converte in `AuditLogResponseDto`; offusca userId per audit di provisioning (restituisce `-`)],
  )

  _Metodi privati:_

  #table(
    columns: (1.5fr, 3.5fr),
    [Metodo], [Comportamento],
    [`resolveUserId(model)`], [Restituisce `-` se è un audit di provisioning (`sourceSubject` inizia con `log.audit.`)],

    [`isProvisioningAudit(details)`], [Verifica se `sourceSubject` inizia con `log.audit.`],
  )

  ==== Entità

  _AuditLogEntity_ (tabella `audits`)

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`id`], [`uuid v4`], [Identificativo univoco],
    [`tenantId`], [`uuid`], [FK verso `TenantEntity`; cascade delete],
    [`userId`], [`uuid`], [ID dell'utente che ha eseguito l'azione],
    [`action`], [`string`], [Tipo di azione eseguita],
    [`resource`], [`string`], [Risorsa su cui è stata eseguita l'azione],
    [`details`], [`jsonb`], [Dettagli aggiuntivi dell'evento],
    [`timestamp`], [`Date`], [Timestamp dell'evento],
  )

  === ApiClientModule

  Il modulo di gestione dei client API gestisce la creazione, consultazione ed eliminazione dei client OIDC associati ai
  tenant, con sincronizzazione su Keycloak.

  ==== ApiClientController

  Controller NestJS esposto sotto il prefisso `/api-clients`. Protetto da `@TenantScoped()` e `@Roles(TENANT_ADMIN)`.

  #table(
    columns: (1.2fr, 2.5fr, 2.3fr),
    [Metodo], [Endpoint], [Note],
    [`getApiClients(tenantId)`], [`GET /api-clients`], [Restituisce tutti i client API del tenant],

    [`createApiClient(tenantId, input)`], [`POST /api-clients`], [Crea un nuovo client API; protetto da `@Audit`],

    [`deleteApiClient(tenantId, id)`], [`DELETE /api-clients/:id`], [Elimina un client API; protetto da `@Audit`],
  )

  ==== ApiClientService

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`acps`], [`ApiClientPersistenceService`], [Iniettato via constructor],
    [`keycloakAdminService`], [`KeycloakAdminService`], [Iniettato via constructor],
    [`logger`], [`Logger`], [Logger interno],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`createApiClient(tenantId, name)`],
    [`(tenantId, name): Promise<{ model, clientSecret }>`],
    [Verifica conflitto nome; crea client su Keycloak; salva nel DB; rollback Keycloak se DB fallisce],

    [`getApiClients(tenantId)`], [`(tenantId): Promise<ApiClientModel[]>`], [Recupera tutti i client API del tenant],

    [`deleteApiClient(tenantId, id)`],
    [`(tenantId, id): Promise<void>`],
    [Elimina dal DB, poi da Keycloak (warn se Keycloak fallisce)],

    [`deleteApiClientsForTenant(tenantId)`],
    [`(tenantId): Promise<void>`],
    [Elimina bulk di tutti i client API per un tenant],
  )

  ==== ApiClientPersistenceService

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`createApiClient(id, tenantId, name, keycloakClientId)`],
    [`(...): Promise<ApiClientEntity>`],
    [Crea e salva un nuovo `ApiClientEntity`],

    [`findByName(tenantId, name)`],
    [`(tenantId, name): Promise<ApiClientEntity | null>`],
    [Trova client per `tenantId + name`],

    [`getApiClients(tenantId)`], [`(tenantId): Promise<ApiClientEntity[]>`], [Trova tutti i client per `tenantId`],

    [`deleteApiClient(tenantId, id)`],
    [`(tenantId, id): Promise<string | null>`],
    [Trova entity, rimuove dal DB, restituisce il `keycloakClientId` o `null`],
  )

  ==== Entità

  _ApiClientEntity_ (tabella `api_clients`)

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`id`], [`string`], [Chiave primaria (stringa, non UUID)],
    [`tenantId`], [`uuid`], [FK verso `TenantEntity`; cascade delete],
    [`name`], [`string`], [Nome del client; indice unico],
    [`keycloakClientId`], [`string`], [Client ID su Keycloak; indice unico],
    [`createdAt`], [`Date`], [Timestamp di creazione],
  )

  === ThresholdsModule
  #figure(caption: "Diagramma del modulo ThresholdsModule")[#image("assets/11-thresholds.svg")]

  Il modulo di gestione delle soglie gestisce i valori minimi e massimi per i sensori, sia a livello di tipo di sensore
  (default per tenant) che a livello di singolo sensore.

  ==== ThresholdsController

  Controller NestJS esposto sotto il prefisso `/thresholds`. Protetto da `@TenantScoped()`.

  #table(
    columns: (2fr, 2.5fr, 2.3fr),
    [Metodo], [Endpoint], [Note],
    [`getThresholds(tenantId)`],
    [`GET /thresholds`],
    [Restituisce tutte le soglie del tenant; accessibile a `TENANT_USER` e `TENANT_ADMIN`],

    [`setDefaultThreshold(tenantId, input)`],
    [`PUT /thresholds/default`],
    [Imposta la soglia di default per un tipo di sensore; protetto da `@Audit` e `@Roles(TENANT_ADMIN)`],

    [`setSensorThreshold(tenantId, sensorId, input)`],
    [`PUT /thresholds/sensor/:sensorId`],
    [Imposta la soglia per un sensore specifico; protetto da `@Audit` e `@Roles(TENANT_ADMIN)`],

    [`deleteSensorThreshold(tenantId, sensorId)`],
    [`DELETE /thresholds/sensor/:sensorId`],
    [Elimina la soglia per un sensore; protetto da `@Audit` e `@Roles(TENANT_ADMIN)`],

    [`deleteThresholdType(tenantId, sensorType)`],
    [`DELETE /thresholds/type/:sensorType`],
    [Elimina la soglia di default per un tipo di sensore; protetto da `@Audit` e `@Roles(TENANT_ADMIN)`],
  )

  ==== ThresholdsService

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`tps`], [`ThresholdsPersistenceService`], [Iniettato via constructor],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`getThresholds(input)`], [`(input): Promise<ThresholdModel[]>`], [Recupera tutte le soglie del tenant],

    [`setThresholdDefaultType(input)`],
    [`(input): Promise<ThresholdModel>`],
    [Valida `sensorType` e range valori; delega al persistence layer],

    [`setThresholdSensor(input)`],
    [`(input): Promise<ThresholdModel>`],
    [Valida `sensorId` e range valori; delega al persistence layer],

    [`deleteSensorThreshold(input)`], [`(input): Promise<void>`], [Solleva `NotFoundException` se non trovato],

    [`deleteThresholdType(input)`], [`(input): Promise<void>`], [Solleva `NotFoundException` se non trovato],
  )

  _Metodi privati:_

  #table(
    columns: (1.5fr, 3.5fr),
    [Metodo], [Comportamento],
    [`ensureSensorType(sensorType)`], [Trim e valida che non sia vuoto; solleva `BadRequestException`],

    [`ensureSensorId(sensorId)`], [Trim e valida che non sia vuoto; solleva `BadRequestException`],

    [`validateValueRange(minValue, maxValue)`],
    [Valida che i numeri siano validi e `minValue < maxValue`; solleva `BadRequestException`],
  )

  ==== ThresholdsPersistenceService

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`getThresholds(input)`],
    [`(input): Promise<ThresholdEntity[]>`],
    [Trova per `tenantId`; ordina per `updatedAt DESC`],

    [`setThresholdDefaultType(input)`],
    [`(input): Promise<ThresholdEntity>`],
    [Upsert: trova per `tenantId + sensorType + sensorId IS NULL`; aggiorna o crea],

    [`setThresholdSensor(input)`],
    [`(input): Promise<ThresholdEntity>`],
    [Upsert: trova per `tenantId + sensorId`; aggiorna o crea],

    [`deleteSensorThreshold(input)`],
    [`(input): Promise<boolean>`],
    [Elimina per `tenantId + sensorId`; restituisce `true` se eliminato],

    [`deleteThresholdType(input)`],
    [`(input): Promise<boolean>`],
    [Elimina per `tenantId + sensorType + sensorId IS NULL`; restituisce `true` se eliminato],
  )

  ==== Entità

  _ThresholdEntity_ (tabella `thresholds`)

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`id`], [`uuid v4`], [Identificativo univoco],
    [`tenantId`], [`uuid`], [FK verso `TenantEntity`; cascade delete],
    [`sensorType`], [`string | null`], [Tipo di sensore (per soglie di default)],
    [`sensorId`], [`uuid | null`], [ID del sensore specifico (per override)],
    [`minValue`], [`number`], [Valore minimo (float)],
    [`maxValue`], [`number`], [Valore massimo (float)],
    [`createdAt`], [`Date`], [Timestamp di creazione],
    [`updatedAt`], [`Date`], [Timestamp dell'ultimo aggiornamento],
  )

  Indici unici composti: uno su `['tenantId', 'sensorType']` dove `sensor_id IS NULL`, uno su `['tenantId', 'sensorId']`
  dove `sensor_id IS NOT NULL`.

  === CostsModule
  #figure(caption: "Diagramma del modulo CostsModule")[#image("assets/07-costs.svg")]

  Il modulo di gestione dei costi calcola lo storage e la banda utilizzati da un tenant, combinando dati da NATS, alert
  e comandi.

  ==== CostsController

  Controller NestJS esposto sotto il prefisso `/costs`. Protetto da `@TenantScoped()` e `@Roles(TENANT_ADMIN)`.

  #table(
    columns: (1.2fr, 2.5fr, 2.3fr),
    [Metodo], [Endpoint], [Note],
    [`getTenantCost(tenantId)`], [`GET /costs`], [Restituisce i costi stimati del tenant: storage e banda in GB],
  )

  ==== CostsService

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`cps`], [`CostsPersistenceService`], [Iniettato via constructor],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`getTenantCost(tenantId)`],
    [`(tenantId): Promise<CostModel>`],
    [Delega al persistence layer; solleva `NotFoundException` se nessun dato; mappa errori HTTP-like a eccezioni
      NestJS],
  )

  ==== CostsPersistenceService

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`nats`], [`JetStreamClient`], [Iniettato per richiesta NATS],
    [`alerts`], [`AlertsPersistenceService`], [Iniettato per conteggio alert],
    [`commands`], [`CommandPersistenceService`], [Iniettato per conteggio comandi],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [Metodo], [Firma], [Note],
    [`getTenantCost(tenantId)`],
    [`(tenantId): Promise<CostData>`],
    [Invia richiesta NATS a `internal.cost` con `{ tenant_id }`; calcola `storageGb = dataSizeAtRest / 1GB` e
      `bandwidthGb = (alertsCount + commandsCount) * 1KB / 1GB`; entrambi arrotondati a 4 decimali],
  )

  ==== DTO

  _CostResponseDto_ — `storage_gb: number`, `bandwidth_gb: number`.

  ==== Modelli

  _CostModel_ — `storageGb: number`, `bandwidthGb: number`.

  _CostData_ — `storageGb: number`, `bandwidthGb: number`.



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
  Un utente con ruolo _system_admin_ invia una richiesta di creazione di un tenant tramite l’endpoint amministrativo
  dedicato. Il controller delega l’operazione al service applicativo, che avvia una transazione sul database locale e
  crea l’entità del tenant. Successivamente il backend interagisce con Keycloak per creare l’utente amministratore del
  tenant, assegnargli il ruolo applicativo previsto e associargli gli attributi necessari, incluso il riferimento al
  tenant. Una volta completata la creazione remota, il microservizio persiste anche il corrispondente utente locale nel
  database applicativo. In caso di errore durante il flusso, vengono applicati meccanismi di rollback per ridurre il
  rischio di inconsistenze tra database locale e Keycloak.

  === Creazione di un Utente Tenant
  Un utente con ruolo _tenant_admin_ invia una richiesta di creazione di un nuovo utente appartenente al proprio tenant.
  Il controller inoltra i dati al service applicativo, che coordina la creazione dell’utente sia nel database locale sia
  su Keycloak. Dopo la creazione remota, il backend salva le informazioni dell’utente nel database applicativo,
  mantenendo allineati il sistema locale e il provider di identità. Il ruolo applicativo assegnato all’utente viene
  sincronizzato con i ruoli configurati in Keycloak.

  === Impersonazione di un Utente
  Un utente con ruolo _system_admin_ invia una richiesta di impersonazione tramite l’endpoint `/auth/impersonate`,
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
  Un utente con ruolo _tenant_admin_ richiede la creazione di un nuovo API client associato al tenant. Il microservizio
  delega a Keycloak la creazione del client applicativo e del relativo secret, quindi persiste nel database locale le
  informazioni necessarie a rappresentarlo nel dominio applicativo. La risposta restituisce sia i dati del nuovo client
  sia, nel momento della creazione, il secret necessario per l’utilizzo da parte del chiamante.

  === Invio di un Comando a un Gateway
  Un utente con ruolo _tenant_admin_ invia un comando verso un gateway, ad esempio per aggiornare la configurazione o
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
  Un utente con ruolo _tenant_admin_ può interrogare i log di audit specificando almeno un intervallo temporale di
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
