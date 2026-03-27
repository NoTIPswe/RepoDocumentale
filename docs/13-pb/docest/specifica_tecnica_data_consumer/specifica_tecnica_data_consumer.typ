#import "../../00-templates/base_document.typ" as base-document
#import "../specifica_tecnica/st_lib.typ" as st

#let metadata = yaml(sys.inputs.meta-path)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Specifica tecnica del microservizio notip-data-consumer: architettura interna, value object di dominio, definizione dei port, design di dettaglio degli adapter, schema del database e metodologie di testing.",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[

  = Introduzione

  Questo documento illustra l'architettura interna e le scelte implementative del microservizio `notip-data-consumer`.
  Sviluppato in Go, questo componente opera esclusivamente nel backend e ha la duplice responsabilità di consumare i
  flussi telemetrici da NATS JetStream per persisterli in batch sotto forma di blob opachi in TimescaleDB, e di
  tracciare la liveness dei gateway IoT tramite un meccanismo di heartbeat in-memory. Espone un server HTTP con due
  endpoint: `/metrics` (Prometheus) e `/healthz` (health check con verifica DB).

  Per l'esatta struttura dei payload e i contratti delle interfacce, il codice sorgente costituisce la Single Source of
  Truth.

  = Dipendenze e Configurazione

  == Variabili d'Ambiente

  Tutte le variabili sono caricate all'avvio da `internal/config`. La mancanza di una variabile obbligatoria causa un
  crash immediato. Il caricatore utilizza un pattern di accumulo dell'errore: la prima lettura fallita invalida tutte le
  successive senza ulteriori branch.

  #table(
    columns: (2fr, 2.2fr, 1.2fr, auto),
    [Campo], [Variabile d'ambiente], [Default], [Obbligatorio],
    [`NATSUrl`], [`NATS_URL`], [—], [Sì],
    [`NATSTlsCa`], [`NATS_TLS_CA`], [—], [Sì],
    [`NATSTlsCert`], [`NATS_TLS_CERT`], [—], [Sì],
    [`NATSTlsKey`], [`NATS_TLS_KEY`], [—], [Sì],
    [`NATSConsumerDurableName`], [`NATS_CONSUMER_DURABLE_NAME`], [`data-consumer-telemetry`], [No],
    [`NATSConnectTimeoutSeconds`], [`NATS_CONNECT_TIMEOUT_SECONDS`], [`10`], [No],
    [`DBHost`], [`DB_HOST`], [—], [Sì],
    [`DBPort`], [`DB_PORT`], [`5432`], [No],
    [`DBName`], [`DB_NAME`], [—], [Sì],
    [`DBUser`], [`DB_USER`], [—], [Sì],
    [`DBPasswordFile`], [`DB_PASSWORD_FILE`], [—], [Sì],
    [`DBMaxConns`], [`DB_MAX_CONNS`], [`10`], [No],
    [`DBMinConns`], [`DB_MIN_CONNS`], [`2`], [No],
    [`DBSSLMode`], [`DB_SSL_MODE`], [`"require"`], [No],
    [`GatewayBufferSize`], [`GATEWAY_BUFFER_SIZE`], [`1000`], [No],
    [`HeartbeatTickMs`], [`HEARTBEAT_TICK_MS`], [`10000`], [No],
    [`HeartbeatGracePeriodMs`], [`HEARTBEAT_GRACE_PERIOD_MS`], [`120000`], [No],
    [`AlertConfigRefreshMs`], [`ALERT_CONFIG_REFRESH_MS`], [`300000`], [No],
    [`AlertConfigDefaultTimeoutMs`], [`ALERT_CONFIG_DEFAULT_TIMEOUT_MS`], [`60000`], [No],
    [`AlertConfigMaxRetries`], [`ALERT_CONFIG_MAX_RETRIES`], [`10`], [No],
    [`MetricsAddr`], [`METRICS_ADDR`], [`":9090"`], [No],
  )

  `Config` espone il metodo `GetDatabaseDSN() (string, error)`: legge la password dal Docker secret file indicato da
  `DBPasswordFile`, e costruisce il DSN nel formato `postgres://user:pass@host:port/dbname?sslmode=<DBSSLMode>`.

  == Sequenza di Avvio

  I passi bloccanti interrompono il processo in caso di fallimento. Il processo definisce tre costanti compile-time:
  `natsRRTimeout = 5s`, `telemetryBatchSize = 100`, `telemetryFlushInterval = 500ms`.

  #table(
    columns: (auto, 1.5fr, 2.5fr, auto),
    [Step], [Componente], [Azione], [Bloccante?],
    [0], [`slog`], [Imposta JSON handler su stderr come logger di default], [No],
    [1],
    [`config.Load`],
    [Carica e valida la configurazione da env; costruisce il DSN leggendo la password dal Docker secret file],
    [Sì],

    [2], [`Metrics`], [Crea le metriche Prometheus con `prometheus.DefaultRegisterer`], [No],
    [3],
    [NATS],
    [Connessione a NATS con mTLS (`RootCAs`, `ClientCert`); configura timeout e handler di riconnessione],
    [Sì],

    [4], [JetStream], [Acquisisce il contesto JetStream dalla connessione NATS], [Sì],
    [5],
    [`pgxpool`],
    [Parse DSN, configura `MaxConns`/`MinConns`, crea il pool TimescaleDB; crea il context di segnale (`SIGTERM`,
      `SIGINT`)],
    [Sì],

    [6],
    [Driven adapter],
    [Istanzia `NATSRRClient`, `AlertConfigCache`, `NATSAlertPublisher`, `NATSGatewayStatusUpdater`,
      `PostgresTelemetryWriter`, `SystemClock`],
    [No],

    [7],
    [`HeartbeatTracker`],
    [Costruisce il servizio con tutte le dipendenze; avvia la goroutine `dispatchWorker`],
    [No],

    [8], [Driving adapter], [Istanzia `HeartbeatTickTimer`, `NATSDecommissionConsumer`, `NATSTelemetryConsumer`], [No],

    [9],
    [Prometheus HTTP],
    [Avvia il server HTTP su `MetricsAddr` in una goroutine di background; `/healthz` verifica la raggiungibilità del DB
      via `pool.Ping`],
    [No],

    [10],
    [`AlertConfigCache.Run`],
    [Avvia goroutine: fetch iniziale con backoff, poi loop di refresh periodico; usa i default se tutti i retry
      falliscono],
    [No],

    [11], [`HeartbeatTickTimer`], [Avvia goroutine di background], [No],
    [12], [`NATSDecommissionConsumer`], [Avvia goroutine di background (errori loggati)], [No],
    [13], [`NATSTelemetryConsumer.Run`], [Avvia il consumer JetStream (blocca il main goroutine)], [Sì],
    [—],
    [Signal handler],
    [Su SIGTERM/SIGINT: cancella il root context → consumer telemetria si ferma → consumer decommission si ferma → tick
      timer si ferma → cache alert si ferma → metrics server shutdown → `tracker.Close()` drena il canale di dispatch →
      pool chiude → NATS drain],
    [—],
  )

  #pagebreak()

  = Architettura Logica

  #align(center)[
    #image("./assets/data-consumer.png", width: 100%)
  ]

  == Pattern Architetturale: Architettura Esagonale

  Il servizio adotta l'*architettura esagonale* (Ports & Adapters). La logica di dominio, contenuta interamente in
  `HeartbeatTracker`, dipende esclusivamente da interfacce (_port_) e mai da implementazioni concrete.

  Il "composition root" in `cmd/consumer/main.go` istanzia l'intero grafo di dipendenze tramite constructor injection.

  == Layout dei Package

  ```text
  notip-data-consumer/
  ├── cmd/consumer/           Composition root, graceful shutdown
  ├── internal/
  │   ├── config/             Config struct, loader da env, GetDatabaseDSN
  │   ├── domain/
  │   │   ├── model/          Value object puri (nessuna import infrastrutturale)
  │   │   └── port/           Definizioni di tutti i driving/driven port
  │   ├── service/            HeartbeatTracker
  │   ├── adapter/
  │   │   ├── driven/         PostgresTelemetryWriter, NATSAlertPublisher,
  │   │   │                   NATSGatewayStatusUpdater, AlertConfigCache,
  │   │   │                   NATSRRClient, SystemClock
  │   │   └── driving/        NATSTelemetryConsumer, NATSDecommissionConsumer,
  │   │                       HeartbeatTickTimer
  │   └── metrics/            Prometheus metric handles e narrow-interface methods
  ├── tests/
  │   └── integration/        Test di integrazione Testcontainers (NATS mTLS, TimescaleDB)
  └── migrations/             SQL migrations TimescaleDB
  ```

  == Strati Architetturali

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Strato], [Package], [Contenuto],
    [Dominio],
    [`internal/domain/model`\ `internal/domain/port`\ `internal/service`],
    [Value object puri, definizioni dei port, `HeartbeatTracker`. Nessun package di questo strato contiene importazioni
      infrastrutturali.],

    [Driving Adapter],
    [`internal/adapter/driving`],
    [Traduce eventi esterni in chiamate ai driving port. Tre adapter: messaggi NATS telemetrici (con batch-processing),
      eventi di decommission NATS, tick periodico del timer.],

    [Driven Adapter],
    [`internal/adapter/driven`],
    [Implementazioni dei driven port verso risorse esterne: TimescaleDB, NATS JetStream, Management API (via NATS RR),
      clock di sistema.],
  )

  = Definizione dei Port

  == Driven Port

  Interfacce invocate dagli adapter (o dal dominio), implementate dagli adapter verso risorse esterne.

  #st.port-interface(
    name: "TelemetryWriter",
    kind: "driven",
    description: [Confine di persistenza per i record telemetrici. Isola il dominio dalla tecnologia di storage,
      consentendo la sostituzione del backend senza impatto sulla logica applicativa.],
    methods: (
      ("Write", [Persiste un singolo record telemetrico opaco]),
      ("WriteBatch", [Persiste un batch di record in un'unica operazione di rete]),
    ),
  )

  #st.port-interface(
    name: "AlertPublisher",
    kind: "driven",
    description: [Confine di pubblicazione degli alert infrastrutturali. Disaccoppia la logica di rilevazione offline
      dal meccanismo di distribuzione (JetStream).],
    methods: (
      ("Publish", [Pubblica un alert gateway-offline per un tenant specifico]),
    ),
  )

  #st.port-interface(
    name: "GatewayStatusUpdater",
    kind: "driven",
    description: [Confine di notifica delle transizioni di stato. Isola il dominio dal protocollo NATS Request-Reply
      verso il Management API.],
    methods: (
      ("UpdateStatus", [Notifica una transizione di stato online/offline al Management API]),
    ),
  )

  #st.port-interface(
    name: "AlertConfigProvider",
    kind: "driven",
    description: [Confine di accesso alla configurazione degli alert. Permette al dominio di richiedere il timeout senza
      conoscere la sorgente. Lookup: override gateway → default tenant → default di sistema.],
    methods: (
      ("TimeoutFor", [Restituisce il timeout offline configurato per uno specifico gateway (ms)]),
    ),
  )

  #st.port-interface(
    name: "ClockProvider",
    kind: "driven",
    description: [Astrazione del clock di sistema. Consente l'iniezione di un clock deterministico nei test, eliminando
      la dipendenza diretta da `time.Now()` nella logica di dominio e di servizio.],
    methods: (
      ("Now", [Restituisce il timestamp corrente]),
    ),
  )

  == Driving Port

  Interfacce implementate dal dominio, invocate dagli adapter per immettere eventi nel sistema.

  #st.port-interface(
    name: "TelemetryMessageHandler",
    kind: "driving",
    description: [Punto di ingresso per gli eventi telemetrici decodificati. L'adapter NATS invoca questo port dopo aver
      estratto il `tenantID` dal subject e deserializzato l'envelope.],
    methods: (
      (
        "HandleTelemetry",
        [Aggiorna l'heartbeat del gateway e gestisce le transizioni di stato (prima comparsa, recovery da offline)],
      ),
    ),
  )

  #st.port-interface(
    name: "DecommissionEventHandler",
    kind: "driving",
    description: [Punto di ingresso per gli eventi di decommission gateway. Rimuove il gateway dalla mappa di heartbeat
      per prevenire falsi alert su gateway dismessi.],
    methods: (
      ("HandleDecommission", [Rimuove un gateway dalla mappa di liveness]),
    ),
  )

  #st.port-interface(
    name: "HeartbeatTicker",
    kind: "driving",
    description: [Punto di ingresso per il tick periodico di liveness. Invocato dal timer adapter a intervalli
      configurabili.],
    methods: (
      ("Tick", [Valuta la liveness di tutti i gateway tracciati e genera alert per quelli offline]),
    ),
  )

  #pagebreak()

  = Design di Dettaglio

  == Value Object del Dominio (`internal/domain/model`)

  Tutti i tipi sono data struct, senza logica e senza importazioni infrastrutturali.

  #table(
    columns: (1.5fr, 4fr),
    [Tipo], [Descrizione e campi],
    [`OpaqueBlob`],
    [Named type con campo `Value string` (blob base64). Il tipo rende visibile nel type system l'invariante della
      pipeline opaca: qualunque tentativo di decodifica del contenuto è considerato una violazione di tipo. Espone
      `MarshalJSON` / `UnmarshalJSON` custom che serializzano `Value` come stringa JSON plain, preservando il payload
      base64 invariato attraverso qualsiasi round-trip JSON.],

    [`TelemetryEnvelope`],
    [Wire format di un messaggio NATS su `telemetry.data.{tenantId}.{gwId}`. Campi con JSON tag: `GatewayID string`
      (`gatewayId`), `SensorID string` (`sensorId`), `SensorType SensorType` (`sensorType`), `Timestamp time.Time`
      (`timestamp`), `KeyVersion int` (`keyVersion`), `EncryptedData OpaqueBlob` (`encryptedData`), `IV OpaqueBlob`
      (`iv`), `AuthTag OpaqueBlob` (`authTag`). `TenantID` non è nel body JSON: è estratto dal subject NATS
      dall'adapter.],

    [`SensorType`],
    [Named string type. Vincola `TelemetryEnvelope.SensorType` ai cinque valori definiti nel contratto AsyncAPI:
      `SensorTypeTemperature = "temperature"`, `SensorTypeHumidity = "humidity"`, `SensorTypeMovement = "movement"`,
      `SensorTypePressure = "pressure"`, `SensorTypeBiometric = "biometric"`.],

    [`TelemetryRow`],
    [Record normalizzato scritto su TimescaleDB. Aggiunge `TenantID string` (dal subject NATS) e `Time time.Time`
      (partition key dell'ipertabella) a `TelemetryEnvelope`. I tre `OpaqueBlob` sono passati invariati.],

    [`AlertPayload`],
    [Payload pubblicato su `alert.gw_offline.{tenantId}`. Campi con JSON tag: `GatewayID string` (`gatewayId`),
      `LastSeen time.Time` (`lastSeen`), `TimeoutMs int64` (`timeoutMs`), `Timestamp time.Time` (`timestamp`).],

    [`AlertConfig`], [`TenantID string`; `GatewayID *string` (nil = default tenant); `TimeoutMs int64`.],

    [`GatewayStatusUpdate`],
    [Payload per la chiamata NATS RR su `internal.mgmt.gateway.update-status`. Campi con JSON tag: `GatewayID string`
      (`gateway_id`), `Status GatewayStatus` (`status`), `LastSeenAt time.Time` (`last_seen_at`).],

    [`GatewayStatus`], [Enum: `Online = "online"`, `Offline = "offline"`.],
  )

  === Tipi Interni al Package `service`

  #table(
    columns: (1.5fr, 4fr),
    [Tipo], [Descrizione e campi],
    [`gatewayKey`],
    [Chiave composita per la mappa heartbeat. Usa una struct invece di una stringa formattata per evitare allocazioni e
      ambiguità di collision. Campi unexported: `tenantID string`, `gatewayID string`.],

    [`heartbeatEntry`],
    [Entry per gateway tracciato nella mappa heartbeat. Tipo unexported, manipolato esclusivamente da
      `HeartbeatTracker`. Campi: `tenantID string`, `gatewayID string`, `lastSeen time.Time`,
      `knownStatus GatewayStatus`.],

    [`statusUpdateJob`],
    [Wrapper di `GatewayStatusUpdate` per il canale di dispatch asincrono. Campo: `update GatewayStatusUpdate`.],
  )

  == HeartbeatTracker (`internal/service`)

  Unico servizio di dominio. Implementa i tre driving port `TelemetryMessageHandler`, `DecommissionEventHandler` e
  `HeartbeatTicker`. Gli status update sono inviati in modo asincrono tramite un canale a capacità limitata processato
  da una goroutine worker dedicata, mantenendo `Tick` e `HandleTelemetry` non-bloccanti.

  === Interfaccia Metrica Ristretta

  `HeartbeatTrackerMetrics` — sottoinsieme delle metriche emesse dal tracker:

  #table(
    columns: (2fr, 1fr),
    [Metodo], [Ritorno],
    [`IncStatusUpdateDropped()`], [—],
    [`SetHeartbeatMapSize(v float64)`], [—],
  )

  === Campi

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`clock`], [`ClockProvider`], [Driven port iniettato],
    [`alertPublisher`], [`AlertPublisher`], [Driven port iniettato],
    [`statusUpdater`], [`GatewayStatusUpdater`], [Driven port iniettato],
    [`configProvider`], [`AlertConfigProvider`], [Driven port iniettato],
    [`metrics`], [`HeartbeatTrackerMetrics`], [Driven port iniettato],
    [`startTime`], [`time.Time`], [Registrato alla costruzione via `clock.Now()`],
    [`gracePeriod`], [`time.Duration`], [Derivata da `HeartbeatGracePeriodMs`; soppressione alert post-avvio],
    [`mu`], [`sync.RWMutex`], [Read-lock per snapshot, write-lock per mutazione di `beats`],
    [`beats`], [`map[gatewayKey]*heartbeatEntry`], [Chiave struct composita `{tenantID, gatewayID}`],
    [`dispatchCh`], [`chan statusUpdateJob`], [Coda asincrona bounded per status update],
    [`done`], [`chan struct{}`], [Chiuso alla terminazione di `dispatchWorker`],
    [`closeOnce`], [`sync.Once`], [Garantisce che `Close()` esegua una sola volta],
  )

  === Costruttore

  ```
  NewHeartbeatTracker(
    clock          ClockProvider,
    alertPublisher AlertPublisher,
    statusUpdater  GatewayStatusUpdater,
    configProvider AlertConfigProvider,
    metrics        HeartbeatTrackerMetrics,
    statusUpdateBufSize int,
    gracePeriod    time.Duration,
  ) *HeartbeatTracker
  ```

  Inizializza la mappa heartbeat vuota, crea il canale di dispatch con capacità `statusUpdateBufSize` e avvia la
  goroutine `dispatchWorker`.

  === Metodi Pubblici

  #table(
    columns: (1.5fr, 2.5fr, 1.5fr),
    [Metodo], [Firma], [Implementa],
    [`HandleTelemetry`],
    [`(ctx context.Context, tenantID string, envelope TelemetryEnvelope) error`],
    [`TelemetryMessageHandler`],

    [`HandleDecommission`], [`(tenantID string, gatewayID string)`], [`DecommissionEventHandler`],
    [`Tick`], [`(ctx context.Context)`], [`HeartbeatTicker`],
    [`Close`], [`()`], [—],
  )

  *`HandleTelemetry`*
  + Deriva la chiave composita `gatewayKey{tenantID, envelope.GatewayID}`.
  + Acquisisce write-lock.
  + Se l'entry *non esiste*: crea una nuova entry con `lastSeen = clock.Now()` e `knownStatus = Online`; aggiorna la
    metrica della dimensione della mappa; esegue dispatch di un status update `Online`; ritorna.
  + Se l'entry *esiste*: aggiorna `lastSeen = clock.Now()`.
  + Se l'entry aveva `knownStatus = Offline`: passa a `Online` e inoltra uno status update `Online`.

  *`HandleDecommission`*\
  Acquisisce write-lock. Cancella l'entry per `gatewayKey{tenantID, gatewayID}`. Aggiorna la metrica della dimensione
  della mappa. Nessun altro side effect.

  *`Tick` — approccio a tre fasi*
  + *Grace period check:* se `clock.Now()` è prima di `startTime + gracePeriod`, ritorna immediatamente.
  + *Fase 1 — RLock snapshot:* acquisisce read-lock, copia tutte le entry in uno slice locale (value copy), rilascia
    read-lock.
  + *Fase 2 — I/O fuori dal lock:* per ogni entry nello snapshot: se `knownStatus == Offline` salta; recupera il timeout
    via `configProvider.TimeoutFor`; se non scaduto salta; pubblica alert via `alertPublisher.Publish`; esegue dispatch
    `Offline` via il canale asincrono.
  + *Fase 3 — WLock con re-validazione:* acquisisce write-lock; rilegge l'entry reale dalla mappa; se `lastSeen` è
    avanzato rispetto allo snapshot (telemetria arrivata durante la Fase 2), annulla la transizione. Altrimenti imposta
    `knownStatus = Offline`.

  *`Close`*\
  Chiude `dispatchCh` (idempotente via `sync.Once`). Attende che `dispatchWorker` termini di drenare la coda e chiuda
  `done`.

  === Metodi Privati

  #table(
    columns: (1.5fr, 3.5fr),
    [Metodo], [Comportamento],
    [`dispatchStatusUpdate(update GatewayStatusUpdate)`],
    [Invio non-bloccante su `dispatchCh`; se il canale è pieno, scarta e incrementa `StatusUpdateDropped`.],

    [`dispatchWorker()`],
    [Goroutine di background; processa serialmente i `statusUpdateJob` da `dispatchCh`; chiude `done` alla
      terminazione.],
  )

  == Adapter Driven (`internal/adapter/driven`)

  Ogni adapter definisce un'interfaccia metrica ristretta con i soli metodi che effettivamente emette. La struct
  `Metrics` soddisfa tutte queste interfacce.

  === PostgresTelemetryWriter

  Implementa `TelemetryWriter`. Scrive `TelemetryRow` verbatim su TimescaleDB — i tre `OpaqueBlob` (`EncryptedData`,
  `IV`, `AuthTag`) sono scritti as-is, senza alcuna decodifica. Dipende dall'interfaccia `dbPool` (soddisfatta da
  `*pgxpool.Pool`).

  #table(
    columns: (1.2fr, 1.8fr),
    [Campo], [Tipo],
    [`pool`], [`dbPool`],
  )

  *Interfaccia `dbPool`:*

  #table(
    columns: (1.5fr, 3.5fr),
    [Metodo], [Firma],
    [`Exec`], [`(ctx context.Context, sql string, arguments ...any) (pgconn.CommandTag, error)`],
    [`SendBatch`], [`(ctx context.Context, b *pgx.Batch) pgx.BatchResults`],
    [`Close`], [`()`],
  )

  #table(
    columns: (1.2fr, 2.5fr, 2.3fr),
    [Metodo], [Firma], [Note],
    [`Write`], [`(ctx context.Context, row TelemetryRow) error`], [Singolo INSERT via `pool.Exec`],
    [`WriteBatch`],
    [`(ctx context.Context, rows []TelemetryRow) error`],
    [Costruisce un `pgx.Batch` con un INSERT per riga; singolo round-trip via `pool.SendBatch`; fallisce al primo
      errore; no-op su slice vuoto],

    [`Close`], [`()`], [Rilascia tutte le connessioni del pool],
  )

  === NATSAlertPublisher

  Implementa `AlertPublisher`. Serializza `AlertPayload` in JSON e pubblica su `alert.gw_offline.{tenantId}` via
  JetStream. Il subject è assemblato al momento della pubblicazione. Dipende dall'interfaccia `natsJSPublisher`
  (soddisfatta da `nats.JetStreamContext`).

  *Interfaccia `natsJSPublisher`:*

  #table(
    columns: (1fr, 3fr),
    [Metodo], [Firma],
    [`Publish`], [`(subj string, data []byte, opts ...nats.PubOpt) (*nats.PubAck, error)`],
  )

  *Interfaccia `alertPublisherMetrics`:*

  #table(
    columns: (2fr, 1fr),
    [Metodo], [Ritorno],
    [`IncAlertsPublished()`], [—],
    [`IncAlertPublishErrors()`], [—],
  )

  Il context è accettato per compliance con l'interfaccia ma non propagato a `js.Publish`, la cui API sincrona non
  supporta cancellazione per-chiamata.

  === NATSGatewayStatusUpdater

  Implementa `GatewayStatusUpdater`. Delega la meccanica NATS RR all'interfaccia `gatewayStatusUpdateCaller`
  (soddisfatta da `NATSRRClient`). Incrementa la metrica di errore sui fallimenti.

  *Interfaccia `gatewayStatusUpdateCaller`:*

  #table(
    columns: (1fr, 3fr),
    [Metodo], [Firma],
    [`UpdateGatewayStatus`], [`(ctx context.Context, update GatewayStatusUpdate) error`],
  )

  *Interfaccia `statusUpdateErrRecorder`:*

  #table(
    columns: (2fr, 1fr),
    [Metodo], [Ritorno],
    [`IncStatusUpdateErrors()`], [—],
  )

  #table(
    columns: (1.2fr, 1.8fr),
    [Campo], [Tipo],
    [`client`], [`gatewayStatusUpdateCaller`],
    [`metrics`], [`statusUpdateErrRecorder`],
  )

  #table(
    columns: (1.2fr, 2.8fr),
    [Metodo], [Firma],
    [`UpdateStatus`], [`(ctx context.Context, update GatewayStatusUpdate) error`],
  )

  === AlertConfigCache

  Implementa `AlertConfigProvider`. Mantiene uno snapshot atomicamente sostituibile delle configurazioni di alert,
  aggiornato periodicamente via NATS RR (`internal.mgmt.alert-configs.list`). Le letture in `TimeoutFor` sono lock-free
  tramite `atomic.Pointer[alertConfigSnapshot]`. Il costruttore inizializza con uno snapshot vuoto, rendendo
  `TimeoutFor` sicuro da chiamare immediatamente.

  Lookup in `TimeoutFor`: override gateway → default tenant → `defaultTimeoutMs`.

  Dipende dall'interfaccia `alertConfigFetcher` (soddisfatta da `NATSRRClient`).

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`snapshot`], [`atomic.Pointer[alertConfigSnapshot]`], [Sostituito atomicamente ad ogni refresh],
    [`rrClient`], [`alertConfigFetcher`], [Fetch configurazioni dal Management API],
    [`metrics`], [`alertCacheErrRecorder`], [Contatore errori di refresh],
    [`defaultTimeoutMs`], [`int64`], [Fallback in assenza di configurazione],
    [`refreshInterval`], [`time.Duration`], [Default: 5 minuti],
    [`maxRetries`], [`int`], [Default: 10; con backoff esponenziale],
  )

  *Interfaccia `alertConfigFetcher`:*

  #table(
    columns: (1fr, 3fr),
    [Metodo], [Firma],
    [`FetchAlertConfigs`], [`(ctx context.Context) ([]AlertConfig, error)`],
  )

  *Interfaccia `alertCacheErrRecorder`:*

  #table(
    columns: (2fr, 1fr),
    [Metodo], [Ritorno],
    [`IncAlertCacheRefreshErrors()`], [—],
  )

  #table(
    columns: (1.2fr, 2.5fr, 2.3fr),
    [Metodo], [Firma], [Note],
    [`TimeoutFor`], [`(tenantID, gatewayID string) int64`], [Lock-free; legge dall'atomic pointer],
    [`Run`],
    [`(ctx context.Context)`],
    [Bloccante; fetch iniziale con backoff (`1s → 30s cap`, max `maxRetries`), poi loop di refresh],

    [`refresh`], [`(ctx context.Context) error`], [Fetch e swap atomico dello snapshot],
    [`fetchWithBackoff`],
    [`(ctx context.Context) error`],
    [Retry con backoff esponenziale; incrementa metrica ad ogni tentativo fallito],
  )

  *Snapshot interno `alertConfigSnapshot`* (immutabile dopo la costruzione):
  - `byGateway map[string]AlertConfig` — chiave: `"tenantID/gatewayID"`
  - `byTenant map[string]AlertConfig` — chiave: `tenantID`
  - `fetchedAt time.Time`

  === NATSRRClient

  Helper infrastrutturale condiviso (non un port). Incapsula i meccanismi di NATS Request-Reply (timeout,
  serializzazione, gestione errori). Usato da `AlertConfigCache` (via `alertConfigFetcher`) e da
  `NATSGatewayStatusUpdater` (via `gatewayStatusUpdateCaller`). Dipende dall'interfaccia `natsRequester` (soddisfatta da
  `*nats.Conn`).

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`nc`], [`natsRequester`], [],
    [`timeout`], [`time.Duration`], [Applicato per-tentativo],
    [`maxRetries`], [`int`], [Default: 3],
    [`backoff`], [`[]time.Duration`], [Default: `[1s, 2s, 4s]`],
    [`sleep`], [`func(time.Duration)`], [Iniettato per controllo nei test; produzione usa `time.Sleep`],
  )

  *Interfaccia `natsRequester`:*

  #table(
    columns: (1fr, 3fr),
    [Metodo], [Firma],
    [`RequestWithContext`], [`(ctx context.Context, subj string, data []byte) (*nats.Msg, error)`],
  )

  #table(
    columns: (auto, 2.5fr, 2.3fr),
    [Metodo], [Firma], [Note],
    [`FetchAlertConfigs`],
    [`(ctx context.Context) ([]AlertConfig, error)`],
    [Body nil verso `internal.mgmt.alert-configs.list`; deserializza la risposta JSON],

    [`UpdateGatewayStatus`],
    [`(ctx context.Context, update GatewayStatusUpdate) error`],
    [Serializza l'update in JSON, invia verso `internal.mgmt.gateway.update-status`; deserializza
      `GatewayStatusUpdateResponse` e ritorna errore se `success` è false],
  )

  Ogni metodo delega a `requestWithRetry`: fino a `maxRetries` tentativi, timeout per-tentativo derivato da `timeout`,
  backoff esponenziale dalla slice `backoff`, con verifica della cancellazione del context tra un tentativo e l'altro.

  === SystemClock

  Implementa `ClockProvider`. Adapter stateless che delega a `time.Now()`. Esiste esclusivamente per soddisfare
  l'interfaccia in produzione, permettendo ai test di iniettare un clock controllato.

  == Adapter Driving (`internal/adapter/driving`)

  `NATSTelemetryConsumer` e `NATSDecommissionConsumer` dipendono dall'interfaccia condivisa `natsJSSubscriber`
  (soddisfatta da `nats.JetStreamContext`):

  #table(
    columns: (1fr, 3fr),
    [Metodo], [Firma],
    [`Subscribe`], [`(subj string, cb nats.MsgHandler, opts ...nats.SubOpt) (*nats.Subscription, error)`],
  )

  === NATSTelemetryConsumer

  Sottoscrive `telemetry.data.>` come durable consumer JetStream. I messaggi sono bufferizzati e scritti in batch per il
  throughput.

  Per ogni messaggio NATS:
  + Incrementa la metrica `MessagesReceived`.
  + `processMessage` esegue: parse del body JSON in `TelemetryEnvelope`; estrazione del `tenantID` dal subject; chiamata
    a `TelemetryMessageHandler.HandleTelemetry`; costruzione della `TelemetryRow`.
  + Il risultato è inviato al canale pending per il batch.
  + `flushLoop` accumula i pending e chiama `WriteBatch` al raggiungimento di `batchSize`, allo scadere di `flushEvery`,
    o alla cancellazione del context (flush finale).
  + Dopo `WriteBatch`: ACK su successo; NAK con delay 5s per errori transitori; Term per errori permanenti di parsing
    (NATS non invia nuovamente).

  #table(
    columns: (1.2fr, 1.8fr),
    [Campo], [Tipo],
    [`js`], [`natsJSSubscriber`],
    [`handler`], [`TelemetryMessageHandler`],
    [`writer`], [`TelemetryWriter`],
    [`metrics`], [`telemetryConsumerMetrics`],
    [`durableName`], [`string`],
    [`batchSize`], [`int`],
    [`flushEvery`], [`time.Duration`],
  )

  *Interfaccia `telemetryConsumerMetrics`:*

  #table(
    columns: (2fr, 1fr),
    [Metodo], [Ritorno],
    [`IncMessagesReceived()`], [—],
    [`IncMessagesWritten()`], [—],
    [`IncWriteErrors()`], [—],
    [`ObserveWriteLatency(d time.Duration)`], [—],
  )

  #table(
    columns: (1.2fr, 2.2fr, 2.6fr),
    [Metodo], [Firma], [Note],
    [`Run`], [`(ctx context.Context) error`], [Bloccante; ritorna alla cancellazione del context],
    [`processMessage`],
    [`(ctx context.Context, msg *nats.Msg) (TelemetryRow, error)`],
    [Orchestrazione parse → handle → build; ritorna `permanentError` o errore transitorio],

    [`flushLoop`], [`(ctx context.Context, pending <-chan pendingMsg)`], [Batch con tre trigger di flush],

    [`writeBatch`],
    [`(ctx context.Context, batch []pendingMsg)`],
    [Separa errori permanenti dalle righe valide; chiama `WriteBatch`; ACK/NAK/Term per messaggio],

    [`extractTenantID`], [`(subject string) (string, error)`], [Parsing del subject NATS],
    [`buildRow`], [`(tenantID string, envelope TelemetryEnvelope) TelemetryRow`], [Mapping envelope + tenantID → row],
  )

  *Tipi interni:* `permanentError` — arricchisce un error per segnalare fallimenti non eseguibili nuovamente.
  `pendingMsg` — accoppia un'interfaccia `msgAcknowledger` (soddisfatta da `*nats.Msg`) con la `TelemetryRow`
  decodificata e l'eventuale errore.

  === NATSDecommissionConsumer

  Sottoscrive `gateway.decommissioned.>` via JetStream con ACK manuale. Per ogni messaggio estrae `tenantID` e
  `gatewayID` dal subject (attesi esattamente 4 segmenti dot-separated) e invoca
  `DecommissionEventHandler.HandleDecommission`. Errori di parsing sono Term()'d.

  #table(
    columns: (1.2fr, 1.8fr),
    [Campo], [Tipo],
    [`js`], [`natsJSSubscriber`],
    [`handler`], [`DecommissionEventHandler`],
  )

  #table(
    columns: (1.2fr, 2.8fr),
    [Metodo], [Firma],
    [`Run`], [`(ctx context.Context) error`],
    [`handleMsg`], [`(msg *nats.Msg)`],
    [`extractIDs`], [`(subject string) (tenantID string, gatewayID string, err error)`],
  )

  === HeartbeatTickTimer

  Possiede un `time.Ticker` con intervallo `HeartbeatTickMs`. A ogni scatto invoca `HeartbeatTicker.Tick(ctx)`. Si ferma
  alla cancellazione del context.

  #table(
    columns: (1.2fr, 1.8fr),
    [Campo], [Tipo],
    [`ticker`], [`HeartbeatTicker`],
    [`interval`], [`time.Duration`],
  )

  == Metriche Prometheus (`internal/metrics`)

  La struct `Metrics` è costruita una volta nel composition root tramite `New(reg prometheus.Registerer)`, che accetta
  un registrer esplicito (anziché il global default) per isolare le registrazioni nei test. Iniettata agli adapter
  tramite interfacce metriche ristrette.

  #table(
    columns: (2fr, 1.2fr, 3.5fr, 2.5fr),
    [Campo], [Tipo], [Nome Prometheus], [Descrizione],

    [`MessagesReceived`], [Counter], [`notip_consumer_messages_received_total`], [Messaggi NATS dequeued],
    [`MessageParsingErrors`],
    [Counter],
    [`notip_consumer_message_parsing_errors_total`],
    [Messaggi scartati definitivamente (Term) per JSON malformato o subject errato],

    [`MessagesWritten`], [Counter], [`notip_consumer_messages_written_total`], [Scritture TimescaleDB riuscite],
    [`WriteErrors`], [Counter], [`notip_consumer_write_errors_total`], [Scritture TimescaleDB fallite],
    [`WriteLatency`], [Histogram], [`notip_consumer_write_duration_seconds`], [Durata scrittura su TimescaleDB],
    [`BatchSize`],
    [Histogram],
    [`notip_consumer_batch_size`],
    [Numero di record telemetrici per ogni operazione di flush batch],

    [`AlertsPublished`], [Counter], [`notip_consumer_alerts_published_total`], [Alert gateway-offline pubblicati],
    [`AlertPublishErrors`], [Counter], [`notip_consumer_alert_publish_errors_total`], [Errori di pubblicazione alert],
    [`HeartbeatMapSize`],
    [Gauge],
    [`notip_consumer_heartbeat_map_size`],
    [Gateway attualmente tracciati nella mappa heartbeat],

    [`HeartbeatTickDuration`],
    [Histogram],
    [`notip_consumer_heartbeat_tick_duration_seconds`],
    [Tempo di esecuzione del ciclo di Tick completo],

    [`StatusUpdateErrors`], [Counter], [`notip_consumer_status_update_errors_total`], [Errori NATS RR status update],
    [`StatusUpdateDropped`],
    [Counter],
    [`notip_consumer_status_update_dropped_total`],
    [Status update scartati (canale pieno)],

    [`DispatchQueueLength`],
    [Gauge],
    [`notip_consumer_dispatch_queue_length`],
    [Numero di job attualmente in coda nel canale asincrono],

    [`AlertCacheRefreshErrors`],
    [Counter],
    [`notip_consumer_alert_cache_refresh_errors_total`],
    [Errori refresh cache configurazioni alert],

    [`AlertCacheLastSuccess`],
    [Gauge],
    [`notip_consumer_alert_cache_last_success_timestamp`],
    [Timestamp Unix dell'ultimo fetch configurazioni riuscito],

    [`NATSReconnects`], [Counter], [`notip_consumer_nats_reconnects_total`], [Riconnessioni NATS],
  )

  La struct `Metrics` soddisfa tutte le narrow metric interface tramite i metodi: `IncMessagesReceived`,
  `IncMessageParsingErrors`, `IncMessagesWritten`, `IncWriteErrors`, `ObserveWriteLatency(d time.Duration)`,
  `ObserveBatchSize(size float64)`, `IncAlertsPublished`, `IncAlertPublishErrors`, `SetHeartbeatMapSize(v float64)`,
  `ObserveHeartbeatTickDuration(d time.Duration)`, `IncStatusUpdateErrors`, `IncStatusUpdateDropped`,
  `SetDispatchQueueLength(v float64)`, `IncAlertCacheRefreshErrors`, `SetAlertCacheLastSuccess(ts float64)`,
  `IncNATSReconnects`.

  == Decisioni Implementative

  #st.design-rationale(title: "Tick a tre fasi con re-validazione")[
    Il ciclo di heartbeat opera in tre fasi distinte:
    + acquisizione di uno snapshot in sola lettura della mappa;
    + operazioni di I/O (pubblicazione alert, dispatch status update) senza lock mantenuto;
    + riacquisizione del write-lock con re-validazione dello stato. Se durante la fase I/O è arrivato un nuovo messaggio
      dal gateway (`lastSeen` avanzato), la transizione a offline viene annullata. Minimizza la contesa sul lock e
      previene falsi positivi causati dalla latenza delle operazioni di rete.
  ]

  #st.design-rationale(title: "Grace period all'avvio")[
    Per `HeartbeatGracePeriodMs` dall'avvio, `Tick` non emette alert. Consente ai gateway di stabilire la connessione e
    inviare il primo messaggio prima che il meccanismo di liveness diventi attivo, evitando alert spurii durante il
    warm-up.
  ]

  #st.design-rationale(title: "Batch write con flush periodico")[
    I record vengono accumulati in un buffer interno e scritti in batch con un singolo round-trip di rete. Il flush
    avviene al raggiungimento della soglia dimensionale (`telemetryBatchSize = 100`) o allo scadere del timer
    (`telemetryFlushInterval = 500ms`). Gli ACK NATS sono emessi solo dopo la scrittura riuscita del batch, garantendo
    semantica at-least-once delivery.
  ]

  #st.design-rationale(title: "Dispatch asincrono non-bloccante per status update")[
    Le chiamate a `GatewayStatusUpdater.UpdateStatus` sono accodate in un canale a capacità limitata
    (`GatewayBufferSize`) e processate da una goroutine worker dedicata. Il path del tick di heartbeat e di
    `HandleTelemetry` non attendono mai il completamento della chiamata RR. Se il canale è pieno, l'aggiornamento è
    scartato deterministicamente e `status_update_dropped_total` viene incrementato. La perdita è accettabile: il ciclo
    successivo genererà un nuovo aggiornamento se la condizione persiste.
  ]

  #st.design-rationale(title: "Interfacce metriche ristrette per adapter")[
    Ogni adapter definisce un'interfaccia metrica minimale con i soli metodi necessari. La struct `Metrics` soddisfa
    tutte queste interfacce, ma ogni adapter è accoppiato esclusivamente ai propri contatori. Semplifica la creazione di
    mock nei test e impedisce a un adapter di acquisire visibilità sulle metriche di altri componenti.
  ]

  #st.design-rationale(title: "Snapshot atomico per AlertConfigCache")[
    La cache delle configurazioni di alert usa `atomic.Pointer[alertConfigSnapshot]` per garantire letture lock-free in
    `TimeoutFor`. Il refresh periodico costruisce un nuovo snapshot immutabile e lo sostituisce atomicamente. In caso di
    errore nel refresh, l'ultimo snapshot valido rimane in uso senza degradare la disponibilità del servizio.
  ]

  #st.design-rationale(title: "Struct key per la mappa heartbeat")[
    `gatewayKey` usa una struct come chiave della mappa invece di una stringa `"tenantID/gatewayID"` formattata. Elimina
    l'allocazione per la costruzione della chiave stringa e previene ambiguità di collision (es. `"a/b/c"` e `"a/b"` +
    `"c"`).
  ]

  #st.design-rationale(title: "mTLS per autenticazione NATS")[
    L'autenticazione NATS usa mTLS (`RootCAs`, `ClientCert`) al posto del file `.creds`. Ogni servizio dispone di un
    certificato client firmato dalla CA interna (step-ca), garantendo mutual authentication e consentendo la revoca per
    certificato senza rotazione di credenziali condivise.
  ]

  #pagebreak()

  = Schema Database

  ```sql
  CREATE TABLE IF NOT EXISTS telemetry (
      time           TIMESTAMPTZ NOT NULL,
      tenant_id      TEXT        NOT NULL,
      gateway_id     TEXT        NOT NULL,
      sensor_id      TEXT        NOT NULL,
      sensor_type    TEXT        NOT NULL,
      encrypted_data TEXT        NOT NULL,  -- Rule Zero: mai decodificato server-side
      iv             TEXT        NOT NULL,  -- Rule Zero: mai decodificato server-side
      auth_tag       TEXT        NOT NULL,  -- Rule Zero: mai decodificato server-side
      key_version    INTEGER     NOT NULL
  );

  SELECT create_hypertable('telemetry', 'time',
      chunk_time_interval => INTERVAL '1 day',
      if_not_exists       => TRUE);

  CREATE INDEX IF NOT EXISTS idx_telemetry_tenant_gateway_time
      ON telemetry (tenant_id, gateway_id, time DESC);
  ```

  Le colonne `encrypted_data`, `iv`, `auth_tag` sono memorizzate come `TEXT` (stringhe base64) e non vengono mai
  decodificate server-side — Rule Zero.

  #pagebreak()

  = Metodologie di Testing

  Il race detector Go (`-race`) è abilitato in tutte le esecuzioni CI, sia per i test di unità sia per quelli di
  integrazione.

  == Test di Unità

  Le dipendenze sono sostituite da mock o stub iniettati tramite constructor. Il clock è sempre un `FakeClock`
  controllato per rendere i test deterministici.

  *`HeartbeatTracker`*

  #table(
    columns: (3fr, 2fr),
    [Caso di test], [Postcondizione verificata],
    [`HandleTelemetry` — primo messaggio da gateway sconosciuto],
    [Entry inserita in `beats`; `knownStatus = Online`; `dispatchCh` riceve un job `Online`; metrica `HeartbeatMapSize`
      incrementata],

    [`HandleTelemetry` — messaggio da gateway con `knownStatus = Offline`],
    [`dispatchCh` riceve un job `Online`; `knownStatus` aggiornato a `Online`],

    [`HandleTelemetry` — messaggio da gateway già `Online`], [`dispatchCh` non riceve nessun job],
    [`HandleDecommission` — gateway presente in mappa],
    [Entry rimossa; metrica `HeartbeatMapSize` decrementata; nessun altro side effect],

    [`HandleDecommission` — gateway assente in mappa], [Nessun errore; nessun side effect],
    [`Tick` — grace period attivo], [`alertPublisher.Publish` non chiamato],
    [`Tick` — timeout superato, nessun aggiornamento intervenuto],
    [`alertPublisher.Publish` chiamato; `dispatchCh` riceve job `Offline`; `knownStatus` aggiornato a `Offline` dopo
      Fase 3],

    [`Tick` — re-validazione: heartbeat arrivato durante Fase 2 simulata],
    [Transizione annullata; `alertPublisher.Publish` non chiamato; `knownStatus` rimane `Online`],

    [`Tick` — gateway già `knownStatus = Offline`], [Nessun alert duplicato; `alertPublisher.Publish` non chiamato],

    [`dispatchStatusUpdate` — canale pieno], [Job scartato; `IncStatusUpdateDropped` invocato],

    [`Close` — drain del canale], [Tutti i job in `dispatchCh` prima della chiusura sono processati; `done` chiuso],
  )

  *`AlertConfigCache`*

  #table(
    columns: (3fr, 2fr),
    [Caso di test], [Postcondizione verificata],
    [`TimeoutFor` — override per gateway presente nello snapshot], [Restituisce `TimeoutMs` specifico del gateway],
    [`TimeoutFor` — solo default tenant presente], [Restituisce `TimeoutMs` del tenant],
    [`TimeoutFor` — nessuna configurazione presente], [Restituisce `defaultTimeoutMs`],
    [`TimeoutFor` su snapshot vuoto (costruzione senza fetch)], [Restituisce `defaultTimeoutMs`; nessun panic],
  )

  *`NATSTelemetryConsumer`*

  #table(
    columns: (3fr, 2fr),
    [Caso di test], [Postcondizione verificata],
    [`extractTenantID` — subject `telemetry.data.tenant1.gw1`], [Restituisce `"tenant1"`],
    [`extractTenantID` — subject malformato (es. `telemetry.data.tenant1`)], [Restituisce errore],
    [`buildRow` — mapping da `TelemetryEnvelope` con `tenantID`],
    [`TenantID` propagato correttamente; campi `OpaqueBlob` passati intatti senza accesso a `Value`],

    [`processMessage` — body JSON non valido], [Ritorna `permanentError`; handler non invocato],

    [`writeBatch` — errore permanente per un messaggio nel batch],
    [Messaggio Term()'d; gli altri messaggi validi del batch sono ACK()'d],
  )

  == Test di Integrazione

  I test di integrazione avviano infrastruttura reale tramite Testcontainers-go.

  #table(
    columns: (2fr, 1fr, 2fr),
    [Caso di test], [Infrastruttura], [Verifica],
    [`PostgresTelemetryWriter.Write` contro TimescaleDB reale],
    [TimescaleDB],
    [Record presente in `telemetry`; campi `OpaqueBlob` invariati rispetto all'input],

    [`PostgresTelemetryWriter.WriteBatch` contro TimescaleDB reale],
    [TimescaleDB],
    [Tutti i record del batch persistiti; count post-inserimento corrisponde alla dimensione del batch],

    [Pipeline completa `NATSTelemetryConsumer`: messaggio NATS → parse → handler → writer → ACK],
    [NATS + TimescaleDB],
    [Record su TimescaleDB; ACK emesso; entry heartbeat presente in `HeartbeatTracker`],

    [`AlertConfigCache.refresh` — fetch e sostituzione snapshot],
    [NATS mock responder],
    [Snapshot aggiornato atomicamente; `TimeoutFor` restituisce i nuovi valori],

    [Connessione NATS con mTLS — certificato client valido],
    [NATS con TLS],
    [Connessione stabilita; subscribe riuscita],

    [Connessione NATS con mTLS — certificato client non valido],
    [NATS con TLS],
    [Connessione rifiutata; errore propagato],
  )
]
