#import "../../../00-templates/base_document.typ" as base-document
#import "../st_lib.typ" as st

=== notip-data-consumer

#align(center)[
  #image("../assets/data-consumer.png", width: 100%)
]

==== Panoramica
Il `notip-data-consumer` è un servizio Go che espone un server HTTP con due endpoint: Prometheus `/metrics` per
l'osservabilità e `/healthz` per la verifica della raggiungibilità del database. Assolve tre responsabilità
architetturali:
+ *Ingestione telemetrica:* sottoscrive `telemetry.data.>` via JetStream e persiste ogni messaggio come blob opaco in
  TimescaleDB, rispettando la pipeline opaca senza mai ispezionare il contenuto cifrato.
+ *Rilevazione della liveness:* mantiene una mappa di heartbeat in memoria e, ad ogni tick periodico, valuta quali
  gateway hanno superato il timeout configurato, pubblicando alert e notificando transizioni di stato.
+ *Gestione della decommission:* sottoscrive `gateway.decommissioned.>` e rimuove i gateway dismessi dalla mappa di
  heartbeat, prevenendo falsi alert.

==== Decomposizione Architetturale
Il servizio applica l'architettura esagonale organizzata in tre strati concentrici:

- *Dominio* (`internal/domain/model`, `internal/domain/port`, `internal/service`): contiene i value object puri
  (`TelemetryEnvelope`, `TelemetryRow`, `AlertPayload`, `GatewayStatusUpdate`, `OpaqueBlob`), le definizioni delle porte
  e il servizio `HeartbeatTracker`, che incapsula l'intera logica di liveness dedicata ai Gateway. Questo strato non
  importa alcun package infrastrutturale.

- *Driving adapter* (`internal/adapter/driving`): traducono eventi esterni in chiamate ai driving port del dominio.
  `NATSTelemetryConsumer` decodifica i messaggi NATS e invoca `TelemetryMessageHandler`; `NATSDecommissionConsumer`
  invoca `DecommissionEventHandler`; `HeartbeatTickTimer` invoca `HeartbeatTicker` ad ogni tick del timer.

- *Driven adapter* (`internal/adapter/driven`): implementano i driven port per raggiungere risorse esterne.
  `PostgresTelemetryWriter` persiste su TimescaleDB; `NATSAlertPublisher` pubblica alert su JetStream;
  `NATSGatewayStatusUpdater` notifica il Management API via NATS Request-Reply; `AlertConfigCache` mantiene una cache
  atomicamente aggiornata delle configurazioni di alert; `SystemClock` astrae `time.Now()` per facilitare il testing.

==== Definizione dei Port

*Driven Port* sono interfacce invocate dal dominio, implementate dagli adapter per raggiungere l'esterno:

#st.port-interface(
  name: "TelemetryWriter",
  kind: "driven",
  description: [Confine di persistenza per i record telemetrici. Permette di isolare il dominio dalla tecnologia di
    storage, consentendo la sostituzione del backend di persistenza senza alcun tipo di impatto sulla logica
    applicativa.],
  methods: (
    ("Write", [Persiste un singolo record telemetrico opaco]),
    ("WriteBatch", [Persiste un batch di record in un'unica operazione di rete]),
  ),
)

#st.port-interface(
  name: "AlertPublisher",
  kind: "driven",
  description: [Confine di pubblicazione degli alert infrastrutturali. Disaccoppia la logica di rilevazione offline dal
    meccanismo di distribuzione degli alert (JetStream).],
  methods: (
    ("Publish", [Pubblica un alert gateway-offline per un tenant specifico]),
  ),
)

#st.port-interface(
  name: "GatewayStatusUpdater",
  kind: "driven",
  description: [Confine di notifica delle transizioni di stato. Permette di isolare il dominio dal protocollo di
    comunicazione con il Management API (NATS Request-Reply).],
  methods: (
    (
      "UpdateStatus",
      [Notifica una transizione di stato online/offline al Management API, servizio con accesso in scrittura al database
        dedicato],
    ),
  ),
)

#st.port-interface(
  name: "AlertConfigProvider",
  kind: "driven",
  description: [Confine di accesso alla configurazione degli alert. Permette al dominio di richiedere il timeout senza
    conoscere la sorgente che lo fornisce.],
  methods: (
    ("TimeoutFor", [Restituisce il timeout offline configurato per uno specifico gateway]),
  ),
)

#st.port-interface(
  name: "ClockProvider",
  kind: "driven",
  description: [Astrazione del tempo di sistema. Consente l'iniezione di un clock deterministico nei test, eliminando la
    dipendenza diretta da `time.Now()` nella logica di dominio.],
  methods: (
    ("Now", [Restituisce il timestamp corrente]),
  ),
)

*Driving Port* sono interfacce implementate dal dominio, invocate dagli adapter per immettere eventi:

#st.port-interface(
  name: "TelemetryMessageHandler",
  kind: "driving",
  description: [Punto di ingresso per gli eventi telemetrici decodificati. L'adapter NATS invoca questo port dopo aver
    estratto il `tenantID` dal subject e deserializzato l'envelope.],
  methods: (
    ("HandleTelemetry", [Registra e aggiorna l'heartbeat del gateway e gestisce le transizioni di stato]),
  ),
)

#st.port-interface(
  name: "DecommissionEventHandler",
  kind: "driving",
  description: [Punto di ingresso per gli eventi di decommission gateway. Permette di rimuovere il gateway dalla mappa
    di heartbeat, prevenendo falsi alert offline per gateway già conosciuti come dismessi.],
  methods: (
    ("HandleDecommission", [Rimuove un gateway dalla mappa di liveness]),
  ),
)

#st.port-interface(
  name: "HeartbeatTicker",
  kind: "driving",
  description: [Punto di ingresso per il tick periodico di liveness. Invocato dal timer adapter a intervalli
    configurabili, attiva la valutazione degli heartbeat scaduti.],
  methods: (
    ("Tick", [Valuta la liveness di tutti i gateway tracciati e genera alert per quelli offline]),
  ),
)

==== Decisioni Architetturali

#st.design-rationale(title: "Tick a tre fasi con re-validazione")[
  Il ciclo di heartbeat adotta un approccio a tre fasi:
  + acquisizione di uno snapshot in sola lettura della mappa,
  + esecuzione delle operazioni di I/O (pubblicazione alert, dispatch status) senza lock
  + riacquisizione del lock in scrittura con re-validazione dello stato.
  Se durante la fase di I/O è arrivato un nuovo messaggio dal gateway (il `lastSeen` è avanzato), la transizione a
  offline viene annullata. Questa strategia premette di minimizzare la contesa sul lock della mappa e previene falsi
  positivi causati dalla latenza delle operazioni di rete.
]

#st.design-rationale(title: "Grace period all'avvio")[
  All'avvio del servizio, nessun gateway ha ancora inviato alcun tipo di telemetria: tutti risulterebbero immediatamente
  offline, innescando l'invio di alert "falsi". Un periodo di grazia configurabile sopprime gli alert durante la fase di
  warm-up, consentendo ai gateway di stabilire la connessione e inviare il primo messaggio prima che il meccanismo di
  heartbeat diventi attivo.
]

#st.design-rationale(title: "Batch write con flush periodico")[
  Anziché eseguire una INSERT per ogni messaggio NATS, il consumer accumula i record in un buffer e li scrive in batch
  tramite un singolo round-trip di rete. Il flush avviene al raggiungimento di una soglia o alla scadenza di un timer. I
  messaggi NATS ricevono l'ACK solo dopo la scrittura riuscita del batch, garantendo at-least-once delivery.
]

#st.design-rationale(title: "Interfacce metriche ristrette")[
  Ogni adapter definisce la propria interfaccia metrica minimale (es. `alertPublisherMetrics` con il solo metodo
  `IncAlertsPublished`) anziché dipendere dall'intera struct `Metrics`. Lo struct `Metrics` soddisfa tutte queste
  interfacce ristrette, ma ogni adapter è accoppiato solo ai contatori che effettivamente emette. Questo impedisce che
  un adapter acquisisca visibilità su metriche di altri componenti e semplifica la creazione di mock nei test.
]
