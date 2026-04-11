#import "../../00-templates/base_document.typ" as base-document
#import "../specifica_tecnica/st_lib.typ" as st

#let metadata = yaml("specifica_tecnica_simulator_backend_cli.meta.yaml")
#show figure.where(kind: table): set block(breakable: true)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Specifica tecnica dei microservizi notip-simulator-backend e notip-simulator-cli: architettura interna (Ports & Adapters), simulazione di gateway e sensori, generazione dati, integrazioni NATS mTLS, schema del database locale, interfaccia a riga di comando per il controllo operativo dell'ambiente di simulazione e metodologie di testing.",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione al Documento

  Il presente documento raccoglie le specifiche tecniche di due microservizi distinti: `notip-simulator-backend` e
  `notip-simulator-cli`. Entrambi i componenti appartengono al sottosistema di simulazione della piattaforma NoTIP e
  sono progettati per operare in stretta sinergia: il backend costituisce il motore di simulazione, mentre la CLI
  rappresenta il piano di controllo operativo che consente agli operatori di pilotarlo.

  La scelta di riunire le specifiche dei due servizi in un unico documento è motivata dal loro accoppiamento funzionale:
  la CLI non possiede utilità autonoma al di fuori del contesto del backend, essendo interamente dedicata alla
  traduzione di comandi umani in chiamate HTTP verso le sue API REST. Trattarle come entità documentali separate
  produrrebbe una frammentazione che non rifletterebbe la reale dipendenza architetturale tra i due servizi.

  Il documento è strutturato in due parti principali:

  - *Parte I — `notip-simulator-backend`*: architettura esagonale, ciclo di vita dei gateway simulati, integrazioni NATS
    mTLS, schema SQLite e pipeline di testing del backend.
  - *Parte II — `notip-simulator-cli`*: struttura del binario Go, modelli di dominio, client HTTP, strato dei comandi
    Cobra, REPL interattiva e strategia di testing della CLI.

  = Parte I — notip-simulator-backend

  == Introduzione

  Questa sezione illustra l'architettura interna e le scelte implementative del microservizio `notip-simulator-backend`.
  Sviluppato in Go, questo componente è responsabile della simulazione di dispositivi fisici (Gateway e Sensori BLE) su
  larga scala. Il simulatore replica fedelmente il comportamento dell'hardware reale all'interno della piattaforma: si
  interfaccia con il Provisioning Service per il processo di onboarding e l'ottenimento del materiale crittografico,
  cifra i dati telemetrici localmente tramite AES-256-GCM, si connette al cluster NATS in mTLS per l'invio asincrono
  della telemetria e rimane in ascolto su JetStream per ricevere comandi dal Cloud o gestire eventi di decommissioning.
  L'architettura è altamente concorrente, associando ogni gateway virtuale a una goroutine dedicata gestita da un
  registro centrale.

  == Dipendenze e Configurazione

  === Variabili d'ambiente

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

  === Sequenza di avvio

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
        Inizializza la connessione SQLite (`modernc.org/sqlite`) ed esegue le migrazioni embeddate per lo schema dati.
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

  == Architettura Logica

  Il servizio adotta un'architettura *Ports and Adapters (Architettura Esagonale)*. La logica di business (generazione
  dati, gestione anomalie e ciclo di vita) è isolata al centro (Domain/App) e non dipende da framework infrastrutturali.
  Le comunicazioni verso l'esterno avvengono tramite interfacce (Ports) implementate dagli adapter (SQLite, NATS, HTTP).

  === Layout dei moduli
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

  #align(center)[
    #image("assets/notip-simulator-backend.svg", width: 100%)
    Architettura Logica del Simulator Backend.
  ]

  === Strati Architetturali

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

  === Decisioni Architetturali

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
  - *Persistenza Locale:* L'utilizzo di SQLite (`modernc.org/sqlite` cross-platform) garantisce sufficiente persistenza
    per la funzionalità di riavvio a caldo (`RecoveryMode`), mantenendo il microservizio completamente *self-contained*.
  - *Pipeline Crittografica Opaca (AES-GCM):* Rispettando il vincolo architetturale della piattaforma NoTIP, il payload
    telemetrico non viene mai esposto in chiaro sul broker di messaggistica. Il `GatewayWorker` utilizza
    l'`AESGCMEncryptor` locale per sigillare i dati prima dell'invio. La `EncryptionKey` è gestita come un _Value
    Object_ immutabile che impedisce l'accesso diretto ai byte della chiave, garantendo che i campi `EncryptedData`,
    `IV` e `AuthTag` viaggino come blob Base64 totalmente opachi.

  === Relazioni tra Componenti

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


  == Design di Dettaglio

  === Moduli del microservizio

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

  === Entità

  #figure(
    caption: [Entità persistenti (SQLite)],
    table(
      columns: (1fr, 3fr),
      [ *Entità* ], [ *Campi principali* ],
      [ `gateways` ],
      [
        `id`, `management_gateway_id`, `factory_id`, `factory_key`, `model`, `firmware_version`, `provisioned`,
        `cert_pem`, `private_key_pem`, `encryption_key`, `send_frequency_ms`, `status`, `tenant_id`, `created_at`
      ],

      [ `sensors` ], [ `id`, `gateway_id`, `sensor_id`, `type`, `min_range`, `max_range`, `algorithm`, `created_at` ],
    ),
  )

  === Endpoint API HTTP

  L'API server (configurato nel file `server.go`) espone gli endpoint per pilotare la simulazione. Di seguito il
  dettaglio completo delle rotte.

  ==== Health
  #figure(
    caption: [Endpoint GET /health],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `GET /health` ],
      [ *Descrizione* ],
      [ Liveness probe. Ritorna HTTP 200 con `{"status": "ok"}` per confermare che il server HTTP è in ascolto. ],
    ),
  )

  ==== Gateways
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
      [ *Body Request* ], [ `{"baseFactoryIds": "sim-", "factoryKey": "...", "model": "..."}` ],
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

  ==== Sensori
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

  ==== Anomalie
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

  === Integrazioni Cloud (HTTP e JetStream)

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

  === Metriche Operative

  Il microservizio espone internamente le proprie metriche in formato Prometheus sulla porta configurata
  (`METRICS_ADDR`). L'uso estensivo di `GaugeVec` e `CounterVec` permette il monitoraggio granulare della "salute" di
  ciascun gateway simulato e l'identificazione di colli di bottiglia verso NATS.

  #figure(
    caption: [Metriche Prometheus esposte dal simulatore],
    table(
      columns: (2.5fr, 1.2fr, 2fr),
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


  === Errori

  #figure(
    caption: [Mappatura Errori di Dominio],
    table(
      columns: (2fr, 1fr, 2fr),
      [ *Errore Dominio* ], [ *Status HTTP* ], [ *Causa* ],
      [ `ErrGatewayNotFound` ], [ 404 ], [ Il gateway richiesto non esiste nel DB locale o nel registro. ],
      [ `ErrInvalidFactoryCredentials` ], [ 401 ], [ Le credenziali fornite sono rifiutate dal Provisioning Service. ],
      [ `ErrGatewayAlreadyProvisioned` ], [ 409 ], [ Tentativo di onboard su un gateway già attivo nel cloud. ],
      [ `ErrInvalidSensorRange` ], [ 400 ], [ Configurazione sensore errata (`MinRange >= MaxRange`). ],
    ),
  )

  === Flussi di Esecuzione

  Per comprendere l'orchestrazione interna del microservizio, vengono delineati i flussi delle operazioni principali,
  tracciando le chiamate attraverso gli strati esagonali dell'architettura.

  ==== Flusso di Provisioning e Avvio

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



  ==== Flusso di Pubblicazione Telemetria

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



  ==== Flusso di Decommissioning
  1. L'adapter `NATSDecommissionListener` rimane in perenne ascolto sul subject wildcard `gateway.decommissioned.>`.
  2. Ricevuto l'evento, estrae UUID e TenantID dalla rotta NATS.
  3. Tramite l'interfaccia (Porta) `DecommissionEventReceiver`, inoltra la richiesta al Core applicativo chiamando il
    metodo `HandleDecommission`.
  4. Il `GatewayRegistry`, che implementa tale interfaccia, riceve la chiamata. Acquisisce un lock di scrittura
    (`RWMutex`), cerca il worker corrispondente, lo arresta inviando un segnale al `context.CancelFunc` e disconnette il
    suo socket NATS.
  5. I dati persistenti vengono eliminati dallo `Store` locale in SQLite in via definitiva.

  == Metodologie di Testing

  Il microservizio adotta una strategia di testing multi-livello progettata per validare il corretto coordinamento dei
  worker concorrenti, la rigorosa segregazione dei dati e la validità della generazione matematica. I test di unità si
  avvalgono di _fake adapter_ in memoria per isolare la logica dall'infrastruttura; i test di integrazione utilizzano
  istanze reali (SQLite temporanei, container NATS via `testcontainers-go`).

  === Test di Unità

  *Generatori Matematici e Crittografia*

  #table(
    columns: (2fr, 3fr),
    [Caso di test], [Postcondizione verificata],
    [`SineWave` — valori entro i limiti],
    [Tutti i campioni generati ricadono nell'intervallo `[MinRange, MaxRange]` per l'intera durata del ciclo],

    [`Spike` — picco e ritorno],
    [Il valore anomalo viene emesso esattamente una volta; i campioni successivi tornano all'algoritmo di base],

    [`UniformRandom` — distribuzione nei limiti],
    [I valori generati rispettano i bound configurati; nessun campione supera `MaxRange` o scende sotto `MinRange`],

    [`Constant` — valore fisso],
    [Tutti i campioni restituiscono invariabilmente il valore configurato indipendentemente dall'iterazione],

    [Cifratura AES-256-GCM — struttura payload],
    [Il payload prodotto contiene un IV generato casualmente, il ciphertext e l'AuthTag; il campo `keyVersion` è
      popolato correttamente],

    [Cifratura AES-256-GCM — chiave non conforme],
    [Una chiave con lunghezza diversa da 32 byte provoca un errore esplicito senza produrre output parziale],
  )

  *Core Applicativo — Worker e Registry*

  #table(
    columns: (2fr, 3fr),
    [Caso di test], [Postcondizione verificata],
    [`GatewayWorker` — ciclo di vita start/stop],
    [Il worker avvia la goroutine di emissione, risponde ai comandi di stop e termina senza goroutine in fuga],

    [`GatewayRegistry` — accesso concorrente],
    [Operazioni concorrenti di lettura e scrittura tramite `RWMutex` non producono data race rilevabili con `-race`],

    [`MessageBuffer` — politica Drop-Oldest in overflow],
    [Quando il buffer è pieno, il messaggio più vecchio viene scartato e il nuovo viene accodato correttamente],

    [`MessageBuffer` — Drop-Oldest su rete assente],
    [In assenza di connettività NATS, il buffer accumula fino al limite e applica Drop-Oldest senza bloccare],

    [Comandi JetStream — scarto obsoleti],
    [Un comando con timestamp superiore a 60 secondi viene scartato con esito NACK o Expired senza essere elaborato],

    [Comandi JetStream — elaborazione valida],
    [Un comando recente viene applicato al worker corretto e l'ACK viene inviato al broker],
  )

  *Handler HTTP e Configurazione*

  #table(
    columns: (2fr, 3fr),
    [Caso di test], [Postcondizione verificata],
    [Handler — validazione input e mapping errori],
    [Input non conformi producono risposte 400; risorse mancanti producono 404; conflitti producono 409; errori interni
      producono 500],

    [Handler — trasformazione DTO],
    [I campi del dominio vengono serializzati nelle chiavi JSON contrattualmente attese dal client CLI],

    [Metriche Prometheus — popolamento isolato],
    [I counter e gli histogram vengono incrementati correttamente senza interferenze tra test paralleli],

    [Configurazione — valori di fallback],
    [Le variabili d'ambiente assenti attivano i default definiti; una variabile obbligatoria mancante causa errore
      all'avvio],
  )

  === Test di Integrazione

  *Persistenza e Migrazioni (SQLite)*

  #table(
    columns: (2fr, 1fr, 2fr),
    [Caso di test], [Infrastruttura], [Verifica],
    [Migrazioni — esecuzione e idempotenza],
    [SQLite temporaneo],
    [Le migrazioni vengono applicate correttamente; una seconda esecuzione è idempotente e non altera lo schema],

    [Migrazioni — rimpiazzo schema],
    [SQLite temporaneo],
    [La validazione a basso livello via `PRAGMA table_info` conferma che le colonne attese siano presenti dopo il
      rimpiazzo],

    [Vincoli relazionali — `ON DELETE CASCADE`],
    [SQLite temporaneo],
    [L'eliminazione di un gateway rimuove automaticamente tutti i sensori logici associati],
  )

  *Message Brokering (NATS JetStream)*

  #table(
    columns: (2fr, 1fr, 2fr),
    [Caso di test], [Infrastruttura], [Verifica],
    [Connessione mTLS al broker],
    [`testcontainers-go`],
    [La connessione al broker NATS con certificati generati _on-the-fly_ viene stabilita correttamente],

    [Pubblicazione telemetria cifrata],
    [`testcontainers-go`],
    [I payload prodotti dal worker vengono pubblicati sul subject corretto e ricevuti da un subscriber di controllo],

    [Sottoscrizione eventi `decommission`],
    [`testcontainers-go`],
    [I payload malformati vengono scartati silenziosamente; i payload validi avviano il decommission del gateway],
  )

  *Provisioning e Recovery*

  #table(
    columns: (2fr, 1fr, 2fr),
    [Caso di test], [Infrastruttura], [Verifica],
    [Provisioning — successo],
    [`httptest.Server`],
    [Il flusso completo produce un gateway provisionato con certificato e chiave AES persistiti nello Store],

    [Provisioning — credenziali rifiutate (HTTP 401)],
    [`httptest.Server`],
    [Il client riceve l'errore 401 e lo propaga senza lasciare dati parziali nello Store],

    [`RecoveryMode` — riavvio worker],
    [SQLite temporaneo],
    [Al bootstrap, i gateway già presenti nello Store vengono estratti e i rispettivi worker vengono riavviati in
      isolamento],
  )

  === Obiettivi di Copertura Funzionale

  Le attività di test automatizzate garantiscono che il microservizio sia verificato almeno rispetto ai seguenti
  scenari:

  - Copertura minima dell'*80%* del codice di dominio e del core applicativo.
  - Assenza di data race nel `GatewayRegistry` verificata con il flag `-race` su scenari di accesso concorrente.
  - Persistenza atomica tramite transazioni SQLite durante le migrazioni, incluso il caso di interruzione parziale.
  - Corretta estrazione e riavvio dei gateway esistenti in `RecoveryMode` dopo caduta del processo.
  - Tolleranza di fronte a NATS congestionato o assente, con applicazione verificabile della politica Drop-Oldest.

  = Parte II — notip-simulator-cli

  == Introduzione

  Il `notip-simulator-cli` è un binario Go autonomo (`sim-cli`) che funge da centro di controllo per il
  `notip-simulator-backend`. È progettato per essere eseguito come container Docker effimero (con esecuzione di singolo
  comando) o direttamente da terminale tramite shell. La sua unica responsabilità è tradurre comandi leggibili
  dall'operatore in chiamate HTTP verso le API REST del backend simulatore.

  La CLI *non contiene logica di business*. Non persiste stato, non comunica con NATS e non interagisce con alcun
  database. Ogni operazione corrisponde a una singola richiesta HTTP (o a una coppia di richieste quando è necessaria la
  risoluzione dell'UUID del gateway).

  == Dipendenze e Configurazione

  === Variabili d'ambiente

  #figure(
    caption: [Variabili d'ambiente del microservizio notip-simulator-cli],
    table(
      columns: (1fr, 1.5fr, 1fr, 1fr),
      [ *Campo* ], [ *Variabile d'ambiente* ], [ *Default* ], [ *Note* ],
      [ SimulatorURL ],
      [ `SIMULATOR_URL` ],
      [ `http://simulator:8090` ],
      [ Base URL del backend. Letta una sola volta all'avvio del processo; non viene riletta durante l'esecuzione. ],
    ),
  )

  === Rilevamento TTY

  All'avvio, la CLI verifica se `os.Stdout` è un terminale interattivo tramite `golang.org/x/term.IsTerminal`. Se *non*
  lo è (output rediretto, pipeline CI), PTerm, modulo di Go, disabilita globalmente stile e colori, garantendo output
  pulito e analizzabile da strumenti automatici. Il controllo viene eseguito una sola volta in `cmd.init()` e non è
  riconfigurabile a runtime.

  Questa scelta progettuale ha due implicazioni dirette:
  - In ambienti non interattivi, lo spinner animato viene sostituito da un `noopSpinner`, prevenendo la creazione di
    goroutine PTerm che causerebbero problemi.
  - Le tabelle e i messaggi di output mantengono la stessa struttura sia in modalità TTY che non-TTY, ma senza codici
    ANSI di colore nella seconda.

  == Scelte Architetturali

  Di seguito sono descritte le scelte progettuali principali adottate nella CLI e la loro motivazione.

  #figure(
    caption: [Pattern architetturali adottati nel notip-simulator-cli],
    table(
      columns: (1.2fr, 2.8fr),
      [ *Pattern* ], [ *Motivazione e comportamento* ],
      [ *Builder / propagazione del contesto* ],
      [
        `Client.WithContext(ctx)` restituisce una copia superficiale del client legata a un nuovo `context.Context`.
        Ogni comando passa `cmd.Context()` tramite questo metodo, assicurando che la gestione dei segnali di Cobra si
        propaghi alle richieste HTTP in corso.
      ],

      [ *Identificatori UUID-first* ],
      [
        Tutti gli identificatori di gateway e sensori sono stringhe UUID nell'intera API. `resolveGatewayID` chiama
        `GetGateway(uuid)` e restituisce `gw.ID` (stringa). I comandi sensore accettano UUID direttamente — non viene
        eseguito alcun parsing di ID numerici.
      ],

      [ *Validazione backend-first* ],
      [
        La maggior parte dei vincoli numerici e di dominio (es. durata positiva, range packet loss) sono trattati come
        regole contrattuali del backend. La CLI impone solo i flag obbligatori e il parsing numerico, senza aggiungere
        una validazione semantica ampia prima dell'invio delle richieste.
      ],
    ),
  )

  == Architettura Logica

  #align(center)[
    #image("./assets/simulator_cli.png", width: 100%)
  ]

  === Layout dei Pacchetti

  ```text
  notip-simulator-cli/
  ├── main.go                          Entry point; execute/exit iniettabili per i test
  ├── main_test.go                     Test dell'entry point per il path di errore
  ├── cmd/
  │   ├── root.go                      Comando Cobra root, init TTY, reset flag, SIMULATOR_URL
  │   ├── gateways.go                  Sottocomandi gateway (list, get, create, bulk, start, stop, delete)
  │   ├── sensors.go                   Sottocomandi sensore (add, list, delete); risoluzione UUID→ID
  │   ├── anomalies.go                 Sottocomandi anomalia (disconnect, network-degradation, outlier)
  │   ├── shell.go                     Modalità REPL interattiva (editor di riga su TTY, fallback bufio)
  │   ├── spinner.go                   Interfaccia spinner, ptermSpinner, noopSpinner, startSpinner
  │   ├── commands_test.go             Test di integrazione per tutti i comandi CLI (mock HTTP server)
  │   ├── shell_test.go                Test della REPL shell
  │   ├── spinner_test.go              Test dell'astrazione spinner
  │   ├── anomalies_test.go            Test di validazione flag anomalie
  │   └── request_mapping_test.go      Test di mapping payload richieste
  └── internal/
      └── client/
          ├── client.go                Client HTTP, modelli di dominio, tipi richiesta/risposta
          ├── client_test.go           Test unitari del client HTTP (httptest)
          └── request_construction_test.go   Test di costruzione delle richieste
  ```

  == Design di Dettaglio

  === Modelli di Dominio (`internal/client`)

  Tutti i tipi sono struct di dati puri con tag JSON. Non sono presenti metodi eccetto su `Client`.

  ==== `Gateway` — value object

  Rispecchia il DTO `GatewayResponse` restituito dal backend simulatore. `ID` è l'identificatore pubblico del gateway
  (stringa UUID) usato in tutti i path API. `ManagementGatewayID` è un UUID aggiuntivo del piano di management presente
  su alcuni backend.

  #figure(
    caption: [Campi della struct Gateway],
    table(
      columns: (1fr, 0.5fr, 1.5fr, 1fr),
      [ *Campo* ], [ *Tipo* ], [ *Tag JSON* ], [ *Note* ],
      [ `ID` ], [ `string` ], [ `id` ], [ Identificatore pubblico (UUID); usato in tutti i path gateway e sensore. ],
      [ `ManagementGatewayID` ],
      [ `string` ],
      [ `managementGatewayId,omitempty` ],
      [ UUID del piano di management; opzionale. ],

      [ `FactoryID` ], [ `string` ], [ `factoryId` ], [ ],
      [ `Model` ], [ `string` ], [ `model` ], [ ],
      [ `FirmwareVersion` ], [ `string` ], [ `firmwareVersion` ], [ ],
      [ `Provisioned` ], [ `bool` ], [ `provisioned` ], [ ],
      [ `SendFrequencyMs` ], [ `int` ], [ `sendFrequencyMs` ], [ Intervallo di emissione telemetria in ms. ],
      [ `Status` ], [ `string` ], [ `status` ], [ Stato runtime (es. `"online"`, `"offline"`). ],
      [ `TenantID` ], [ `string` ], [ `tenantId` ], [ ],
      [ `CreatedAt` ], [ `string` ], [ `createdAt` ], [ Stringa ISO-8601; non viene effettuato il parsing. ],
    ),
  )

  ==== `Sensor` — value object

  Rispecchia il DTO `SensorResponse` restituito dal backend.

  #figure(
    caption: [Campi della struct Sensor],
    table(
      columns: (1fr, 1fr, 1.2fr, 2fr),
      [ *Campo* ], [ *Tipo* ], [ *Tag JSON* ], [ *Note* ],
      [ `ID` ], [ `string` ], [ `id` ], [ Identificatore pubblico (UUID); usato nei path di delete sensore e outlier. ],
      [ `GatewayID` ], [ `string` ], [ `gatewayId` ], [ UUID del gateway padre. ],
      [ `Type` ], [ `string` ], [ `type` ], [ Stringa del tipo di sensore. ],
      [ `MinRange` ], [ `float64` ], [ `minRange` ], [ ],
      [ `MaxRange` ], [ `float64` ], [ `maxRange` ], [ ],
      [ `Algorithm` ], [ `string` ], [ `algorithm` ], [ Algoritmo di generazione dati. ],
      [ `CreatedAt` ], [ `string` ], [ `createdAt` ], [ Stringa ISO-8601; non viene effettuato il parsing. ],
    ),
  )

  === Tipi di Richiesta (`internal/client`)

  Le struct di richiesta sono serializzate in JSON e inviate come corpo delle richieste HTTP. I campi marcati
  `omitempty` vengono omessi dal payload JSON quando assumono il valore zero.

  ==== `CreateGatewayRequest`

  Payload dedicato all'endpoint `POST /sim/gateways`.

  #figure(
    caption: [Campi di CreateGatewayRequest],
    table(
      columns: (1.2fr, 0.8fr, 2fr, 0.6fr, 1.2fr),
      [ *Campo* ], [ *Tipo* ], [ *Tag JSON* ], [ *Req.* ], [ *Note* ],
      [ `FactoryID` ], [ `string` ], [ `factoryId` ], [ Sì ], [ ],
      [ `FactoryKey` ], [ `string` ], [ `factoryKey` ], [ Sì ], [ ],
      [ `Model` ], [ `string` ], [ `model,omitempty` ], [ No ], [ ],
      [ `FirmwareVersion` ], [ `string` ], [ `firmwareVersion,omitempty` ], [ No ], [ ],
      [ `SendFrequencyMs` ], [ `int` ], [ `sendFrequencyMs,omitempty` ], [ No ], [ Default: 1000 ms via flag CLI. ],
    ),
  )

  ==== `BulkCreateGatewaysRequest`

  Payload dedicato all'endpoint `POST /sim/gateways/bulk`.

  #figure(
    caption: [Campi di BulkCreateGatewaysRequest],
    table(
      columns: (1.2fr, 0.8fr, 2fr, 0.6fr, 1.2fr),
      [ *Campo* ], [ *Tipo* ], [ *Tag JSON* ], [ *Req.* ], [ *Note* ],
      [ `FactoryIDs` ], [ `[]string` ], [ `factoryId` ], [ Sì ], [ ],
      [ `FactoryKey` ], [ `string` ], [ `factoryKey` ], [ Sì ], [ ],
      [ `Model` ], [ `string` ], [ `model,omitempty` ], [ No ], [ ],
      [ `FirmwareVersion` ], [ `string` ], [ `firmwareVersion,omitempty` ], [ No ], [ ],
      [ `SendFrequencyMs` ], [ `int` ], [ `sendFrequencyMs,omitempty` ], [ No ], [ Default: 1000 ms via flag CLI. ],
    ),
  )

  ==== `BulkCreateResponse`

  Risposta di `POST /sim/gateways/bulk`. HTTP 201 indica successo totale; HTTP 207 indica errori parziali.

  #figure(
    caption: [Campi di BulkCreateResponse],
    table(
      columns: (1fr, 1fr, 1fr, 2fr),
      [ *Campo* ], [ *Tipo* ], [ *Tag JSON* ], [ *Note* ],
      [ `Gateways` ], [ `[]Gateway` ], [ `gateways` ], [ Gateway creati con successo. ],
      [ `Errors` ],
      [ `[]string` ],
      [ `errors` ],
      [ Slice parallela: stringa vuota all'indice i significa che il gateway i è stato creato con successo. ],
    ),
  )

  ==== `AddSensorRequest`

  Payload dedicato all'endpoint `POST /sim/gateways/{id}/sensors`. Il parametro `{id}` è l'UUID del gateway.

  #figure(
    caption: [Campi di AddSensorRequest],
    table(
      columns: (1fr, 1fr, 1fr, 0.6fr, 2fr),
      [ *Campo* ], [ *Tipo* ], [ *Tag JSON* ], [ *Req.* ], [ *Note* ],
      [ `Type` ], [ `string` ], [ `type` ], [ Sì ], [ `temperature`, `humidity`, `pressure`, `movement`, `biometric`. ],
      [ `MinRange` ], [ `float64` ], [ `minRange` ], [ Sì ], [ ],
      [ `MaxRange` ], [ `float64` ], [ `maxRange` ], [ Sì ], [ ],
      [ `Algorithm` ], [ `string` ], [ `algorithm` ], [ Sì ], [ `uniform_random`, `sine_wave`, `spike`, `constant`. ],
    ),
  )

  ==== `NetworkDegradationRequest`

  Payload dedicato all'endpoint `POST /sim/gateways/{id}/anomaly/network-degradation`.

  #figure(
    caption: [Campi di NetworkDegradationRequest],
    table(
      columns: (1fr, 0.5fr, 1.8fr, 1.8fr),
      [ *Campo* ], [ *Tipo* ], [ *Tag JSON* ], [ *Note* ],
      [ `DurationSeconds` ],
      [ `int` ],
      [ `duration_seconds` ],
      [ Obbligatorio da policy flag CLI; la CLI non impone `> 0`, il backend valida la semantica. ],

      [ `PacketLossPct` ],
      [ `float64` ],
      [ `packet_loss_pct,omitempty` ],
      [ Frazione 0–1; omesso quando 0; il backend applica il default 0.3. ],
    ),
  )

  ==== `DisconnectRequest`

  Payload dedicato all'endpoint `POST /sim/gateways/{id}/anomaly/disconnect`.

  #figure(
    caption: [Campi di DisconnectRequest],
    table(
      columns: (1fr, 1fr, 1.2fr, 2.5fr),
      [ *Campo* ], [ *Tipo* ], [ *Tag JSON* ], [ *Note* ],
      [ `DurationSeconds` ],
      [ `int` ],
      [ `duration_seconds` ],
      [ Obbligatorio da policy flag CLI; il backend valida la semantica. ],
    ),
  )

  ==== `OutlierRequest`

  Payload dedicato all'endpoint `POST /sim/sensors/{sensorId}/anomaly/outlier`.

  #figure(
    caption: [Campi di OutlierRequest],
    table(
      columns: (1fr, 1fr, 1.2fr, 2.5fr),
      [ *Campo* ], [ *Tipo* ], [ *Tag JSON* ], [ *Note* ],
      [ `Value` ],
      [ `*float64` ],
      [ `value,omitempty` ],
      [
        Puntatore opzionale; omesso quando nil. Il campo è assente dal JSON quando il flag `--value` non è stato
        esplicitamente impostato; il backend applica il proprio fallback.
      ],
    ),
  )

  === HTTP Client (`internal/client`)

  ==== Struct `Client`

  Il singolo client HTTP per tutte le interazioni con il backend simulatore. Mantiene una base URL, un `*http.Client`
  standard con timeout fisso di 30 secondi e un `context.Context` per la cancellazione per-richiesta.

  #figure(
    caption: [Campi della struct Client],
    table(
      columns: (1fr, 1fr, 2fr),
      [ *Campo* ], [ *Tipo* ], [ *Note* ],
      [ `baseURL` ], [ `string` ], [ Impostato alla costruzione; mai mutato. ],
      [ `httpClient` ], [ `*http.Client` ], [ Condiviso tra tutti i metodi; timeout 30 s. ],
      [ `ctx` ], [ `context.Context` ], [ Contesto per-richiesta; sostituito da `WithContext`. ],
    ),
  )

  Le costanti interne definiscono i prefissi dei path: `pathGateways` (`"/sim/gateways/"`), `pathSensors`
  (`"/sim/sensors/"`), `defaultTimeout` (30 s).

  Il costruttore `New(baseURL string) *Client` crea un `Client` con un nuovo `*http.Client` (timeout 30 s) e
  `context.Background()`. Il metodo `WithContext(ctx context.Context) *Client` restituisce una copia superficiale con
  `ctx` impostato; se `ctx` è nil, ricade su `context.Background()`.

  ==== Metodi Gateway

  #figure(
    caption: [Metodi HTTP del Client per i Gateway],
    table(
      columns: (1.5fr, 1.8fr, 2.2fr, 1.8fr),
      [ *Metodo* ], [ *HTTP / Path* ], [ *Body* ], [ *Ritorna* ],
      [ `ListGateways` ], [ GET `/sim/gateways` ], [ — ], [ `([]Gateway, error)` ],
      [ `GetGateway` ], [ GET `/sim/gateways/{uuid}` ], [ — ], [ `(*Gateway, error)` ],
      [ `CreateGateway` ], [ POST `/sim/gateways` ], [ `CreateGatewayRequest` ], [ `(*Gateway, error)` ],
      [ `BulkCreateGateways` ],
      [ POST `/sim/gateways/bulk` ],
      [ `BulkCreateGatewaysRequest` ],
      [ `(*BulkCreateResponse, error)` ],

      [ `StartGateway` ], [ POST `/sim/gateways/{uuid}/start` ], [ nessuno ], [ `error` ],
      [ `StopGateway` ], [ POST `/sim/gateways/{uuid}/stop` ], [ nessuno ], [ `error` ],
      [ `DeleteGateway` ], [ DELETE `/sim/gateways/{uuid}` ], [ — ], [ `error` ],
    ),
  )

  ==== Metodi Sensori

  #figure(
    caption: [Metodi HTTP del Client per i Sensori],
    table(
      columns: (2fr, 3fr, 2fr),
      [ *Metodo* ], [ *HTTP / Path* ], [ *Note* ],
      [ `AddSensor(gatewayID, req)` ], [ POST `/sim/gateways/{gatewayID}/sensors` ], [ Usa UUID gateway. ],
      [ `ListSensors(gatewayID)` ], [ GET `/sim/gateways/{gatewayID}/sensors` ], [ Usa UUID gateway. ],
      [ `DeleteSensor(sensorID)` ], [ DELETE `/sim/sensors/{sensorID}` ], [ Usa UUID sensore. ],
    ),
  )

  ==== Metodi Anomalie

  #figure(
    caption: [Metodi HTTP del Client per le Anomalie],
    table(
      columns: (3fr, 1.5fr, 1.5fr),
      [ *Metodo* ], [ *HTTP / Path* ], [ *Note* ],
      [ `InjectNetworkDegradation(gatewayID, durationSeconds, packetLossPct)` ],
      [ POST `/sim/gateways/{uuid}/anomaly/network-degradation` ],
      [ Usa UUID gateway. ],

      [ `Disconnect(gatewayID, durationSeconds)` ],
      [ POST `/sim/gateways/{uuid}/anomaly/disconnect` ],
      [ Usa UUID gateway. ],

      [ `InjectOutlier(sensorID, value *float64)` ],
      [ POST `/sim/sensors/{sensorID}/anomaly/outlier` ],
      [ Usa UUID sensore. ],
    ),
  )

  ==== Helper Privati

  Il metodo privato `post(path string, body any) (*http.Response, error)` serializza il `body` in JSON se non nil,
  imposta `Content-Type: application/json` e usa `http.NewRequestWithContext` con `c.ctx`. La funzione
  `checkStatus(resp *http.Response) error` permette di restituire nil per i codici 2xx; per qualsiasi altro codice legge
  il corpo della risposta e restituisce un errore formattato.

  === Strato dei Comandi (`cmd`)

  I comandi della CLI sono implementati come variabili di pacchetto non esportate di tipo `*cobra.Command` e registrate
  tramite le funzioni `init()`. L'architettura di questo strato è *stateless*: ogni singola invocazione di un comando
  istanzia un nuovo `*client.Client`, evitando qualsiasi condivisione di stato tra le esecuzioni.

  ==== Comando Radice (`root`)

  La variabile `rootCmd` rappresenta il punto di ingresso principale dell'applicativo (`sim-cli`). La sua configurazione
  e il suo ciclo di vita sono gestiti come segue:

  - Inizializzazione: La variabile di pacchetto `simulatorURL` viene popolata leggendo la variabile d'ambiente
    `SIMULATOR_URL` durante la fase di `init()`.
  - Esecuzione: La funzione esportata `Execute() error` agisce da wrapper per `rootCmd.Execute()` e viene invocata
    direttamente dall'entry point nel `main()`.
  - Gestione dello Stato: La funzione `resetAllCommandFlags(c *cobra.Command)` percorre ricorsivamente l'albero dei
    comandi per ripristinare ogni flag al proprio valore di default dichiarato, forzando lo stato `Changed = false`.
    Questo meccanismo di pulizia è essenziale e obbligatorio prima di ogni iterazione della REPL shell, in quanto
    previene la contaminazione dei parametri tra un comando e il successivo.

  ==== Sottocomandi `gateways`

  Il comando padre `gatewaysCmd` (invocato come `sim-cli gateways`) funge da raggruppamento logico per sette
  sottocomandi operativi. L'intera configurazione e registrazione di questo gruppo avviene all'interno della funzione
  `init()` del file `cmd/gateways.go`.

  #figure(
    caption: [Sottocomandi gateways e loro flag],
    table(
      columns: (1fr, 1.5fr, 2fr),
      [ *Sottocomando* ], [ *Argomenti / Flag* ], [ *Comportamento* ],
      [ `gateways list` ],
      [ Nessun flag. ],
      [
        Elenca tutti i gateway come tabella PTerm con colonne: ID, UUID, Status (color-coded), Model, Freq (ms), Tenant.
      ],

      [ `gateways get <uuid>` ],
      [ 1 argomento posizionale: UUID gateway. ],
      [
        Mostra una tabella chiave–valore verticale con: ID, UUID, Factory ID, Model, Firmware, Status, Provisioned, Send
        Freq (ms), Tenant, Created At.
      ],

      [ `gateways create` ],
      [
        `--factory-id` (req.), `--factory-key` (req.), `--model` (req.), `--firmware` (req.), `--freq` int default 1000
        (req.).
      ],
      [ In caso di successo, mostra il gateway creato come tabella. ],

      [ `gateways bulk` ],
      [
        `--count` int default 1 (req.), `--factory-id` (req.), `--factory-key` (req.), `--model` (req.), `--firmware`
        (req.), `--freq` int default 1000 (req.).
      ],
      [
        HTTP 207 (parziale) non è un errore a livello comando: viene mostrato uno stato `Warning` con il conteggio dei
        fallimenti; i gateway creati con successo vengono comunque renderizzati.
      ],

      [ `gateways start <uuid>` ], [ 1 argomento posizionale: UUID gateway. ], [ Avvia il worker del gateway. ],
      [ `gateways stop <uuid>` ], [ 1 argomento posizionale: UUID gateway. ], [ Arresta il worker del gateway. ],
      [ `gateways delete <uuid>` ],
      [ 1 argomento posizionale: UUID gateway. ],
      [ Rimuove permanentemente il gateway e i suoi sensori. ],
    ),
  )

  ==== Sottocomandi `sensors`

  Il comando padre `sensorsCmd` (invocato come `sim-cli sensors`) gestisce le operazioni relative ai sensori ed è
  composto da tre sottocomandi registrati nel file `cmd/sensors.go` durante la fase di `init()`.

  Un aspetto implementativo rilevante di questo gruppo è la validazione preventiva degli identificatori. Per garantire
  la coerenza delle operazioni, viene utilizzata la funzione di supporto
  `resolveGatewayID(c *client.Client, input string) (string, error)`. Tale funzione invoca `c.GetGateway(input)` e ne
  restituisce il campo `gw.ID`; questo comporta l'esecuzione deliberata di una richiesta HTTP aggiuntiva verso il
  backend al solo scopo di validare l'esistenza e la correttezza dell'UUID del gateway prima di procedere con la logica
  del comando.

  #figure(
    caption: [Sottocomandi sensors e loro flag],
    table(
      columns: (1fr, 1.5fr, 2fr),
      [ *Sottocomando* ], [ *Argomenti / Flag* ], [ *Comportamento* ],
      [ `sensors add <gateway-uuid>` ],
      [ `--type` (req.), `--min` float64 default 0 (req.), `--max` float64 default 100 (req.), `--algorithm` (req.). ],
      [ Chiama sempre prima `GetGateway` per validare e risolvere l'ID gateway (2 richieste HTTP totali). ],

      [ `sensors list <gateway-uuid>` ],
      [ 1 argomento posizionale. ],
      [
        Chiama `resolveGatewayID` (1 richiesta `GetGateway` aggiuntiva). Mostra tabella PTerm con colonne: ID, UUID,
        Type, Min, Max, Algorithm.
      ],

      [ `sensors delete <sensor-uuid>` ],
      [ 1 argomento posizionale: UUID sensore. ],
      [ Nessuna validazione oltre la presenza dell'argomento. ],
    ),
  )

  ==== Sottocomandi `anomalies`

  Il comando padre `anomaliesCmd` (invocato come `sim-cli anomalies`) costituisce il raggruppamento logico per tutte le
  operazioni di iniezione di guasti e manipolazione del comportamento simulato (come disconnessioni forzate, degrado
  della rete e generazione di valori _outlier_). I tre sottocomandi che lo compongono sono registrati e configurati
  all'interno della funzione `init()` del file `cmd/anomalies.go`.

  #figure(
    caption: [Sottocomandi anomalies e loro flag],
    table(
      columns: (1fr, 1.5fr, 2fr),
      [ *Sottocomando* ], [ *Argomenti / Flag* ], [ *Comportamento* ],
      [ `anomalies disconnect <gateway-uuid>` ],
      [ `--duration` int default 0 (req.). ],
      [ Il backend impone la validità semantica della durata. ],

      [ `anomalies network-degradation <gateway-uuid>` ],
      [ `--duration` int default 0 (req.), `--packet-loss` float64 default 0 (opz.). ],
      [
        Quando `--packet-loss` non è fornito (`Changed == false`), il valore 0 viene passato a
        `InjectNetworkDegradation`; il tag `omitempty` lo esclude dal JSON e il backend applica il proprio default di
        0.3.
      ],

      [ `anomalies outlier <sensor-uuid>` ],
      [ `--value` float64 default 0 (opz.). ],
      [
        La presenza del flag è controllata esplicitamente via `cmd.Flags().Changed("value")`. Solo quando il flag è
        stato impostato esplicitamente, il valore è convertito in `*float64` e incluso nella richiesta. Quando omesso,
        `OutlierRequest.Value` è nil e il campo è assente dal JSON.
      ],
    ),
  )

  ==== Comando `shell`

  Il comando `sim-cli shell` avvia una sessione interattiva, consentendo l'esecuzione sequenziale di molteplici comandi
  senza la necessità di riavviare il processo o il container ospite. Il ciclo di vita della sessione si articola nelle
  seguenti fasi:

  + Inizializzazione visiva: Viene stampato un banner di benvenuto. In modalità _styled_ (interattiva) utilizza i
    componenti `BigText` e `DefaultBox` della libreria PTerm. In modalità _raw-output_, il rendering grafico del
    `BigText` viene omesso per mantenere l'output pulito, preservando unicamente il testo informativo.
  + Selezione della modalità di input: Viene effettuato un controllo su `stdin` e `stdout`. Se l'ambiente è interattivo,
    la CLI entra in modalità _raw_ e istanzia `term.NewTerminal` come editor di riga, offrendo un'esperienza utente
    avanzata (inclusa la cronologia e l'editing dei comandi). In caso contrario, effettua un fallback su un approccio
    standard leggendo gli stream riga per riga tramite `bufio.Reader`.
  + Loop di elaborazione: Per ogni riga in ingresso non vuota, viene applicata la seguente logica:
    - I token `exit` o `quit` innescano la terminazione pulita (stampando "Goodbye!") e restituiscono `nil`.
    - Il token `shell` (come primo comando) viene intercettato ed emette un avviso, bloccando attivamente l'annidamento
      non voluto di sessioni REPL multiple.
    - Per qualsiasi altro input, la shell effettua la pulizia dello stato chiamando `resetAllCommandFlags(rootCmd)`,
      applica i nuovi parametri tramite `rootCmd.SetArgs(args)` e delega l'azione a `rootCmd.Execute()`. Eventuali
      errori restituiti dai sottocomandi vengono intercettati e stampati a schermo tramite `pterm.Error.Println`, ma
      *non* causano la terminazione della sessione.
  + Gestione terminazione: La ricezione di un segnale `io.EOF` (in qualsiasi modalità di input) conclude la sessione in
    modo controllato.

  ==== Interfaccia `spinner`

  L'astrazione del feedback visivo di caricamento è definita all'interno di `cmd/spinner.go` ed è utilizzata
  uniformemente da tutti gli handler dei comandi. Tale scelta architetturale disaccoppia l'esecuzione logica dal
  rendering grafico a terminale.

  #figure(
    caption: [Interfaccia spinner e implementazioni],
    table(
      columns: (1fr, 1.5fr, 1.2fr),
      [ *Tipo* ], [ *Metodi* ], [ *Comportamento* ],
      [ Interfaccia `spinner` ],
      [ `Success(text)`, `Fail(text)`, `Warning(text)` ],
      [ Contratto comune per i due adattatori. ],

      [ `noopSpinner` ],
      [ Tutti no-op. ],
      [ Usato in raw-output mode e nei test per evitare la creazione di goroutine PTerm. ],

      [ `ptermSpinner` ],
      [ Delega a `*pterm.SpinnerPrinter`. ],
      [ Gestisce il caso nil di `inner` (PTerm può restituire nil su fallimento di `Start`). ],
    ),
  )

  La factory `startSpinner(text string) spinner` restituisce `noopSpinner` quando `pterm.RawOutput` è true; altrimenti
  avvia uno spinner PTerm e restituisce `ptermSpinner`.

  ==== Funzioni di supporto

  #figure(
    caption: [Funzioni di supporto nel package cmd],
    table(
      columns: (1.5fr, 3fr),
      [ *Funzione* ], [ *Comportamento* ],
      [ `mustMarkRequired(cmd, flagName)` ],
      [
        Chiama `cmd.MarkFlagRequired`; in caso di errore scrive su stderr e chiama `exitProcess(1)`. `exitProcess` è una
        variabile di pacchetto (default `os.Exit`) per permettere l'iniezione nei test.
      ],

      [ `statusStyle(status string) string` ],
      [
        Restituisce lo status avvolto in verde PTerm per `"online"`/`"connected"`, rosso per
        `"offline"`/`"disconnected"`, stringa plain altrimenti. No-op in raw-output mode.
      ],

      [ `gatewayUUID(gw Gateway) string` ],
      [
        Restituisce `gw.ManagementGatewayID` se non vuoto; altrimenti ricade su `gw.ID`. Usato da `gateways list`,
        `gateways get` e `printGatewayTable` per popolare la colonna UUID.
      ],

      [ `printGatewayTable(gateways)` ],
      [
        Mostra una tabella PTerm con colonne: ID, UUID, Status, Model, Freq (ms). No-op su slice vuota. A differenza di
        `gateways list`, questo helper non include la colonna Tenant.
      ],

      [ `printSensorTable(sensors)` ],
      [
        Mostra una tabella PTerm con colonne: ID, UUID, Type, Min, Max, Algorithm. No-op su slice vuota. Entrambe le
        colonne ID e UUID mostrano `Sensor.ID` (la stringa UUID), poiché nel modello attuale non esiste una chiave
        numerica separata.
      ],
    ),
  )

  === Entry Point (`main.go`)

  #figure(
    caption: [Variabili iniettabili dell'entry point],
    table(
      columns: (1fr, 1fr, 1fr, 2fr),
      [ *Variabile* ], [ *Tipo* ], [ *Default* ], [ *Scopo* ],
      [ `execute` ], [ `func() error` ], [ `cmd.Execute` ], [ Iniettabile per i test; `main` chiama `execute()`. ],
      [ `osExit` ],
      [ `func(int)` ],
      [ `os.Exit` ],
      [ Iniettabile per i test; chiamata con codice 1 in caso di errore. ],
    ),
  )

  `main()` chiama `execute()` e chiama `osExit(1)` se restituisce un errore non nil. L'iniettabilità permette a
  `main_test.go` di verificare il comportamento del path di errore senza avviare un sottoprocesso.

  == Metodologie di Testing

  Il binario CLI è verificato attraverso una suite di test automatizzati suddivisa in test di unità (focalizzati sui
  componenti UI e sul client HTTP) e test di integrazione (focalizzati sull'albero dei comandi e sulla traduzione dei
  flag in payload HTTP).

  Durante l'esecuzione dei test (`TestMain`), l'output formattato e i colori vengono disabilitati globalmente
  (`pterm.DisableOutput()`, `pterm.DisableStyling()`). Questo forza la modalità `RawOutput`, garantendo che i componenti
  visivi (come lo spinner animato) vengano istanziati come oggetti `noop` (no-operation).

  === Test di Unità

  Le dipendenze esterne non sono presenti. I test dell'interfaccia utente (UI) usano mock dell'`os.Stdout` e pattern di
  iniezione delle funzioni, mentre i test del client HTTP isolano la logica di serializzazione e deserializzazione.

  *Componenti UI e Utility (`cmd`)*

  #table(
    columns: (2fr, 3fr),
    [Caso di test], [Postcondizione verificata],
    [`mustMarkRequired` — successo], [Il flag specificato viene correttamente annotato come obbligatorio in Cobra],
    [`mustMarkRequired` — flag mancante],
    [Scatta l'errore e viene invocata la funzione iniettata `exitProcess(1)` (comportamento di `os.Exit`)],

    [`startSpinner` in `RawOutput` mode],
    [Restituisce un'istanza `noopSpinner`; le chiamate a `Success`, `Fail` e `Warning` non generano side effect],

    [`ptermSpinner` con istanza `inner` nil], [Le chiamate ai metodi di completamento non causano panic (safety check)],

    [`printPrompt` / `printWelcomeBanner`],
    [In modalità raw stampano output plain text scansionabile; in modalità styled usano i widget grafici PTerm],

    [`printWelcomeBanner` — errore di render],
    [Se il renderer PTerm restituisce un errore, il banner viene silenziosamente omesso senza causare panic],
  )

  *Shell con Line-Editor (`cmd`)*

  #table(
    columns: (2fr, 3fr),
    [Caso di test], [Postcondizione verificata],
    [`RunShell` con line-editor — EOF],
    [Alla fine dello stream di input il loop REPL termina in modo pulito senza panic],

    [`RunShell` con line-editor — errore di lettura],
    [Un errore `Read` sul terminale viene propagato e il comando REPL restituisce un errore non nil],

    [`RunShell` con line-editor — errore di ripristino terminale],
    [Se `Restore` fallisce dopo `MakeRaw`, il comando restituisce comunque l'errore di ripristino],

    [`RunShell` con line-editor — errore `MakeRaw` tra comandi],
    [Se `MakeRaw` fallisce dopo l'esecuzione di un sottocomando, l'errore viene propagato e la shell si arresta],

    [`shell` — esecuzione con line-editor attivo],
    [Il comando letto dal line-editor viene eseguito correttamente da Cobra],

    [`shell` — fallback a reader classico se line-editor non disponibile],
    [Se il costruttore del line-editor fallisce, la shell passa automaticamente alla modalità `bufio.Scanner`],

    [`shell` — copertura hook di default (`DefaultHooks`)],
    [La funzione `DefaultHooks` restituisce i callback `BeforeCommand` e `AfterCommand` senza errori],
  )

  *Client HTTP e Costruzione Richieste (`internal/client`)*

  #table(
    columns: (2fr, 3fr),
    [Caso di test], [Postcondizione verificata],
    [`CreateGateway` / `AddSensor` — serializzazione base],
    [Il JSON risultante ha le chiavi previste contrattualmente dal backend (es. `duration_seconds` e non `duration`;
      `minRange` e non `min`)],

    [`CreateGateway` — omitempty su campi opzionali],
    [Se `Model`, `FirmwareVersion` o `SendFrequencyMs` sono zero-valued, le relative chiavi sono assenti dal JSON],

    [`InjectNetworkDegradation` — default `packet_loss_pct`],
    [Se il valore è 0, la chiave JSON viene omessa per demandare l'applicazione del default (`0.3`) al backend],

    [`InjectOutlier` — puntatore nil per valore omesso], [Se il puntatore `value` è `nil`, la chiave scompare dal JSON],
    [Risposta con JSON malformato (es. decodifica lista gateway)],
    [Restituisce un errore di decodifica invece di terminare brutalmente],

    [Risposta HTTP 400 (Bad Request)],
    [L'errore restituito include esplicitamente sia lo status code che il corpo testuale inviato dal backend (es. errori
      di validazione ID)],

    [Gestione HTTP 404 (Not Found)],
    [I metodi restituiscono un errore mappato per mancata risorsa, non mascherato da unparseable struct],

    [`ListGateways` — URL base non valido],
    [Un URL su cui non può essere fatto il parsing passato al client produce un errore di costruzione della richiesta,
      senza panic],

    [`AddSensor` — errore di encoding payload],
    [Se la serializzazione JSON del payload fallisce, viene restituito un errore prima di contattare il server],

    [`WithContext` — `nil` come argomento],
    [Il client usa automaticamente `context.Background()` come fallback senza panic],

    [`WithContext` — context cancellato],
    [La richiesta HTTP in-flight viene interrotta e viene restituito un errore di cancellazione],
  )

  === Test di Integrazione

  I test di integrazione eseguono l'intera pipeline della CLI: dal parsing della linea di comando (`Cobra`) alla
  generazione delle richieste verso un server HTTP locale (`httptest.Server`) istanziato per l'occasione e assegnato
  alla variabile `simulatorURL`. La funzione di supporto `resetAllFlags(rootCmd)` assicura che lo stato sticky dei flag
  di Cobra venga pulito prima di ogni esecuzione, evitando inquinamento tra i test.

  *Mapping dei Comandi e Payload*

  Questi test verificano che la combinazione dei flag da linea di comando generi l'esatto payload JSON previsto dal
  backend.

  #table(
    columns: (2fr, 1fr, 2fr),
    [Caso di test], [Infrastruttura], [Verifica],
    [`gateways create` — tutti i flag valorizzati],
    [`httptest`],
    [Il mock riceve una POST `/sim/gateways` con `Content-Type: application/json` e i campi `factoryId`, `model`, ecc.,
      mappati correttamente],

    [`sensors add` — traduzione nomi dei flag],
    [`httptest`],
    [I flag CLI `--min` e `--max` generano le chiavi JSON esatte `minRange` e `maxRange`],

    [`anomalies network-degradation` — omissione flag opzionale],
    [`httptest`],
    [Senza il flag `--packet-loss`, la chiave non è presente nel body JSON generato],
  )

  *Esecuzione Comandi Gateway e Sensor*

  #table(
    columns: (2fr, 1fr, 2fr),
    [Caso di test], [Infrastruttura], [Verifica],
    [`gateways bulk` — successo parziale (HTTP 207)],
    [`httptest`],
    [Il comando gestisce il 207 senza uscire con codice di errore (exit 1), parsando la slice di `errors` mista e
      stampando warning e successi assieme],

    [`gateways create` — flag `--model` mancante],
    [Cobra (Locale)],
    [Il mock server non viene mai invocato; Cobra rileva la violazione e blocca l'esecuzione ritornando errore],

    [`sensors add` — identificatore gateway non valido (NaN)],
    [`httptest`],
    [La pre-validazione `GetGateway` via HTTP fallisce (404); il comando si arresta senza mai chiamare l'endpoint POST
      del sensore],

    [`sensors list` — errore durante il lookup gateway],
    [`httptest`],
    [Se la risoluzione UUID/ID del gateway fallisce, il comando restituisce l'errore senza invocare l'endpoint della
      lista sensori],

    [`sensors add` — fallimento dopo lookup gateway riuscito],
    [`httptest`],
    [Se il lookup del gateway ha successo ma la POST del sensore ritorna un errore server, il comando lo propaga
      correttamente],

    [`gateways get` — gateway inesistente (404)],
    [`httptest`],
    [Il comando rileva l'errore HTTP 404 e restituisce un log informativo di errore per l'operatore],
  )

  *Esecuzione Shell*

  #table(
    columns: (2fr, 1fr, 2fr),
    [Caso di test], [Infrastruttura], [Verifica],
    [`shell` — invocazione comando `quit` / `exit`],
    [`os.Pipe` (stdin)],
    [Il loop di elaborazione si interrompe e il comando ritorna `nil` in modo pulito chiudendo la CLI],

    [`shell` — ricezione segnale `io.EOF`],
    [`os.Pipe` (stdin chiuso)],
    [Il loop rileva la fine dello stream e termina gracefully senza panics],

    [`shell` — tentativo di annidamento (comando `shell`)],
    [`os.Pipe` (stdin)],
    [Il loop intercetta il token `shell`, stampa un avviso e previene l'apertura annidata di un nuovo editor],

    [`shell` — comando interno fallito (es. server error 500)],
    [`httptest` + `os.Pipe`],
    [L'errore del comando (`gateways list`) viene intercettato da `pterm.Error` e stampato, *senza* causare
      l'interruzione della sessione di shell interattiva],

    [`anomalies outlier` — successo senza flag `--value`],
    [`httptest`],
    [L'outlier viene iniettato omettendo la chiave `value` dal JSON; il backend applica il valore di default],

    [`gateways list` — tabella vuota senza output],
    [Locale],
    [Se la slice dei gateway è vuota, la funzione di rendering non produce righe su stdout],

    [`sensors list` — tabella vuota senza output],
    [Locale],
    [Se la slice dei sensori è vuota, la funzione di rendering non produce righe su stdout],

    [Risoluzione UUID gateway (`GetGatewayUUID`)],
    [`httptest`],
    [Dato un identificativo numerico, il helper risolve e restituisce l'UUID corretto del gateway tramite GET],
  )

  === Obiettivi di copertura funzionale

  Le attività di test automatizzate garantiscono che il binario CLI sia verificato almeno rispetto ai seguenti scenari:

  - Verifica che ogni sottocomando produca la richiesta HTTP corretta (metodo, path, body) verso il backend.
  - Corretta gestione di HTTP 207 nel comando `gateways bulk`: i gateway creati con successo vengono renderizzati e i
    fallimenti parziali generano un warning senza interrompere l'esecuzione.
  - Comportamento della REPL shell in modalità TTY e non-TTY: corretto funzionamento del line editor, gestione di
    `io.EOF`, prevenzione dell'annidamento shell.
  - Verifica che i flag sticky tra iterazioni REPL siano eliminati da `resetAllCommandFlags`.
  - Verifica che in ambienti non-TTY (`pterm.RawOutput = true`) nessuna goroutine spinner venga creata, garantendo
    assenza di data race rilevabili con `-race`.
  - Propagazione corretta del `context.Context` di Cobra alle richieste HTTP in-flight per la gestione della
    cancellazione via segnale.

]
