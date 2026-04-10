#import "../../00-templates/base_document.typ" as base-document
#import "../specifica_tecnica/st_lib.typ" as st

#let metadata = yaml(sys.inputs.meta-path)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Specifica tecnica del microservizio data-api: architettura logica, contratti REST, port applicativi, design di dettaglio dei componenti, gestione errori e strategia di test del servizio di consultazione delle misure cifrate.",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione
  Questo documento illustra l'architettura interna e le scelte implementative del microservizio `data-api`. Sviluppato
  in NestJS, questo componente è responsabile dell'esposizione di funzionalità di consultazione delle misure cifrate
  raccolte dal sistema. Il servizio rende disponibili endpoint HTTP per l'interrogazione paginata delle misure,
  l'esportazione completa di un intervallo temporale, la fruizione in streaming dei dati e l'elenco dei sensori
  osservati di recente.

  L'obiettivo del componente è fornire un punto di accesso unificato ai dati telemetrici già acquisiti e persistiti,
  mantenendo separata la logica di esposizione API dalla logica di accesso alla persistenza. Il servizio restituisce
  verso i client esclusivamente payload cifrati e metadati tecnici associati alla misura, senza effettuare operazioni di
  decifratura.

  Il progetto è strutturato in moduli NestJS distinti per le funzionalità `measure` e `sensor`, con utilizzo di DTO per
  i contratti esposti, model interni per la logica applicativa e servizi dedicati per orchestrazione, filtraggio e
  accesso ai dati.

  = Dipendenze e Configurazione

  == Variabili d'ambiente

  Tutte le variabili d'ambiente necessarie per il funzionamento del microservizio sono elencate di seguito, una
  eventuale mancanza di una di queste variabili comporterà un errore all'avvio del microservizio:

  #figure(caption: "Variabili d'ambiente richieste da data-api")[
    #table(
      columns: (auto, auto, auto, auto),
      [#par(justify: false)[Campo]],
      [#par(justify: false)[Variabile d'ambiente]],
      [#par(justify: false)[Default]],
      [#par(justify: false)[Obbligatorio]],

      [#par(justify: false)[`ApiPort`]],
      [#par(justify: false)[DATA_API_PORT]],
      [#par(justify: false)[`3000`]],
      [#par(justify: false)[No]],

      [#par(justify: false)[`DBHost`]],
      [#par(justify: false)[MEASURES_DB_HOST]],
      [#par(justify: false)[`-`]],
      [#par(justify: false)[Sì]],

      [#par(justify: false)[`DBPort`]],
      [#par(justify: false)[MEASURES_DB_PORT]],
      [#par(justify: false)[`5432`]],
      [#par(justify: false)[No]],

      [#par(justify: false)[`DBName`]],
      [#par(justify: false)[MEASURES_DB_NAME]],
      [#par(justify: false)[`-`]],
      [#par(justify: false)[Sì]],

      [#par(justify: false)[`DBUser`]],
      [#par(justify: false)[MEASURES_DB_USER]],
      [#par(justify: false)[`-`]],
      [#par(justify: false)[Sì]],

      [#par(justify: false)[`DBPassword`]],
      [#par(justify: false)[MEASURES_DB_PASSWORD]],
      [#par(justify: false)[`-`]],
      [#par(justify: false)[Sì]],

      [#par(justify: false)[`DBSSL`]],
      [#par(justify: false)[DB_SSL]],
      [#par(justify: false)[`false`]],
      [#par(justify: false)[No]],

      [#par(justify: false)[`NatsUrl`]],
      [#par(justify: false)[NATS_URL]],
      [#par(justify: false)[`-`]],
      [#par(justify: false)[No]],

      [#par(justify: false)[`NatsServers`]],
      [#par(justify: false)[NATS_SERVERS]],
      [#par(justify: false)[`-`]],
      [#par(justify: false)[No]],

      [#par(justify: false)[`MgmtApiUrl`]],
      [#par(justify: false)[MGMT_API_URL]],
      [#par(justify: false)[`http://management-api:3000`]],
      [#par(justify: false)[Sì]],
    )
  ]

  == Sequenza di avvio

  I passi bloccanti interrompono l'avvio del microservizio, pertanto è necessario assicurarsi che tutti i servizi
  esterni siano operativi prima di avviare `notip-data-api`. La sequenza di avvio è la seguente:
  #figure(caption: "Sequenza di avvio del microservizio data-api")[
    #table(
      columns: (auto, 1.5fr, 2.5fr, auto),
      [#par(justify: false)[Step]],
      [#par(justify: false)[Componente]],
      [#par(justify: false)[Azione]],
      [#par(justify: false)[Bloccante?]],

      [#par(justify: false)[0]],
      [#par(justify: false)[.env]],
      [#par(justify: false)[Carica le variabili d'ambiente del servizio]],
      [#par(justify: false)[Si]],

      [#par(justify: false)[1]],
      [#par(justify: false)[env.validation]],
      [#par(justify: false)[Verifica la validità delle variabili d'ambiente]],
      [#par(justify: false)[Si]],

      [#par(justify: false)[2]],
      [#par(justify: false)[bootstrap.nestjs]],
      [#par(justify: false)[Inizializza i moduli, controller e provider dell'applicazione NestJS]],
      [#par(justify: false)[Si]],

      [#par(justify: false)[3]],
      [#par(justify: false)[app.module]],
      [#par(justify: false)[Inizializza TypeORM e registra i moduli Measure e Sensor]],
      [#par(justify: false)[Si]],

      [#par(justify: false)[4]],
      [#par(justify: false)[auth.guard]],
      [#par(justify: false)[Registra il TenantAccessGuard globale per la validazione del tenant]],
      [#par(justify: false)[Si]],

      [#par(justify: false)[5]],
      [#par(justify: false)[metrics.module]],
      [#par(justify: false)[Registra MetricsService e MetricsInterceptor per il monitoraggio]],
      [#par(justify: false)[Si]],

      [#par(justify: false)[6]],
      [#par(justify: false)[main]],
      [#par(justify: false)[Crea l'applicazione NestJS e avvia il listener HTTP sulla porta configurata]],
      [#par(justify: false)[Si]],
    )
  ]

  = Architettura Logica

  #align(center)[
    #figure(caption: "Architettura del microservizio")[
      #image("./assets/01-app-architecture.svg", width: 110%)
    ]

  ]

  Il servizio adotta una Layered Architecture con organizzazione interna di tipo Modular Monolith. All'interno dei vari
  moduli è utilizzato prevalentemente il pattern Controller-Service-Persistence, che consente una chiara separazione
  delle responsabilità tra esposizione API, logica di business e accesso ai dati. I componenti collaborano tramite
  Dependency Injection e, dove opportuno, tramite interfacce e contratti applicativi. La presenza di Business Models,
  DTO ed Entities ha portato all'introduzione di Mappers per la conversione dei dati tra i diversi livelli
  dell'applicazione.

  == Strati Architetturali
  #figure(caption: "Strati architetturali")[
    #table(
      columns: (1.5fr, 2.4fr, 2.5fr),
      [#par(justify: false)[Strato]], [#par(justify: false)[Package]], [#par(justify: false)[Contenuto]],
      [#par(justify: false)[Presentation]],
      [#par(justify: false)[`src/app.controller.ts`\ `src/data-api/controller`\ `src/data-api/dto`\
        `src/data-api/openapi.decorators.ts`]],
      [#par(justify: false)[Gestione delle richieste HTTP, esposizione delle API REST, validazione dei payload,
        autenticazione e definizione dei contratti di ingresso/uscita dei dati.]],

      [#par(justify: false)[Business]],
      [#par(justify: false)[`src/data-api/services`\ `src/data-api/models`\ `src/data-api/interfaces`\
        `src/data-api/measure.mapper.ts`]],
      [#par(justify: false)[Logica applicativa e di dominio: validazione dei parametri di query, orchestrazione dei casi
        d'uso, trasformazione tra entity/model/DTO, filtraggio dei dati e definizione delle interfacce tra
        componenti.]],

      [#par(justify: false)[Persistence]],
      [#par(justify: false)[`src/data-api/entity`\ `src/data-api/services/measure.persistence.service.ts`]],
      [#par(justify: false)[Accesso ai dati tramite TypeORM, definizione dell'entità `MeasureEntity`, costruzione delle
        query paginated e non-paginated su PostgreSQL e incapsulamento delle operazioni di persistenza.]],
    )
  ]
  = Design di Dettaglio

  == Moduli del microservizio

  === MeasureModule
  Gestione delle funzionalità di interrogazione ed esportazione delle misure. Espone gli endpoint dedicati, orchestra la
  logica applicativa tramite `MeasureService` e delega l'accesso ai dati a `MeasurePersistenceService` usando TypeORM
  sull'entità `MeasureEntity`, responsabile dell'esposizione degli endpoint per la consultazione delle misure cifrate.
  Gestisce query paginate, export completo e streaming SSE.

  ===== MeasureController

  Controller NestJS esposto sotto il prefisso `/measures`. Gestisce tre endpoint principali.
  #figure(caption: "Endpoint esposti da MeasureController")[
    #table(
      columns: (1.2fr, 2.5fr, 2.3fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Endpoint]], [#par(justify: false)[Note]],
      [#par(justify: false)[`query(...)`]],
      [#par(justify: false)[`GET /measures/query`]],
      [#par(justify: false)[Query paginata con cursor-based pagination; valida limit <= 999 e finestra <= 24h]],

      [#par(justify: false)[`stream(...)`]],
      [#par(justify: false)[`SSE /measures/stream`]],
      [#par(justify: false)[Server-Sent Events; replay storico + live; termina con `token_expired` alla scadenza del
        JWT]],

      [#par(justify: false)[`export(...)`]],
      [#par(justify: false)[`GET /measures/export`]],
      [#par(justify: false)[Export completo senza paginazione; valida finestra <= 24h]],
    )
  ]

  _Metodi privati:_
  #figure(caption: "Metodi privati di MeasureController")[
    #table(
      columns: (2.5fr, 3.5fr),
      [#par(justify: false)[Funzione]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`normalizeLimit(value)`]],
      [#par(justify: false)[Parsing del parametro limit; default 999; scarta valori non interi]],

      [#par(justify: false)[`normalizeArrayParam(value)`]],
      [#par(justify: false)[Converte parametro singolo o array in `string[]`]],

      [#par(justify: false)[`parseBearerToken(authorization)`]],
      [#par(justify: false)[Estrae il token Bearer dall'header Authorization]],

      [#par(justify: false)[`extractTokenExpiresAt(authorization)`]],
      [#par(justify: false)[Decodifica il payload JWT e estrae il claim `exp` in millisecondi]],
    )
  ]
  ===== MeasureService

  Contiene la logica di business per query ed export. Coordina `MeasurePersistenceService`.

  _Campi:_
  #figure(caption: "Campi di MeasureService")[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`mps`]],
      [#par(justify: false)[`MeasurePersistenceService`]],
      [#par(justify: false)[Iniettato via constructor]],
    )]

  _Costanti:_
  #figure(caption: "Costanti di MeasureService")[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Costante]], [#par(justify: false)[Valore]], [#par(justify: false)[Note]],
      [#par(justify: false)[`MAX_QUERY_LIMIT`]],
      [#par(justify: false)[`999`]],
      [#par(justify: false)[Limite massimo di righe per pagina]],

      [#par(justify: false)[`MAX_WINDOW_MS`]],
      [#par(justify: false)[`86400000`]],
      [#par(justify: false)[Finestra temporale massima: 24 ore]],
    )]

  _Metodi pubblici:_
  #figure(caption: "Metodi pubblici di MeasureService")[
    #table(
      columns: (1.5fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`query(input)`]],
      [#par(justify: false)[`(input: QueryInput): Promise<PaginatedQueryModel>`]],
      [#par(justify: false)[Valida input; chiama `mps.paginatedQuery()`; mappa risultato via `MeasureMapper`]],

      [#par(justify: false)[`export(input)`]],
      [#par(justify: false)[`(input: ExportInput): Promise<EncryptedEnvelopeModel[]>`]],
      [#par(justify: false)[Valida input; chiama `mps.nonPaginatedQuery()`; mappa risultato via `MeasureMapper`]],
    )]

  _Metodi privati:_
  #figure(caption: "Metodi privati di MeasureService")[
    #table(
      columns: (1.5fr, 3.5fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`validateQueryInput(input)`]],
      [#par(justify: false)[Verifica `limit <= MAX_QUERY_LIMIT` (code `QUERY_LIMIT_EXCEEDED`); chiama
        `validateWindow`]],

      [#par(justify: false)[`validateExportInput(input)`]],
      [#par(justify: false)[Chiama `validateWindow` con code `EXPORT_WINDOW_EXCEEDED`]],

      [#par(justify: false)[`validateWindow(from, to, code)`]],
      [#par(justify: false)[Parsa le date; se finestra > 24h solleva `BadRequestException` con il code fornito]],

      [#par(justify: false)[`handleQueryError(error)`]],
      [#par(justify: false)[Mappa errori: 400/BadRequest, 401/Unauthorized, 403/Forbidden]],

      [#par(justify: false)[`handleExportError(error)`]],
      [#par(justify: false)[Mappa errori: 400/BadRequest, 401/Unauthorized, 403/Forbidden]],
    )]

  ===== MeasurePersistenceService

  Layer di accesso ai dati. Implementa `NpQueryPersistenceService`. Costruisce query TypeORM sull'entità `MeasureEntity`
  (tabella `telemetry`).

  _Campi:_
  #figure(caption: "Campi di MeasurePersistenceService")[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`repository`]],
      [#par(justify: false)[`Repository<MeasureEntity>`]],
      [#par(justify: false)[Repository TypeORM iniettato]],
    )
  ]

  _Metodi pubblici:_

  #table(
    columns: (2.6fr, 2.1fr, 2fr),
    [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
    [#par(justify: false)[`paginatedQuery(p)`]],
    [#par(justify: false)[`(p: PQueryPersistenceInput): Promise<PaginatedQuery>`]],
    [#par(justify: false)[Query con filtri (tenantId, gatewayId IN, sensorId IN, sensorType IN, time range) e
      cursor-based pagination composta `(time, sensorId)`. Fetch `limit + 1` righe per determinare `hasMore`]],

    [#par(justify: false)[`nonPaginatedQuery(n)`]],
    [#par(justify: false)[`(n: NpQueryPersistenceInput): Promise<MeasureEntity[]>`]],
    [#par(justify: false)[Query senza paginazione; stessi filtri; ordine `time DESC`]],

    [#par(justify: false)[`getTenantDataSizeAtRest(_tenantId)`]],
    [#par(justify: false)[`(_tenantId: string): Promise<number>`]],
    [#par(justify: false)[Esegue `SELECT pg_database_size`\ `(current_database()):`\ `:bigint`; restituisce dimensione
      in byte]],
  )

  _Metodi privati:_

  #figure(caption: "Metodi privati di MeasurePersistenceService")[
    #table(
      columns: (1.9fr, 3.5fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`applyScalarFilter(qb, column, param, value)`]],
      [#par(justify: false)[Aggiunge `WHERE column = :param` se value è definito]],

      [#par(justify: false)[`applyArrayFilter(qb, column, param, values)`]],
      [#par(justify: false)[Aggiunge `WHERE column IN (:...param)` se l'array ha elementi]],

      [#par(justify: false)[`parseCompositeCursor(cursor)`]],
      [#par(justify: false)[Splitta il cursor sull'ultimo `|`; restituisce `{ time, sensorId }` o `undefined`]],

      [#par(justify: false)[`toCompositeCursor(time, sensorId)`]],
      [#par(justify: false)[Formatta come `time|sensorId`]],
    )
  ]

  ===== StreamListenerService

  Gestisce lo streaming RxJS delle misure. Crea un `Subject` per tenant e gestisce il replay storico e gli eventi live.

  _Campi:_

  #figure(caption: "Campi di StreamListenerService")[
    #table(
      columns: (1.5fr, 2.6fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`tenantStreams`]],
      [#par(justify: false)[`Map<string, Subject<EncryptedEnvelopeModel>>`]],
      [#par(justify: false)[Soggetti per tenant (lazy-created)]],

      [#par(justify: false)[`mps`]],
      [#par(justify: false)[`MeasurePersistenceService`]],
      [#par(justify: false)[Iniettato per replay storico]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: "Metodi pubblici di StreamListenerService")[
    #table(
      columns: (2.2fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`stream(input)`]],
      [#par(justify: false)[`(input: StreamInput): Observable<StreamEmission>`]],
      [#par(justify: false)[Concatena replay storico + live events; filtra per gatewayId/sensorId/sensorType; termina
        con `token_expired`]],

      [#par(justify: false)[`publishLiveMeasure(tenantId, event)`]],
      [#par(justify: false)[`(tenantId: string, event: EncryptedEnvelopeModel): void`]],
      [#par(justify: false)[Pubblica una misura live sul Subject del tenant]],
    )
  ]

  _Metodi privati:_

  #figure(caption: "Metodi privati di StreamListenerService")[
    #table(
      columns: (1.5fr, 3.5fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`replayHistorical(input)`]],
      [#par(justify: false)[Se `since` è definito, query `[since, now]` ed emette ogni misura come evento `data`]],

      [#par(justify: false)[`listenToSource(input)`]],
      [#par(justify: false)[Sottoscrive al Subject del tenant e wrappa come Observable]],

      [#par(justify: false)[`getTenantStream(tenantId?)`]],
      [#par(justify: false)[Crea lazy il Subject per il tenant (default: `'anonymous'`)]],

      [#par(justify: false)[`matchesFilters(event, input)`]],
      [#par(justify: false)[Verifica se l'evento soddisfa i filtri gatewayId/sensorId/sensorType (OR dentro ogni
        array)]],
    )
  ]

  ===== TelemetryStreamBridgeService

  Bridge tra NATS e lo streaming RxJS. Si sottoscrive a `telemetry.data.*.*` e pubblica le misure live sullo stream del
  tenant corrispondente.

  _Campi:_

  #figure(caption: "Campi di TelemetryStreamBridgeService")[
    #table(
      columns: (1.5fr, 2fr, 2.5fr),
      [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
      [#par(justify: false)[`logger`]], [#par(justify: false)[`Logger`]], [#par(justify: false)[Logger interno]],
      [#par(justify: false)[`connection`]],
      [#par(justify: false)[`NatsConnection | null`]],
      [#par(justify: false)[Connessione NATS]],

      [#par(justify: false)[`subscription`]],
      [#par(justify: false)[`Subscription | null`]],
      [#par(justify: false)[Sottoscrizione NATS]],

      [#par(justify: false)[`streamListener`]],
      [#par(justify: false)[`StreamListenerService`]],
      [#par(justify: false)[Iniettato per pubblicare misure live]],
    )
  ]

  _Metodi pubblici:_

  #figure(caption: "Metodi pubblici di TelemetryStreamBridgeService")[
    #table(
      columns: (1.5fr, 2.5fr, 2fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
      [#par(justify: false)[`onModuleInit()`]],
      [#par(justify: false)[`(): Promise<void>`]],
      [#par(justify: false)[Salta in test mode; chiama `connectAndSubscribe()`]],

      [#par(justify: false)[`onModuleDestroy()`]],
      [#par(justify: false)[`(): Promise<void>`]],
      [#par(justify: false)[Unsubscribe, drain e close della connessione NATS]],
    )
  ]

  _Metodi privati:_

  #figure(caption: "Metodi privati di TelemetryStreamBridgeService")[
    #table(
      columns: (1.8fr, 3.5fr),
      [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
      [#par(justify: false)[`connectAndSubscribe()`]],
      [#par(justify: false)[Connette a NATS con TLS/token/user-pass; sottoscrive `telemetry.data.*.*`; avvia
        `consumeMessages()`]],

      [#par(justify: false)[`consumeMessages(subscription)`]],
      [#par(justify: false)[Itera messaggi NATS; estrae tenantId dal subject; pars envelope; pubblica su
        `streamListener`]],

      [#par(justify: false)[`buildConnectionOptions()`]],
      [#par(justify: false)[Costruisce opzioni NATS: servers da env, TLS mTLS, token o user/pass]],

      [#par(justify: false)[`extractTenantId(subject)`]],
      [#par(justify: false)[Estrae tenantId da `telemetry.data.{tenantId}.{something}` (parte 2)]],

      [#par(justify: false)[`parseEnvelope(data)`]],
      [#par(justify: false)[JSON-parsa i dati e valida tutti i campi richiesti; restituisce `undefined` se invalido]],
    )
  ]

  ===== CostNatsResponderService

  Responder NATS per le richieste di costo. Risponde su `internal.cost` con la dimensione del database.

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
    [#par(justify: false)[`logger`]], [#par(justify: false)[`Logger`]], [#par(justify: false)[Logger interno]],
    [#par(justify: false)[`connection`]],
    [#par(justify: false)[`NatsConnection | null`]],
    [#par(justify: false)[Connessione NATS]],

    [#par(justify: false)[`subscription`]],
    [#par(justify: false)[`Subscription | null`]],
    [#par(justify: false)[Sottoscrizione NATS]],

    [#par(justify: false)[`persistence`]],
    [#par(justify: false)[`MeasurePersistenceService`]],
    [#par(justify: false)[Iniettato per ottenere la dimensione DB]],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
    [#par(justify: false)[`onModuleInit()`]],
    [#par(justify: false)[`(): Promise<void>`]],
    [#par(justify: false)[Salta in test mode; chiama `connectAndSubscribe()`]],

    [#par(justify: false)[`onModuleDestroy()`]],
    [#par(justify: false)[`(): Promise<void>`]],
    [#par(justify: false)[Unsubscribe, drain e close della connessione NATS]],
  )

  _Metodi privati:_

  #table(
    columns: (2fr, 3.5fr),
    [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
    [#par(justify: false)[`connectAndSubscribe()`]],
    [#par(justify: false)[Connette a NATS; sottoscrive `internal.cost`; avvia `consumeMessages()`]],

    [#par(justify: false)[`consumeMessages(subscription)`]],
    [#par(justify: false)[Itera messaggi; estrae tenantId; chiama `persistence.getTenantDataSizeAtRest()`; risponde]],

    [#par(justify: false)[`extractTenantId(data)`]],
    [#par(justify: false)[JSON-parsa la richiesta e estrae `tenant_id`]],

    [#par(justify: false)[`respondWithCost(message, dataSizeAtRest)`]],
    [#par(justify: false)[Risponde su NATS con `{ dataSizeAtRest }`]],
  )

  === SensorModule
  Gestione delle funzionalità di discovery e consultazione dei sensori disponibili. Espone gli endpoint relativi ai
  sensori, utilizza `SensorService` per costruire la vista logica dei sensori a partire dalle misure persistite e riusa
  `MeasurePersistenceService` come dipendenza di persistenza. Riusa `MeasurePersistenceService` come dipendenza di
  persistenza tramite il token `NP_QUERY_PERSISTENCE`.

  ===== SensorController

  Controller NestJS esposto sotto il prefisso `/sensor`.

  #table(
    columns: (2fr, 2.5fr, 2.3fr),
    [#par(justify: false)[Metodo]], [#par(justify: false)[Endpoint]], [#par(justify: false)[Note]],
    [#par(justify: false)[`getSensors(gatewayId?, tenantId?)`]],
    [#par(justify: false)[`GET /sensor`]],
    [#par(justify: false)[Restituisce i sensori attivi negli ultimi 10 minuti; filtro opzionale per gatewayId]],
  )

  ===== SensorService

  Contiene la logica di aggregazione dei sensori. Dipende dall'interfaccia `NpQueryPersistenceService`.

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
    [#par(justify: false)[`npqps`]],
    [#par(justify: false)[`NpQueryPersistenceService`]],
    [#par(justify: false)[Iniettato via token `NP_QUERY_PERSISTENCE`]],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2.4fr),
    [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
    [#par(justify: false)[`getSensors(input)`]],
    [#par(justify: false)[`(input: GetSensorsInput): Promise<SensorModel[]>`]],
    [#par(justify: false)[Query misure ultimi 10 minuti; deduplica per `gatewayId::sensorId::sensorType`; tiene il
      `lastSeen` più recente]],
  )

  _Metodi privati:_

  #table(
    columns: (1.5fr, 3.5fr),
    [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
    [#par(justify: false)[`toSensorModels(measures)`]],
    [#par(justify: false)[Deduplica le misure in sensori univoci; traccia il timestamp `lastSeen` più recente per
      sensore]],
  )

  === Auth (Tenant Access)

  Il modulo di autenticazione gestisce la validazione dello stato del tenant tramite chiamate al Management API. Applica
  un guard globale su tutte le richieste.

  ===== TenantAccessGuard

  Guard globale registrato come `APP_GUARD` in `AppModule`.

  _Campi:_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
    [#par(justify: false)[`configService`]],
    [#par(justify: false)[`ConfigService`]],
    [#par(justify: false)[Iniettato per leggere `MGMT_API_URL`]],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.5fr, 2.5fr, 2fr),
    [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
    [#par(justify: false)[`canActivate(context)`]],
    [#par(justify: false)[`(context: ExecutionContext): Promise<boolean>`]],
    [#par(justify: false)[Salta per path pubblici (`/`, `/metrics`) e OPTIONS; estrae Bearer token; chiama Management
      API; applica read-only mode]],
  )

  _Metodi privati:_

  #table(
    columns: (2.2fr, 3.5fr),
    [#par(justify: false)[Metodo]], [#par(justify: false)[Comportamento]],
    [#par(justify: false)[`isPublicRequest(request)`]], [#par(justify: false)[Verifica se il path è `/` o `/metrics`]],

    [#par(justify: false)[`extractBearerToken(authorization)`]], [#par(justify: false)[Estrae il token dopo `Bearer `]],

    [#par(justify: false)[`resolveTenantAccess(authorization)`]],
    [#par(justify: false)[Chiama `GET ${MGMT_API_URL}/auth/tenant-status`; mappa 401->Unauthorized, 403->Forbidden;
      valida payload]],
  )

  ===== TenantId Decorator

  Decoratore `@TenantId()` che estrae il `tenantId` dal `TenantAccessContext` della richiesta.

  ===== Interfacce

  _TenantAccessContext_

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
    [#par(justify: false)[`tenantId`]],
    [#par(justify: false)[`string`]],
    [#par(justify: false)[Identificativo del tenant]],

    [#par(justify: false)[`status`]],
    [#par(justify: false)[`'active' | 'suspended'`]],
    [#par(justify: false)[Stato corrente del tenant]],

    [#par(justify: false)[`readOnly`]],
    [#par(justify: false)[`boolean`]],
    [#par(justify: false)[Se true, blocca le modifiche]],
  )

  === MetricsModule

  Modulo per l'esposizione di metriche Prometheus. Registrato come globale in `AppModule`.

  ===== MetricsService

  Servizio che gestisce il registry Prometheus e le metriche custom.

  _Campi:_

  #table(
    columns: (2fr, 2fr, 2.5fr),
    [#par(justify: false)[Campo]], [#par(justify: false)[Tipo]], [#par(justify: false)[Note]],
    [#par(justify: false)[`registry`]],
    [#par(justify: false)[`Registry`]],
    [#par(justify: false)[Registry Prometheus (private, readonly)]],

    [#par(justify: false)[`httpRequestsTotal`]],
    [#par(justify: false)[`Counter`]],
    [#par(justify: false)[Contatore richieste totali]],

    [#par(justify: false)[`httpRequestDurationSeconds`]],
    [#par(justify: false)[`Histogram`]],
    [#par(justify: false)[Istogramma durata richieste (11 bucket)]],

    [#par(justify: false)[`httpRequestsInFlight`]],
    [#par(justify: false)[`Gauge`]],
    [#par(justify: false)[Gauge richieste in corso]],
  )

  _Metodi pubblici:_

  #table(
    columns: (1.8fr, 2.5fr, 2fr),
    [#par(justify: false)[Metodo]], [#par(justify: false)[Firma]], [#par(justify: false)[Note]],
    [#par(justify: false)[`contentType` (getter)]],
    [#par(justify: false)[`get contentType(): string`]],
    [#par(justify: false)[Restituisce il content type del registry]],

    [#par(justify: false)[`getMetrics()`]],
    [#par(justify: false)[`(): Promise<string>`]],
    [#par(justify: false)[Restituisce la stringa delle metriche]],

    [#par(justify: false)[`incInFlight(method)`]],
    [#par(justify: false)[`(method: string): void`]],
    [#par(justify: false)[Incrementa il gauge in-flight]],

    [#par(justify: false)[`decInFlight(method)`]],
    [#par(justify: false)[`(method: string): void`]],
    [#par(justify: false)[Decrementa il gauge in-flight]],

    [#par(justify: false)[`observeHttpRequest(...)`]],
    [#par(justify: false)[`(method, route, statusCode, durationSeconds): void`]],
    [#par(justify: false)[Incrementa il counter e osserva l'istogramma]],

    [#par(justify: false)[`resolveRouteLabel(req)`]],
    [#par(justify: false)[`(req): string`]],
    [#par(justify: false)[Restituisce `${baseUrl}${routePath}` o `'_unmatched'`]],
  )

  ===== MetricsController

  Controller che espone l'endpoint `/metrics` per Prometheus.

  #table(
    columns: (1.2fr, 2.5fr, 2.3fr),
    [#par(justify: false)[Metodo]], [#par(justify: false)[Endpoint]], [#par(justify: false)[Note]],
    [#par(justify: false)[`metrics(res)`]],
    [#par(justify: false)[`GET /metrics`]],
    [#par(justify: false)[Imposta `Content-Type` dal registry e invia la stringa delle metriche]],
  )

  ===== MetricsInterceptor

  Intercettatore globale registrato come `APP_INTERCEPTOR` in `AppModule`.

  _Comportamento:_
  - Salta i contesti non HTTP
  - Incrementa il gauge in-flight all'ingresso
  - Usa `finalize` per registrare durata, risolvere route, osservare la richiesta e decrementare il gauge

  === Database

  Il file `data-source.ts` configura il TypeORM DataSource per le migration CLI:
  - `type: 'postgres'`
  - `entities: join(__dirname, '..', '**', '*.entity.{ts,js}')`
  - `migrations: join(__dirname, '..', 'migrations', '*.ts')` e `*.js`
  - Variabili: `MEASURES_DB_HOST`, `MEASURES_DB_PORT`, `MEASURES_DB_USER`, `MEASURES_DB_PASSWORD`, `MEASURES_DB_NAME`,
    `DB_SSL`

  La cartella `migrations/` esiste ma contiene solo `.gitkeep` (nessuna migration al momento).

  == Entità
  #table(
    columns: (1.5fr, 2fr),
    [#par(justify: false)[Entità]], [#par(justify: false)[Campi]],

    [#par(justify: false)[MeasureEntity]],
    [#par(justify: false)[
      *`time`*: `timestamptz` `(PK)`, *`tenantId`*: `uuid`, *`gatewayId`*: `uuid`, *`sensorId`*: `uuid` `(PK)`,
      *`sensorType`*: `varchar(255)`, *`encryptedData`*: `varchar(255)`, *`iv`*: `varchar(255)`, *`authTag`*:
      `varchar(255)`, *`keyVersion`*: `integer`
    ]],
  )

  _Chiave primaria composita:_ `(time, sensor_id)`

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
    del modulo. I *`Mapper`* consentono di incapsulare la logica di trasformazione dei dati (inclusa la normalizzazione
    di timestamp, la conversione base64->hex per IV/authTag/encryptedData), mantenendo i controller e i servizi
    focalizzati sulle rispettive responsabilità di esposizione API e logica applicativa.
  ]

  #st.design-rationale(title: "Utilizzo di TypeORM")[
    La scelta di utilizzare TypeORM come strumento di accesso alla persistenza è stata guidata dalla necessità di
    interagire con un database PostgreSQL/TimescaleDB in modo efficiente e strutturato. TypeORM offre un'astrazione di
    alto livello per la definizione delle entità, la costruzione delle query e la gestione delle connessioni al
    database. L'adozione di TypeORM ha permesso di implementare in modo rapido e robusto le operazioni di query paginata
    (con cursor-based pagination composta) e non paginata sulle misure.
  ]

  #st.design-rationale(title: "Cursor-based Pagination Composta")[
    La paginazione utilizza un cursore composto `(time, sensorId)` per garantire ordinamento deterministico e
    consistenza anche in presenza di misure con lo stesso timestamp. Il cursore viene codificato come stringa
    `time|sensorId` e decodificato dal persistence service per costruire la clausola `WHERE (time < cursorTime OR
    (time = cursorTime AND sensorId < cursorSensorId))`. Questo approccio evita duplicazioni o salti di record tra
    pagine consecutive.
  ]

  #st.design-rationale(title: "Streaming con RxJS e NATS")[
    Lo streaming SSE è implementato tramite RxJS: ogni tenant ha un `Subject` dedicato che riceve eventi live da
    `TelemetryStreamBridgeService` (sottoscritto a NATS). Lo stream concatena un replay storico (opzionale, via query
    non paginata) con gli eventi live. Il stream termina automaticamente alla scadenza del JWT (`tokenExpiresAt`)
    tramite `takeUntil`, emettendo un evento di errore `token_expired`. Questo design disaccoppia la fonte eventi (NATS)
    dalla consegna al client (SSE) permettendo filtri per-tenant e per-sensore.
  ]

  == Flussi di Esecuzione

  Di seguito sono descritti i principali flussi di esecuzione del servizio `notip-data-api`, con particolare attenzione
  ai componenti applicativi coinvolti nell'elaborazione delle richieste e nell'accesso ai dati.

  === Query Paginata delle Misure

  Il client invia una richiesta `GET` all'endpoint `/measures/query`, specificando l'intervallo temporale di interesse
  ed eventuali filtri su `gatewayId`, `sensorId` e `sensorType`. Il `MeasureController` raccoglie i parametri di query,
  normalizza gli array e costruisce l'oggetto `QueryInput` per il `MeasureService`.

  Il `MeasureService` valida i parametri ricevuti, verificando in particolare il limite massimo (`limit <= 999`) e la
  dimensione della finestra temporale (`<= 24h`). In caso di validazione positiva, la richiesta viene delegata al
  `MeasurePersistenceService`, che costruisce una query TypeORM sull'entità `MeasureEntity` con filtri e cursor-based
  pagination composta `(time, sensorId)`, recuperando `limit + 1` righe per determinare `hasMore`.

  I dati ottenuti vengono poi trasformati tramite `MeasureMapper` in oggetti `QueryResponseDto`, comprensivi della lista
  delle misure (con normalizzazione timestamp e conversione base64->hex), dell'eventuale `nextCursor` e
  dell'informazione `hasMore`, quindi restituiti al client.

  === Export Completo delle Misure

  Il flusso di export viene attivato tramite una richiesta `GET` all'endpoint `/measures/export`. Il `MeasureController`
  estrae i parametri di filtro e li inoltra al `MeasureService`.

  Il servizio applicativo verifica la correttezza dell'intervallo temporale richiesto (max 24h) e, se i parametri
  risultano validi, invoca il `MeasurePersistenceService` per eseguire una query non paginata sull'insieme delle misure
  persistite, ordinata per `time DESC`. I record recuperati vengono successivamente convertiti in `EncryptedEnvelopeDto`
  mediante `MeasureMapper`.

  Il client riceve quindi l'elenco completo delle misure cifrate compatibili con i filtri indicati.

  === Streaming delle Misure (SSE)

  Il servizio espone un flusso continuo di eventi tramite l'endpoint `/measures/stream`, implementato come Server-Sent
  Events. Il `MeasureController` raccoglie gli eventuali filtri e il parametro `since`, quindi delega la gestione dello
  stream a `StreamListenerService`.

  Lo `StreamListenerService` genera un flusso osservabile che concatena:
  1. *Replay storico*: se `since` è definito, esegue una query non paginata su `[since, now]` ed emette ogni misura come
    evento `data`.
  2. *Eventi live*: sottoscrive al `Subject` del tenant e filtra gli eventi per `gatewayId`/`sensorId`/`sensorType`.

  Se il token JWT è già scaduto (`tokenExpiresAt <= Date.now()`), emette immediatamente un evento di errore
  `token_expired`. Altrimenti, usa `takeUntil` per terminare lo stream alla scadenza del token.

  Ogni evento compatibile viene trasformato nel formato SSE e inviato al client. Questo flusso consente al client di
  ricevere aggiornamenti continui senza dover effettuare polling esplicito.

  === Elenco dei Sensori Disponibili

  Il client può richiedere l'elenco dei sensori osservati di recente tramite l'endpoint `GET /sensor`. Il
  `SensorController` costruisce l'input applicativo e lo inoltra al `SensorService`.

  Il `SensorService` definisce automaticamente una finestra temporale degli ultimi dieci minuti e interroga il livello
  di persistenza attraverso l'interfaccia `NpQueryPersistenceService` (implementata da `MeasurePersistenceService`). Le
  misure recuperate vengono aggregate in memoria: per ogni chiave univoca `gatewayId::sensorId::sensorType` viene
  mantenuta la misura con il `time` più recente, che diventa il `lastSeen` del sensore.

  Il risultato finale viene convertito in `SensorDto` e restituito come elenco dei sensori disponibili, eventualmente
  filtrato per `gatewayId`.

  === Validazione Tenant (TenantAccessGuard)

  Ad ogni richiesta HTTP, il `TenantAccessGuard` globale intercetta il flusso:
  1. Salta la validazione per path pubblici (`/`, `/metrics`) e richieste `OPTIONS`.
  2. Estrae il Bearer token dall'header `Authorization`.
  3. Chiama `GET ${MGMT_API_URL}/auth/tenant-status` con il token.
  4. Mappa la risposta: 401 -> `UnauthorizedException`, 403 -> `ForbiddenException`, altro errore ->
    `ServiceUnavailableException`.
  5. Se il tenant è in modalità `readOnly`, blocca tutti i metodi non-GET/HEAD/OPTIONS con `ForbiddenException`.

  === Bridge NATS -> SSE (TelemetryStreamBridgeService)

  All'avvio del modulo, il `TelemetryStreamBridgeService`:
  1. Si connette a NATS con le opzioni configurate (TLS/token/user-pass).
  2. Sottoscrive al subject wildcard `telemetry.data.*.*`.
  3. Per ogni messaggio ricevuto:
    - Estrae il `tenantId` dal subject (`telemetry.data.{tenantId}.{something}`).
    - JSON-parsa l'envelope e valida i campi richiesti.
    - Pubblica la misura sul `Subject` del tenant tramite `StreamListenerService.publishLiveMeasure()`.

  I client SSE connessi allo stream ricevono l'evento in tempo reale, filtrato per i parametri richiesti.

  = Test e Verifica

  Il progetto include:

  - unit test sui servizi applicativi (MeasureService, SensorService, StreamListenerService);
  - unit test sui controller (MeasureController, SensorController);
  - unit test sul componente di persistenza (MeasurePersistenceService);
  - unit test sulle metriche (MetricsService, MetricsInterceptor);
  - unit test sulla validazione ambiente (env.validation);
  - integration test applicativi con persistenza in memoria e stream mockato.

  Le verifiche coperte dai test includono in particolare:

  - corretto mapping di query ed export;
  - rispetto del limite massimo di paginazione (`999`);
  - rispetto del vincolo massimo di `24` ore sulla finestra temporale;
  - cursor-based pagination composta `(time, sensorId)`;
  - deduplicazione dei sensori e calcolo del `lastSeen`;
  - corretto filtraggio dello stream per gateway/sensore/tipo;
  - terminazione dello stream con `token_expired` alla scadenza del JWT;
  - bridge NATS -> StreamListenerService;
  - corretto funzionamento del TenantAccessGuard (read-only mode);
  - corretta propagazione delle eccezioni HTTP;
  - metriche Prometheus (counter, histogram, gauge).

  Questa copertura consente di validare il comportamento funzionale principale del servizio, soprattutto per quanto
  riguarda i contratti esposti, la gestione dei casi di errore e l'integrazione con NATS.

  = Considerazioni Finali

  Il servizio `data-api` costituisce il punto di accesso applicativo ai dati telemetrici cifrati del sistema. La
  soluzione è costruita con una separazione chiara tra API, logica applicativa, mapping e accesso ai dati.

  Le funzionalità principali includono:
  - consultazione paginata delle misure con cursor-based pagination composta;
  - export completo con validazione della finestra temporale;
  - streaming SSE con replay storico e eventi live da NATS;
  - discovery dei sensori attivi con finestra automatica di 10 minuti;
  - validazione dello stato del tenant tramite guard globale;
  - esposizione di metriche Prometheus;
  - integrazione NATS per telemetria live e calcolo costi.

  Il dominio di consultazione delle misure risulta ben definito sul piano contrattuale e della validazione applicativa,
  con un'architettura pronta a evolvere verso integrazioni più complete lato persistenza e streaming.
]
