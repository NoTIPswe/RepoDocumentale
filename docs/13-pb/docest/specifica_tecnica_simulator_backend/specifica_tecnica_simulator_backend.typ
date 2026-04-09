#import "../../00-templates/base_document.typ" as base-document
#import "../specifica_tecnica/st_lib.typ" as st

#let metadata = yaml(sys.inputs.meta-path)
#show figure.where(kind: table): set block(breakable: true)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Specifica tecnica del microservizio notip-simulator-backend: architettura interna (Ports & Adapters), simulazione di gateway e sensori, generazione dati, integrazioni NATS mTLS, schema del database locale e metodologia di testing.",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione

  Questo documento illustra l'architettura interna e le scelte implementative del microservizio
  `notip-simulator-backend`. Sviluppato in Go, questo componente è responsabile della simulazione di dispositivi fisici
  (Gateway e Sensori BLE) su larga scala. Il simulatore replica fedelmente il comportamento dell'hardware reale
  all'interno della piattaforma: si interfaccia con il Provisioning Service per il processo di onboarding e
  l'ottenimento del materiale crittografico, cifra i dati telemetrici localmente tramite AES-256-GCM, si connette al
  cluster NATS in mTLS per l'invio asincrono della telemetria e rimane in ascolto su JetStream per ricevere comandi dal
  Cloud o gestire eventi di decommissioning. L'architettura è altamente concorrente, associando ogni gateway virtuale a
  una goroutine dedicata gestita da un registro centrale.

  = Dipendenze e Configurazione

  == Variabili d'ambiente

  Tutte le variabili d'ambiente necessarie per il funzionamento del microservizio sono elencate di seguito. Un'eventuale
  mancanza o configurazione errata delle variabili obbligatorie comporterà un errore fatale all'avvio del microservizio:

  #figure(
    caption: [Variabili d'ambiente del microservizio notip-simulator-backend],
    table(
      columns: (1.2fr, 1.5fr, 1fr, 1fr),
      [ *Campo* ], [ *Variabile d'ambiente* ], [ *Default* ], [ *Obbligatorio* ],
      [ ProvisioningUrl ], [ `PROVISIONING_URL` ], [-], [ Sì ],
      [ NATSUrl ], [ `NATS_URL` ], [-], [ Sì ],
      [ NATSCACertPath ], [ `NATS_CA_CERT_PATH` ], [-], [ Sì ],
      [ NATSTLSCertPath ], [ `NATS_TLS_CERT` ], [-], [ No ],
      [ NATSTLSKeyPath ], [ `NATS_TLS_KEY` ], [-], [ No ],
      [ SQLitePath ], [ `SQLITE_PATH` ], [ `/data/simulator.db` ], [ No ],
      [ HttpAddr ], [ `HTTP_ADDR` ], [ `:8090` ], [ No ],
      [ MetricsAddr ], [ `METRICS_ADDR` ], [ `:9090` ], [ No ],
      [ DefaultSendFreq ], [ `DEFAULT_SEND_FREQUENCY_MS` ], [ `5000` ], [ No ],
      [ GatewayBufferSize ], [ `GATEWAY_BUFFER_SIZE` ], [ `1000` ], [ No ],
      [ RecoveryMode ], [ `RECOVERY_MODE` ], [ `false` ], [ No ],
    ),
  )

  _Nota: `NATS_TLS_CERT` e `NATS_TLS_KEY` non sono obbligatori in assoluto, ma sono vincolati tra loro: devono essere
  entrambi valorizzati o entrambi vuoti._

  == Sequenza di avvio

  I passi bloccanti interrompono l'avvio del microservizio, pertanto è necessario assicurarsi che le dipendenze esterne
  (Provisioning, NATS) siano raggiungibili. La sequenza di avvio è la seguente:

  #figure(
    caption: [Sequenza di avvio del microservizio notip-simulator-backend],
    table(
      columns: (auto, 1fr, 2fr, auto),
      [ *Step* ], [ *Componente* ], [ *Azione* ], [ *Bloccante?* ],
      [ 0 ], [ `config.Load()` ], [ Carica e valida le variabili d'ambiente dal sistema operativo. ], [ Sì ],
      [ 1 ],
      [ `SQLiteStore` ],
      [
        Inizializza la connessione SQLite (`modernc.org/sqlite`) ed esegue le migrazioni per lo schema dati.
      ],
      [ Sì ],

      [ 2 ],
      [ `Adapters` ],
      [
        Istanzia il connettore NATS mTLS caricando il CertPool della CA, il client HTTP di Provisioning e l'Encryptor
        AES-GCM.
      ],
      [ Sì ],

      [ 3 ],
      [ `GatewayRegistry` ],
      [ Inizializza il registro centrale thread-safe che orchestra i `GatewayWorker`. ],
      [ Sì ],

      [ 4 ],
      [ `RestoreAll` ],
      [Se `RECOVERY_MODE` è true, interroga il DB locale e riavvia i gateway pre-esistenti. ],
      [ No ],

      [ 5 ],
      [ `DecommissionListener` ],
      [ Sottoscrizione a JetStream su `gateway.decommissioned.>` per cleanup locale in tempo reale. ],
      [ Sì ],

      [ 6 ],
      [ `Metrics Server` ],
      [ Avvia il listener HTTP per l'esposizione delle metriche Prometheus (es. `:9090`). ],
      [ No ],

      [ 7 ],
      [ `API Server` ],
      [ Avvia il `http.ServeMux` con gli handler REST per il controllo delle simulazioni. ],
      [ Sì ],
    ),
  )

  = Architettura Logica

  Il servizio adotta un'architettura *Ports and Adapters (Architettura Esagonale)*. La logica di business (generazione
  dati, gestione anomalie e ciclo di vita) è isolata al centro (Domain/App) e non dipende da framework infrastrutturali.
  Le comunicazioni verso l'esterno avvengono tramite interfacce (Ports) implementate dagli adapter (SQLite, NATS, HTTP).

  == Layout dei moduli
  Essendo il microservizio strutturato per isolare la logica applicativa dalle dipendenze infrastrutturali, di seguito è
  riportata la struttura interna e rigorosa dei pacchetti:

  ```text
  notip-simulator-backend/
  ├── internal/
  │   ├── adapters/               Implementazioni tecniche e Adapter Driven:
  │   │   ├── http/               Handler REST, DTO mapper e client Provisioning
  │   │   ├── nats/               Connettore mTLS, Pub/Sub JetStream e Listener
  │   │   ├── sqlite/             Persistenza locale SQLite (store.go)
  │   │   ├── clock.go            Implementazione di utilità del tempo di sistema
  │   │   └── encryptor.go        Implementazione dell'algoritmo AES-256-GCM
  │   ├── app/                    Core orchestrativo: app.go, buffer.go, registry.go, worker.go
  │   ├── config/                 Caricamento env vars e defaults
  │   ├── domain/                 Modelli di business (Gateway, Sensor) ed Errori
  │   ├── generator/              Algoritmi matematici e Factory (sine, spike, ecc.)
  │   ├── health/                 Endpoint di Liveness e Readiness
  │   ├── metrics/                Definizione metriche Prometheus
  │   ├── migrations/             Script SQL embeddati per lo schema
  │   └── ports/                  Definizione interfacce Driving (API) e Driven
  ├── tests/                      Test di integrazione intra-service e mock
  └── main.go                     Entrypoint dell'applicazione
  ```

  #figure(
    caption: [Architettura Logica del Simulator Backend],
    image("assets/architettura_logica.png", width: 80%),
  )

  == Strati Architetturali

  #figure(
    caption: [Strati architetturali del microservizio notip-simulator-backend],
    table(
      columns: (1fr, 1.5fr, 2fr),
      [ *Strato* ], [ *Package* ], [ *Contenuto* ],
      [ *Presentation* ],
      [ `adapters/http` ],
      [
        Handler HTTP REST per la creazione, l'avvio, l'arresto e la configurazione delle anomalie dei gateway simulati.
      ],

      [ *Business* ],
      [ `app`, `generator`, `domain` ],
      [ Logica applicativa: esecuzione dei tick temporali nei worker, calcolo dei dati, cifratura payload. ],

      [ *Persistence* ],
      [ `adapters/sqlite` ],
      [ Accesso al database locale SQLite per conservare lo stato dei gateway e dei sensori creati via API. ],

      [ *Integration* ],
      [ `adapters/nats`, `adapters/http` ],
      [ Scambio dati verso l'infrastruttura Cloud (Provisioning via REST, Telemetria e Comandi via JetStream). ],
    ),
  )

  == Decisioni Architetturali

  Per garantire le performance, la resilienza e la manutenibilità del simulatore senza appesantire l'infrastruttura,
  sono state prese le seguenti decisioni architetturali chiave:

  - *Modello di Concorrenza (1 Goroutine = 1 Gateway):* Ogni gateway simulato è gestito da un `GatewayWorker` isolato
    eseguito in una propria goroutine dedicata. Questo approccio mappa 1:1 il comportamento, garantendo che la
    congestione o il crash di un gateway virtuale non impatti l'esecuzione degli altri. La sincronizzazione e il ciclo
    di vita sono orchestrati in sicurezza tramite `context.Context` e `sync.RWMutex` nel registro centrale.
  - *Gestione della Backpressure (Drop-Oldest):* Per scongiurare l'esaurimento della memoria (Out-Of-Memory) o il blocco
    permanente delle goroutine in caso di prolungata irraggiungibilità di NATS, è stato implementato il componente
    `MessageBuffer`. Questo canale a capacità limitata adotta una politica "Drop-Oldest": in caso di saturazione,
    espelle silenziosamente il pacchetto telemetrico più vecchio per fare spazio al nuovo, privilegiando sempre il dato
    più recente.
  - *Persistenza Locale Embedded:* L'utilizzo di SQLite (`modernc.org/sqlite` cross-platform) garantisce sufficiente
    persistenza per la funzionalità di riavvio a caldo (`RecoveryMode`), mantenendo il microservizio completamente
    *self-contained*.
  - *Pipeline Crittografica Opaca (AES-GCM):* Rispettando il vincolo architetturale della piattaforma NoTIP, il payload
    telemetrico non viene mai esposto in chiaro sul broker di messaggistica. Il `GatewayWorker` utilizza
    l'`AESGCMEncryptor` locale per sigillare i dati prima dell'invio. La `EncryptionKey` è gestita come un _Value
    Object_ immutabile che impedisce l'accesso diretto ai byte della chiave, garantendo che i campi `EncryptedData`,
    `IV` e `AuthTag` viaggino come blob Base64 totalmente opachi.

  == Relazioni tra Componenti

  Di seguito viene sintetizzata la catena delle dipendenze interne, che evidenzia la corretta applicazione
  dell'inversione del controllo (Ports & Adapters):

  #figure(
    caption: [Relazioni funzionali interne],
    table(
      columns: (1.5fr, 1fr, 1.5fr),
      [ *Componente Core* ], [ *Relazione* ], [ *Porta / Adapter* ],
      [ `GatewayHandler`], [ Gestisce ciclo di vita via ], [ `GatewayRegistry`],
      [ `SensorHandler`], [ Gestisce entità via ], [ `GatewayRegistry`],
      [ `AnomalyHandler`], [ Inietta alterazioni via ], [ `GatewayRegistry` ],
      [ `GatewayRegistry` ], [ Delega a ], [ `ProvisioningServiceClient` (HTTP) ],
      [ `GatewayRegistry` ], [ Crea ed orchestra ], [ `GatewayWorker` (Goroutine) ],
      [ `GatewayRegistry` ], [ Persiste lo stato su ], [ `GatewayStore` / SQLite (Driven) ],
      [ `GatewayRegistry` ], [ Richiede connessioni a ], [ `NATSMTLSConnector` (Driven) ],
      [ `GatewayWorker` ], [ Cifra tramite ], [ `AESGCMEncryptor` ],
      [ `GatewayWorker` ], [ Interroga ], [ `Generator` (`SineWave`, ecc.) ],
      [ `GatewayWorker` ], [ Accoda in ], [ `MessageBuffer` ],
      [ `MessageBuffer` ], [ Pubblica su ], [ `NATSGatewayPublisher` (NATS) ],
      [ `NATSGatewaySubscriber` ], [ Inoltra i comandi cloud a ], [ `GatewayWorker` (Core) ],
      [ `NATSDecommissionListener` ], [ Notifica ], [ `GatewayRegistry` ],
    ),
  )

  = Design di Dettaglio

  == Moduli del microservizio

  #figure(
    caption: [Responsabilità dei moduli applicativi],
    table(
      columns: (1fr, 3fr),
      [ *Modulo* ], [ *Responsabilità* ],
      [ `GatewayRegistry` ],
      [
        Entry-point per tutte le chiamate API. Gestisce una mappa thread-safe di `GatewayWorker` associati al proprio
        management ID. Apre e chiude i contesti e delega al database.
      ],

      [ `GatewayWorker` ],
      [
        Goroutine isolata per singolo gateway. Gestisce un `time.Ticker` interno, acquisisce dati dai sensori, li cifra
        in AES-GCM e li accoda per la pubblicazione. Elabora anche i comandi in ingresso.
      ],

      [ `MessageBuffer` ],
      [
        Sistema di code (channel) con capienza limitata per assorbire i picchi di rete o NATS lento, applicando una
        politica *drop-oldest* per non bloccare la simulazione.
      ],

      [ `Generator` ],
      [
        Interfaccia comune per gli algoritmi matematici. Implementa metodi per produrre il sample successivo e un
        meccanismo di override (`InjectOutlier`).
      ],
    ),
  )

  == Entità

  #figure(
    caption: [Entità persistenti (SQLite)],
    table(
      columns: (1fr, 3fr),
      [ *Entità* ], [ *Campi principali* ],
      [ `gateways` ],
      [
        `id`, `management_gateway_id`, `factory_id`, `factory_key`, `model`, `firmware_version`, `provisioned`,
        `cert_pem`, `private_key_pem`, `encryption_key` (BLOB), `send_frequency_ms`, `status`, `tenant_id`, `created_at`
      ],

      [ `sensors` ],
      [ `id`, `gateway_id` (FK), `sensor_id`, `type`, `min_range`, `max_range`, `algorithm`, `created_at` ],
    ),
  )

  == Endpoint API HTTP

  L'API server (configurato nel file `server.go`) espone gli endpoint per pilotare la simulazione. Di seguito il
  dettaglio completo delle rotte.

  === Health
  #figure(
    caption: [Endpoint GET /health],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `GET /health` ],
      [ *Descrizione* ],
      [ Liveness probe. Ritorna HTTP 200 con `{"status": "ok"}` per confermare che il server HTTP è in ascolto. ],
    ),
  )

  === Gateways
  #figure(
    caption: [Endpoint POST /sim/gateways],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `POST /sim/gateways` ],
      [ *Descrizione* ], [ Crea un gateway locale, esegue l'onboarding crittografico con il Cloud e avvia il worker. ],
      [ *Body Request* ], [ `{"factoryId": "...", "factoryKey": "...", "model": "...", "sendFrequencyMs": 5000}` ],
      [ *Response* ], [ `GatewayResponse` JSON. HTTP 200. ],
    ),
  )

  #figure(
    caption: [Endpoint POST /sim/gateways/bulk],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `POST /sim/gateways/bulk` ],
      [ *Descrizione* ], [ Creazione massiva di N gateway. Utile per test di carico. ],
      [ *Body Request* ], [ `{"count": 10, "baseFactoryId": "sim-", "factoryKey": "...", "model": "..."}` ],
      [ *Response* ], [ Array combinato di successi e fallimenti. HTTP 200. ],
    ),
  )

  #figure(
    caption: [Endpoint GET /sim/gateways],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `GET /sim/gateways` ],
      [ *Descrizione* ], [ Recupera la lista di tutti i gateway locali presenti nel DB simulatore. ],
      [ *Response* ], [ Array di `GatewayResponse` (senza materiale crittografico). HTTP 200. ],
    ),
  )

  #figure(
    caption: [Endpoint GET /sim/gateways/{id}],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `GET /sim/gateways/{id}` ],
      [ *Descrizione* ], [ Recupera il dettaglio di un singolo gateway partendo dal suo UUID (Management ID). ],
      [ *Response* ], [ Singolo `GatewayResponse` JSON. HTTP 200. HTTP 404 se non trovato. ],
    ),
  )

  #figure(
    caption: [Endpoint POST Lifecycle (Start / Stop)],
    table(
      columns: (1fr, 3fr),
      [ *Rotte* ], [ `POST /sim/gateways/{id}/start` \ `POST /sim/gateways/{id}/stop` ],
      [ *Descrizione* ], [ Avvia la goroutine (worker) di un gateway fermo, o la arresta chiudendo il Context. ],
      [ *Response* ], [ HTTP 204 No Content in caso di successo. ],
    ),
  )

  #figure(
    caption: [Endpoint DELETE /sim/gateways/{id}],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `DELETE /sim/gateways/{id}` ],
      [ *Descrizione* ],
      [ Arresta il worker (se attivo) e rimuove in modo permanente il gateway e i suoi sensori dal database locale. ],

      [ *Response* ], [ HTTP 204 No Content. ],
    ),
  )

  === Sensori
  #figure(
    caption: [Endpoint POST /sim/gateways/{id}/sensors],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `POST /sim/gateways/{id}/sensors` ],
      [ *Descrizione* ], [ Aggiunge un nuovo sensore (generatore dati) a un gateway esistente. ],
      [ *Body Request* ], [ `{"type": "temperature", "minRange": 20.0, "maxRange": 25.0, "algorithm": "sine_wave"}` ],
      [ *Response* ], [ `SensorResponse` JSON. HTTP 201 Created. ],
    ),
  )

  #figure(
    caption: [Endpoint GET /sim/gateways/{id}/sensors],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `GET /sim/gateways/{id}/sensors` ],
      [ *Descrizione* ], [ Restituisce tutti i sensori logici associati al gateway indicato. ],
      [ *Response* ], [ Array di `SensorResponse` JSON. HTTP 200. ],
    ),
  )

  #figure(
    caption: [Endpoint DELETE /sim/sensors/{sensorId}],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `DELETE /sim/sensors/{sensorId}` ],
      [ *Descrizione* ], [ Elimina permanentemente il sensore dal database SQLite. ],
      [ *Response* ], [ HTTP 204 No Content. ],
    ),
  )

  === Anomalie
  #figure(
    caption: [Endpoint Network Degradation],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `POST /sim/gateways/{id}/anomaly/network-degradation` ],
      [ *Descrizione* ],
      [
        Inietta una perdita pacchetti temporanea. Il worker applicherà la `packet_loss_pct` (es. 0.3 = 30%) prima
        dell'invio.
      ],

      [ *Body Request* ], [ `{"duration_seconds": 30, "packet_loss_pct": 0.5}` ],
      [ *Response* ], [ HTTP 204 No Content. ],
    ),
  )

  #figure(
    caption: [Endpoint Disconnect],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `POST /sim/gateways/{id}/anomaly/disconnect` ],
      [ *Descrizione* ],
      [ Simula un down totale di rete. Nessun pacchetto verrà emesso dal gateway per la durata impostata. ],

      [ *Body Request* ], [ `{"duration_seconds": 60}` ],
      [ *Response* ], [ HTTP 204 No Content. ],
    ),
  )

  #figure(
    caption: [Endpoint Sensor Outlier],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `POST /sim/sensors/{sensorId}/anomaly/outlier` ],
      [ *Descrizione* ],
      [
        Forza il generatore matematico del sensore a restituire il valore esatto fornito per il primissimo sample utile,
        sovrascrivendo la logica matematica.
      ],

      [ *Body Request* ], [ `{"value": 999.99}` ],
      [ *Response* ], [ HTTP 204 No Content. ],
    ),
  )

  == Integrazioni Cloud (HTTP e JetStream)

  #figure(
    caption: [Integrazioni di rete Cloud-Simulator],
    table(
      columns: (2fr, 1fr, 1.5fr),
      [ *Target / Subject* ], [ *Tipologia* ], [ *Responsabilità* ],
      [ `POST /api/provision/onboard` ],
      [ HTTP REST ],
      [
        Invia il CSR crittografico al Provisioning e riceve Certificato X.509 + Chiave AES. Errori HTTP 401/409 sono
        mappati sul dominio.
      ],

      [ `telemetry.data.{tenantId}.{gwId}` ],
      [ JetStream Pub ],
      [ Pubblica la telemetria in tempo reale cifrata AES-256-GCM. ],

      [ `command.gw.{tenantId}.{gwId}` ],
      [ JetStream Sub ],
      [ Ricezione asincrona di comandi cloud (config, firmware). Scarta comandi scaduti (> 60s). ],

      [ `command.ack.{tenantId}.{gwId}` ],
      [ JetStream Pub ],
      [ Invia l'esito (ACK, NACK, Expired) dell'elaborazione di un comando. ],

      [ `gateway.decommissioned.>` ],
      [ JetStream Sub ],
      [ Ascolta l'eliminazione cloud dei gateway per innescare un cleanup del db locale. ],
    ),
  )

  == Metriche Operative

  Il microservizio espone internamente le proprie metriche in formato Prometheus sulla porta configurata
  (`METRICS_ADDR`). L'uso estensivo di `GaugeVec` e `CounterVec` permette il monitoraggio granulare della "salute" di
  ciascun gateway simulato e l'identificazione di colli di bottiglia verso NATS.

  #figure(
    caption: [Metriche Prometheus esposte dal simulatore],
    table(
      columns: (2.2fr, 1.2fr, 2.5fr),
      [ *Nome Metrica* ], [ *Tipo Prometheus* ], [ *Descrizione / Help* ],
      [ `notip_sim_gateways_running` ], [ Gauge ], [ Numero di worker (`GatewayWorker`) attualmente in esecuzione. ],
      [ `notip_sim_buffer_fill_level` ],
      [ GaugeVec (per `gateway_id`) ],
      [ Livello attuale di occupazione del canale del `MessageBuffer`. ],

      [ `notip_sim_buffer_dropped_total` ],
      [ CounterVec (per `gateway_id`) ],
      [ Messaggi scartati per saturazione della coda (Drop-Oldest). ],

      [ `notip_sim_envelopes_published_total` ],
      [ CounterVec (per `gateway_id`) ],
      [ Tentativi di pubblicazione NATS conclusi con successo. ],

      [ `notip_sim_publish_errors_total` ],
      [ CounterVec (per `gateway_id`) ],
      [ Errori intercettati durante la pubblicazione NATS. ],

      [ `notip_sim_nats_reconnects_total` ],
      [ CounterVec (per `gateway_id`) ],
      [ Riconnessioni forzate eseguite dal connettore NATS mTLS. ],

      [ `notip_sim_provisioning_success_total` ],
      [ Counter ],
      [ Onboarding completati con successo verso il Provisioning Cloud. ],

      [ `notip_sim_provisioning_errors_total` ],
      [ Counter ],
      [ Errori o rifiuti durante il processo di provisioning HTTP. ],

      [ `notip_sim_anomalies_injected_total` ],
      [ CounterVec (per `type`) ],
      [ Anomalie iniettate via API (classificate per tipo di anomalia). ],
    ),
  )

  == Errori

  #figure(
    caption: [Mappatura Errori di Dominio],
    table(
      columns: (1fr, 1fr, 2fr),
      [ *Errore Dominio* ], [ *Status HTTP* ], [ *Causa* ],
      [ `ErrGatewayNotFound` ], [ 404 ], [ Il gateway richiesto non esiste nel DB locale o nel registro. ],
      [ `ErrInvalidFactoryCredentials` ], [ 401 ], [ Le credenziali fornite sono rifiutate dal Provisioning Service. ],
      [ `ErrGatewayAlreadyProvisioned` ], [ 409 ], [ Tentativo di onboard su un gateway già attivo nel cloud. ],
      [ `ErrInvalidSensorRange` ], [ 400 ], [ Configurazione sensore errata (`MinRange >= MaxRange`). ],
    ),
  )

  == Flussi di Esecuzione

  Per comprendere l'orchestrazione interna del microservizio, vengono delineati i flussi delle operazioni principali,
  tracciando le chiamate attraverso gli strati esagonali dell'architettura.

  === Flusso di Provisioning e Avvio

  1. Il client effettua una chiamata `POST /sim/gateways`.
  2. Il `GatewayHandler` converte il payload in DTO di dominio e invoca il `GatewayRegistry`.
  3. Il Registry orchestra l'operazione delegando l'`Onboard` (`ProvisioningServiceClient`).
  4. Il Client genera una coppia di chiavi *RSA a 2048 bit* e crea un file *CSR*.
  5. Il CSR viene inviato tramite HTTP POST al Provisioning Service in Cloud.
  6. Alla ricezione del certificato X.509 e della *Chiave AES in Base64*, questa viene convertita nell'entità protetta
    `EncryptionKey`.
  7. Il `GatewayStore` SQLite salva l'entità completa (comprese le chiavi PEM locali).
  8. Il Registry crea un nuovo `GatewayWorker`, istanzia una connessione NATS isolata con i nuovi certificati, e avvia
    la goroutine di background.

  #align(center)[
    #image("assets/provisioning.png", width: 118%)
    Provisioning e Avvio
  ]

  === Flusso di Pubblicazione Telemetria

  1. Il `GatewayWorker` esegue ciclicamente operazioni non bloccanti basate sul `time.Ticker` della frequenza
    configurata.
  2. Per ogni `SimSensor` associato, viene invocata l'interfaccia `Generator.Next()` (es. onda sinusoidale o outlier
    forzato).
  3. Il payload JSON interno viene passato all'`AESGCMEncryptor`.
  4. L'Encryptor genera un *IV univoco di 12 byte*, cifra i dati utilizzando il materiale crittografico locale e appende
    l'AuthTag di validazione.
  5. La `TelemetryEnvelope` finale (con campi offuscati in Base64) viene spinta nel `MessageBuffer`.
  6. Il Buffer tenta l'invio a JetStream; in caso di congestione o offline, scarta l'elemento più vecchio in coda per
    far spazio al nuovo, aggiornando le metriche Prometheus (`notip_sim_buffer_dropped_total`).

  #align(center)[
    #image("assets/pubblicazione_telemetria.png", width: 110%)
    Pubblicazione Telemetria
  ]

  === Flusso di Decommissioning
  1. L'adapter `NATSDecommissionListener` rimane in perenne ascolto sul subject wildcard `gateway.decommissioned.>`.
  2. Ricevuto l'evento, estrae UUID e TenantID dalla rotta NATS.
  3. Tramite l'interfaccia (Porta) `DecommissionEventReceiver`, inoltra la richiesta al Core applicativo chiamando il
    metodo `HandleDecommission`.
  4. Il `GatewayRegistry`, che implementa tale interfaccia, riceve la chiamata. Acquisisce un lock di scrittura
    (`RWMutex`), cerca il worker corrispondente, lo arresta inviando un segnale al `context.CancelFunc` e disconnette il
    suo socket NATS.
  5. I dati persistenti vengono eliminati dallo `Store` locale in SQLite in via definitiva.

  = Metodologie di Testing

  Il microservizio adotta una strategia di testing multi-livello progettata per validare il corretto coordinamento dei
  worker concorrenti, la rigorosa segregazione dei dati e la validità della generazione matematica.

  == Test di unità
  I test di unità coprono i generatori matematici, il core applicativo (worker e registry), gli handler HTTP, le utilità
  crittografiche e i componenti di dominio, avvalendosi di _fake adapter_ in memoria per isolare la logica
  dall'infrastruttura. In particolare, devono essere verificati i seguenti aspetti:

  - Corretta generazione dei valori matematici (`SineWave`, `Spike`, `UniformRandom`, `Constant`) all'interno dei rigidi
    limiti `MinRange` e `MaxRange`;
  - Corretta iniezione temporanea di anomalie (outlier) e successivo e immediato ripristino dell'algoritmo matematico
    originario;
  - Corretta cifratura e strutturazione dei payload (AES-256-GCM), verificando la generazione dell'IV, l'apposizione
    dell'AuthTag e il rifiuto di chiavi non conformi ai 32 byte;
  - Corretta gestione del ciclo di vita dei `GatewayWorker` e della concorrenza sicura nel `GatewayRegistry` tramite
    `RWMutex`;
  - Corretta applicazione della politica _Drop-Oldest_ nel `MessageBuffer` in caso di overflow o indisponibilità della
    rete;
  - Corretta elaborazione e scarto di comandi JetStream obsoleti (scaduti da oltre 60 secondi) con conseguente invio di
    esiti NACK o Expired;
  - Corretta validazione, trasformazione in DTO e mappatura centralizzata degli errori di dominio nei corrispondenti
    codici di stato HTTP (400, 401, 404, 409, 500) all'interno degli handler REST;
  - Corretto popolamento isolato delle metriche Prometheus e validazione della configurazione applicativa con
    attivazione dei valori di fallback.

  == Test di integrazione
  I test di integrazione verificano il comportamento coordinato di più componenti interni al microservizio, sfruttando
  istanze reali per la persistenza (SQLite temporanei) e per il message brokering (tramite container generati con
  `testcontainers-go`). In particolare, devono essere coperti i seguenti aspetti:

  - Corretta esecuzione, transazionalità e idem-potenza delle migrazioni SQL su database locale, inclusa la validazione
    a basso livello (`PRAGMA table_info`) per i rimpiazzi di schema;
  - Corretto comportamento dei vincoli di integrità relazionale, come le policy `ON DELETE CASCADE` tra gateway e
    sensori logici;
  - Corretta instaurazione della connessione mTLS al broker NATS JetStream, verificata generando materialmente
    certificati e chiavi crittografiche _on-the-fly_;
  - Corretta pubblicazione e sottoscrizione dei messaggi sui subject JetStream, verificando l'inoltro della telemetria
    cifrata e l'ascolto resiliente, con scarto automatico dei payload malformati, sugli eventi di `decommission`;
  - Corretta simulazione del flusso di provisioning cloud tramite mock HTTP (`httptest.Server`), verificando il
    comportamento dei client a fronte di successi e fallimenti (es. HTTP 401 per credenziali di fabbrica rifiutate);
  - Corretto recupero dello stato applicativo e riavvio automatico e isolato dei worker al bootstrap del servizio in
    scenari di caduta del processo (`RecoveryMode`).

  == Obiettivi di copertura funzionale
  Le attività di test automatizzate garantiscono che il microservizio sia verificato almeno rispetto ai seguenti scenari
  e metriche:
  - *Copertura minima dell'80%* del codice di dominio e del core applicativo.
  - Integrità dello stato concorrente su scenari di stress test (creazione, avvio e arresto massivo di simulazioni).
  - Verifica della persistenza atomica tramite transazioni SQLite durante le migrazioni.
  - Isolamento crittografico deterministico tra i vari gateway simulati.
  - Tolleranza e resilienza di fronte a NATS congestionato o assente.
]
