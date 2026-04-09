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
      columns: (2.8fr, auto, auto, auto),
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
      [#par(justify: false)[Registra i guard globali di autenticazione, ruoli, policy di accesso e blocco
        impersonazione]],
      [Si],

      [6], [jwt.strategy], [Configura la strategia JWT con Keycloak e JWKS], [Si],

      [7],
      [main],
      [#par(justify: false)[Crea l’applicazione NestJS, registra ValidationPipe, filtri globali e documentazione Swagger
        su `/docs`.]],
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
  completa dei moduli interni al microservizio e delle cartelle di contorno:

  #figure(
    caption: [Architettura del microservizio (parte 1)],
  )[
    #image("./assets/01-app-architecture-part1.svg", width: 110%)
  ]

  #figure(
    caption: [Architettura del microservizio (parte 2)],
  )[
    #image("./assets/01-app-architecture-part2.svg", width: 110%)
  ]

  #figure(
    caption: [Architettura del microservizio (parte 3)],
  )[
    #image("./assets/01-app-architecture-part3.svg", width: 110%)
  ]


  == Strati Architetturali
  Di seguito è riportata la suddivisione in strati architetturali del microservizio, con l'indicazione delle cartelle e
  dei componenti principali:

  #figure(
    caption: [Strati architetturali del microservizio `notip-management-api`],
  )[
    #table(
      columns: (1.5fr, 2fr, 2.5fr, 3fr),
      [#par(justify: false)[Strato]],
      [#par(justify: false)[Package]],
      [#par(justify: false)[Componenti]],
      [#par(justify: false)[Responsabilità]],

      [#par(justify: false)[Presentation]],
      [#par(justify: false)[`src/*/controller`\ `src/auth`\ `src/common/decorators`\ `src/auth/guards`\
        `src/common/interceptors`\
        `src/common/pipes`\ `src/common/filters`\ `src/*/dto`]],
      [#par(justify: false)[Controller, Guards, Interceptors, Filters, Decorators, DTO, Pipes]],
      [#par(justify: false)[Gestione delle richieste HTTP, esposizione delle API REST, validazione dei payload,
        autenticazione e definizione dei contratti di ingresso/uscita dei dati. I Guards applicano le policy di accesso
        (JWT, ruoli, impersonazione). Gli Interceptors gestiscono metriche, audit log e iniezione del tenant context. I
        filtri globali gestiscono le eccezioni e le mappano verso risposte HTTP strutturate.]],

      [#par(justify: false)[Business]],
      [#par(justify: false)[`src/*/services`\ `src/*/models`\ `src/*/interfaces`\ `src/*/enums`\ `src/*/*.mapper.ts`\
        `src/*/listeners`\
        `src/*/encryption`]],
      [#par(justify: false)[Services, Models, Mappers, Listeners, Enum, Encryption utilities]],
      [#par(justify: false)[Logica di business, regole di dominio, orchestrazione dei processi, definizione dei modelli
        di dominio e delle interfacce tra i servizi. Gestione delle richieste verso servizi esterni come Keycloak (token
        exchange, CRUD utenti/ruoli/gruppi) e NATS (publish, subscribe, request-reply). I Mappers convertono dati tra
        Entity, Model e DTO. I Listener reagiscono agli eventi interni del sistema (es. gateway decommissioned). Le
        utilities di crittografia gestiscono AES-256-GCM per il materiale delle chiavi.]],

      [#par(justify: false)[Persistence]],
      [#par(justify: false)[`src/*/entities`\ `src/*/services/*.persistence.ts`\ `src/database`\ `src/migrations`]],
      [#par(justify: false)[Entities, Persistence Services, Repository, Data Source, Migrations]],
      [#par(justify: false)[Gestione dell'accesso ai dati tramite TypeORM, definizione delle entità e dei repository,
        gestione delle migrazioni del database, implementazione dei servizi di persistenza che interagiscono con il
        database PostgreSQL. Ogni modulo ha un proprio persistence service che astrae le operazioni CRUD sul repository
        TypeORM. Il DataSource centralizza la configurazione della connessione e il supporto transazionale.]],

      [#par(justify: false)[Infrastructure]],
      [#par(justify: false)[`src/nats`\ `src/common/env.validation.ts`\ `src/metrics`]],
      [#par(justify: false)[NATS JetStream Client, Config Validation, Prometheus Metrics]],
      [#par(justify: false)[Componenti infrastrutturali trasversali: connessione e interazione con NATS JetStream
        (pubblicazione comandi, consumo ACK, request-reply per provisioning e alert), validazione della configurazione
        da variabili d'ambiente, esposizione di metriche Prometheus (request count, duration, in-flight).]],
    )
  ]

  === Pattern architetturali

  Il microservizio adotta diversi pattern architetturali che garantiscono manutenibilità, testabilità e separazione
  delle responsabilità:

  #figure(caption: [Pattern architetturali])[
    #table(
      columns: (1.5fr, 3.5fr),
      [#par(justify: false)[Pattern]], [#par(justify: false)[Descrizione]],
      [#par(justify: false)[Controller-Service-Persistence]],
      [#par(justify: false)[Ogni modulo segue questa tripartizione: il *Controller* espone endpoint HTTP, il *Service*
        contiene la logica di business e coordina i servizi esterni, il *Persistence Service* gestisce le operazioni
        CRUD su TypeORM. Questo pattern garantisce una chiara separazione tra i livelli dell'applicazione.]],

      [#par(justify: false)[Dependency Injection]],
      [#par(justify: false)[Tutti i componenti sono registrati come provider NestJS e iniettati tramite constructor
        injection. Il grafo delle dipendenze è configurato nel composition root di ciascun modulo (`*.module.ts`).]],

      [#par(justify: false)[Mapper]],
      [#par(justify: false)[Le classi mapper statiche (`*Mapper`) convertono dati tra i diversi livelli: Entity → Model
        → DTO. Questo evita che i dettagli di persistenza (TypeORM decorators) o di presentazione (class-transformer) si
        propaghino tra i layer.]],

      [#par(justify: false)[Event-driven]],
      [#par(justify: false)[Il modulo Gateways emette eventi interni tramite `EventEmitter2` (es.
        `gateway.decommissioned`). I listener (`GatewaysListener`) li traducono in messaggi NATS. Questo disaccoppia la
        logica di dominio dal meccanismo di trasporto.]],

      [#par(justify: false)[NATS Request-Reply]],
      [#par(justify: false)[Alcuni servizi espongono API interne tramite NATS RR: `ProvisioningNatsResponderService`
        (factory key validation), `GatewayStatusNatsResponderService` (aggiornamento stato runtime),
        `AlertConfigNatsResponderService` (config listing). Questo permette la comunicazione asincrona tra
        microservizi.]],

      [#par(justify: false)[Guard pattern]],
      [#par(justify: false)[I Guards globali (`JwtAuthGuard`, `RolesGuard`, `AccessPolicyGuard`,
        `BlockImpersonationGuard`) applicano politiche di accesso su ogni richiesta. I decoratori (`@AdminOnly()`,
        `@TenantScoped()`, `@Roles()`, `@BlockImpersonation()`) configurano il comportamento per-endpoint tramite
        metadati.]],
    )
  ]

  === Flusso di una richiesta

  Una richiesta HTTP attraversa i seguenti strati prima di raggiungere la logica di dominio:

  #figure(caption: [Flusso di una richiesta])[
    #table(
      columns: (auto, 1.5fr, 3fr),
      [#par(justify: false)[Step]], [#par(justify: false)[Strato]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[1]],
      [#par(justify: false)[Guards]],
      [#par(justify: false)[`JwtAuthGuard` valida il token JWT. `AccessPolicyGuard` verifica la policy
        (`@AdminOnly/@TenantScoped`). `RolesGuard` controlla i ruoli richiesti. `BlockImpersonationGuard` blocca se in
        impersonazione su endpoint protetti.]],

      [#par(justify: false)[2]],
      [#par(justify: false)[Interceptors]],
      [#par(justify: false)[`MetricsInterceptor` registra la richiesta. `LastAccessInterceptor` aggiorna l'ultimo
        accesso dell'utente. `TenantInterceptor` inietta il tenant context nella richiesta. `AuditInterceptor` registra
        l'evento di audit.]],

      [#par(justify: false)[3]],
      [#par(justify: false)[Pipes]],
      [#par(justify: false)[Validazione automatica dei DTO tramite `class-validator` e `class-transformer`. I decorator
        `@IsString()`, `@IsEnum()`, `@IsUUID()` garantiscono l'integrità dei dati in ingresso.]],

      [#par(justify: false)[4]],
      [#par(justify: false)[Controller]],
      [#par(justify: false)[Il controller riceve la richiesta valida, delega al Service e mappa la risposta tramite il
        Mapper.]],

      [#par(justify: false)[5]],
      [#par(justify: false)[Service]],
      [#par(justify: false)[Il Service applica le regole di business (validazione ownership, transazioni, chiamate a
        Keycloak/NATS).]],

      [#par(justify: false)[6]],
      [#par(justify: false)[Persistence]],
      [#par(justify: false)[Il Persistence Service esegue le operazioni TypeORM sul database PostgreSQL.]],

      [#par(justify: false)[7]],
      [#par(justify: false)[Response]],
      [#par(justify: false)[La risposta viene mappata dal Mapper al DTO appropriato e restituita al client con il
        formato JSON corretto.]],
    )
  ]

  = Design di Dettaglio
  == Moduli del microservizio

  === AdminModule
  Funzionalità amministrative di livello di sistema, in particolare gestione dei Tenant e di tutte le operazioni che
  richiedono privilegi elevati. Tra queste è inclusa la possibilità di impersonare un utente per conto del quale agire.
  ==== Admin Tenants
  #figure(caption: "Diagramma del modulo AdminModule")[#image("assets/02-admin-tenants.svg", width: 110%)]

  Il sottosistema di gestione dei Tenant si occupa di tutte le operazioni amministrative relative ai tenant del sistema:
  creazione, modifica, sospensione, riattivazione ed eliminazione. È il punto di ingresso per la gestione del ciclo di
  vita dei tenant e dei loro utenti.

  ===== TenantsController

  Controller NestJS esposto sotto il prefisso `/admin/tenants`. Protetto dal decoratore `@AdminOnly()`, espone cinque
  endpoint REST. Delega ogni operazione a `TenantsService` e utilizza `TenantsMapper` per trasformare i risultati nei
  DTO di risposta appropriati.

  #figure(caption: [Endpoint del TenantsController])[
    #table(
      columns: (1.5fr, 2.5fr, 2.3fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Endpoint]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getTenants()`]],
      [#par(justify: false)[`GET /admin/tenants`]],
      [#par(justify: false)[Restituisce la lista di tutti i tenant con i relativi dettagli]],

      [#par(justify: false)[`getTenantUsers(id)`]],
      [#par(justify: false)[`GET /admin/tenants/:id/users`]],
      [#par(justify: false)[Restituisce gli utenti associati a un tenant specifico]],

      [#par(justify: false)[`createTenant(dto)`]],
      [#par(justify: false)[`POST /admin/tenants`]],
      [#par(justify: false)[Crea un nuovo tenant con il relativo utente amministratore]],

      [#par(justify: false)[`updateTenant(id, dto)`]],
      [#par(justify: false)[`PATCH /admin/tenants/:id`]],
      [#par(justify: false)[Aggiorna nome, stato o intervallo di sospensione di un tenant]],

      [#par(justify: false)[`deleteTenant(id)`]],
      [#par(justify: false)[`DELETE /admin/tenants/:id`]],
      [#par(justify: false)[Elimina un tenant e cascata tutti i dati associati]],
    )
  ]

  ===== TenantsService

  Contiene la logica di business principale. Coordina `TenantsPersistenceService`, `KeycloakAdminService` e
  `ApiClientService`.

  _Campi:_

  #figure(caption: [Campi del TenantsService])[
    #table(
      columns: (1.9fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`tenantsPersistenceService`]],
      [#par(justify: false)[`TenantsPersistenceService`]],
      [#par(justify: false)[Iniettato via constructor]],

      [#par(justify: false)[`keycloakAdminService`]],
      [#par(justify: false)[`KeycloakAdminService`]],
      [#par(justify: false)[Iniettato via constructor]],

      [#par(justify: false)[`apiClientService`]],
      [#par(justify: false)[`ApiClientService`]],
      [#par(justify: false)[Iniettato via constructor]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici del TenantsService])[
    #table(
      columns: (1.9fr, 2.6fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getTenants()`]],
      [#par(justify: false)[`(): Promise<TenantsModel[]>`]],
      [#par(justify: false)[Recupera tutti i tenant dal database e li restituisce come array di modelli]],

      [#par(justify: false)[`getTenantUsers(tenantId)`]],
      [#par(justify: false)[`(tenantId: string): Promise<UserEntity[]>`]],
      [#par(justify: false)[Recupera gli utenti di un tenant specifico]],

      [#par(justify: false)[`createTenant(input)`]],
      [#par(justify: false)[`(input: CreateTenantInput): Promise<TenantsModel>`]],
      [#par(justify: false)[Crea un tenant in modo transazionale: entità DB, gruppo Keycloak, utente admin, client API.
        Rollback completo in caso di errore]],

      [#par(justify: false)[`updateTenant(input)`]],
      [#par(justify: false)[`(input: UpdateTenantInput): Promise<TenantsModel>`]],
      [#par(justify: false)[Aggiorna un tenant esistente; sincronizza il nome del gruppo su Keycloak se il nome è
        cambiato]],

      [#par(justify: false)[`deleteTenant(input)`]],
      [#par(justify: false)[`(input: DeleteTenantInput): Promise<void>`]],
      [#par(justify: false)[Elimina un tenant e tutti i dati correlati: utenti, gateway, gruppo Keycloak, client API]],
    )
  ]

  _Metodi privati:_
  #figure(caption: [Metodi privati del TenantsService])[
    #table(
      columns: (2.5fr, 3.5fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`isSuspensionExpired(tenant)`]],
      [#par(justify: false)[Verifica se un tenant sospeso ha superato il periodo di sospensione configurato confrontando
        `suspensionUntil` con la data corrente]],

      [#par(justify: false)[`reactivateTenantIfExpired(tenant)`]],
      [#par(justify: false)[Riattiva automaticamente un tenant il cui periodo di sospensione è scaduto, impostando lo
        stato ad `ACTIVE`]],

      [#par(justify: false)[`syncTenantUsersEnabledState(tenantId, status)`]],
      [#par(justify: false)[Sincronizza lo stato enabled/disabled di tutti gli utenti del tenant su Keycloak in base
        allo stato del tenant]],
    )
  ]

  ===== KeycloakAdminService

  Servizio di integrazione con Keycloak IAM. Utilizza `ConfigService` per recuperare le credenziali di accesso e
  comunica con le API REST di Keycloak tramite `fetch()`.

  _Campi:_

  #figure(caption: [Campi del KeycloakAdminService])[
    #table(
      columns: (2fr, 2.5fr, 2fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`configService`]],
      [#par(justify: false)[`ConfigService`]],
      [#par(justify: false)[Iniettato; fornisce URL, realm, admin username/password]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici del KeycloakAdminService])[
    #table(
      columns: (2.4fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`createApiClient(name, tenantId)`]],
      [#par(justify: false)[`(name: string, tenantId: string): Promise<ClientRepresentation>`]],
      [#par(justify: false)[Crea un client OIDC su Keycloak per un tenant]],

      [#par(justify: false)[`deleteApiClient(clientUuid)`]],
      [#par(justify: false)[`(clientUuid: string): Promise<void>`]],
      [#par(justify: false)[Elimina un client OIDC da Keycloak]],

      [#par(justify: false)[`updateApiClient(clientUuid, name)`]],
      [#par(justify: false)[`(clientUuid: string, name: string): Promise<void>`]],
      [#par(justify: false)[Aggiorna il nome di un client OIDC]],

      [#par(justify: false)[`createTenantAdminUser(input)`]],
      [#par(justify: false)[`(input: CreateUserInput): Promise<string>`]],
      [#par(justify: false)[Crea l'utente amministratore del tenant su Keycloak; restituisce l'ID utente]],

      [#par(justify: false)[`createTenantUser(input)`]],
      [#par(justify: false)[`(input: CreateUserInput): Promise<string>`]],
      [#par(justify: false)[Crea un utente generico del tenant su Keycloak; restituisce l'ID utente]],

      [#par(justify: false)[`getClientCredentialsToken()`]],
      [#par(justify: false)[`(): Promise<string>`]],
      [#par(justify: false)[Ottiene un token di accesso tramite client credentials grant]],

      [#par(justify: false)[`deleteUser(userId)`]],
      [#par(justify: false)[`(userId: string): Promise<void>`]],
      [#par(justify: false)[Elimina un utente da Keycloak]],

      [#par(justify: false)[`syncUserApplicationRole(userId, role)`]],
      [#par(justify: false)[`(userId: string, role: string): Promise<void>`]],
      [#par(justify: false)[Assegna o rimuove il ruolo applicativo a un utente]],

      [#par(justify: false)[`updateUser(userId, updates)`]],
      [#par(justify: false)[`(userId: string, updates: UserRepresentation): Promise<void>`]],
      [#par(justify: false)[Aggiorna i dati di un utente su Keycloak]],

      [#par(justify: false)[`setUserEnabled(userId, enabled)`]],
      [#par(justify: false)[`(userId: string, enabled: boolean): Promise<void>`]],
      [#par(justify: false)[Abilita o disabilita un utente su Keycloak]],

      [#par(justify: false)[`updateTenantGroup(oldId, newId)`]],
      [#par(justify: false)[`(oldId: string, newId: string): Promise<void>`]],
      [#par(justify: false)[Rinomina il gruppo tenant su Keycloak]],

      [#par(justify: false)[`deleteTenantGroup(tenantId)`]],
      [#par(justify: false)[`(tenantId: string): Promise<void>`]],
      [#par(justify: false)[Elimina il gruppo tenant da Keycloak]],
    )
  ]

  _Metodi privati:_

  #figure(caption: [Metodi privati del KeycloakAdminService])[
    #table(
      columns: (2fr, 3.5fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`deleteUserWithToken(userId, token)`]],
      [#par(justify: false)[Elimina un utente utilizzando un token di accesso specifico]],

      [#par(justify: false)[`ensureExclusiveAppRole(token, userId, role)`]],
      [#par(justify: false)[Garantisce che l'utente abbia un solo ruolo applicativo, rimuovendo ruoli conflittuali]],

      [#par(justify: false)[`ensureTenantGroup(token, tenantId)`]],
      [#par(justify: false)[Verifica o crea il gruppo tenant su Keycloak; restituisce il gruppo ID]],

      [#par(justify: false)[`assignUserToGroup(token, userId, groupId)`]],
      [#par(justify: false)[Assegna un utente a un gruppo specifico su Keycloak]],

      [#par(justify: false)[`getAdminAccessToken()`]],
      [#par(justify: false)[Ottiene il token di accesso amministrativo tramite le credenziali configurate]],

      [#par(justify: false)[`getRequiredEnv(key)`]],
      [#par(justify: false)[Recupera una variabile d'ambiente obbligatoria; lancia se non presente]],

      [#par(justify: false)[`buildTenantGroupName(tenantId)`]],
      [#par(justify: false)[Costruisce il nome del gruppo tenant: `tenant-<tenantId>`]],

      [#par(justify: false)[`buildUserAttributes(input)`]],
      [#par(justify: false)[Costruisce la mappa degli attributi utente per Keycloak]],
    )
  ]

  ===== TenantsPersistenceService

  Layer di accesso ai dati. Utilizza due repository separati gestiti tramite TypeORM: `tenantRepo` per `TenantEntity` e
  `userRepo` per `UserEntity`. Supporta le transazioni tramite `DataSource` (il parametro opzionale `manager` consente
  di partecipare a una transazione esterna).

  _Campi:_

  #figure(caption: [Campi del TenantsPersistenceService])[
    #table(
      columns: (1.8fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`tenantRepo`]],
      [#par(justify: false)[`Repository<TenantEntity>`]],
      [#par(justify: false)[Repository TypeORM, schema `common`]],

      [#par(justify: false)[`userRepo`]],
      [#par(justify: false)[`Repository<UserEntity>`]],
      [#par(justify: false)[Repository TypeORM, schema `users`]],

      [#par(justify: false)[`dataSource`]],
      [#par(justify: false)[`DataSource`]],
      [#par(justify: false)[Iniettato per supporto transazioni]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici del TenantsPersistenceService])[
    #table(
      columns: (2.5fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getTenants()`]],
      [#par(justify: false)[`(): Promise<TenantEntity[]>`]],
      [#par(justify: false)[Recupera tutti i tenant]],

      [#par(justify: false)[`createTenant(input, manager?)`]],
      [#par(justify: false)[`(input, manager?): Promise<TenantEntity>`]],
      [#par(justify: false)[Crea un tenant con supporto transazionale]],

      [#par(justify: false)[`updateTenant(input, manager?)`]],
      [#par(justify: false)[`(input, manager?): Promise<TenantEntity>`]],
      [#par(justify: false)[Aggiorna un tenant esistente]],

      [#par(justify: false)[`deleteTenant(input, manager?)`]],
      [#par(justify: false)[`(input, manager?): Promise<boolean>`]],
      [#par(justify: false)[Elimina un tenant; restituisce `true` se eliminato]],

      [#par(justify: false)[`createTenantAdminLocalUser(input, manager?)`]],
      [#par(justify: false)[`(input, manager?): Promise<UserEntity>`]],
      [#par(justify: false)[Crea l'utente amministratore locale nel database]],

      [#par(justify: false)[`getTenantAdminUsers(tenantId)`]],
      [#par(justify: false)[`(tenantId: string): Promise<UserEntity[]>`]],
      [#par(justify: false)[Recupera solo gli utenti admin di un tenant]],

      [#par(justify: false)[`getUsersByTenant(tenantId)`]],
      [#par(justify: false)[`(tenantId: string): Promise<UserEntity[]>`]],
      [#par(justify: false)[Recupera tutti gli utenti di un tenant]],
    )
  ]

  _Metodi privati:_

  #figure(caption: [Metodi privati del TenantsPersistenceService])[
    #table(
      columns: (1.5fr, 3.5fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`getTenantRepo(manager?)`]],
      [#par(justify: false)[Restituisce il repository tenant: se `manager` è fornito usa il suo repository, altrimenti
        il default]],

      [#par(justify: false)[`getUserRepo(manager?)`]],
      [#par(justify: false)[Restituisce il repository user: se `manager` è fornito usa il suo repository, altrimenti il
        default]],
    )
  ]

  ===== TenantsMapper

  Classe con metodi statici per la conversione tra i layer. Non ha dipendenze iniettate.

  _Metodi statici_

  #figure(caption: [Metodi statici del TenantsMapper])[
    #table(
      columns: (2fr, 3.5fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`toModel(entity)`]],
      [#par(justify: false)[Converte `TenantEntity` in `TenantsModel`: mappa i campi uno-a-uno]],

      [#par(justify: false)[`toResponseDto(model)`]],
      [#par(justify: false)[Converte `TenantsModel` in `TenantsResponseDto`: adatta i nomi per la risposta HTTP]],

      [#par(justify: false)[`toUpdateResponseDto(model)`]],
      [#par(justify: false)[Converte `TenantsModel` in `UpdateTenantsResponseDto`: include `updatedAt`]],

      [#par(justify: false)[`toSuspensionIntervalDays(model)`]],
      [#par(justify: false)[Calcola i giorni di sospensione dal modello, gestendo il caso `null`]],
    )
  ]

  ===== DTO e Input

  _CreateTenantRequestDto_

  #figure(caption: [Campi del CreateTenantRequestDto])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`name`]], [#par(justify: false)[`string`]], [#par(justify: false)[Nome del tenant]],
      [#par(justify: false)[`adminEmail`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Email dell'utente amministratore]],

      [#par(justify: false)[`adminUsername`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Username dell'utente amministratore]],

      [#par(justify: false)[`adminPassword`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Password iniziale dell'amministratore]],
    )
  ]

  _UpdateTenantRequestDto_

  #figure(caption: [Campi del UpdateTenantRequestDto])[
    #table(
      columns: (1.7fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`name`]],
      [#par(justify: false)[`string | null`]],
      [#par(justify: false)[Nuovo nome del tenant]],

      [#par(justify: false)[`status`]],
      [#par(justify: false)[`TenantStatus | null`]],
      [#par(justify: false)[Nuovo stato del tenant]],

      [#par(justify: false)[`suspensionIntervalDays`]],
      [#par(justify: false)[`number | null`]],
      [#par(justify: false)[Giorni prima della sospensione automatica]],
    )
  ]

  _TenantsResponseDto_

  #figure(caption: [Campi del TenantsResponseDto])[
    #table(
      columns: (1.6fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`id`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Identificativo univoco del tenant]],

      [#par(justify: false)[`name`]], [#par(justify: false)[`string`]], [#par(justify: false)[Nome del tenant]],
      [#par(justify: false)[`status`]],
      [#par(justify: false)[`TenantStatus`]],
      [#par(justify: false)[Stato corrente del tenant]],

      [#par(justify: false)[`createdAt`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Data di creazione in formato ISO 8601]],

      [#par(justify: false)[`suspensionIntervalDays`]],
      [#par(justify: false)[`number`]],
      [#par(justify: false)[Giorni prima della sospensione automatica]],
    )
  ]

  _UpdateTenantsResponseDto_

  #figure(caption: [Campi del UpdateTenantsResponseDto])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`id`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Identificativo univoco del tenant]],

      [#par(justify: false)[`name`]], [#par(justify: false)[`string`]], [#par(justify: false)[Nome del tenant]],
      [#par(justify: false)[`status`]],
      [#par(justify: false)[`TenantStatus`]],
      [#par(justify: false)[Stato corrente del tenant]],

      [#par(justify: false)[`updatedAt`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Data dell'ultimo aggiornamento in formato ISO 8601]],
    )
  ]

  _DeleteTenantResponseDto_

  #figure(caption: [Campi del DeleteTenantResponseDto])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`message`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Messaggio di conferma dell'eliminazione]],
    )
  ]

  _CreateTenantInput_

  #figure(caption: [Campi del CreateTenantInput])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`name`]], [#par(justify: false)[`string`]], [#par(justify: false)[Nome del tenant]],
      [#par(justify: false)[`adminEmail`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Email dell'utente amministratore]],

      [#par(justify: false)[`adminUsername`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Username dell'utente amministratore]],

      [#par(justify: false)[`adminPassword`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Password iniziale dell'amministratore]],
    )
  ]

  _UpdateTenantInput_

  #figure(caption: [Campi del UpdateTenantInput])[
    #table(
      columns: (1.7fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`id`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Identificativo del tenant da aggiornare]],

      [#par(justify: false)[`name`]],
      [#par(justify: false)[`string | null`]],
      [#par(justify: false)[Nuovo nome del tenant]],

      [#par(justify: false)[`status`]],
      [#par(justify: false)[`TenantStatus | null`]],
      [#par(justify: false)[Nuovo stato del tenant]],

      [#par(justify: false)[`suspensionIntervalDays`]],
      [#par(justify: false)[`number | null`]],
      [#par(justify: false)[Giorni prima della sospensione automatica]],
    )
  ]

  _DeleteTenantInput_

  #figure(caption: [Campi del DeleteTenantInput])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`id`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Identificativo del tenant da eliminare]],
    )
  ]

  ===== Enum

  _TenantStatus_

  #figure(caption: [Valori dell'enum TenantStatus])[
    #table(
      columns: (1.5fr, 4fr),
      [#par(justify: false)[Valore]], [#par(justify: false)[Descrizione]],
      [#par(justify: false)[`ACTIVE`]], [#par(justify: false)[Tenant operativo, tutti i servizi sono attivi]],
      [#par(justify: false)[`SUSPENDED`]],
      [#par(justify: false)[Tenant sospeso, gli utenti non possono accedere ai servizi]],
    )
  ]

  _UsersRole_

  #figure(caption: [Valori dell'enum UsersRole])[
    #table(
      columns: (1.5fr, 4fr),
      [#par(justify: false)[Valore]], [#par(justify: false)[Descrizione]],
      [#par(justify: false)[`SYSTEM_ADMIN`]],
      [#par(justify: false)[Amministratore di sistema, accesso completo a tutti i tenant]],

      [#par(justify: false)[`TENANT_ADMIN`]],
      [#par(justify: false)[Amministratore del tenant, gestisce utenti e configurazione del proprio tenant]],

      [#par(justify: false)[`TENANT_USER`]],
      [#par(justify: false)[Utente standard del tenant, accesso limitato alle funzionalità concesse]],
    )
  ]

  ===== Entità

  _TenantEntity_ (schema `common`)

  #figure(caption: [Campi del TenantEntity])[
    #table(
      columns: (1.7fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`id`]],
      [#par(justify: false)[`uuid v4`]],
      [#par(justify: false)[Identificativo univoco generato automaticamente]],

      [#par(justify: false)[`name`]], [#par(justify: false)[`string`]], [#par(justify: false)[Nome del tenant]],
      [#par(justify: false)[`status`]],
      [#par(justify: false)[`TenantStatus`]],
      [#par(justify: false)[Stato corrente del tenant]],

      [#par(justify: false)[`suspensionIntervalDays`]],
      [#par(justify: false)[`number | null`]],
      [#par(justify: false)[Giorni di sospensione]],

      [#par(justify: false)[`suspensionUntil`]],
      [#par(justify: false)[`Date | null`]],
      [#par(justify: false)[Data di sospensione programmata]],

      [#par(justify: false)[`createdAt`]],
      [#par(justify: false)[`Date`]],
      [#par(justify: false)[Timestamp di creazione del record]],

      [#par(justify: false)[`updatedAt`]],
      [#par(justify: false)[`Date`]],
      [#par(justify: false)[Timestamp dell'ultimo aggiornamento]],
    )
  ]

  Relazioni: OneToMany con `UserEntity` (tramite `tenantId`), OneToMany con `GatewayEntity` (tramite `tenantId`).

  _UserEntity_ (schema `users`)

  #figure(caption: [Campi del UserEntity])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`id`]],
      [#par(justify: false)[`uuid`]],
      [#par(justify: false)[Identificativo univoco dell'utente]],

      [#par(justify: false)[`tenantId`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[FK verso `TenantEntity.id`]],

      [#par(justify: false)[`username`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Username dell'utente]],

      [#par(justify: false)[`email`]], [#par(justify: false)[`string`]], [#par(justify: false)[Email dell'utente]],
      [#par(justify: false)[`role`]],
      [#par(justify: false)[`UsersRole`]],
      [#par(justify: false)[Ruolo dell'utente nel sistema]],

      [#par(justify: false)[`permissions`]],
      [#par(justify: false)[`string[] | null`]],
      [#par(justify: false)[Permessi specifici aggiuntivi]],

      [#par(justify: false)[`lastAccess`]],
      [#par(justify: false)[`Date | null`]],
      [#par(justify: false)[Timestamp dell'ultimo accesso]],

      [#par(justify: false)[`createdAt`]],
      [#par(justify: false)[`Date`]],
      [#par(justify: false)[Timestamp di creazione del record]],
    )
  ]

  ==== Admin Gateways
  #figure(caption: "Diagramma del modulo Admin Gateways")[#image("assets/03-admin-gateways.svg", width: 110%)]

  Il sottosistema di gestione dei Gateway amministrativi si occupa della registrazione e consultazione dei gateway
  associati ai tenant. Espone endpoint per elencare tutti i gateway (con filtro opzionale per tenant) e per registrare
  nuovi gateway a partire da un factory ID e una chiave di provisioning.

  ===== GatewaysController

  Controller NestJS esposto sotto il prefisso `/admin/gateways`. Protetto dal decoratore `@AdminOnly()`, espone due
  endpoint REST. Delega ogni operazione a `GatewaysService` e utilizza `GatewaysMapper` per trasformare i risultati nei
  DTO di risposta appropriati.

  #figure(caption: [Campi del GatewaysController])[
    #table(
      columns: (2.4fr, 2fr, 3fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Endpoint]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getAdminGateways(tenantId?)`]],
      [#par(justify: false)[`GET /admin/gateways`]],
      [#par(justify: false)[Restituisce la lista di tutti i gateway, con filtro opzionale per tenantId]],

      [#par(justify: false)[`addGateway(input)`]],
      [#par(justify: false)[`POST /admin/gateways`]],
      [#par(justify: false)[Registra un nuovo gateway per un tenant a partire da factoryId, tenantId, factoryKey e
        model]],
    )
  ]

  ===== GatewaysService

  Contiene la logica di business principale. Coordina `GatewaysPersistenceService` e utilizza il mapper per convertire
  tra DTO e modelli di dominio.

  _Campi:_

  #figure(caption: [Campi del GatewaysService])[
    #table(
      columns: (2fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`gatewaysPersistenceService`]],
      [#par(justify: false)[`GatewaysPersistenceService`]],
      [#par(justify: false)[Iniettato via constructor]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici del GatewaysService])[
    #table(
      columns: (1.5fr, 2.8fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getGateways(input)`]],
      [#par(justify: false)[`(input: GetGatewaysInput): Promise<GatewayModel[]>`]],
      [#par(justify: false)[Recupera tutti i gateway dal database; se `tenantId` è fornito, filtra per tenant]],

      [#par(justify: false)[`addGateway(input)`]],
      [#par(justify: false)[`(input: AddGatewayInput): Promise<GatewayModel>`]],
      [#par(justify: false)[Registra un nuovo gateway: hash della factoryKey con bcrypt, crea l'entità nel database con
        metadata di default]],
    )
  ]

  ===== GatewaysPersistenceService

  Layer di accesso ai dati. Utilizza due repository separati gestiti tramite TypeORM: `gatewayRepo` per `GatewayEntity`
  e `metadataRepo` per `GatewayMetadataEntity`. Supporta le transazioni tramite `DataSource`.

  _Campi:_

  #figure(caption: [Campi del GatewaysPersistenceService])[
    #table(
      columns: (1.5fr, 2.5fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`gatewayRepo`]],
      [#par(justify: false)[`Repository<GatewayEntity>`]],
      [#par(justify: false)[Repository TypeORM, schema `gateways`]],

      [#par(justify: false)[`metadataRepo`]],
      [#par(justify: false)[`Repository<GatewayMetadataEntity>`]],
      [#par(justify: false)[Repository TypeORM, schema `gateways`]],

      [#par(justify: false)[`dataSource`]],
      [#par(justify: false)[`DataSource`]],
      [#par(justify: false)[Iniettato per supporto transazioni]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici del GatewaysPersistenceService])[
    #table(
      columns: (1.4fr, 3.3fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getGateways(input)`]],
      [#par(justify: false)[`(input: GetGatewaysInput): Promise<GatewayEntity[]>`]],
      [#par(justify: false)[Recupera tutti i gateway; se `tenantId` è fornito, filtra con clausola WHERE]],

      [#par(justify: false)[`addGateway(input)`]],
      [#par(justify: false)[`(input: AddGatewayPersistenceInput): Promise<GatewayEntity>`]],
      [#par(justify: false)[Crea il gateway e il relativo metadata in modo transazionale]],
    )
  ]

  ===== GatewaysMapper

  Classe con metodi statici per la conversione tra i layer. Non ha dipendenze iniettate.

  _Metodi statici_:

  #figure(caption: [Metodi statici del GatewaysMapper])[
    #table(
      columns: (1.9fr, 3.5fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`toModel(entity)`]],
      [#par(justify: false)[Converte `GatewayEntity` in `GatewayModel`: mappa i campi uno-a-uno]],

      [#par(justify: false)[`toResponseDto(model)`]],
      [#par(justify: false)[Converte `GatewayModel` in `GatewayResponseDto`: adatta i nomi per la risposta HTTP]],

      [#par(justify: false)[`toAddGatewayInput(dto)`]],
      [#par(justify: false)[Converte `AddGatewayRequestDto` in `AddGatewayInput`: hash della factoryKey con bcrypt]],

      [#par(justify: false)[`toAddGatewayResponseDto(model)`]],
      [#par(justify: false)[Converte `GatewayModel` in `AddGatewayResponseDto`: restituisce solo l'`id`]],
    )
  ]

  ===== DTO e Input

  _AddGatewayRequestDto_

  #figure(caption: [Campi dell'AddGatewayRequestDto])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`factoryId`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Identificativo del factory di produzione]],

      [#par(justify: false)[`tenantId`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Identificativo del tenant proprietario]],

      [#par(justify: false)[`factoryKey`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Chiave di provisioning del gateway]],

      [#par(justify: false)[`model`]], [#par(justify: false)[`string`]], [#par(justify: false)[Modello del gateway]],
    )
  ]

  _AddGatewayResponseDto_

  #figure(caption: [Campi dell'AddGatewayResponseDto])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`id`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Identificativo univoco del gateway creato]],
    )
  ]

  _GatewayResponseDto_

  #figure(caption: [Campi del GatewayResponseDto])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`id`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Identificativo univoco del gateway]],

      [#par(justify: false)[`tenantId`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Identificativo del tenant proprietario]],

      [#par(justify: false)[`factoryId`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Identificativo del factory di produzione]],

      [#par(justify: false)[`model`]], [#par(justify: false)[`string`]], [#par(justify: false)[Modello del gateway]],
      [#par(justify: false)[`provisioned`]],
      [#par(justify: false)[`boolean`]],
      [#par(justify: false)[Indica se il gateway è stato provisionato]],

      [#par(justify: false)[`firmwareVersion`]],
      [#par(justify: false)[`string | undefined`]],
      [#par(justify: false)[Versione del firmware installato]],

      [#par(justify: false)[`createdAt`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Data di creazione in formato ISO 8601]],
    )
  ]

  _GetGatewaysInput_

  #figure(caption: [Campi del GetGatewaysInput])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`tenantId`]],
      [#par(justify: false)[`string | undefined`]],
      [#par(justify: false)[Filtro opzionale per tenant]],
    )
  ]

  _AddGatewayInput_

  #figure(caption: [Campi dell'AddGatewayInput])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`factoryId`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Identificativo del factory di produzione]],

      [#par(justify: false)[`tenantId`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Identificativo del tenant proprietario]],

      [#par(justify: false)[`factoryKey`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Chiave di provisioning (in chiaro, verrà hashata)]],

      [#par(justify: false)[`model`]], [#par(justify: false)[`string`]], [#par(justify: false)[Modello del gateway]],
      [#par(justify: false)[`firmwareVersion`]],
      [#par(justify: false)[`string | undefined`]],
      [#par(justify: false)[Versione del firmware (opzionale)]],
    )
  ]

  _AddGatewayPersistenceInput_

  #figure(caption: [Campi dell'AddGatewayPersistenceInput])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`factoryId`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Identificativo del factory di produzione]],

      [#par(justify: false)[`tenantId`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Identificativo del tenant proprietario]],

      [#par(justify: false)[`factoryKeyHash`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Hash bcrypt della factoryKey]],

      [#par(justify: false)[`model`]], [#par(justify: false)[`string`]], [#par(justify: false)[Modello del gateway]],
      [#par(justify: false)[`firmwareVersion`]],
      [#par(justify: false)[`string | undefined`]],
      [#par(justify: false)[Versione del firmware (opzionale)]],
    )
  ]

  ===== Enum

  _GatewayStatus_

  #figure(caption: [Valori dell'enum GatewayStatus])[
    #table(
      columns: (1.5fr, 4fr),
      [#par(justify: false)[Valore]], [#par(justify: false)[Descrizione]],
      [#par(justify: false)[`GATEWAY_ONLINE`]], [#par(justify: false)[Gateway attivo e comunicante]],
      [#par(justify: false)[`GATEWAY_OFFLINE`]], [#par(justify: false)[Gateway non raggiungibile]],
      [#par(justify: false)[`GATEWAY_SUSPENDED`]],
      [#par(justify: false)[Gateway sospeso manualmente o automaticamente]],
    )
  ]

  ===== Entità

  _GatewayEntity_ (schema `gateways`)

  #figure(caption: [Campi dell'GatewayEntity])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`id`]],
      [#par(justify: false)[`uuid v4`]],
      [#par(justify: false)[Identificativo univoco generato automaticamente]],

      [#par(justify: false)[`tenantId`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[FK verso `TenantEntity.id`]],

      [#par(justify: false)[`factoryId`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Identificativo del factory di produzione]],

      [#par(justify: false)[`factoryKeyHash`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Hash bcrypt della chiave di provisioning; `select: false` per sicurezza]],

      [#par(justify: false)[`provisioned`]],
      [#par(justify: false)[`boolean`]],
      [#par(justify: false)[Indica se il gateway è stato provisionato]],

      [#par(justify: false)[`model`]], [#par(justify: false)[`string`]], [#par(justify: false)[Modello del gateway]],
      [#par(justify: false)[`firmwareVersion`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Versione del firmware installato]],

      [#par(justify: false)[`createdAt`]],
      [#par(justify: false)[`Date`]],
      [#par(justify: false)[Timestamp di creazione del record]],

      [#par(justify: false)[`updatedAt`]],
      [#par(justify: false)[`Date`]],
      [#par(justify: false)[Timestamp dell'ultimo aggiornamento]],
    )
  ]

  Relazioni: ManyToOne con `TenantEntity` (tramite `tenantId`, cascade delete), OneToOne con `GatewayMetadataEntity`
  (cascade).

  _GatewayMetadataEntity_ (schema `gateways`)

  #figure(caption: [Campi del GatewayMetadataEntity])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`gatewayId`]],
      [#par(justify: false)[`uuid`]],
      [#par(justify: false)[FK verso `GatewayEntity.id`, chiave primaria]],

      [#par(justify: false)[`name`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Nome descrittivo del gateway; offuscato alla vista dell'admin]],

      [#par(justify: false)[`status`]],
      [#par(justify: false)[`GatewayStatus`]],
      [#par(justify: false)[Stato corrente del gateway]],

      [#par(justify: false)[`lastSeenAt`]],
      [#par(justify: false)[`Date`]],
      [#par(justify: false)[Timestamp dell'ultima comunicazione ricevuta]],

      [#par(justify: false)[`sendFrequencyMs`]],
      [#par(justify: false)[`number`]],
      [#par(justify: false)[Frequenza di invio dati in millisecondi; default: 30000]],
    )
  ]
  #pagebreak()
  === AuthModule
  #figure(caption: "Diagramma del modulo Auth")[#image("assets/05-auth.png", width: 110%)]

  Il modulo di autenticazione gestisce la validazione JWT tramite Keycloak, il controllo degli accessi basato sui ruoli,
  la politica di accesso per endpoint e il meccanismo di impersonificazione utente.

  ==== AuthController

  Controller NestJS esposto sotto il prefisso `/auth`. Espone endpoint per consultare i dati dell'utente autenticato,
  verificare lo stato del tenant e generare token di impersonificazione.

  #figure(caption: [Endpoint dell'AuthController])[
    #table(
      columns: (1.8fr, 2.5fr, 2.3fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Endpoint]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getMe(req)`]],
      [#par(justify: false)[`GET /auth/me`]],
      [#par(justify: false)[Restituisce i dati dell'utente autenticato come `AuthenticatedUser`; include informazioni su
        actor ed effective user]],

      [#par(justify: false)[`getTenantStatus(req)`]],
      [#par(justify: false)[`GET /auth/tenant-status`]],
      [#par(justify: false)[Restituisce lo stato del tenant corrente; riattiva automaticamente le sospensioni scadute]],

      [#par(justify: false)[`impersonate(body, req)`]],
      [#par(justify: false)[`POST /auth/impersonate`]],
      [#par(justify: false)[Genera un token di impersonificazione per un utente target; riservato ai `SYSTEM_ADMIN`;
        protetto da
        `@AdminOnly()`]],
    )
  ]

  _Metodi privati:_

  #figure(caption: [Metodi privati dell'AuthController])[
    #table(
      columns: (2.3fr, 3.5fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`isSuspensionExpired(tenant)`]],
      [#par(justify: false)[Verifica se `status === SUSPENDED` e `suspensionUntil` è nel passato]],

      [#par(justify: false)[`reactivateTenantIfExpired(tenant)`]],
      [#par(justify: false)[Se la sospensione è scaduta: imposta `status = ACTIVE`, `suspensionIntervalDays = null`,
        `suspensionUntil = null`]],
    )
  ]

  ==== ImpersonationService

  Servizio per il token exchange con Keycloak. Consente a un amministratore di sistema di ottenere un token JWT per
  impersonare un altro utente.

  _Campi:_

  #figure(caption: [Campi dell'ImpersonationService])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`config`]],
      [#par(justify: false)[`ConfigService`]],
      [#par(justify: false)[Iniettato; fornisce credenziali Keycloak]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici dell'ImpersonationService])[
    #table(
      columns: (1.5fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`impersonateUser(...)`]],
      [#par(justify: false)[`({ adminAccessToken, targetUserId }): Promise<{ access_token, expires_in }>`]],
      [#par(justify: false)[Esegue token exchange OAuth 2.0 con Keycloak;
        `grant_type: urn:ietf:params:oauth:grant-type:token-exchange`]],
    )
  ]

  ==== JwtStrategy

  Strategia Passport per la validazione JWT. Verifica i token JWT provenienti da Keycloak tramite JWKS.

  _Campi:_

  #figure(caption: [Campi del JwtStrategy])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`configService`]],
      [#par(justify: false)[`ConfigService`]],
      [#par(justify: false)[Iniettato; fornisce URL, realm, issuer, client ID]],

      [#par(justify: false)[`managementClientId`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Memorizzato per il matching dell'audience]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici del JwtStrategy])[
    #table(
      columns: (1.5fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`validate(payload)`]],
      [#par(justify: false)[`(payload: JwtClaims): AuthenticatedUser`]],
      [#par(justify: false)[Estrae ruolo, tenant, informazioni di impersonazione dal payload JWT; costruisce
        `AuthenticatedUser`]],
    )
  ]

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

  #figure(caption: [Campi dell'AuthenticatedUser])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`actorUserId`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[ID dell'utente che sta agendo (impersonante)]],

      [#par(justify: false)[`actorEmail`]],
      [#par(justify: false)[`string | undefined`]],
      [#par(justify: false)[Email dell'attore]],

      [#par(justify: false)[`actorName`]],
      [#par(justify: false)[`string | undefined`]],
      [#par(justify: false)[Nome dell'attore]],

      [#par(justify: false)[`actorRole`]],
      [#par(justify: false)[`UsersRole`]],
      [#par(justify: false)[Ruolo dell'attore]],

      [#par(justify: false)[`actorTenantId`]],
      [#par(justify: false)[`string | undefined`]],
      [#par(justify: false)[Tenant ID dell'attore]],

      [#par(justify: false)[`effectiveUserId`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[ID dell'utente target (effettivo)]],

      [#par(justify: false)[`effectiveEmail`]],
      [#par(justify: false)[`string | undefined`]],
      [#par(justify: false)[Email dell'utente effettivo]],

      [#par(justify: false)[`effectiveName`]],
      [#par(justify: false)[`string | undefined`]],
      [#par(justify: false)[Nome dell'utente effettivo]],

      [#par(justify: false)[`effectiveRole`]],
      [#par(justify: false)[`UsersRole`]],
      [#par(justify: false)[Ruolo dell'utente effettivo]],

      [#par(justify: false)[`effectiveTenantId`]],
      [#par(justify: false)[`string | undefined`]],
      [#par(justify: false)[Tenant ID dell'utente effettivo]],

      [#par(justify: false)[`isImpersonating`]],
      [#par(justify: false)[`boolean`]],
      [#par(justify: false)[Indica se è attiva l'impersonificazione]],
    )
  ]

  === KeysModule
  #figure(caption: "Diagramma del modulo KeysModule")[#image("assets/09-keys.svg", width: 110%)]

  Il modulo di gestione delle chiavi gestisce il provisioning delle chiavi AES-256 per i gateway, la validazione delle
  chiavi di fabbrica e il completamento del provisioning. Implementa crittografia trasparente a livello di persistenza.

  ==== KeysController

  Controller NestJS esposto sotto il prefisso `/keys`. Protetto da `@TenantScoped()` e `@BlockImpersonation()`.

  #figure(caption: [Endpoint del KeysController])[
    #table(
      columns: (1.2fr, 2.5fr, 2.3fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Endpoint]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getKeys(tenantId, id)`]],
      [#par(justify: false)[`GET /keys?id=<gatewayId>`]],
      [#par(justify: false)[Restituisce tutte le chiavi per un gateway specifico; richiede `tenantId` dal contesto]],
    )
  ]

  ==== ProvisioningController

  Controller pubblico per il provisioning interno. Protetto da `@Public()`.

  #figure(caption: [Endpoint del ProvisioningController])[
    #table(
      columns: (1.2fr, 2.5fr, 2.3fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Endpoint]], [#par(justify: false)[Note]],
      [#par(justify: false)[`validate(dto)`]],
      [#par(justify: false)[`POST /internal/provisioning/validate`]],
      [#par(justify: false)[Valida una chiave di fabbrica; restituisce `gateway_id` e `tenant_id` se valida]],

      [#par(justify: false)[`complete(dto)`]],
      [#par(justify: false)[`POST /internal/provisioning/complete`]],
      [#par(justify: false)[Completa il provisioning con materiale crittografico; restituisce `{ success: true }`]],
    )
  ]

  ==== KeysService

  Contiene la logica di business principale. Coordina `GatewaysKeysPersistenceService`, `GatewaysService` e
  `DataSource`.

  _Campi:_

  #figure(caption: [Campi del KeysService])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`gkp`]],
      [#par(justify: false)[`GatewaysKeysPersistenceService`]],
      [#par(justify: false)[Iniettato via constructor]],

      [#par(justify: false)[`gs`]],
      [#par(justify: false)[`GatewaysService`]],
      [#par(justify: false)[Iniettato via constructor]],

      [#par(justify: false)[`dataSource`]],
      [#par(justify: false)[`DataSource`]],
      [#par(justify: false)[Iniettato per supporto transazioni]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici del KeysService])[
    #table(
      columns: (2.3fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getKeys(id, tenantId?)`]],
      [#par(justify: false)[`(id: string, tenantId?): Promise<KeyModel[]>`]],
      [#par(justify: false)[Verifica ownership del gateway; solleva `ForbiddenException` se tenantId non corrisponde;
        restituisce le chiavi]],

      [#par(justify: false)[`saveKeys(id, keyMaterial, keyVersion)`]],
      [#par(justify: false)[`(id, keyMaterial, keyVersion): Promise<KeyModel>`]],
      [#par(justify: false)[Persiste una nuova chiave per il gateway]],

      [#par(justify: false)[`validateFactoryKey(factoryId, factoryKey)`]],
      [#par(justify: false)[`(factoryId, factoryKey): Promise<{ gatewayId, tenantId }>`]],
      [#par(justify: false)[Cerca gateway per factoryId; verifica hash con bcrypt; solleva `UnauthorizedException` o
        `ConflictException`]],

      [#par(justify: false)[`completeProvisioning(...)`]],
      [#par(justify: false)[`(gatewayId, keyMaterial, keyVersion, sendFrequencyMs, firmwareVersion?): Promise<void>`]],
      [#par(justify: false)[Transazione: crea KeyEntity, aggiorna GatewayMetadata, imposta provisioned=true,
        factoryKeyHash=null]],

      [#par(justify: false)[`provisionGateway(...)`]],
      [#par(justify: false)[`(factoryId, factoryKey, keyMaterial, firmwareVersion, model): Promise<void>`]],
      [#par(justify: false)[Valida factory key, calcola nextVersion, salva nuova KeyEntity, aggiorna gateway]],
    )
  ]

  ==== GatewaysKeysPersistenceService

  Layer di accesso ai dati per le chiavi.

  _Campi:_

  #figure(caption: [Campi del GatewaysKeysPersistenceService])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`repository`]],
      [#par(justify: false)[`Repository<KeyEntity>`]],
      [#par(justify: false)[Repository TypeORM iniettato]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici del GatewaysKeysPersistenceService])[
    #table(
      columns: (1.5fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getKeys(id)`]],
      [#par(justify: false)[`(id: string): Promise<KeyEntity[]>`]],
      [#par(justify: false)[Trova tutte le chiavi per `gatewayId`]],

      [#par(justify: false)[`saveKeys(id, keyMaterial, keyVersion)`]],
      [#par(justify: false)[`(id, keyMaterial, keyVersion): Promise<KeyEntity>`]],
      [#par(justify: false)[Crea e salva una nuova `KeyEntity`]],
    )
  ]

  ==== Crittografia del Materiale Chiave

  Il file `key-material-encryption.ts` fornisce crittografia AES-256-GCM trasparente per la colonna `keyMaterial` di
  `KeyEntity` tramite un `ValueTransformer` TypeORM.

  _Costanti:_

  #figure(caption: [Costanti della crittografia])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Costante]], [#par(justify: false)[Tipo]], [#par(justify: false)[Valore]],
      [#par(justify: false)[`ENCRYPTION_PREFIX`]],
      [#par(justify: false)[`Buffer`]],
      [#par(justify: false)[`Buffer.from('enc:v1:')` — 7 byte]],

      [#par(justify: false)[`IV_LENGTH`]], [#par(justify: false)[`number`]], [#par(justify: false)[12 byte]],
      [#par(justify: false)[`AUTH_TAG_LENGTH`]], [#par(justify: false)[`number`]], [#par(justify: false)[16 byte]],
      [#par(justify: false)[`AES_256_KEY_LENGTH`]], [#par(justify: false)[`number`]], [#par(justify: false)[32 byte]],
    )
  ]

  _Funzioni esportate:_

  #figure(caption: [Funzioni della crittografia])[
    #table(
      columns: (2fr, 2.5fr, 2fr),
      [#par(justify: false)[Funzione]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`encryptKeyMaterial(value)`]],
      [#par(justify: false)[`(value: Buffer): Buffer`]],
      [#par(justify: false)[Genera IV casuale, cifra con AES-256-GCM, restituisce
        `[prefix | IV | authTag | encrypted]`]],

      [#par(justify: false)[`decryptKeyMaterial(value)`]],
      [#par(justify: false)[`(value: Buffer): Buffer`]],
      [#par(justify: false)[Se inizia con prefix: estrae IV, authTag, decripta. Altrimenti (legacy): restituisce
        unchanged]],
    )
  ]

  _keyMaterialTransformer_ — Oggetto `ValueTransformer` TypeORM con metodi `to` (cripta in scrittura) e `from` (decripta
  in lettura). Applicato alla colonna `keyMaterial` di `KeyEntity`.

  _Funzioni helper (non esportate):_

  #figure(caption: [Funzioni helper (non esportate)])[
    #table(
      columns: (1.5fr, 3.5fr),
      [#par(justify: false)[Funzione]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`normalizeKey(rawKey)`]],
      [#par(justify: false)[Normalizza la chiave di crittografia da `DB_ENCRYPTION_KEY`: accetta hex (64 char), base64,
        o UTF-8 (32 byte)]],

      [#par(justify: false)[`getEncryptionKey()`]],
      [#par(justify: false)[Legge `DB_ENCRYPTION_KEY` dall'env e chiama `normalizeKey()` per produrre il buffer a 32
        byte]],
    )
  ]

  ==== DTO e Input

  _ValidateFactoryKeyRequestDto_ — `factory_id: string`, `factory_key: string`.

  _ValidateFactoryKeyResponseDto_ — `gateway_id: string`, `tenant_id: string`.

  _ProvisioningCompleteRequestDto_ — `gateway_id: string`, `key_material: string`, `key_version: number`,
  `send_frequency_ms: number`, `firmware_version?: string`.

  _ProvisioningCompleteResponseDto_ — `success: boolean`.

  _KeysResponseDto_ — `gateway_id: string`, `key_material: string` (base64), `key_version: number`.

  ==== Entità

  _KeyEntity_ (tabella `keys`)

  #figure(caption: [Campi della KeyEntity])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`id`]],
      [#par(justify: false)[`uuid v4`]],
      [#par(justify: false)[Identificativo univoco generato automaticamente]],

      [#par(justify: false)[`gatewayId`]],
      [#par(justify: false)[`uuid`]],
      [#par(justify: false)[FK verso `GatewayEntity.id`; cascade delete]],

      [#par(justify: false)[`keyMaterial`]],
      [#par(justify: false)[`Buffer`]],
      [#par(justify: false)[Materiale crittografato con AES-256-GCM; trasformatore automatico]],

      [#par(justify: false)[`keyVersion`]],
      [#par(justify: false)[`number`]],
      [#par(justify: false)[Versione della chiave]],

      [#par(justify: false)[`createdAt`]],
      [#par(justify: false)[`Date`]],
      [#par(justify: false)[Timestamp di creazione]],

      [#par(justify: false)[`revokedAt`]],
      [#par(justify: false)[`Date | null`]],
      [#par(justify: false)[Timestamp di revoca (opzionale)]],
    )
  ]

  === UsersModule
  #figure(caption: "Diagramma del modulo UsersModule")[#image("assets/12-users.svg", width: 110%)]

  Il modulo di gestione degli utenti gestisce le operazioni CRUD sugli utenti del tenant, inclusa la sincronizzazione
  con Keycloak per la creazione, l'aggiornamento dei ruoli e l'eliminazione.

  ==== UsersController

  Controller NestJS esposto sotto il prefisso `/users`. Protetto da `@TenantScoped()`. Tutti gli endpoint richiedono
  `TENANT_ADMIN`.

  #figure(caption: [Endpoint dello UsersController])[
    #table(
      columns: (1.8fr, 2.5fr, 2.3fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Endpoint]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getUsers(tenantId)`]],
      [#par(justify: false)[`GET /users`]],
      [#par(justify: false)[Restituisce la lista di tutti gli utenti del tenant]],

      [#par(justify: false)[`getUserById(tenantId, id)`]],
      [#par(justify: false)[`GET /users/:id`]],
      [#par(justify: false)[Restituisce il dettaglio di un singolo utente]],

      [#par(justify: false)[`createUser(tenantId, dto)`]],
      [#par(justify: false)[`POST /users`]],
      [#par(justify: false)[Crea un nuovo utente; protetto da `@Audit` e `@Roles(TENANT_ADMIN)`]],

      [#par(justify: false)[`updateUser(tenantId, id, dto)`]],
      [#par(justify: false)[`PATCH /users/:id`]],
      [#par(justify: false)[Aggiorna un utente esistente; sincronizza ruolo e dati con Keycloak]],

      [#par(justify: false)[`deleteUsers(tenantId, requesterId, requesterRole, dto)`]],
      [#par(justify: false)[`POST /users/bulk-delete`]],
      [#par(justify: false)[Eliminazione bulk di utenti; previene auto-eliminazione e protezione TENANT_ADMIN]],
    )
  ]

  ==== UsersService

  Contiene la logica di business. Coordina `UsersPersistenceService` e `KeycloakAdminService`.

  _Campi:_

  #figure(caption: [Campi dello UsersService])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`ps`]],
      [#par(justify: false)[`UsersPersistenceService`]],
      [#par(justify: false)[Iniettato via constructor]],

      [#par(justify: false)[`keycloakAdminService`]],
      [#par(justify: false)[`KeycloakAdminService`]],
      [#par(justify: false)[Iniettato via constructor]],

      [#par(justify: false)[`logger`]], [#par(justify: false)[`Logger`]], [#par(justify: false)[Logger interno]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici dello UsersService])[
    #table(
      columns: (1.5fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getUsers(input)`]],
      [#par(justify: false)[`(input: GetUsersInput): Promise<UserModel[]>`]],
      [#par(justify: false)[Recupera gli utenti del tenant; solleva `NotFoundException` se la lista è vuota]],

      [#par(justify: false)[`createUser(input)`]],
      [#par(justify: false)[`(input: CreateUserInput): Promise<UserModel>`]],
      [#par(justify: false)[Blocca `SYSTEM_ADMIN`; crea utente su Keycloak; salva nel DB; rollback Keycloak se il DB
        fallisce]],

      [#par(justify: false)[`updateUser(input)`]],
      [#par(justify: false)[`(input: UpdateUserInput): Promise<UserModel>`]],
      [#par(justify: false)[Blocca `SYSTEM_ADMIN`; aggiorna DB; sincronizza ruolo e dati con Keycloak se cambiati]],

      [#par(justify: false)[`deleteUsers(input)`]],
      [#par(justify: false)[`(input: DeleteUsersInput): Promise<number>`]],
      [#par(justify: false)[Filtra auto-eliminazione; blocca eliminazione TENANT_ADMIN da non-SYSTEM_ADMIN; cancella da
        Keycloak e DB]],
    )
  ]

  _Metodi privati:_

  #figure(caption: [Metodi privati del UsersService])[
    #table(
      columns: (1.6fr, 3.5fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`normalizeUsername(username)`]],
      [#par(justify: false)[Trim, lowercase, capitalizza prima lettera; restituisce stringa vuota se risultato vuoto]],
    )
  ]

  ==== UsersPersistenceService

  Layer di accesso ai dati per gli utenti.

  _Campi:_

  #figure(caption: [Campi dello UsersPersistenceService])[
    #table(
      columns: (1.8fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`repository`]],
      [#par(justify: false)[`Repository<UserEntity>`]],
      [#par(justify: false)[Repository TypeORM iniettato]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici dello UsersPersistenceService])[
    #table(
      columns: (1.8fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getUsers(tenantId)`]],
      [#par(justify: false)[`(tenantId: string): Promise<UserEntity[]>`]],
      [#par(justify: false)[Trova tutti gli utenti per `tenantId`]],

      [#par(justify: false)[`getTenantAdmins(tenantId)`]],
      [#par(justify: false)[`(tenantId: string): Promise<UserEntity[]>`]],
      [#par(justify: false)[Trova gli amministratori del tenant]],

      [#par(justify: false)[`createUser(input)`]],
      [#par(justify: false)[`(input): Promise<UserEntity>`]],
      [#par(justify: false)[Crea e salva un nuovo `UserEntity`]],

      [#par(justify: false)[`updateUser(input)`]],
      [#par(justify: false)[`(input): Promise<UserEntity | null>`]],
      [#par(justify: false)[Trova per `id + tenantId`; aggiorna solo i campi forniti; restituisce `null` se non
        trovato]],

      [#par(justify: false)[`getUsersByIds(ids, tenantId)`]],
      [#par(justify: false)[`(ids, tenantId): Promise<UserEntity[]>`]],
      [#par(justify: false)[Trova utenti per lista di ID con clausola `In(ids)`]],

      [#par(justify: false)[`touchLastAccess(userId, timestamp?)`]],
      [#par(justify: false)[`(userId, timestamp?): Promise<void>`]],
      [#par(justify: false)[Aggiorna `lastAccess` al timestamp corrente o fornito]],

      [#par(justify: false)[`deleteUsersByIds(ids, tenantId)`]],
      [#par(justify: false)[`(ids, tenantId): Promise<number>`]],
      [#par(justify: false)[Elimina utenti per lista di ID; restituisce il numero di righe eliminate]],
    )
  ]

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

  #figure(caption: [Campi della UserEntity])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`id`]], [#par(justify: false)[`uuid`]], [#par(justify: false)[Chiave primaria]],
      [#par(justify: false)[`tenantId`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[FK verso `TenantEntity.id`; cascade delete]],

      [#par(justify: false)[`username`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Username dell'utente]],

      [#par(justify: false)[`email`]], [#par(justify: false)[`string`]], [#par(justify: false)[Email dell'utente]],
      [#par(justify: false)[`role`]],
      [#par(justify: false)[`UsersRole`]],
      [#par(justify: false)[Ruolo; default: `TENANT_USER`]],

      [#par(justify: false)[`permissions`]],
      [#par(justify: false)[`string[] | null`]],
      [#par(justify: false)[Permessi specifici in formato JSONB]],

      [#par(justify: false)[`lastAccess`]],
      [#par(justify: false)[`Date | null`]],
      [#par(justify: false)[Ultimo accesso]],

      [#par(justify: false)[`createdAt`]],
      [#par(justify: false)[`Date`]],
      [#par(justify: false)[Timestamp di creazione]],
    )
  ]

  Relazione: ManyToOne con `TenantEntity` (tramite `tenantId`, cascade delete).

  === AlertsModule
  #figure(caption: "Diagramma del modulo AlertsModule")[#image("assets/04-alerts.svg", width: 110%)]

  Il modulo di gestione degli alert gestisce la configurazione dei timeout di irraggiungibilità dei gateway e la
  registrazione degli eventi di gateway offline. Supporta configurazioni di default per tenant e override per singolo
  gateway.

  ==== AlertsController

  Controller NestJS esposto sotto il prefisso `/alerts`. Protetto da `@TenantScoped()`.

  #figure(caption: [Endpoint dell'AlertsController])[
    #table(
      columns: (3fr, 2.5fr, 2.3fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Endpoint]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getAlerts(tenantId, from?, to?, gatewayId?)`]],
      [#par(justify: false)[`GET /alerts`]],
      [#par(justify: false)[Restituisce gli alert del tenant con filtri opzionali per data e gateway]],

      [#par(justify: false)[`getAlertsConfig(tenantId)`]],
      [#par(justify: false)[`GET /alerts/config`]],
      [#par(justify: false)[Restituisce la configurazione degli alert: timeout di default e override per gateway]],

      [#par(justify: false)[`setDefaultAlertsConfig(tenantId, dto)`]],
      [#par(justify: false)[`PUT /alerts/config/default`]],
      [#par(justify: false)[Imposta il timeout di default per il tenant; protetto da `@Audit` e
        `@Roles(TENANT_ADMIN)`]],

      [#par(justify: false)[`setGatewayAlertsConfig(tenantId, gatewayId, dto)`]],
      [#par(justify: false)[`PUT /alerts/config/gateway/:gatewayId`]],
      [#par(justify: false)[Imposta il timeout per un gateway specifico; protetto da `@Audit` e
        `@Roles(TENANT_ADMIN)`]],

      [#par(justify: false)[`deleteGatewayAlertsConfig(tenantId, gatewayId)`]],
      [#par(justify: false)[`DELETE /alerts/config/gateway/:gatewayId`]],
      [#par(justify: false)[Elimina la configurazione per un gateway; protetto da `@Audit` e `@Roles(TENANT_ADMIN)`]],
    )
  ]

  ==== AlertsService

  Contiene la logica di business. Coordina `AlertsPersistenceService` e `GatewaysService`.

  _Campi:_

  #figure(caption: [Campi dell'AlertsService])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`aps`]],
      [#par(justify: false)[`AlertsPersistenceService`]],
      [#par(justify: false)[Iniettato via constructor]],

      [#par(justify: false)[`gatewayService`]],
      [#par(justify: false)[`GatewaysService`]],
      [#par(justify: false)[Iniettato via constructor per validazione ownership]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici dell'AlertsService])[
    #table(
      columns: (2.8fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`setGatewayAlertsConfig(input)`]],
      [#par(justify: false)[`(input): Promise<AlertsConfigEntity>`]],
      [#par(justify: false)[Verifica ownership gateway; solleva `NotFoundException` o `ForbiddenException`; upsert della
        configurazione]],

      [#par(justify: false)[`deleteGatewayAlertsConfig(tenantId, gatewayId)`]],
      [#par(justify: false)[`(tenantId, gatewayId): Promise<void>`]],
      [#par(justify: false)[Verifica ownership; elimina configurazione; solleva `NotFoundException` se non eliminata]],

      [#par(justify: false)[`setDefaultAlertsConfig(input)`]],
      [#par(justify: false)[`(input): Promise<AlertsConfigEntity>`]],
      [#par(justify: false)[Imposta o aggiorna il timeout di default per il tenant]],

      [#par(justify: false)[`getAlertsConfig(input)`]],
      [#par(justify: false)[`(input): Promise<AlertsConfigModel>`]],
      [#par(justify: false)[Recupera tutte le configurazioni del tenant; mappa in modello con default + override]],

      [#par(justify: false)[`getAlerts(input)`]],
      [#par(justify: false)[`(input): Promise<AlertsModel[]>`]],
      [#par(justify: false)[Recupera gli alert con filtri opzionali per data e gateway]],
    )
  ]

  ==== AlertsPersistenceService

  Layer di accesso ai dati per alert e configurazioni.

  _Campi:_

  #figure(caption: [Campi dell'AlertsPersistenceService])[
    #table(
      columns: (1.9fr, 2.3fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`repository`]],
      [#par(justify: false)[`Repository<AlertsEntity>`]],
      [#par(justify: false)[Repository per gli alert]],

      [#par(justify: false)[`alertsConfigRepository`]],
      [#par(justify: false)[`Repository<AlertsConfigEntity>`]],
      [#par(justify: false)[Repository per le configurazioni]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici dell'AlertsPersistenceService])[
    #table(
      columns: (2.8fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`setGatewayAlertsConfig(input)`]],
      [#par(justify: false)[`(input): Promise<AlertsConfigEntity>`]],
      [#par(justify: false)[Upsert su `['tenantId', 'gatewayId']`; restituisce l'entità aggiornata]],

      [#par(justify: false)[`deleteGatewayAlertsConfig(tenantId, gatewayId)`]],
      [#par(justify: false)[`(tenantId, gatewayId): Promise<boolean>`]],
      [#par(justify: false)[Elimina configurazione; restituisce `true` se righe eliminate]],

      [#par(justify: false)[`setDefaultAlertsConfig(input)`]],
      [#par(justify: false)[`(input): Promise<AlertsConfigEntity>`]],
      [#par(justify: false)[Trova l'ultimo default esistente; aggiorna o crea nuovo; elimina duplicati stale]],

      [#par(justify: false)[`getAlertsConfig(tenantId)`]],
      [#par(justify: false)[`(tenantId): Promise<AlertsConfigEntity[]>`]],
      [#par(justify: false)[Trova tutte le configurazioni del tenant con relazione gateway]],

      [#par(justify: false)[`findAllAlertConfigs()`]],
      [#par(justify: false)[`(): Promise<AlertsConfigEntity[]>`]],
      [#par(justify: false)[Trova tutte le configurazioni (usato dal NATS responder)]],

      [#par(justify: false)[`getAlerts(input)`]],
      [#par(justify: false)[`(input): Promise<AlertsEntity[]>`]],
      [#par(justify: false)[Filtra per `tenantId`, `createdAt` (range), `gatewayId`; ordina per `createdAt DESC`]],

      [#par(justify: false)[`countAlerts(tenantId)`]],
      [#par(justify: false)[`(tenantId): Promise<number>`]],
      [#par(justify: false)[Conta gli alert per un tenant]],

      [#par(justify: false)[`saveAlert(alert)`]],
      [#par(justify: false)[`(alert): Promise<AlertsEntity>`]],
      [#par(justify: false)[Crea e salva un nuovo alert]],
    )
  ]

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

  #figure(caption: [Valori dell'enum AlertType])[
    #table(
      columns: (1.5fr, 4fr),
      [#par(justify: false)[Valore]], [#par(justify: false)[Descrizione]],
      [#par(justify: false)[`GATEWAY_OFFLINE`]],
      [#par(justify: false)[Gateway non raggiungibile entro il timeout configurato]],
    )
  ]

  ==== Entità

  _AlertsEntity_ (tabella `alerts`)

  #figure(caption: [Campi dell'AlertsEntity])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`id`]], [#par(justify: false)[`uuid v4`]], [#par(justify: false)[Identificativo univoco]],
      [#par(justify: false)[`tenantId`]], [#par(justify: false)[`uuid`]], [#par(justify: false)[FK verso il tenant]],
      [#par(justify: false)[`type`]],
      [#par(justify: false)[`AlertType`]],
      [#par(justify: false)[Tipo di alert; default: `GATEWAY_OFFLINE`]],

      [#par(justify: false)[`gatewayId`]],
      [#par(justify: false)[`uuid`]],
      [#par(justify: false)[ID del gateway che ha generato l'alert]],

      [#par(justify: false)[`details`]],
      [#par(justify: false)[`jsonb`]],
      [#par(justify: false)[Dettagli: `lastSeen`, `timeoutConfigured`]],

      [#par(justify: false)[`createdAt`]],
      [#par(justify: false)[`Date`]],
      [#par(justify: false)[Timestamp di creazione]],
    )
  ]

  _AlertsConfigEntity_ (tabella `alert_configs`)

  #figure(caption: [Campi dell'AlertsConfigEntity])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`id`]], [#par(justify: false)[`uuid v4`]], [#par(justify: false)[Identificativo univoco]],
      [#par(justify: false)[`tenantId`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[FK verso `TenantEntity`; cascade delete]],

      [#par(justify: false)[`gatewayId`]],
      [#par(justify: false)[`string | null`]],
      [#par(justify: false)[FK verso `GatewayEntity`; `null` = configurazione di default]],

      [#par(justify: false)[`gatewayTimeoutMs`]],
      [#par(justify: false)[`number`]],
      [#par(justify: false)[Timeout in millisecondi; default: 60000]],

      [#par(justify: false)[`updatedAt`]],
      [#par(justify: false)[`Date`]],
      [#par(justify: false)[Timestamp dell'ultimo aggiornamento]],
    )
  ]

  Indice composito unico su `['tenantId', 'gatewayId']`.

  === CommandModule
  #figure(caption: "Diagramma del modulo CommandModule")[#image("assets/06-command.svg", width: 110%)]

  Il modulo di gestione dei comandi gestisce l'invio di comandi ai gateway (configurazione e firmware) e il tracciamento
  dello stato attraverso ACK ricevuti via NATS JetStream.

  ==== CommandController

  Controller NestJS esposto sotto il prefisso `/cmd`. Protetto da `@TenantScoped()`.

  #figure(caption: [Endpoint del CommandController])[
    #table(
      columns: (1.8fr, 2.5fr, 2.3fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Endpoint]], [#par(justify: false)[Note]],
      [#par(justify: false)[`sendConfig(tenantId, gatewayId, dto)`]],
      [#par(justify: false)[`POST :gatewayId/config`]],
      [#par(justify: false)[Invia un comando di configurazione; protetto da `@Audit` e `@Roles(TENANT_ADMIN)`]],

      [#par(justify: false)[`sendFirmware(tenantId, gatewayId, dto)`]],
      [#par(justify: false)[`POST :gatewayId/firmware`]],
      [#par(justify: false)[Invia un comando di aggiornamento firmware; protetto da `@Audit` e `@Roles(TENANT_ADMIN)`]],

      [#par(justify: false)[`getStatus(tenantId, gatewayId, commandId)`]],
      [#par(justify: false)[`GET :gatewayId/status/:commandId`]],
      [#par(justify: false)[Restituisce lo stato di esecuzione di un comando]],
    )
  ]

  ==== CommandService

  Contiene la logica di business. Coordina `CommandPersistenceService`, `GatewaysService` e `JetStreamClient`.

  _Campi:_

  #figure(caption: [Campi del CommandService])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`cps`]],
      [#par(justify: false)[`CommandPersistenceService`]],
      [#par(justify: false)[Iniettato via constructor]],

      [#par(justify: false)[`gatewaysService`]],
      [#par(justify: false)[`GatewaysService`]],
      [#par(justify: false)[Iniettato per validazione ownership]],

      [#par(justify: false)[`jetStreamClient`]],
      [#par(justify: false)[`JetStreamClient`]],
      [#par(justify: false)[Iniettato per pubblicazione NATS]],

      [#par(justify: false)[`logger`]], [#par(justify: false)[`Logger`]], [#par(justify: false)[Logger interno]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici del CommandService])[
    #table(
      columns: (1.5fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`sendConfig(input)`]],
      [#par(justify: false)[`(input): Promise<CommandModel>`]],
      [#par(justify: false)[Valida input; verifica ownership; coda comando; pubblica su NATS
        `command.gw.<tenantId>.<gatewayId>`]],

      [#par(justify: false)[`sendFirmware(input)`]],
      [#par(justify: false)[`(input): Promise<CommandModel>`]],
      [#par(justify: false)[Verifica ownership; coda comando con tipo `FIRMWARE`; pubblica su NATS]],

      [#par(justify: false)[`getStatus(input)`]],
      [#par(justify: false)[`(input): Promise<CommandModel>`]],
      [#par(justify: false)[Trova comando per ID; solleva `NotFoundException` se non trovato]],
    )
  ]

  _Metodi privati:_

  #figure(caption: [Metodi privati del CommandService])[
    #table(
      columns: (2fr, 3.5fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`publishToNats(model, type, payload)`]],
      [#par(justify: false)[Costruisce subject `command.gw.<tenantId>.<gatewayId>`; pubblica JSON con `command_id`,
        `type`, `payload`, `issued_at`; non solleva errori in caso di fallimento]],

      [#par(justify: false)[`ensureGatewayOwnership(tenantId, gatewayId)`]],
      [#par(justify: false)[Delega a `gatewaysService.findById()`; solleva `NotFoundException` se il gateway non
        appartiene al tenant]],
    )
  ]

  ==== CommandsAckConsumer

  Consumer NATS JetStream per gli ACK. Si sottoscrive a `command.ack.>`. Aggiorna lo stato del comando nel database e,
  se lo stato è `ACK`, applica gli effetti del comando sull'entità gateway.

  _Metodi privati:_

  #figure(caption: [Metodi privati del CommandsAckConsumer])[
    #table(
      columns: (1.5fr, 3.5fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`processMessage(message)`]],
      [#par(justify: false)[Parsa payload; risolve commandId (supporta `command_id` e `commandId`); normalizza stato;
        valida timestamp; aggiorna stato; se ACK applica effetti; ack del messaggio]],

      [#par(justify: false)[`parsePayload(buffer)`]], [#par(justify: false)[Decodifica buffer UTF-8 e pars JSON]],

      [#par(justify: false)[`resolveCommandId(payload)`]],
      [#par(justify: false)[Controlla `command_id` poi `commandId`; restituisce primo valore valido o `null`]],

      [#par(justify: false)[`normalizeStatus(value)`]],
      [#par(justify: false)[Mappa stringa a `CommandStatus` enum tramite tabella di normalizzazione]],
    )
  ]

  ==== CommandWritingPersistenceService

  Servizio di scrittura per i comandi. Gestisce l'aggiornamento dello stato e l'applicazione degli effetti sui gateway.

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici del CommandWritingPersistenceService])[
    #table(
      columns: (2.5fr, 2.4fr, 2.2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`updateStatus(input)`]],
      [#par(justify: false)[`(input): Promise<CommandEntity | null>`]],
      [#par(justify: false)[Trova comando per ID; aggiorna `status` e `ackReceivedAt`; restituisce `null` se non
        trovato]],

      [#par(justify: false)[`applyAckedCommandEffects(command)`]],
      [#par(justify: false)[`(command): Promise<void>`]],
      [#par(justify: false)[Se `ACK` e tipo `CONFIG`: aggiorna `sendFrequencyMs` e/o `status` su gateway metadata. Se
        `FIRMWARE`: aggiorna `firmwareVersion` su gateway. Salva solo se ci sono modifiche]],
    )
  ]

  _Metodi privati:_

  #figure(caption: [Metodi privati del CommandWritingPersistenceService])[
    #table(
      columns: (1.9fr, 3.5fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`mapCommandGatewayStatus(status)`]],
      [#par(justify: false)[Mappa stringa a `GatewayStatus`: `online`/`gateway_online` → `GATEWAY_ONLINE`,
        `paused`/`suspended` → `GATEWAY_SUSPENDED`, `offline` → `GATEWAY_OFFLINE`]],
    )
  ]

  ==== CommandPersistenceService

  Layer di accesso ai dati per i comandi (read/create).

  _Metodi pubblici:_

  #figure(caption: [Metodi del CommandPersistenceService])[
    #table(
      columns: (1.8fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`queueCommand(input)`]],
      [#par(justify: false)[`(input): Promise<CommandEntity>`]],
      [#par(justify: false)[Crea e salva un nuovo `CommandEntity` con stato `QUEUED`]],

      [#par(justify: false)[`findCommand(input)`]],
      [#par(justify: false)[`(input): Promise<CommandEntity | null>`]],
      [#par(justify: false)[Trova comando per `id + tenantId + gatewayId`]],

      [#par(justify: false)[`countCommands(tenantId)`]],
      [#par(justify: false)[`(tenantId): Promise<number>`]],
      [#par(justify: false)[Conta i comandi per un tenant]],
    )
  ]

  ==== Enum

  _CommandStatus_

  #figure(caption: [Valori dell'enum CommandStatus])[
    #table(
      columns: (1.5fr, 4fr),
      [#par(justify: false)[Valore]], [#par(justify: false)[Descrizione]],
      [#par(justify: false)[`QUEUED`]], [#par(justify: false)[Comando accodato in attesa di invio]],
      [#par(justify: false)[`ACK`]], [#par(justify: false)[Comando confermato dal gateway]],
      [#par(justify: false)[`NACK`]], [#par(justify: false)[Comando negato dal gateway]],
      [#par(justify: false)[`EXPIRED`]], [#par(justify: false)[Comando scaduto]],
      [#par(justify: false)[`TIMEOUT`]], [#par(justify: false)[Timeout nella ricezione dell'ACK]],
    )
  ]

  _CommandType_

  #figure(caption: [Valori dell'enum CommandType])[
    #table(
      columns: (1.5fr, 4fr),
      [#par(justify: false)[Valore]], [#par(justify: false)[Descrizione]],
      [#par(justify: false)[`CONFIG`]],
      [#par(justify: false)[Aggiornamento configurazione: frequenza di invio, stato operativo]],

      [#par(justify: false)[`FIRMWARE`]], [#par(justify: false)[Aggiornamento firmware]],
      [#par(justify: false)[`SUSPEND`]], [#par(justify: false)[Sospensione del gateway]],
    )
  ]

  ==== Entità

  _CommandEntity_ (tabella `commands`)

  #figure(caption: [Campi del CommandEntity])[
    #table(
      columns: (1.8fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`id`]], [#par(justify: false)[`uuid v4`]], [#par(justify: false)[Identificativo univoco]],
      [#par(justify: false)[`gatewayId`]],
      [#par(justify: false)[`uuid`]],
      [#par(justify: false)[FK verso `GatewayEntity`; cascade delete]],

      [#par(justify: false)[`tenantId`]],
      [#par(justify: false)[`uuid`]],
      [#par(justify: false)[FK verso `TenantEntity`; cascade delete]],

      [#par(justify: false)[`type`]], [#par(justify: false)[`CommandType`]], [#par(justify: false)[Tipo di comando]],
      [#par(justify: false)[`status`]], [#par(justify: false)[`CommandStatus`]], [#par(justify: false)[Stato corrente]],
      [#par(justify: false)[`issuedAt`]],
      [#par(justify: false)[`Date`]],
      [#par(justify: false)[Timestamp di emissione]],

      [#par(justify: false)[`ackReceivedAt`]],
      [#par(justify: false)[`Date | null`]],
      [#par(justify: false)[Timestamp di ricezione ACK]],

      [#par(justify: false)[`requestedSendFrequencyMs`]],
      [#par(justify: false)[`number | null`]],
      [#par(justify: false)[Frequenza richiesta (per comandi CONFIG)]],

      [#par(justify: false)[`requestedStatus`]],
      [#par(justify: false)[`string | null`]],
      [#par(justify: false)[Stato richiesto (per comandi CONFIG)]],

      [#par(justify: false)[`requestedFirmwareVersion`]],
      [#par(justify: false)[`string | null`]],
      [#par(justify: false)[Versione firmware richiesta (per comandi FIRMWARE)]],

      [#par(justify: false)[`createdAt`]],
      [#par(justify: false)[`Date`]],
      [#par(justify: false)[Timestamp di creazione]],
    )
  ]

  ==== DTO

  _SendConfigRequestDto_ — `send_frequency_ms?: number` (min 0), `status?: string`.

  _SendFirmwareRequestDto_ — `firmware_version: string`, `download_url: string` (URL valido).

  _CommandResponseDto_ — `command_id: string`, `status: CommandStatus`, `issued_at: string`.

  _CommandStatusResponseDto_ — `command_id: string`, `status: CommandStatus`, `timestamp: string`.

  === AuditLogModule
  #figure(caption: "Diagramma del modulo AuditLogModule")[#image("assets/13-audit-log.svg", width: 110%)]

  Il modulo di audit log gestisce la registrazione e la consultazione delle operazioni eseguite sul microservizio.
  Supporta la registrazione di eventi provenienti da altri microservizi tramite NATS.

  ==== AuditLogController

  Controller NestJS esposto sotto il prefisso `/audit`. Protetto da `@TenantScoped()` e `@Roles(TENANT_ADMIN)`.

  #figure(caption: [Endpoint dell'AuditLogController])[
    #table(
      columns: (1.8fr, 2.5fr, 2.3fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Endpoint]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getAuditLogs(tenantId, from, to, userId?, action?)`]],
      [#par(justify: false)[`GET /audit`]],
      [#par(justify: false)[Restituisce i log di audit del tenant con filtri per data, utente e azione; offusca i nomi
        dei gateway durante l'impersonificazione]],
    )
  ]

  ==== AuditLogService

  Servizio di registrazione e consultazione dei log di audit.

  _Campi:_

  #figure(caption: [Campi dell'AuditLogEntity])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`alps`]],
      [#par(justify: false)[`AuditLogPersistenceService`]],
      [#par(justify: false)[Iniettato via constructor]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici dell'AuditLogService])[
    #table(
      columns: (1.5fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getAuditLogs(input)`]],
      [#par(justify: false)[`(input): Promise<AuditLogModel[]>`]],
      [#par(justify: false)[Delega al persistence layer e mappa le entità in modelli]],

      [#par(justify: false)[`logAuditEvent(...)`]],
      [#par(justify: false)[`({ userId, action, resource, details, tenantId }): Promise<void>`]],
      [#par(justify: false)[Crea e salva un nuovo evento di audit]],
    )
  ]

  ==== ProvisioningAuditConsumer

  Consumer NATS JetStream per gli eventi di audit provenienti da altri microservizi. Si sottoscrive a `log.audit.>`.
  Parsa i payload, valida i campi richiesti, risolve tenant ID e user ID, e registra l'evento.

  _Metodi privati:_

  #figure(caption: [Metodi privati del ProvisioningAuditConsumer])[
    #table(
      columns: (1.5fr, 3.5fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`processMessage(message)`]],
      [#par(justify: false)[Parsa payload; valida action/resource/timestamp/tenantId; risolve userId; registra evento;
        ack del messaggio]],

      [#par(justify: false)[`resolveTenantId(subject, details)`]],
      [#par(justify: false)[Estrae tenant ID dal subject NATS o dall'oggetto details; valida formato UUID]],

      [#par(justify: false)[`resolveUserId(value)`]],
      [#par(justify: false)[Restituisce UUID string o `SYSTEM_USER_ID` (`00000000-0000-0000-0000-000000000000`)]],

      [#par(justify: false)[`parseTimestamp(value)`]],
      [#par(justify: false)[Parsa stringa in Date; restituisce `undefined` se non valida]],

      [#par(justify: false)[`toDetailsObject(value, subject)`]],
      [#par(justify: false)[Avvolge i dettagli; aggiunge `sourceSubject` se il subject esiste]],
    )
  ]

  ==== AuditLogMapper

  _Metodi statici:_

  #figure(caption: [Metodi statici dell'AuditLogMapper])[
    #table(
      columns: (1.5fr, 3.5fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`toModel(entity)`]], [#par(justify: false)[Converte `AuditLogEntity` in `AuditLogModel`]],

      [#par(justify: false)[`toDto(model)`]],
      [#par(justify: false)[Converte in `AuditLogResponseDto`; offusca userId per audit di provisioning (restituisce
        `-`)]],
    )
  ]

  _Metodi privati:_

  #figure(caption: [Metodi privati dell'AuditLogController])[
    #table(
      columns: (1.8fr, 3.5fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`resolveUserId(model)`]],
      [#par(justify: false)[Restituisce `-` se è un audit di provisioning (`sourceSubject` inizia con `log.audit.`)]],

      [#par(justify: false)[`isProvisioningAudit(details)`]],
      [#par(justify: false)[Verifica se `sourceSubject` inizia con `log.audit.`]],
    )
  ]

  ==== Entità

  _AuditLogEntity_ (tabella `audits`)

  #figure(caption: [Campi dell'AuditLogEntity])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`id`]], [#par(justify: false)[`uuid v4`]], [#par(justify: false)[Identificativo univoco]],
      [#par(justify: false)[`tenantId`]],
      [#par(justify: false)[`uuid`]],
      [#par(justify: false)[FK verso `TenantEntity`; cascade delete]],

      [#par(justify: false)[`userId`]],
      [#par(justify: false)[`uuid`]],
      [#par(justify: false)[ID dell'utente che ha eseguito l'azione]],

      [#par(justify: false)[`action`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Tipo di azione eseguita]],

      [#par(justify: false)[`resource`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Risorsa su cui è stata eseguita l'azione]],

      [#par(justify: false)[`details`]],
      [#par(justify: false)[`jsonb`]],
      [#par(justify: false)[Dettagli aggiuntivi dell'evento]],

      [#par(justify: false)[`timestamp`]],
      [#par(justify: false)[`Date`]],
      [#par(justify: false)[Timestamp dell'evento]],
    )
  ]

  === ApiClientModule

  Il modulo di gestione dei client API gestisce la creazione, consultazione ed eliminazione dei client OIDC associati ai
  tenant, con sincronizzazione su Keycloak.

  ==== ApiClientController

  Controller NestJS esposto sotto il prefisso `/api-clients`. Protetto da `@TenantScoped()` e `@Roles(TENANT_ADMIN)`.

  #figure(caption: [Endpoint dell'ApiClientController])[
    #table(
      columns: (2fr, 2.5fr, 2.3fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Endpoint]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getApiClients(tenantId)`]],
      [#par(justify: false)[`GET /api-clients`]],
      [#par(justify: false)[Restituisce tutti i client API del tenant]],

      [#par(justify: false)[`createApiClient(tenantId, input)`]],
      [#par(justify: false)[`POST /api-clients`]],
      [#par(justify: false)[Crea un nuovo client API; protetto da `@Audit`]],

      [#par(justify: false)[`deleteApiClient(tenantId, id)`]],
      [#par(justify: false)[`DELETE /api-clients/:id`]],
      [#par(justify: false)[Elimina un client API; protetto da `@Audit`]],
    )
  ]

  ==== ApiClientService

  _Campi:_

  #figure(caption: [Campi dell'ApiClientService])[
    #table(
      columns: (2.4fr, 2.3fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`acps`]],
      [#par(justify: false)[`ApiClientPersistenceService`]],
      [#par(justify: false)[Iniettato via constructor]],

      [#par(justify: false)[`keycloakAdminService`]],
      [#par(justify: false)[`KeycloakAdminService`]],
      [#par(justify: false)[Iniettato via constructor]],

      [#par(justify: false)[`logger`]], [#par(justify: false)[`Logger`]], [#par(justify: false)[Logger interno]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici dell'ApiClientService])[
    #table(
      columns: (2.7fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`createApiClient(tenantId, name)`]],
      [#par(justify: false)[`(tenantId, name): Promise<{ model, clientSecret }>`]],
      [#par(justify: false)[Verifica conflitto nome; crea client su Keycloak; salva nel DB; rollback Keycloak se DB
        fallisce]],

      [#par(justify: false)[`getApiClients(tenantId)`]],
      [#par(justify: false)[`(tenantId): Promise<ApiClientModel[]>`]],
      [#par(justify: false)[Recupera tutti i client API del tenant]],

      [#par(justify: false)[`deleteApiClient(tenantId, id)`]],
      [#par(justify: false)[`(tenantId, id): Promise<void>`]],
      [#par(justify: false)[Elimina dal DB, poi da Keycloak (warn se Keycloak fallisce)]],

      [#par(justify: false)[`deleteApiClientsForTenant(tenantId)`]],
      [#par(justify: false)[`(tenantId): Promise<void>`]],
      [#par(justify: false)[Elimina bulk di tutti i client API per un tenant]],
    )
  ]

  ==== ApiClientPersistenceService

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici dell'ApiClientPersistenceService])[
    #table(
      columns: (1.8fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`createApiClient(id, tenantId, name, keycloakClientId)`]],
      [#par(justify: false)[`(...): Promise<ApiClientEntity>`]],
      [#par(justify: false)[Crea e salva un nuovo `ApiClientEntity`]],

      [#par(justify: false)[`findByName(tenantId, name)`]],
      [#par(justify: false)[`(tenantId, name): Promise<ApiClientEntity | null>`]],
      [#par(justify: false)[Trova client per `tenantId + name`]],

      [#par(justify: false)[`getApiClients(tenantId)`]],
      [#par(justify: false)[`(tenantId): Promise<ApiClientEntity[]>`]],
      [#par(justify: false)[Trova tutti i client per `tenantId`]],

      [#par(justify: false)[`deleteApiClient(tenantId, id)`]],
      [#par(justify: false)[`(tenantId, id): Promise<string | null>`]],
      [#par(justify: false)[Trova entity, rimuove dal DB, restituisce il `keycloakClientId` o `null`]],
    )
  ]

  ==== Entità

  _ApiClientEntity_ (tabella `api_clients`)

  #figure(caption: [Campi dell'ApiClientEntity])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`id`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Chiave primaria (stringa, non UUID)]],

      [#par(justify: false)[`tenantId`]],
      [#par(justify: false)[`uuid`]],
      [#par(justify: false)[FK verso `TenantEntity`; cascade delete]],

      [#par(justify: false)[`name`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Nome del client; indice unico]],

      [#par(justify: false)[`keycloakClientId`]],
      [#par(justify: false)[`string`]],
      [#par(justify: false)[Client ID su Keycloak; indice unico]],

      [#par(justify: false)[`createdAt`]],
      [#par(justify: false)[`Date`]],
      [#par(justify: false)[Timestamp di creazione]],
    )
  ]

  === ThresholdsModule
  #figure(caption: "Diagramma del modulo ThresholdsModule")[#image("assets/11-thresholds.svg", width: 110%)]

  Il modulo di gestione delle soglie gestisce i valori minimi e massimi per i sensori, sia a livello di tipo di sensore
  (default per tenant) che a livello di singolo sensore.

  ==== ThresholdsController

  Controller NestJS esposto sotto il prefisso `/thresholds`. Protetto da `@TenantScoped()`.

  #figure(caption: [Endpoint del ThresholdsController])[
    #table(
      columns: (2.6fr, 2.5fr, 2.3fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Endpoint]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getThresholds(tenantId)`]],
      [#par(justify: false)[`GET /thresholds`]],
      [#par(justify: false)[Restituisce tutte le soglie del tenant; accessibile a `TENANT_USER` e `TENANT_ADMIN`]],

      [#par(justify: false)[`setDefaultThreshold(tenantId, input)`]],
      [#par(justify: false)[`PUT /thresholds/default`]],
      [#par(justify: false)[Imposta la soglia di default per un tipo di sensore; protetto da `@Audit` e
        `@Roles(TENANT_ADMIN)`]],

      [#par(justify: false)[`setSensorThreshold(tenantId, sensorId, input)`]],
      [#par(justify: false)[`PUT /thresholds/sensor/:sensorId`]],
      [#par(justify: false)[Imposta la soglia per un sensore specifico; protetto da `@Audit` e `@Roles(TENANT_ADMIN)`]],

      [#par(justify: false)[`deleteSensorThreshold(tenantId, sensorId)`]],
      [#par(justify: false)[`DELETE /thresholds/sensor/:sensorId`]],
      [#par(justify: false)[Elimina la soglia per un sensore; protetto da `@Audit` e `@Roles(TENANT_ADMIN)`]],

      [#par(justify: false)[`deleteThresholdType(tenantId, sensorType)`]],
      [#par(justify: false)[`DELETE /thresholds/type/:sensorType`]],
      [#par(justify: false)[Elimina la soglia di default per un tipo di sensore; protetto da `@Audit` e
        `@Roles(TENANT_ADMIN)`]],
    )
  ]

  ==== ThresholdsService

  _Campi:_

  #figure(caption: [Campi del ThresholdsService])[
    #table(
      columns: (1.9fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`tps`]],
      [#par(justify: false)[`ThresholdsPersistenceService`]],
      [#par(justify: false)[Iniettato via constructor]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici del ThresholdsService])[
    #table(
      columns: (2.2fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getThresholds(input)`]],
      [#par(justify: false)[`(input): Promise<ThresholdModel[]>`]],
      [#par(justify: false)[Recupera tutte le soglie del tenant]],

      [#par(justify: false)[`setThresholdDefaultType(input)`]],
      [#par(justify: false)[`(input): Promise<ThresholdModel>`]],
      [#par(justify: false)[Valida `sensorType` e range valori; delega al persistence layer]],

      [#par(justify: false)[`setThresholdSensor(input)`]],
      [#par(justify: false)[`(input): Promise<ThresholdModel>`]],
      [#par(justify: false)[Valida `sensorId` e range valori; delega al persistence layer]],

      [#par(justify: false)[`deleteSensorThreshold(input)`]],
      [#par(justify: false)[`(input): Promise<void>`]],
      [#par(justify: false)[Solleva `NotFoundException` se non trovato]],

      [#par(justify: false)[`deleteThresholdType(input)`]],
      [#par(justify: false)[`(input): Promise<void>`]],
      [#par(justify: false)[Solleva `NotFoundException` se non trovato]],
    )
  ]

  _Metodi privati:_

  #figure(caption: [Metodi privati del ThresholdsService])[
    #table(
      columns: (1.9fr, 3.5fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`ensureSensorType(sensorType)`]],
      [#par(justify: false)[Trim e valida che non sia vuoto; solleva `BadRequestException`]],

      [#par(justify: false)[`ensureSensorId(sensorId)`]],
      [#par(justify: false)[Trim e valida che non sia vuoto; solleva `BadRequestException`]],

      [#par(justify: false)[`validateValueRange(minValue, maxValue)`]],
      [#par(justify: false)[Valida che i numeri siano validi e `minValue < maxValue`; solleva `BadRequestException`]],
    )
  ]

  ==== ThresholdsPersistenceService

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici del ThresholdsPersistenceService])[
    #table(
      columns: (2.3fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getThresholds(input)`]],
      [#par(justify: false)[`(input): Promise<ThresholdEntity[]>`]],
      [#par(justify: false)[Trova per `tenantId`; ordina per `updatedAt DESC`]],

      [#par(justify: false)[`setThresholdDefaultType(input)`]],
      [#par(justify: false)[`(input): Promise<ThresholdEntity>`]],
      [#par(justify: false)[Upsert: trova per `tenantId + sensorType + sensorId IS NULL`; aggiorna o crea]],

      [#par(justify: false)[`setThresholdSensor(input)`]],
      [#par(justify: false)[`(input): Promise<ThresholdEntity>`]],
      [#par(justify: false)[Upsert: trova per `tenantId + sensorId`; aggiorna o crea]],

      [#par(justify: false)[`deleteSensorThreshold(input)`]],
      [#par(justify: false)[`(input): Promise<boolean>`]],
      [#par(justify: false)[Elimina per `tenantId + sensorId`; restituisce `true` se eliminato]],

      [#par(justify: false)[`deleteThresholdType(input)`]],
      [#par(justify: false)[`(input): Promise<boolean>`]],
      [#par(justify: false)[Elimina per `tenantId + sensorType + sensorId IS NULL`; restituisce `true` se eliminato]],
    )
  ]

  ==== Entità

  _ThresholdEntity_ (tabella `thresholds`)

  #figure(caption: [Campi del ThresholdEntity])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`id`]], [#par(justify: false)[`uuid v4`]], [#par(justify: false)[Identificativo univoco]],
      [#par(justify: false)[`tenantId`]],
      [#par(justify: false)[`uuid`]],
      [#par(justify: false)[FK verso `TenantEntity`; cascade delete]],

      [#par(justify: false)[`sensorType`]],
      [#par(justify: false)[`string | null`]],
      [#par(justify: false)[Tipo di sensore (per soglie di default)]],

      [#par(justify: false)[`sensorId`]],
      [#par(justify: false)[`uuid | null`]],
      [#par(justify: false)[ID del sensore specifico (per override)]],

      [#par(justify: false)[`minValue`]],
      [#par(justify: false)[`number`]],
      [#par(justify: false)[Valore minimo (float)]],

      [#par(justify: false)[`maxValue`]],
      [#par(justify: false)[`number`]],
      [#par(justify: false)[Valore massimo (float)]],

      [#par(justify: false)[`createdAt`]],
      [#par(justify: false)[`Date`]],
      [#par(justify: false)[Timestamp di creazione]],

      [#par(justify: false)[`updatedAt`]],
      [#par(justify: false)[`Date`]],
      [#par(justify: false)[Timestamp dell'ultimo aggiornamento]],
    )
  ]

  Indici unici composti: uno su `['tenantId', 'sensorType']` dove `sensor_id IS NULL`, uno su `['tenantId', 'sensorId']`
  dove `sensor_id IS NOT NULL`.

  === CostsModule
  #figure(caption: "Diagramma del modulo CostsModule")[#image("assets/07-costs.svg", width: 110%)]

  Il modulo di gestione dei costi calcola lo storage e la banda utilizzati da un tenant, combinando dati da NATS, alert
  e comandi.

  ==== CostsController

  Controller NestJS esposto sotto il prefisso `/costs`. Protetto da `@TenantScoped()` e `@Roles(TENANT_ADMIN)`.

  #figure(caption: [Endpoint del CostsController])[
    #table(
      columns: (1.7fr, 2.5fr, 2.3fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Endpoint]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getTenantCost(tenantId)`]],
      [#par(justify: false)[`GET /costs`]],
      [#par(justify: false)[Restituisce i costi stimati del tenant: storage e banda in GB]],
    )
  ]

  ==== CostsService

  _Campi:_

  #figure(caption: [Campi del CostsService])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`cps`]],
      [#par(justify: false)[`CostsPersistenceService`]],
      [#par(justify: false)[Iniettato via constructor]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici del CostsService])[
    #table(
      columns: (1.7fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getTenantCost(tenantId)`]],
      [#par(justify: false)[`(tenantId): Promise<CostModel>`]],
      [#par(justify: false)[Delega al persistence layer; solleva `NotFoundException` se nessun dato; mappa errori
        HTTP-like a eccezioni NestJS]],
    )
  ]

  ==== CostsPersistenceService

  _Campi:_

  #figure(caption: [Campi del CostsPersistenceService])[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`nats`]],
      [#par(justify: false)[`JetStreamClient`]],
      [#par(justify: false)[Iniettato per richiesta NATS]],

      [#par(justify: false)[`alerts`]],
      [#par(justify: false)[`AlertsPersistenceService`]],
      [#par(justify: false)[Iniettato per conteggio alert]],

      [#par(justify: false)[`commands`]],
      [#par(justify: false)[`CommandPersistenceService`]],
      [#par(justify: false)[Iniettato per conteggio comandi]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: [Metodi pubblici del CostsPersistenceService])[
    #table(
      columns: (1.7fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`getTenantCost(tenantId)`]],
      [#par(justify: false)[`(tenantId): Promise<CostData>`]],
      [#par(justify: false)[Invia richiesta NATS a `internal.cost` con `{ tenant_id }`; calcola
        `storageGb = dataSizeAtRest / 1GB` e `bandwidthGb = (alertsCount + commandsCount) * 1KB / 1GB`; entrambi
        arrotondati a 4 decimali]],
    )
  ]

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
