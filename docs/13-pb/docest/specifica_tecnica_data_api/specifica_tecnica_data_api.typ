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

  Il servizio `data-api` è un microservizio applicativo sviluppato con framework NestJS, deputato all'esposizione di
  funzionalità di consultazione delle misure cifrate raccolte dal sistema. Il servizio rende disponibili endpoint HTTP
  per l'interrogazione paginata delle misure, l'esportazione completa di un intervallo temporale, la fruizione in
  streaming dei dati e l'elenco dei sensori osservati di recente.

  L'obiettivo del componente è fornire un punto di accesso unificato ai dati telemetrici già acquisiti e persistiti,
  mantenendo separata la logica di esposizione API dalla logica di accesso alla persistenza. Il servizio restituisce
  verso i client esclusivamente payload cifrati e metadati tecnici associati alla misura, senza effettuare operazioni di
  decifratura.

  Il progetto è strutturato in moduli NestJS distinti per le funzionalità `measure` e `sensor`, con utilizzo di DTO per
  i contratti esposti, model interni per la logica applicativa e servizi dedicati per orchestrazione, filtraggio e
  accesso ai dati.

  = Dipendenze e Configurazione

  == Stack Tecnologico

  Il servizio è implementato in TypeScript su piattaforma Node.js, utilizzando le seguenti tecnologie principali:

  - NestJS come framework applicativo e di dependency injection.
  - TypeORM per l'accesso astratto alla persistenza.
  - RxJS per la gestione dello stream di eventi.
  - Swagger/OpenAPI per la generazione del contratto REST.
  - Jest per unit test e integration test.

  == Variabili d'Ambiente
  Tutte le variabili d’ambiente necessarie per il funzionamento del microservizio sono elencate
  di seguito, una eventuale mancanza di una di queste variabili comporterà un errore all’avvio
  del microservizio:
  #table(
    columns: (1.4fr, 2.5fr, 1.2fr, 1.2fr),
    [Campo], [Variabile d'ambiente], [Default], [obbligatorio],
    [`DataApiPort`], [DATA_API_PORT], [`3000`], [Sì],
    [`DBHost`], [MEASURES_DB_HOST], [`-`], [Sì],
    [`DBPort`], [MEASURES_DB_PORT], [`5432`], [Sì],
    [`DBName`], [MEASURES_DB_NAME], [`-`], [Sì],
    [`DBUser`], [MEASURES_DB_USER], [`-`], [Sì],
    [`DBPassword`], [MEASURES_DB_PASSWORD], [`-`], [Sì],
  )

  == Sequenza di Avvio
  La sequenza di avvio è la seguente:

  #table(
    columns: (auto, 2fr, 3fr),
    [Step], [Componente], [Azione],
    [1], [`NestFactory`], [Istanzia l'applicazione NestJS],
    [2], [`AppModule`], [Carica il modulo radice dell'applicazione],
    [3], [`MeasureModule` e `SensorModule`], [Importa i moduli funzionali esposti dal servizio],
    [4], [HTTP listener], [Espone il listener HTTP sulla porta configurata],
    [5], [`/`], [Rende disponibile un endpoint base di test che restituisce `Hello World!`],
  )

  = Architettura Logica

  #align(center)[
    #image("./assets/data-api.jpg", width: 100%)
  ]


  == Impostazione Architetturale

  Il servizio adotta un'architettura modulare a responsabilità separate, basata sui concetti nativi di NestJS. Le
  responsabilità principali sono suddivise come segue:

  - `controller`: esposizione degli endpoint HTTP e trasformazione dei parametri di input;
  - `service`: orchestrazione della logica applicativa, validazione e gestione delle eccezioni;
  - `persistence service`: accesso alla persistenza tramite repository TypeORM;
  - `mapper`: conversione tra entity di persistenza, model interni e DTO esposti;
  - `dto`: definizione del contratto di risposta verso i client;
  - `interfaces`: definizione dei contratti di input e delle porte applicative.

  Il sistema implementa una _layered architecture_. È presente infatti una distinzione chiara tra: strato di
  esposizione, strato applicativo e strato di accesso ai dati. I componenti collaborano tramite Dependency Injection
e, dove opportuno, tramite interfacce e contratti applicativi. La presenza di Business Models,
DTO ed Entities ha portato all’introduzione di Mappers per la conversione dei dati tra i
diversi livelli dell’applicazione.

  == Layout dei Package

  ```text
  notip-data-api/
  ├── src/
  │   ├── data-api/                        Logica API di misure e sensori
  │   │   ├── controller/                  Controller HTTP NestJS
  │   │   │                                (MeasureController, SensorController)
  │   │   │   
  │   │   ├── services/                    Logica applicativa e accesso ai dati
  │   │   │                                (MeasureService, SensorService,
  │   │   │                                MeasurePersistenceService, StreamListenerService)
  │   │   │    
  │   │   ├── entity/                      Entity TypeORM (MeasureEntity)
  │   │   │                                
  │   │   ├── models/                      Modelli dominio interni (EncryptedEnvelopeModel,
  │   │   │                                PaginatedQueryModel, SensorModel)
  │   │   │                                
  │   │   ├── dto/                         DTO esposti dall'API
  │   │   │                                (EncryptedEnvelopeDto, QueryResponseDto,
  │   │   │                                SensorDto, ErrorResponseDto)
  │   │   │
  │   │   ├── interfaces/                  Contratti e token di injection
  │   │   │                                (QueryInput, ExportInput, StreamInput,
  │   │   │                                GetSensorsInput, persistence interfaces)
  │   │   │   
  │   │   ├── measure.module.ts            Modulo NestJS per la parte misure
  │   │   │ 
  │   │   ├── sensor.module.ts             Modulo NestJS per la parte sensori
  │   │   │ 
  │   │   ├── measure.mapper.ts            Mapper tra Entity, Model e DTO
  │   │   │ 
  │   │   └── openapi.decorators.ts        Decoratori condivisi Swagger/OpenAPI
  │   │
  │   ├── app.module.ts                    Modulo root e configurazione TypeORM
  │   │
  │   ├── app.controller.ts                Controller base dell'app
  │   │
  │   ├── app.service.ts                   Service base dell'app
  │   │
  │   └── main.ts                          Bootstrap NestJS

  ```


  == Strati Architetturali

  #table(
    columns: (18%, 35%, 47%),
    inset: 8pt,
    stroke: 0.6pt + rgb("#666"),
    fill: (_, y) => if y == 0 { luma(230) },
    align: (x, y) => if x == 1 { left } else { left + top },

    table.header(
      [*Strato*],
      [*Package*],
      [*Contenuto*],
    ),

    [Presentation],
    [
      `src/app.controller.ts` \
      `src/data-api/controller` \
      `src/data-api/dto` \
      `src/data-api/openapi.decorators.ts` \
      `src/generated/openapi`
    ],
    [
      Esposizione delle API HTTP, definizione dei contratti di ingresso/uscita,
      documentazione OpenAPI e gestione del livello di interazione con i client.
    ],

    [Application / Business],
    [
      `src/app.service.ts` \
      `src/data-api/services` \
      `src/data-api/models` \
      `src/data-api/interfaces` \
      `src/data-api/measure.mapper.ts`
    ],
    [
      Logica applicativa e di dominio: validazione dei parametri di query,
      orchestrazione dei casi d'uso, trasformazione tra entity/model/DTO,
      filtraggio dei dati e definizione delle interfacce tra componenti.
    ],

    [Persistence],
    [
      `src/data-api/entity` \
      `src/data-api/services/`\
      `measure.persistence.service.ts`
    ],
    [
      Accesso ai dati tramite TypeORM, definizione dell'entità `MeasureEntity`,
      costruzione delle query paginated e non-paginated su PostgreSQL e
      incapsulamento delle operazioni di persistenza.
    ],
  )


  = Definizione dei Port

  == Driving Port

  I driving port del servizio sono gli endpoint HTTP esposti ai client consumer.

  #st.port-interface(
    name: "GET /measures/query",
    kind: "driving",
    description: [Restituisce una pagina di misure cifrate comprese in una finestra temporale richiesta.],
    methods: (
      ("from / to", [Timestamp iniziale e finale inclusivi in formato ISO 8601]),
      ("limit / cursor", [Paginazione con default `1000`, massimo `1000` e cursore opaco]),
      ("gatewayId / sensorId / sensorType", [Filtri ripetibili applicati alla query]),
      ("response", [`data`, `nextCursor`, `hasMore`]),
    ),
  )

  #st.port-interface(
    name: "GET /measures/export",
    kind: "driving",
    description: [Restituisce tutte le misure cifrate che ricadono nella finestra temporale richiesta, senza
      paginazione.],
    methods: (
      ("from / to", [Intervallo temporale richiesto]),
      ("gatewayId / sensorId / sensorType", [Filtri opzionali]),
      ("response", [Array di buste cifrate con metadati della misura e payload cifrato]),
    ),
  )

  #st.port-interface(
    name: "GET /measures/stream",
    kind: "driving",
    description: [Espone uno stream Server-Sent Events (`text/event-stream`) di misure cifrate.],
    methods: (
      ("gatewayId / sensorId / sensorType", [Filtri opzionali per lo stream live]),
      ("response", [Eventi SSE contenenti una misura cifrata per evento]),
    ),
  )

  #st.port-interface(
    name: "GET /sensor",
    kind: "driving",
    description: [Restituisce l'elenco univoco dei sensori visti negli ultimi dieci minuti, con possibilità di filtro
      per `gatewayId`.],
    methods: (
      ("gatewayId", [Filtro opzionale per gateway]),
      ("response", [`sensorId`, `sensorType`, `gatewayId`, `lastSeen`]),
    ),
  )

  == Driven Port

  I driven port del servizio rappresentano le dipendenze verso componenti esterni o infrastrutturali.

  #st.port-interface(
    name: "MeasurePersistenceService",
    kind: "driven",
    description: [Adapter verso la persistenza delle misure, utilizzato dal dominio applicativo per interrogazioni
      paginate e non paginate.],
    methods: (
      ("paginatedQuery", [Recupera una pagina ordinata di misure con supporto a `limit` e `cursor`]),
      ("nonPaginatedQuery", [Recupera tutte le misure corrispondenti ai filtri richiesti]),
    ),
  )

  #st.port-interface(
    name: "NpQueryPersistenceService",
    kind: "driven",
    description: [Interfaccia utilizzata dal servizio sensori mediante token di injection `NP_QUERY_PERSISTENCE`, per
      mantenere basso l'accoppiamento rispetto all'implementazione concreta.],
    methods: (
      ("nonPaginatedQuery", [Fornisce le misure necessarie alla costruzione dell'elenco sensori recenti]),
    ),
  )

  #st.port-interface(
    name: "Repository<MeasureEntity>",
    kind: "driven",
    description: [Dipendenza TypeORM utilizzata per costruire query dinamiche in base ai filtri ricevuti.],
    methods: (
      ("where / andWhere", [Applica i filtri su intervallo temporale e attributi funzionali]),
      ("orderBy", [Ordina i risultati per timestamp decrescente]),
      ("getMany", [Recupera i record corrispondenti alla query]),
    ),
  )

  #st.port-interface(
    name: "StreamListenerService",
    kind: "driven",
    description: [Porta verso la sorgente eventi live. Nella versione corrente la sorgente è simulata internamente
      tramite `interval(1000)`, ma il componente è il punto naturale di integrazione con broker o stream processor
      reali.],
    methods: (
      ("listen", [Produce lo stream di misure cifrate filtrabili]),
    ),
  )

  = Design di Dettaglio

  == Modello Dati del Dominio

  La misura persistita è rappresentata da `MeasureEntity`, che include i seguenti campi:

  - `time`
  - `tenantId`
  - `gatewayId`
  - `sensorId`
  - `sensorType`
  - `encryptedData`
  - `iv`
  - `authTag`
  - `keyVersion`

  La rappresentazione esposta verso l'esterno è `EncryptedEnvelopeDto`, che mantiene i dati cifrati e i metadati
  essenziali della misura:

  - identificativo gateway;
  - identificativo sensore;
  - tipo sensore;
  - timestamp;
  - payload cifrato;
  - initialization vector;
  - authentication tag;
  - versione della chiave.

  Per la query paginata viene usato `QueryResponseDto`, che incapsula lista dati, cursore successivo e flag `hasMore`.
  Per l'elenco sensori viene usato `SensorDto`, che espone l'ultima osservazione disponibile per ogni sensore univoco.

  == MeasureController

  Il controller `MeasureController` espone gli endpoint del dominio `measures`.

  Le principali responsabilità del componente sono:

  - lettura dei query parameter HTTP;
  - normalizzazione dei filtri singoli in array tramite `normalizeArrayParam`;
  - costruzione degli input applicativi `QueryInput`, `ExportInput` e `StreamInput`;
  - invocazione dei servizi applicativi;
  - mapping finale delle risposte tramite `MeasureMapper`.

  Il controller non contiene logica di business significativa; delega interamente validazioni e gestione funzionale ai
  servizi.

  == MeasureService

  `MeasureService` implementa la logica applicativa relativa a query ed export delle misure.

  Le responsabilità principali sono:

  - validazione del parametro `limit`;
  - validazione dell'intervallo temporale richiesto;
  - trasformazione degli input API in input di persistenza;
  - invocazione del servizio di persistenza;
  - mapping delle eccezioni provenienti dal layer sottostante in eccezioni HTTP NestJS.

  Le regole applicative esplicite attualmente implementate sono:

  - `limit` massimo consentito: `1000`;
  - ampiezza massima della finestra temporale: `24` ore.

  In caso di violazione vengono generati i codici applicativi:

  - `QUERY_LIMIT_EXCEEDED`
  - `QUERY_WINDOW_EXCEEDED`
  - `EXPORT_WINDOW_EXCEEDED`

  Le eccezioni gestite verso l'esterno sono:

  - `400 Bad Request`
  - `401 Unauthorized`
  - `403 Forbidden`

  == SensorController

  `SensorController` espone l'endpoint `GET /sensor` e delega a `SensorService` il recupero dei sensori osservati di
  recente. Il controller raccoglie l'eventuale filtro `gatewayId` e restituisce il risultato trasformato in `SensorDto`.

  == SensorService

  `SensorService` implementa la logica applicativa per la costruzione dell'elenco sensori. Il componente:

  - calcola una finestra temporale mobile degli ultimi dieci minuti;
  - invoca la porta di persistenza non paginata;
  - aggrega le misure per tripletta `gatewayId`, `sensorId`, `sensorType`;
  - mantiene per ogni chiave il valore `lastSeen` più recente.

  L'algoritmo costruisce una mappa in memoria per deduplicare i sensori e produrre la vista finale destinata ai client.

  Le eccezioni mappate sono:

  - `401 Unauthorized`
  - `403 Forbidden`
  - `404 Not Found`

  == MeasurePersistenceService

  `MeasurePersistenceService` implementa l'accesso alla persistenza tramite TypeORM.

  *Query paginata*

  La query paginata:

  - applica filtri opzionali su gateway, sensore e tipo sensore;
  - applica il range temporale richiesto;
  - applica il filtro su `cursor`, se presente;
  - ordina i risultati in ordine decrescente sul tempo;
  - recupera `limit + 1` record per determinare la presenza di ulteriori pagine;
  - valorizza `hasMore`;
  - calcola `nextCursor` con il timestamp dell'ultimo elemento utile.

  *Query non paginata*

  La query non paginata:

  - applica filtri opzionali;
  - applica la finestra temporale;
  - ordina i risultati in ordine decrescente sul tempo;
  - restituisce tutti i record corrispondenti.

  == StreamListenerService

  `StreamListenerService` è il componente responsabile dell'emissione dello stream live. Attualmente il servizio:

  - genera un evento ogni secondo;
  - costruisce un payload cifrato di esempio;
  - filtra gli eventi in base ai criteri ricevuti in input.

  Il componente rappresenta una implementazione placeholder o mock evolutivo, utile a dimostrare l'interfaccia di
  streaming prima dell'integrazione con una sorgente eventi reale.

  == MeasureMapper

  `MeasureMapper` centralizza le trasformazioni tra:

  - `MeasureEntity` e `EncryptedEnvelopeModel`;
  - `EncryptedEnvelopeModel` e `EncryptedEnvelopeDto`;
  - `PaginatedQuery` e `PaginatedQueryModel`;
  - `PaginatedQueryModel` e `QueryResponseDto`;
  - `SensorModel` e `SensorDto`.

  La presenza del mapper consente di isolare la logica di conversione e di mantenere separati il modello di persistenza,
  il modello interno e il contratto esposto.

  = Contratti API

  == Endpoint `GET /measures/query`

  Scopo: recupero paginato delle misure cifrate.

  Parametri obbligatori:

  - `from`
  - `to`

  Parametri opzionali:

  - `limit`
  - `cursor`
  - `gatewayId`
  - `sensorId`
  - `sensorType`

  Output:

  - struttura `QueryResponseDto`

  Codici di risposta previsti:

  - `200 OK`
  - `400 Bad Request`
  - `401 Unauthorized`
  - `403 Forbidden`

  == Endpoint `GET /measures/export`

  Scopo: esportazione completa delle misure cifrate in una finestra temporale.

  Parametri obbligatori:

  - `from`
  - `to`

  Parametri opzionali:

  - `gatewayId`
  - `sensorId`
  - `sensorType`

  Output:

  - array di `EncryptedEnvelopeDto`

  Codici di risposta previsti:

  - `200 OK`
  - `400 Bad Request`
  - `401 Unauthorized`
  - `403 Forbidden`

  == Endpoint `GET /measures/stream`

  Scopo: sottoscrizione a stream live di misure cifrate.

  Parametri opzionali:

  - `gatewayId`
  - `sensorId`
  - `sensorType`

  Output:

  - stream `text/event-stream` con eventi SSE contenenti una misura cifrata per evento

  Codice di risposta previsto:

  - `200 OK`

  == Endpoint `GET /sensor`

  Scopo: recupero dei sensori osservati negli ultimi dieci minuti.

  Parametri opzionali:

  - `gatewayId`

  Output:

  - array di `SensorDto`

  Codici di risposta previsti:

  - `200 OK`
  - `401 Unauthorized`
  - `403 Forbidden`
  - `404 Not Found`

  = Gestione Errori

  La gestione errori è centralizzata nei servizi applicativi, che intercettano gli errori provenienti dallo strato di
  persistenza o da servizi esterni e li rimappano in eccezioni HTTP NestJS.

  Per il dominio `measures` sono previste in particolare le seguenti condizioni:

  - finestra temporale superiore a `24` ore;
  - limite di paginazione maggiore di `1000`;
  - errori di autenticazione;
  - errori di autorizzazione.

  La struttura di errore esposta è rappresentata da `ErrorResponseDto`, che può includere:

  - `statusCode`
  - `code`
  - `message`
  - `error`

  Tale approccio consente di mantenere uniforme la comunicazione degli errori verso i client e di propagare, quando
  disponibile, il codice applicativo originario.

  = Documentazione del Contratto

  La documentazione OpenAPI è definita centralmente nel file `openapi.decorators.ts` e viene utilizzata per descrivere:

  - `summary` e `description` delle operation;
  - parametri di query;
  - esempi di request e response;
  - media type prodotto;
  - codici di risposta e DTO associati.

  Il contratto generato è disponibile nel file `api-contracts/openapi/openapi.yaml`.

  Nel repository è presente anche un contratto AsyncAPI condiviso (`api-contracts/asyncapi/nats-contracts.yaml`)
  relativo ai subject NATS dell'ecosistema. Tale file descrive il contesto di integrazione complessivo, pur non essendo
  direttamente consumato dal bootstrap corrente del servizio `data-api`.

  = Test e Verifica

  Il progetto include:

  - unit test sui servizi applicativi;
  - unit test sui controller;
  - unit test sul componente di streaming;
  - integration test applicativi con persistenza in memoria e stream mockato (ATTUALMENTE!).

  Le verifiche coperte dai test includono in particolare:

  - corretto mapping di query ed export;
  - rispetto del limite massimo di paginazione;
  - rispetto del vincolo massimo di `24` ore sulla finestra temporale;
  - deduplicazione dei sensori e calcolo del `lastSeen`;
  - corretto filtraggio dello stream;
  - corretta propagazione delle eccezioni HTTP.

  Questa copertura consente di validare il comportamento funzionale principale del servizio, soprattutto per quanto
  riguarda i contratti esposti e la gestione dei casi di errore.

  = Considerazioni Finali

  Il servizio `data-api` costituisce il punto di accesso applicativo ai dati telemetrici cifrati del sistema. La
  soluzione è costruita con una separazione chiara tra API, logica applicativa, mapping e accesso ai dati, ed è
  predisposta per evolvere verso integrazioni più complete lato persistenza e streaming.

  Allo stato attuale, il dominio di consultazione delle misure risulta già ben definito sul piano contrattuale e della
  validazione applicativa, mentre la parte di streaming presenta una implementazione simulata, utile per validare il
  contratto e pronta a essere sostituita con una sorgente eventi reale in una fase successiva.
]
