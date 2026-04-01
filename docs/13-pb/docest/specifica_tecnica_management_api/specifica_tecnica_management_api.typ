#import "../../00-templates/base_document.typ" as base-document
#import "../specifica_tecnica/st_lib.typ" as st

#let metadata = yaml(sys.inputs.meta-path)
#show figure.where(kind: table): set block(breakable: true)

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
      [KeycloakHostname], [KEYCLOAK_HOSTNAME], [localhost], [No],
      [NATSUrl], [NATS_URL], [-], [Si],
      [DBHost], [MGMT_DB_HOST], [—], [Sì],
      [DBPort], [MGMT_DB_PORT], [5432], [No],
      [DBName], [MGMT_DB_NAME], [—], [Sì],
      [DBUser], [MGMT_DB_USER], [—], [Sì],
      [DBPassword], [MGMT_DB_PASSWORD], [—], [Sì],
      [DBEncryptionKey], [MGMT_DB_ENCRYPTION_KEY], [-], [Si],
      [ApiPort], [MGMT_API_PORT], [3001], [No],
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
      [2], [bootstrap.nestjs], [Inizializza i moduli, controller e provider dell'applicazione NestJS], [Si],
      [3], [app.module], [Inizializza TypeORM], [Si],
      [4], [auth.module], [Registra guard, e servizi di autenticazione], [Si],
      [5], [jwt.strategy], [Configura la strategia JWT con Keycloak], [Si],
      [6], [keys.module], [Registra il modulo per la gestione delle chiavi], [Si],
      [7], [main], [Crea l’applicazione NestJS, registra pipe, filtri globali e documentazione Swagger.], [Si],
    )
  ]



  #pagebreak()

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
    #image("./assets/gatewaysDiagram.png", width: 100%)
  ]

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
  #pagebreak()
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
    )
  ]


  = Design di Dettaglio

  == Moduli del microservizio

  #figure(
    caption: [Moduli interni del microservizio `notip-management-api`],
  )[
    #table(
      columns: (0.5fr, 1fr),
      [Modulo], [Responsabilità],
      [AuthModule],
      [Gestione autenticazione e autorizzazione tramite Keycloak, implementazione della strategia JWT, definizione dei
        guard e delle policy di accesso agli endpoint.],

      [AdminModule],
      [Funzionalità amministrative di livello di sistema, in particolare gestione dei Tenant e di tutte le operazioni
        che richiedono privilegi elevati. Tra queste è inclusa la possibilità di impersonare un utente per conto del
        quale agire.],

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
      [Gestisce la configurazione e le operazioni relative agli alert sui Gateway, inclusa la definizione delle soglie
        di notifica.],

      [ThresholdsModule], [Gestisce le soglie applicative associate ai Gateway o ai Tenant.],
      [CostsModule], [ Gestisce le informazioni e la logica applicativa relative ai costi.],
      [CommonModule],
      [Contiene componenti trasversali come decoratori, filtri, intercettori, validazione configurazione e utility
        condivise.],
    )
  ]



  == Entità
  #figure(
    caption: [Entità principali del microservizio `notip-management-api`],
  )[
    #table(
      columns: (1.5fr, 2fr),
      [Entità], [Campi],

      [TenantEntity],
      [#par(justify: false)[
        *`id`*: `uuid v4`, *`name`*: `string`, *`status`*: `TenantStatus` `(enum)`, *`suspensionIntervalDays`*:
        `number | null`, *`createdAt`*: `Date`, *`updatedAt`*: `Date`]],

      [UserEntity],
      [#par(justify: false)[
        *`id`*: `uuid`, *`tenantId`*: `string`, *`name`*: `string`, *`email`*: `string`, *`role`*: `UsersRole` `(enum)`,
        *`permissions`*: `string[] | null`, *`lastAccess`*: `Date | null`, *`createdAt`*: `Date`]],

      [GatewayEntity],
      [#par(justify: false)[
        *`id`*: `uuid v4`, *`tenantId`*: `string`, *`factoryId`*: `string`, *`factoryKeyHash`*: `string | null`,
        *`provisioned`*: `boolean`, *`model`*: `string`, *`firmwareVersion`*: `string`, *`createdAt`*: `Date`,
        *`updatedAt`*:
        `Date`]],

      [GatewayMetadataEntity],
      [#par(justify: false)[
        *`gatewayId`*: `uuid`, *`name`*: `string`, *`status`*: `GatewayStatus` `(enum)`, *`lastSeenAt`*: `Date`,
        *`sendFrequencyMs`*:
        `number | null`]],

      [KeyEntity],
      [#par(justify: false)[
        *`id`*: `uuid v4`, *`gatewayId`*: `uuid`, *`keyMaterial`*: `Buffer`, *`keyVersion`*: `number`, *`createdAt`*:
        `Date`, *`revokedAt`*: `Date | null`]],

      [AlertsEntity],
      [#par(justify: false)[
        *`id`*: `uuid v4`, *`tenantId`*: `uuid`, *`type`*: `AlertType` `(enum)`, *`gatewayId`*: `uuid`, *`details`*:
        `jsonb`, *`createdAt`*: `Date`]],

      [AlertsConfigEntity],
      [#par(justify: false)[
        *`id`*: `uuid v4`, *`tenantId`*: `string`, *`gatewayId`*: `uuid | null`, *`gatewayTimeoutMs`*: `number`,
        *`updatedAt`*:
        `Date`]],

      [ThresholdEntity],
      [#par(justify: false)[
        *`id`*: `uuid v4`, *`tenantId`*: `uuid`, *`sensorType`*: `string | null`, *`sensorId`*: `uuid | null`,
        *`minValue`*: `number`, *`maxValue`*: `number`, *`createdAt`*: `Date`, *`updatedAt`*: `Date`]],

      [AuditLogEntity],
      [#par(justify: false)[
        *`id`*: `uuid v4`, *`tenantId`*: `uuid`, *`userId`*: `uuid`, *`action`*: `string`, *`resource`*: `string`,
        *`details`*: `jsonb`, *`timestamp`*: `Date`]],

      [ApiClientEntity],
      [#par(justify: false)[
        *`id`*: `string`, *`tenantId`*: `uuid`, *`name`*: `string`, *`keycloakClientId`*: `string`, *`createdAt`*:
        `Date`]],

      [CommandEntity],
      [#par(justify: false)[
        *`id`*: `uuid v4`, *`gatewayId`*: `uuid`, *`tenantId`*: `uuid`, *`type`*: `CommandType` `(enum)`, *`status`*:
        `CommandStatus` `(enum)`, *`issuedAt`*: `Date`, *`ackReceivedAt`*: `Date | null`, *`createdAt`*: `Date`]],
    )
  ]
  == Enums
  #figure(
    caption: [Enumerazioni principali del microservizio `notip-management-api`],
  )[
    #table(
      columns: (1fr, 2fr),
      [Enum], [Valori],
      [TenantStatus], [*`active`*, *`suspended`*],
      [UsersRole], [*`system_admin`*, *`tenant_admin`*, *`user`*],
      [GatewayStatus], [*`online`*, *`offline`*, *`provisioning`*, *`suspended`*],
      [AlertType], [*`gateway_offline`*],
      [CommandType], [*`config`*, *`firmware`*, *`suspend`*],
      [CommandStatus], [*`queued`*, *`ack`*, *`nack`*, *`expired`*, *`timeout`*],
    )
  ]
  == Endpoint API
  Di seguito è riportato l'elenco completo degli endpoint esposti dal microservizio divisi per area di interesse. Non
  tutti gli endpoint sono accessibili via frontend, alcuni sono utilizzati esclusivamente per la comunicazione tra
  microservizi o per operazioni di amministrazione via terminale:
  #let desc(body) = text(10pt, {
    set par(justify: false)
    body
  })
  #show raw.where(lang: "json"): set text(size: 7pt)

  === Admin
  Questi endpoint sono accessibili solo agli utenti con ruolo `system_admin`:

  #figure(
    caption: [Endpoint riservati agli amministratori di sistema],
  )[
    #table(
      columns: (0.8fr, 1.4fr, 1.6fr, 2.4fr, 2.2fr),
      align: (left, left, left, left, left),
      [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

      [`GET`],
      [`/admin/tenants`],
      desc[Restituisce l’elenco dei Tenant],
      [-],
      [```json
      [{
        "id": "string",
        "name": "string",
        "status": "TenantStatus",
        "created_at": "string"
      }]
      ```],

      [`GET`],
      [`/admin/tenants/:id/users`],
      desc[Restituisce gli utenti associati a uno specifico Tenant],
      [-],
      [```json
      [{
          "user_id": "string",
          "role": "UsersRole"
      }]
      ```],

      [`POST`],
      [`/admin/tenants`],
      desc[Crea un nuovo Tenant e il relativo amministratore],
      [```json
      {
        "name": "string",
        "admin_email": "string",
        "admin_name": "string",
        "admin_password": "string"
      }
      ```],
      [```json
      {
        "id": "string",
        "name": "string",
        "status": "TenantStatus",
        "created_at": "string"
      }
      ```],

      [`PATCH`],
      [`/admin/tenants/:id`],
      desc[Aggiorna i dati di un Tenant],
      [```json
      {
        "name?": "string",
        "status?": "TenantStatus",
        "suspension_interval_days?": "number"
      }
      ```],
      [```json
      {
        "id": "string",
        "name": "string",
        "status": "TenantStatus",
        "updated_at": "string"
      }
      ```],

      [`DELETE`],
      [`/admin/tenants/:id`],
      desc[Elimina un Tenant],
      [-],
      [```json
      {
        "status": 200
      }
      ```],

      [`GET`],
      [`/admin/gateways?id=:tenantId`],
      desc[Restituisce tutti i Gateway, con filtro opzionale per Tenant],
      [-],
      [```json
      [{
        "id": "string",
        "tenant_id": "string"
      }]
      ```],

      [`POST`],
      [`/admin/gateways`],
      desc[Registra un nuovo Gateway per un Tenant],
      [```json
      {
        "factory_id": "string",
        "tenant_id": "string",
        "factory_key_hash":
        "string"
      }
      ```],
      [```json
      {
        "id": "string"
      }
      ```],
    )
  ]

  === Auth
  Questi endpoint sono accessibili agli utenti autenticati; l’endpoint di impersonazione è riservato ai `system_admin`:

  #figure(
    caption: [Endpoint di autenticazione e impersonazione],
  )[
    #table(
      columns: (0.8fr, 1.4fr, 1.6fr, 2.4fr, 3fr),
      align: (left, left, left, left, left),
      [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

      [`GET`],
      [`/auth/me`],
      desc[Restituisce i dati dell’utente autenticato],
      [-],
      [```json
      {
        "actor_user_id?": "string",
        "actor_email?": "string",
        "actor_name?": "string",
        "actor_role?": "UsersRole",
        "actor_tenant_id?": "string",
        "effective_user_id": "string",
        "effective_email": "string",
        "effective_name": "string",
        "effective_role": "UsersRole",
        "effective_tenant_id": "string",
        "is_impersonating": "boolean"
      }
      ```],

      [`POST`],
      [`/auth/impersonate`],
      desc[Genera un token di impersonazione per un utente],
      [```json
      {
        "user_id": "string"
      }
      ```],
      [```json
      {
        "access_token": "string",
        "expires_in": "number"
      }
      ```],
    )
  ]

  === Gateways
  Questi endpoint sono accessibili agli utenti del Tenant; le modifiche sono riservate ai `tenant_admin`:

  #figure(
    caption: [Endpoint per la gestione dei `Gateway`],
  )[
    #table(
      columns: (0.8fr, 1.4fr, 1.6fr, 2.4fr, 2.7fr),
      align: (left, left, left, left, left),
      [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

      [`GET`],
      [`/gateways`],
      desc[Restituisce i Gateway del Tenant autenticato],
      [-],
      [```json
      [{
        "id": "string",
        "name": "string",
        "status": "GatewayStatus",
        "last_seen_at?": "string",
        "provisioned": "boolean",
        "firmware_version?": "string",
        "send_frequency_ms?": "number"
      }]
      ```],

      [`GET`],
      [`/gateways/:id`],
      desc[Restituisce il dettaglio di un Gateway],
      [-],
      [```json
      {
        "id": "string",
        "name": "string",
        "status": "GatewayStatus",
        "last_seen_at?": "string",
        "provisioned": "boolean",
        "firmware_version?": "string",
        "send_frequency_ms?": "number"
      }
      ```],

      [`PATCH`],
      [`/gateways/:id`],
      desc[Aggiorna il nome di un Gateway],
      [```json
      { "name": "string" }
      ```],
      [```json
      {
        "id": "string",
        "name": "string",
        "status": "GatewayStatus",
        "updated_at": "string"
      }
      ```],

      [`DELETE`],
      [`/gateways/:id`],
      desc[Elimina un Gateway],
      [-],
      [```json
      { "status": 200 }
      ```],
    )
  ]

  === Users
  Questi endpoint sono accessibili ai `tenant_admin`:

  #figure(
    caption: [Endpoint per la gestione degli utenti del `Tenant`],
  )[
    #table(
      columns: (1fr, 1.5fr, 2.2fr, 2.4fr, 2.5fr),
      align: (left, left, left, left, left),
      [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

      [`GET`],
      [`/users`],
      desc[Restituisce gli utenti del Tenant],
      [-],
      [```json
      [{
        "id": "string",
        "name": "string",
        "email": "string",
        "role": "UsersRole",
        "last_access?": "string"
      }]
      ```],

      [`GET`],
      [`/users/:id`],
      desc[Restituisce il dettaglio di un utente],
      [-],
      [```json
      {
        "id": "string",
        "name": "string",
        "email": "string",
        "role": "UsersRole",
        "last_access?": "string"
      }
      ```],

      [`POST`],
      [`/users`],
      desc[Crea un utente nel Tenant],
      [```json
      {
        "name": "string",
        "email": "string",
        "role": "UsersRole",
        "password": "string"
      }
      ```],
      [```json
      {
        "id": "string",
        "name": "string",
        "email": "string",
        "role": "UsersRole",
        "created_at": "string"
      }
      ```],

      [`PATCH`],
      [`/users/:id`],
      desc[Aggiorna un utente del Tenant],
      [```json
      {
        "name?": "string",
        "email?": "string",
        "role?": "UsersRole",
      }
      ```],
      [```json
      {
        "id": "string",
        "name": "string",
        "email": "string",
        "role": "UsersRole",
        "updated_at": "string"
      }
      ```],

      [`POST`],
      [`/users/bulk-delete`],
      desc[Elimina più utenti in un’unica richiesta],
      [```json
      { "ids": ["string"] }
      ```],
      [```json
      {
        "deleted": "number",
        "failed": ["string"]
      }
      ```],
    )
  ]

  === API Clients
  #figure(
    caption: [Endpoint per la gestione degli `API Client`],
  )[
    #table(
      columns: (1fr, 1.8fr, 1.5fr, 1.6fr, 2.3fr),
      align: (left, left, left, left, left),
      [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

      [`GET`],
      [`/api-clients`],
      desc[Restituisce i client API del Tenant],
      [-],
      [```json
      [{
        "id": "string",
        "name": "string",
        "client_id": "string",
        "created_at": "string"
      }]
      ```],

      [`POST`],
      [`/api-clients`],
      desc[Crea un nuovo client API],
      [```json
      { "name": "string" }
      ```],
      [```json
      {
        "id": "string",
        "name": "string",
        "client_id": "string",
        "client_secret": "string",
        "created_at": "string"
      }
      ```],

      [`DELETE`],
      [`/api-clients/:id`],
      desc[Elimina un client API],
      [-],
      [```json
      { "status": 200 }
      ```],
    )
  ]

  === Keys e Provisioning
  #figure(
    caption: [Endpoint per chiavi e provisioning],
  )[
    #table(
      columns: (1fr, 1.8fr, 1.7fr, 2.5fr, 2.5fr),
      align: (left, left, left, left, left),
      [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

      [`GET`],
      [`/keys?id=:gatewayId`],
      desc[Restituisce le chiavi associate a un Gateway],
      [-],
      [```json
      [{
        "gateway_id": "string",
        "key_material": "Buffer",
        "key_version": "number"
      }]
      ```],

      [`POST`],
      [`/internal/provisioning/validate`],
      desc[Valida factory ID e factory key del Gateway],
      [```json
      {
        "factory_id": "string",
        "factory_key": "string"
      }
      ```],
      [```json
      {
        "gateway_id": "string",
        "tenant_id": "string"
      }
      ```],

      [`POST`],
      [`/internal/provisioning/complete`],
      desc[Completa il provisioning del Gateway],
      [```json
      {
        "gateway_id": "string",
        "key_material": "string",
        "key_version": "number"
      }
      ```],
      [```json
      { "success": "boolean" }
      ```],
    )
  ]

  === Alerts
  #figure(
    caption: [Endpoint per la gestione degli alert],
  )[
    #table(
      columns: (1fr, 1.6fr, 1.5fr, 1.8fr, 2.5fr),
      align: (left, left, left, left, left),
      [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

      [`GET`],
      [`/alerts/config`],
      desc[Imposta la configurazione alert di default],
      [-],
      [```json
      {
        "default_timeout_ms": "integer",
        "gateway_overrides":[{
                    "gateway_id": "string",
                    "timeout_ms":
                    "integer"
                                           }]
      }
      ```],

      [`GET`],
      [
        `/alerts?from=:from&` \
        `to=:to&` \
        `gatewayId=
        :gatewayId`
      ],
      desc[Restituisce gli alert del Tenant nel range richiesto],
      [-],
      [```json
      [{
        "id": "string",
        "gateway_id": "string",
        "type": "AlertType",
        "details":
            {
              "last_seen":
              "string",
              "timeout_configured":
              "number"
            },
        "created_at": "string"
      }]
      ```],

      [`PUT`],
      [`/alerts/config/default`],
      desc[Imposta la configurazione alert di default],
      [```json
      { "timeout_ms":
        "number" }
      ```],
      [```json
      {
        "tenant_id": "string",
        "timeout_ms": "number",
        "updated_at": "string"
      }
      ```],

      [`PUT`],
      [`/alerts/config/gateway/
      :gatewayId`],
      desc[Imposta la configurazione alert specifica per un Gateway],
      [```json
      { "timeout_ms":
        "number" }
      ```],
      [```json
      {
        "gateway_id": "string",
        "timeout_ms": "number",
        "updated_at": "string"
      }
      ```],

      [`DELETE`],
      [`/alerts/config/gateway/
      :gatewayId`],
      desc[Elimina la configurazione alert specifica per un Gateway, tornando a utilizzare la configurazione di
        default],
      [-],
      [```json
      {
        "status": 200,
      }
      ```],
    )
  ]

  === Thresholds
  #figure(
    caption: [Endpoint per la gestione delle soglie],
  )[
    #table(
      columns: (1fr, 2fr, 2.2fr, 2.7fr, 2.7fr),
      align: (left, left, left, left, left),
      [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

      [`GET`],
      [`/thresholds`],
      desc[Restituisce le soglie del Tenant],
      [-],
      [```json
      [{
        "sensor_type?":
        "string",
        "sensor_id?": "string",
        "min_value": "number",
        "max_value": "number",
        "updated_at": "string"
      }]
      ```],

      [`PUT`],
      [`/thresholds/default`],
      desc[Imposta la soglia di default per tipologia],
      [```json
      {
        "sensor_type": "string",
        "min_value": "number",
        "max_value": "number"
      }
      ```],
      [```json
      {
        "sensor_type": "string",
        "min_value": "number",
        "max_value": "number",
        "updated_at": "string"
      }
      ```],

      [`PUT`],
      [`/thresholds/sensor/:id`],
      desc[Imposta o aggiorna la soglia per uno specifico sensore (override della soglia di default).],
      [```json
      {
        "min_value": "number",
        "max_value": "number"
      }
      ```],
      [```json
      {
        "sensor_id": "string",
        "min_value": "number",
        "max_value": "number",
        "updated_at": "string"
      }
      ```],

      [`DELETE`],
      [`/thresholds/sensor/:id`],
      desc[Elimina la soglia specifica di un sensore, ripristinando quella di default per tipologia.],
      [-],
      [```json
      {"status": 200}
      ```],

      [`DELETE`],
      [`/thresholds/type/
      :sensor_type`],
      desc[Elimina la soglia di default per una intera tipologia di sensori.],
      [-],
      [```json
      {"status": 200}
      ```],
    )
  ]

  === Commands
  #figure(
    caption: [Endpoint per l'invio e il tracciamento dei comandi],
  )[
    #table(
      columns: (1fr, 1.8fr, 1.8fr, 2.0fr, 2fr),
      align: (left, left, left, left, left),
      [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

      [`POST`],
      [`/cmd/:gatewayId/config`],
      desc[Invia una configurazione a un Gateway],
      [```json
      {
        "send_frequency_ms?":
        "number",
        "status?": "string"
      }
      ```],
      [```json
      {
        "command_id":
        "string",
        "status": "queued",
        "issued_at": "string"
      }
      ```],

      [`POST`],
      [`/cmd/:gatewayId/firmware`],
      desc[Invia un comando di aggiornamento firmware a uno specifico Gateway.],
      [```json
      {
        "firmware_version":
        "string",
        "download_url":
        "string"
      }
      ```],
      [```json
      {
        "command_id":
        "string",
        "status": "queued",
        "issued_at": "string"
      }
      ```],

      [`GET`],
      [`/cmd/:gatewayId/status/
      :commandId`],
      desc[Restituisce lo stato corrente di esecuzione di un comando specifico.],
      [-],
      [```json
      {
        "command_id":
        "string",
        "status":
        "CommandStatus",
        "timestamp?": "string"
      }
      ```],
    )
  ]

  === Costs
  #figure(
    caption: [Endpoint per la consultazione dei costi],
  )[
    #table(
      columns: (1fr, 1.7fr, 2.2fr, 2.4fr, 2fr),
      align: (left, left, left, left, left),
      [Metodo], [Endpoint], [Descrizione], [Body Request], [Response],

      [`GET`],
      [`/costs`],
      desc[Restituisce i costi correnti del Tenant],
      [-],
      [```json
      {
        "storage_gb":
        "number",
        "bandwidth_gb":
        "number"
      }
      ```],
    )
  ]
  === Errori
  Di seguito sono elencati i principali codici di errore restituiti dagli endpoint del microservizio, con una breve
  descrizione di ciascuno. In caso di errori non gestiti o eccezioni impreviste, il microservizio restituisce un errore
  generico 500 Internal Server Error.

  #figure(
    caption: [Codici di errore del microservizio `notip-management-api`],
  )[
    #table(
      columns: (auto, auto, 2.2fr),
      align: (left, left, left),
      [Codice], [Errore], [Descrizione],
      [401], [Unauthorized], [Client non autorizzato.],
      [403],
      [Forbidden],
      [Accesso negato, mancanza di permessi necessari, oppure nei casi di endpoint bloccati a chi sta impersonando un
        altro utente.],

      [404], [Not Found], [Risorsa richiesta non trovata.],
      [409],
      [Conflict],
      [Conflitto nello stato della risorsa, ad esempio tentativo di creare un Gateway con factory_id già esistente.],

      [500],
      [Internal Server Error],
      [Errore generico del server, in caso di eccezioni non gestite o errori imprevisti.],

      [503], [Service Unavailable],

      [Il servizio non è disponibile, ad esempio in caso di problemi di connessione con NATS o a Keycloak.],
    )
  ]
  == Decisioni implementative

  #st.design-rationale(title: "Interfacce tra le componenti dei moduli")[
    Sono state definite interfacce specifiche per la comunicazione tra i componenti dei moduli, in particolare per il
    passaggio dei parametri dei metodi tra *`Controller`* e *`Service`* e tra *`Service`* e *`PersistenceService`*.
    Questa scelta è stata motivata dalla volontà di mantenere una chiara separazione tra i livelli dell'applicazione,
    evitando di esporre direttamente i dati delle richieste fatte dal controller ai layer inferiori. Le interfacce
    consentono di definire contratti chiari e stabili tra i componenti, facilitando la manutenzione e l'evoluzione del
    codice, oltre a migliorare la testabilità isolata dei singoli componenti.
  ]

  #st.design-rationale(title: "Introduzione di Mappers tra i layer")[
    L'utilizzo di *`Persistence Entities`*, *`Business Models`* e *`DTO`* ha portato alla necessità di introdurre
    componenti di mapping dedicati per permettere una conversione corretta e centralizzata dei dati tra i diversi layer
    del modulo. I *`Mapper`* consentono di incapsulare la logica di trasformazione dei dati, mantenendo i controller e i
    servizi focalizzati sulle rispettive responsabilità di esposizione API e logica applicativa, senza doversi
    preoccupare dei dettagli di conversione tra i formati dei dati. Questa scelta migliora la manutenibilità del codice,
    riduce la duplicazione e facilita l'introduzione di eventuali modifiche future nei formati dei dati o nelle
    strutture delle entità senza impattare direttamente la logica di business o i contratti esposti.
  ]



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
