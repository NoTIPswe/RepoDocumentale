#import "../../00-templates/base_document.typ" as base-document
#import "../specifica_tecnica/st_lib.typ" as st

#let metadata = yaml(sys.inputs.meta-path)
#show figure.where(kind: table): set block(breakable: true)
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
  == Variabili d'Ambiente
  Tutte le variabili d’ambiente necessarie per il funzionamento del microservizio sono elencate di seguito, un'eventuale
  mancanza di una di queste variabili comporterà un errore all’avvio del microservizio:

  #figure(
    caption: [Variabili d'ambiente del microservizio `data-api`],
  )[
    #table(
      columns: (1.4fr, 2.5fr, 1.2fr, 1.2fr),
      table.header([Campo], [Variabile d'ambiente], [Default], [Obbligatorio]),

      [`ApiPort`], [DATA_API_PORT], [`3000`], [No],
      [`DBHost`], [MEASURES_DB_HOST], [`-`], [Sì],
      [`DBPort`], [MEASURES_DB_PORT], [`-`], [Sì],
      [`DBName`], [MEASURES_DB_NAME], [`-`], [Sì],
      [`DBUser`], [MEASURES_DB_USER], [`-`], [Sì],
      [`DBPassword`], [MEASURES_DB_PASSWORD], [`-`], [Sì],
    )
  ]

  == Sequenza di Avvio
  La sequenza di avvio è la seguente:

  #figure(
    caption: [Sequenza di avvio del microservizio `data-api`],
  )[
    #table(
      columns: (auto, 2fr, 3fr),
      table.header([Step], [Componente], [Azione]),

      [1], [`NestFactory`], [Istanzia l'applicazione NestJS a partire dall'`AppModule`.],
      [2], [`AppModule`], [Valida le variabili d'ambiente critiche e carica la configurazione globale.],
      [3], [`TypeOrmModule`], [Stabilisce la connessione al database PostgreSQL per la persistenza delle misure.],
      [4],
      [`MeasureModule` e `SensorModule`],
      [Istanzia i moduli funzionali, i service di logica e i repository di dati.],

      [5], [HTTP listener], [Espone il servizio sulla porta configurata e attiva l'endpoint `/` di health check.],
    )
  ]


  = Architettura Logica

  #figure(
    caption: [Architettura logica del microservizio `data-api`],
  )[
    #image("./assets/data-api.jpg", width: 100%)
  ]


  == Impostazione Architetturale

  Il servizio adotta una Layered Architecture con organizzazione interna di tipo Modular Monolith. All'interno dei vari
  moduli è utilizzato prevalentemente il pattern Controller-Service-Persistence, che consente una chiara separazione
  delle responsabilità tra esposizione API, logica di business e accesso ai dati. I componenti collaborano tramite
  Dependency Injection e, dove opportuno, tramite interfacce e contratti applicativi. La presenza di Business Models,
  DTO ed Entities ha portato all’introduzione di Mappers per la conversione dei dati tra i diversi livelli
  dell’applicazione.


  == Layout dei Moduli

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

  #figure(
    caption: [Strati architetturali del microservizio `data-api`],
  )[
    #table(
      columns: (18%, 35%, 47%),
      inset: 8pt,
      stroke: 0.6pt + rgb("#666"),
      fill: (_, y) => if y == 0 { luma(230) },
      align: (x, y) => if x == 1 { left } else { left + top },

      table.header([Strato], [Package], [Contenuto]),

      [Presentation],
      [
        `src/app.controller.ts` \
        `src/data-api/controller` \
        `src/data-api/dto` \
        `src/data-api/openapi.decorators.ts` \
        `src/generated/openapi`
      ],
      [
        Esposizione delle API HTTP, definizione dei contratti di ingresso/uscita, documentazione OpenAPI e gestione del
        livello di interazione con i client.
      ],

      [Business],
      [
        `src/app.service.ts` \
        `src/data-api/services` \
        `src/data-api/models` \
        `src/data-api/interfaces` \
        `src/data-api/measure.mapper.ts`
      ],
      [
        Logica applicativa e di dominio: validazione dei parametri di query, orchestrazione dei casi d'uso,
        trasformazione tra entity/model/DTO, filtraggio dei dati e definizione delle interfacce tra componenti.
      ],

      [Persistence],
      [
        `src/data-api/entity` \
        `src/data-api/services/`\
        `measure.persistence.service.ts`
      ],
      [
        Accesso ai dati tramite TypeORM, definizione dell'entità `MeasureEntity`, costruzione delle query paginated e
        non-paginated su PostgreSQL e incapsulamento delle operazioni di persistenza.
      ],
    )
  ]

  = Design di Dettaglio

  == Moduli del microservizio
  #figure(
    caption: [Moduli funzionali del microservizio `data-api`],
  )[
    #table(
      columns: (0.5fr, 1fr),
      table.header([Modulo], [Responsabilità]),
      [MeasureModule],
      [
        Gestione delle funzionalità di interrogazione ed esportazione delle misure. Espone gli endpoint dedicati,
        orchestra la logica applicativa tramite `MeasureService` e delega l'accesso ai dati a
        `MeasurePersistenceService` usando TypeORM sull'entità `MeasureEntity`.
      ],

      [SensorModule],
      [
        Gestione delle funzionalità di discovery e consultazione dei sensori disponibili. Espone gli endpoint relativi
        ai sensori, utilizza `SensorService` per costruire la vista logica dei sensori a partire dalle misure persistite
        e riusa `MeasurePersistenceService` come dipendenza di persistenza.
      ],
    )
  ]


  == Entità
  #figure(
    caption: [Entità persistenti del microservizio `data-api`],
  )[
    #table(
      columns: (1.5fr, 2fr),
      table.header([Entità], [Campi]),

      [MeasureEntity],
      [#par(justify: false)[
        *`timestamp`*: `timestamptz`, *`tenantId`*: `uuid`, *`gatewayId`*: `uuid`, *`sensorId`*: `uuid`, *`sensorType`*:
        `string`, *`encryptedData`*: `string`, *`iv`*: `string`, *`authTag`*: `string`, *`keyVersion`*: `number`
      ]],
    )
  ]

  == Endpoint API
  Di seguito è riportato l’elenco completo degli endpoint esposti dal microservizio divisi per area di interesse.

  I campi indicati con *`?`* sono opzionali.
  === Measure

  #show raw.where(lang: "json"): set text(size: 7pt)

  #figure(
    caption: [Endpoint dell'area `Measure` del microservizio `data-api`],
  )[
    #table(
      columns: (0.8fr, 1.4fr, 2fr, 2.2fr, 2.6fr),
      align: (left, left, left, left, left),

      table.header([Metodo], [Endpoint], [Descrizione], [Query Parameters], [Response]),

      [GET],
      [`/measures/query`],
      [#par(justify: false)[
        Restituisce una query paginata delle misure cifrate filtrabili per intervallo temporale, gateway, sensore e tipo
        di sensore.]],
      [```json
      {
      "from": "string",
      "to": "string",
      "limit?": "number",
      "gatewayId?": "string",
      "sensorId?": "string",
      "sensorType?": "string",
      "cursor?": "string"
      }
      ```],
      [```json
      {
      "data":
        [{
          "gatewayId": "string",
          "sensorId": "string",
          "sensorType": "string",
          "timestamp": "string",
          "encryptedData": "string",
          "iv": "string",
          "authTag": "string",
          "keyVersion": "number"
        }],
      "nextCursor?": "string",
      "hasMore": "boolean"
      }
      ```],

      [GET],
      [`/measures/export`],
      [#par(justify: false)[
        Restituisce l'export completo delle misure cifrate in un intervallo temporale, senza paginazione.]],
      [```json
      {
       "from": "string",
       "to": "string",
       "gatewayId?": "string",
       "sensorId?": "string",
       "sensorType?": "string"
       }
      ```],
      [```json
      {
        "data":
        [{
          "gatewayId": "string",
          "sensorId": "string",
          "sensorType": "string",
          "timestamp": "string",
          "encryptedData": "string",
          "iv": "string",
          "authTag": "string",
          "keyVersion": "number"
        }]
      }
      ```],

      [SSE],
      [`/measures/stream`],
      [#par(justify: false)[
        Espone uno stream Server-Sent Events di misure cifrate filtrabile per gateway, sensore e tipo di sensore.]],
      [```json
      {
        "gatewayId?": "string",
        "sensorId?": "string",
        "sensorType?": "string"
      }
      ```],
      [```json
      `text/event-stream`:
      {
        "gatewayId": "string",
        "sensorId": "string",
        "sensorType": "string",
        "timestamp": "string",
        "encryptedData": "string",
        "iv": "string",
        "authTag": "string",
        "keyVersion": "number"
      }
      ```],
    )
  ]

  === Sensor
  #figure(
    caption: [Endpoint dell'area `Sensor` del microservizio `data-api`],
  )[
    #table(
      columns: (1fr, 1.1fr, 2.2fr, 2fr, 2fr),
      align: (left, left, left, left, left),

      [Metodo], [Endpoint], [Descrizione], [Query Parameters], [Response],

      [GET],
      [`/sensors`],
      [#par(justify: false)[
        Restituisce l'elenco dei sensori osservati di recente, con possibilità di filtro per gateway e indicazione
        dell'ultimo timestamp disponibile.]],
      [```json {"gatewayId": "string"}``` ],
      [```json
        [{
          "sensorId": "string",
          "sensorType": "string",
          "gatewayId": "string",
          "lastSeen": "string"
        }]
        ```
      ],
    )
  ]
  === Errori

  Di seguito sono elencati i principali codici di errore restituiti dagli endpoint del microservizio, con una breve
  descrizione di ciascuno. In caso di errori non gestiti o eccezioni impreviste, il microservizio restituisce un errore
  generico 500 Internal Server Error.

  #set par(justify: false)

  #figure(
    caption: [Codici di errore del microservizio `data-api`],
  )[
    #table(
      columns: (12%, 23%, 65%),
      inset: 8pt,
      stroke: 0.6pt + rgb("#666"),
      align: center + horizon,

      table.header([Codice], [Errore], [Descrizione]),

      [400],
      [Bad Request],
      [
        Richiesta non valida. Nel contesto degli endpoint `measure` viene restituito quando i parametri di query sono
        errati, quando `limit` supera `1000` oppure quando la finestra temporale eccede `24` ore. Possono comparire i
        codici applicativi `QUERY_LIMIT_EXCEEDED`, `QUERY_WINDOW_EXCEEDED` ed `EXPORT_WINDOW_EXCEEDED`.
      ],

      [401],
      [Unauthorized],
      [
        Client non autenticato o autenticazione fallita. Questo errore è documentato per gli endpoint `measure` e
        `sensor`.
      ],

      [403],
      [Forbidden],
      [
        Accesso negato alla risorsa richiesta. Nel progetto viene restituito quando il chiamante non ha i permessi
        necessari per consultare misure o sensori.
      ],

      [404],
      [Not Found],
      [
        Risorsa non trovata. Nel contesto dell'endpoint `sensor` può indicare che il gateway richiesto o la risorsa
        associata non è disponibile.
      ],

      [500],
      [Internal Server Error],
      [
        Errore generico del server in presenza di eccezioni non gestite o condizioni impreviste non mappate
        esplicitamente a un codice HTTP applicativo.
      ],
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

  #st.design-rationale(title: "Utilizzo di TypeORM")[
    La scelta di utilizzare TypeORM come strumento di accesso alla persistenza è stata guidata dalla necessità di
    interagire con un database PostgreSQL in modo efficiente e strutturato. TypeORM offre un'astrazione di alto livello
    per la definizione delle entità, la costruzione delle query e la gestione delle connessioni al database,
    semplificando notevolmente lo sviluppo del livello di persistenza. Inoltre, TypeORM si integra bene con NestJS,
    consentendo di sfruttare appieno le funzionalità di Dependency Injection e la modularità del framework. L'adozione
    di TypeORM ha permesso di implementare in modo rapido e robusto le operazioni di query paginata e non paginata sulle
    misure, garantendo al contempo una buona manutenibilità e scalabilità del codice di accesso ai dati.
  ]
  == Flussi di Esecuzione

  Di seguito sono descritti i principali flussi di esecuzione del servizio `notip-data-api`, con particolare attenzione
  ai componenti applicativi coinvolti nell'elaborazione delle richieste e nell'accesso ai dati.

  === Query Paginata delle Misure

  Il client invia una richiesta `GET` all'endpoint `/measures/query`, specificando l'intervallo temporale di interesse
  ed eventuali filtri su `gatewayId`, `sensorId` e `sensorType`. Il `MeasureController` raccoglie i parametri di query e
  costruisce l'oggetto di input per il `MeasureService`.

  Il `MeasureService` valida i parametri ricevuti, verificando in particolare il limite massimo degli elementi richiesti
  e la dimensione della finestra temporale. In caso di validazione positiva, la richiesta viene delegata al
  `MeasurePersistenceService`, che costruisce una query TypeORM sull'entità `MeasureEntity` e recupera una pagina di
  risultati dal database PostgreSQL.

  I dati ottenuti vengono poi trasformati tramite `MeasureMapper` in oggetti `QueryResponseDto`, comprensivi della lista
  delle misure, dell'eventuale `nextCursor` e dell'informazione `hasMore`, quindi restituiti al client.

  === Export Completo delle Misure

  Il flusso di export viene attivato tramite una richiesta `GET` all'endpoint `/measures/export`. Anche in questo caso
  il `MeasureController` estrae i parametri di filtro e li inoltra al `MeasureService`.

  Il servizio applicativo verifica la correttezza dell'intervallo temporale richiesto e, se i parametri risultano
  validi, invoca il `MeasurePersistenceService` per eseguire una query non paginata sull'insieme delle misure
  persistite. I record recuperati vengono successivamente convertiti in `EncryptedEnvelopeDto` mediante `MeasureMapper`.

  Il client riceve quindi l'elenco completo delle misure cifrate compatibili con i filtri indicati.

  === Streaming delle Misure

  Il servizio espone un flusso continuo di eventi tramite l'endpoint `/measures/stream`, implementato come Server-Sent
  Events. Il `MeasureController` raccoglie gli eventuali filtri su gateway, sensore e tipo di sensore, quindi delega la
  gestione dello stream a `StreamListenerService`.

  Lo `StreamListenerService` genera un flusso osservabile di eventi e applica i filtri richiesti dal client. Ogni evento
  compatibile viene trasformato dal controller nel formato previsto per SSE, incapsulando i dati della misura cifrata
  all'interno del campo `data`.

  Questo flusso consente al client di ricevere aggiornamenti continui senza dover effettuare polling esplicito sugli
  endpoint di query.

  === Elenco dei Sensori Disponibili

  Il client può richiedere l'elenco dei sensori osservati di recente tramite l'endpoint `GET /sensor`. Il
  `SensorController` costruisce l'input applicativo e lo inoltra al `SensorService`.

  Il `SensorService` definisce automaticamente una finestra temporale degli ultimi dieci minuti e interroga il livello
  di persistenza attraverso l'interfaccia `NpQueryPersistenceService`, concretamente implementata da
  `MeasurePersistenceService`. Le misure recuperate vengono aggregate in memoria per identificare i sensori univoci e
  calcolare, per ciascuno di essi, l'ultimo istante di osservazione.

  Il risultato finale viene convertito in `SensorDto` e restituito come elenco dei sensori disponibili, eventualmente
  filtrato per `gatewayId`.

  = Test e Verifica

  Il progetto include:

  - unit test sui servizi applicativi;
  - unit test sui controller;
  - unit test sul componente di streaming;
  - integration test applicativi con persistenza in memoria e stream mockato.

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
