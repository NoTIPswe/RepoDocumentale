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

  Il presente documento raccoglie le specifiche tecniche di due microservizi distinti: `notip-simulator-backend` e `notip-simulator-cli`. Entrambi i componenti appartengono al sottosistema di simulazione della piattaforma NoTIP e sono progettati per operare in stretta sinergia: il backend costituisce il motore di simulazione, mentre la CLI rappresenta il piano di controllo operativo che consente agli operatori di pilotarlo.

  La scelta di riunire le specifiche dei due servizi in un unico documento è motivata dal loro accoppiamento funzionale: la CLI non possiede utilità autonoma al di fuori del contesto del backend, essendo interamente dedicata alla traduzione di comandi umani in chiamate HTTP verso le sue API REST. Trattarle come entità documentali separate produrrebbe una frammentazione che non rifletterebbe la reale dipendenza architetturale tra i due servizi.

  Il documento è strutturato in due parti principali:

  - *Parte I — `notip-simulator-backend`*: architettura esagonale, ciclo di vita dei gateway simulati, integrazioni NATS mTLS, schema SQLite e pipeline di testing del backend.
  - *Parte II — `notip-simulator-cli`*: struttura del binario Go, modelli di dominio, client HTTP, strato dei comandi Cobra, REPL interattiva e strategia di testing della CLI.

  = Parte I — notip-simulator-backend

  == Introduzione

  Questa sezione illustra l'architettura interna e le scelte implementative del microservizio `notip-simulator-backend`.
  Sviluppato in Go, questo componente è responsabile della simulazione di dispositivi fisici (Gateway e Sensori BLE) su larga scala.
  Il simulatore replica fedelmente il comportamento dell'hardware reale all'interno della piattaforma: si interfaccia con il Provisioning Service per il processo di onboarding e l'ottenimento del materiale crittografico, cifra i dati telemetrici localmente tramite AES-256-GCM, si connette al cluster NATS in mTLS per l'invio asincrono della telemetria e rimane in ascolto su JetStream per ricevere comandi dal Cloud o gestire eventi di decommissioning.
  L'architettura è altamente concorrente, associando ogni gateway virtuale a una goroutine dedicata gestita da un registro centrale.

  == Dipendenze e Configurazione

  === Variabili d'ambiente

  Tutte le variabili d'ambiente necessarie per il funzionamento del microservizio sono elencate di seguito. Un'eventuale mancanza o configurazione errata delle variabili obbligatorie comporterà un errore fatale all'avvio del microservizio:

  #figure(
    caption: [Variabili d'ambiente del microservizio notip-simulator-backend],
    table(
      columns: (1.2fr, 1.5fr, 1fr, 1fr),
      [ *Campo* ], [ *Variabile d'ambiente* ], [ *Default* ], [ *Obbligatorio* ],
      [ ProvisioningUrl ], [ `PROVISIONING_URL` ], [ - ], [ Sì ],
      [ NATSUrl ], [ `NATS_URL` ], [ - ], [ Sì ],
      [ NATSCACertPath ], [ `NATS_CA_CERT_PATH` ], [ - ], [ Sì ],
      [ NATSTLSCertPath ], [ `NATS_TLS_CERT` ], [ - ], [ No ],
      [ NATSTLSKeyPath ], [ `NATS_TLS_KEY` ], [ - ], [ No ],
      [ SQLitePath ], [ `SQLITE_PATH` ], [ `/data/simulator.db` ], [ No ],
      [ HttpAddr ], [ `HTTP_ADDR` ], [ `:8090` ], [ No ],
      [ MetricsAddr ], [ `METRICS_ADDR` ], [ `:9090` ], [ No ],
      [ DefaultSendFreq ], [ `DEFAULT_SEND_FREQUENCY_MS` ], [ `5000` ], [ No ],
      [ GatewayBufferSize ], [ `GATEWAY_BUFFER_SIZE` ], [ `1000` ], [ No ],
      [ RecoveryMode ], [ `RECOVERY_MODE` ], [ `false` ], [ No ],
    )
  )

  _Nota: `NATS_TLS_CERT` e `NATS_TLS_KEY` non sono obbligatori in assoluto, ma sono vincolati tra loro: devono essere entrambi valorizzati o entrambi vuoti._

  === Sequenza di avvio

  I passi bloccanti interrompono l'avvio del microservizio, pertanto è necessario assicurarsi che le dipendenze esterne (Provisioning, NATS) siano raggiungibili. La sequenza di avvio è la seguente:

  #figure(
    caption: [Sequenza di avvio del microservizio notip-simulator-backend],
    table(
      columns: (auto, 1fr, 2fr, auto),
      [ *Step* ], [ *Componente* ], [ *Azione* ], [ *Bloccante?* ],
      [ 0 ], [ `config.Load()` ], [ Carica e valida le variabili d'ambiente dal sistema operativo. ], [ Sì ],
      [ 1 ], [ `SQLiteStore` ], [ Inizializza la connessione SQLite (`modernc.org/sqlite`) ed esegue le migrazioni embeddate per lo schema dati. ], [ Sì ],
      [ 2 ], [ `Adapters` ], [ Istanzia il connettore NATS mTLS caricando il CertPool della CA, il client HTTP di Provisioning e l'Encryptor AES-GCM. ], [ Sì ],
      [ 3 ], [ `GatewayRegistry` ], [ Inizializza il registro centrale thread-safe che orchestra i `GatewayWorker`. ], [ Sì ],
      [ 4 ], [ `RestoreAll` ], [Se `RECOVERY_MODE` è true, interroga il DB locale e riavvia i gateway pre-esistenti. ], [ No ],
      [ 5 ], [ `DecommissionListener` ], [ Sottoscrizione a JetStream su `gateway.decommissioned.>` per cleanup locale in tempo reale. ], [ Sì ],
      [ 6 ], [ `Metrics Server` ], [ Avvia il listener HTTP per l'esposizione delle metriche Prometheus (es. `:9090`). ], [ No ],
      [ 7 ], [ `API Server` ], [ Avvia il `http.ServeMux` con gli handler REST per il controllo delle simulazioni. ], [ Sì ],
    )
  )

  == Architettura Logica

  Il servizio adotta un'architettura *Ports and Adapters (Architettura Esagonale)*. La logica di business (generazione dati, gestione anomalie e ciclo di vita) è isolata al centro (Domain/App) e non dipende da framework infrastrutturali. Le comunicazioni verso l'esterno avvengono tramite interfacce (Ports) implementate dagli adapter (SQLite, NATS, HTTP).

  === Layout dei moduli
  Essendo il microservizio strutturato per isolare la logica applicativa dalle dipendenze infrastrutturali, di seguito è riportata la struttura interna e rigorosa dei pacchetti:

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

  === Strati Architetturali

  #figure(
    caption: [Strati architetturali del microservizio notip-simulator-backend],
    table(
      columns: (1fr, 1.5fr, 2fr),
      [ *Strato* ], [ *Package* ], [ *Contenuto* ],
      [ *Presentation* ], [ `adapters/http` ], [ Handler HTTP REST per la creazione, l'avvio, l'arresto e la configurazione delle anomalie dei gateway simulati. ],
      [ *Business* ], [ `app`, `generator`, `domain` ], [ Logica applicativa: esecuzione dei tick temporali nei worker, calcolo dei dati, cifratura payload. ],
      [ *Persistence* ], [ `adapters/sqlite` ], [ Accesso al database locale SQLite per conservare lo stato dei gateway e dei sensori creati via API. ],
      [ *Integration* ], [ `adapters/nats`, `adapters/http` ], [ Scambio dati verso l'infrastruttura Cloud (Provisioning via REST, Telemetria e Comandi via JetStream). ],
    )
  )

  == Design di Dettaglio

  === Moduli del microservizio

  #figure(
    caption: [Responsabilità dei moduli applicativi],
    table(
      columns: (1fr, 3fr),
      [ *Modulo* ], [ *Responsabilità* ],
      [ `GatewayRegistry` ], [ Entry-point per tutte le chiamate API. Gestisce una mappa thread-safe di `GatewayWorker` associati al proprio management ID. Apre e chiude i contesti e delega al database. ],
      [ `GatewayWorker` ], [ Goroutine isolata per singolo gateway. Gestisce un `time.Ticker` interno, acquisisce dati dai sensori, li cifra in AES-GCM e li accoda per la pubblicazione. Elabora anche i comandi in ingresso. ],
      [ `MessageBuffer` ], [ Sistema di code (channel) con capienza limitata per assorbire i picchi di rete o NATS lento, applicando una politica *drop-oldest* per non bloccare la simulazione. ],
      [ `Generator` ], [ Interfaccia comune per gli algoritmi matematici. Implementa metodi per produrre il sample successivo e un meccanismo di override (`InjectOutlier`). ],
    )
  )

  === Entità

  #figure(
    caption: [Entità persistenti (SQLite)],
    table(
      columns: (1fr, 3fr),
      [ *Entità* ], [ *Campi principali* ],
      [ `gateways` ], [ `id`, `management_gateway_id`, `factory_id`, `factory_key`, `model`, `firmware_version`, `provisioned`, `cert_pem`, `private_key_pem`, `encryption_key` (BLOB), `send_frequency_ms`, `status`, `tenant_id`, `created_at` ],
      [ `sensors` ], [ `id`, `gateway_id` (FK), `sensor_id`, `type`, `min_range`, `max_range`, `algorithm`, `created_at` ]
    )
  )

  === Endpoint API HTTP

  L'API server (configurato nel file `server.go`) espone gli endpoint per pilotare la simulazione. Di seguito il dettaglio completo delle rotte.

  ==== Health
  #figure(
    caption: [Endpoint GET /health],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `GET /health` ],
      [ *Descrizione* ], [ Liveness probe. Ritorna HTTP 200 con `{"status": "ok"}` per confermare che il server HTTP è in ascolto. ]
    )
  )

  ==== Gateways
  #figure(
    caption: [Endpoint POST /sim/gateways],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `POST /sim/gateways` ],
      [ *Descrizione* ], [ Crea un gateway locale, esegue l'onboarding crittografico con il Cloud e avvia il worker. ],
      [ *Body Request* ], [ `{"factoryId": "...", "factoryKey": "...", "model": "...", "sendFrequencyMs": 5000}` ],
      [ *Response* ], [ `GatewayResponse` JSON. HTTP 200. ]
    )
  )

  #figure(
    caption: [Endpoint POST /sim/gateways/bulk],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `POST /sim/gateways/bulk` ],
      [ *Descrizione* ], [ Creazione massiva di N gateway. Utile per test di carico. ],
      [ *Body Request* ], [ `{"count": 10, "baseFactoryId": "sim-", "factoryKey": "...", "model": "..."}` ],
      [ *Response* ], [ Array combinato di successi e fallimenti. HTTP 200. ]
    )
  )

  #figure(
    caption: [Endpoint GET /sim/gateways],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `GET /sim/gateways` ],
      [ *Descrizione* ], [ Recupera la lista di tutti i gateway locali presenti nel DB simulatore. ],
      [ *Response* ], [ Array di `GatewayResponse` (senza materiale crittografico). HTTP 200. ]
    )
  )

  #figure(
    caption: [Endpoint GET /sim/gateways/{id}],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `GET /sim/gateways/{id}` ],
      [ *Descrizione* ], [ Recupera il dettaglio di un singolo gateway partendo dal suo UUID (Management ID). ],
      [ *Response* ], [ Singolo `GatewayResponse` JSON. HTTP 200. HTTP 404 se non trovato. ]
    )
  )

  #figure(
    caption: [Endpoint POST Lifecycle (Start / Stop)],
    table(
      columns: (1fr, 3fr),
      [ *Rotte* ], [ `POST /sim/gateways/{id}/start` \ `POST /sim/gateways/{id}/stop` ],
      [ *Descrizione* ], [ Avvia la goroutine (worker) di un gateway fermo, o la arresta chiudendo il Context. ],
      [ *Response* ], [ HTTP 204 No Content in caso di successo. ]
    )
  )

  #figure(
    caption: [Endpoint DELETE /sim/gateways/{id}],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `DELETE /sim/gateways/{id}` ],
      [ *Descrizione* ], [ Arresta il worker (se attivo) e rimuove in modo permanente il gateway e i suoi sensori dal database locale. ],
      [ *Response* ], [ HTTP 204 No Content. ]
    )
  )

  ==== Sensori
  #figure(
    caption: [Endpoint POST /sim/gateways/{id}/sensors],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `POST /sim/gateways/{id}/sensors` ],
      [ *Descrizione* ], [ Aggiunge un nuovo sensore (generatore dati) a un gateway esistente. ],
      [ *Body Request* ], [ `{"type": "temperature", "minRange": 20.0, "maxRange": 25.0, "algorithm": "sine_wave"}` ],
      [ *Response* ], [ `SensorResponse` JSON. HTTP 201 Created. ]
    )
  )

  #figure(
    caption: [Endpoint GET /sim/gateways/{id}/sensors],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `GET /sim/gateways/{id}/sensors` ],
      [ *Descrizione* ], [ Restituisce tutti i sensori logici associati al gateway indicato. ],
      [ *Response* ], [ Array di `SensorResponse` JSON. HTTP 200. ]
    )
  )

  #figure(
    caption: [Endpoint DELETE /sim/sensors/{sensorId}],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `DELETE /sim/sensors/{sensorId}` ],
      [ *Descrizione* ], [ Elimina permanentemente il sensore dal database SQLite. ],
      [ *Response* ], [ HTTP 204 No Content. ]
    )
  )

  ==== Anomalie
  #figure(
    caption: [Endpoint Network Degradation],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `POST /sim/gateways/{id}/anomaly/network-degradation` ],
      [ *Descrizione* ], [ Inietta una perdita pacchetti temporanea. Il worker applicherà la `packet_loss_pct` (es. 0.3 = 30%) prima dell'invio. ],
      [ *Body Request* ], [ `{"duration_seconds": 30, "packet_loss_pct": 0.5}` ],
      [ *Response* ], [ HTTP 204 No Content. ]
    )
  )

  #figure(
    caption: [Endpoint Disconnect],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `POST /sim/gateways/{id}/anomaly/disconnect` ],
      [ *Descrizione* ], [ Simula un down totale di rete. Nessun pacchetto verrà emesso dal gateway per la durata impostata. ],
      [ *Body Request* ], [ `{"duration_seconds": 60}` ],
      [ *Response* ], [ HTTP 204 No Content. ]
    )
  )

  #figure(
    caption: [Endpoint Sensor Outlier],
    table(
      columns: (1fr, 3fr),
      [ *Rotta* ], [ `POST /sim/sensors/{sensorId}/anomaly/outlier` ],
      [ *Descrizione* ], [ Forza il generatore matematico del sensore a restituire il valore esatto fornito per il primissimo sample utile, sovrascrivendo la logica matematica. ],
      [ *Body Request* ], [ `{"value": 999.99}` ],
      [ *Response* ], [ HTTP 204 No Content. ]
    )
  )

  === Integrazioni Cloud (HTTP e JetStream)

  #figure(
    caption: [Integrazioni di rete Cloud-Simulator],
    table(
      columns: (2fr, 1fr, 1.5fr),
      [ *Target / Subject* ], [ *Tipologia* ], [ *Responsabilità* ],
      [ `POST /api/provision/onboard` ], [ HTTP REST ], [ Invia il CSR crittografico al Provisioning e riceve Certificato X.509 + Chiave AES. Errori HTTP 401/409 sono mappati sul dominio. ],
      [ `telemetry.data.{tenantId}.{gwId}` ], [ JetStream Pub ], [ Pubblica la telemetria in tempo reale cifrata AES-256-GCM. ],
      [ `command.gw.{tenantId}.{gwId}` ], [ JetStream Sub ], [ Ricezione asincrona di comandi cloud (config, firmware). Scarta comandi scaduti (> 60s). ],
      [ `command.ack.{tenantId}.{gwId}` ], [ JetStream Pub ], [ Invia l'esito (ACK, NACK, Expired) dell'elaborazione di un comando. ],
      [ `gateway.decommissioned.>` ], [ JetStream Sub ], [ Ascolta l'eliminazione cloud dei gateway per innescare un cleanup del db locale. ],
    )
  )

  === Errori

  #figure(
    caption: [Mappatura Errori di Dominio],
    table(
      columns: (1fr, 1fr, 2fr),
      [ *Errore Dominio* ], [ *Status HTTP* ], [ *Causa* ],
      [ `ErrGatewayNotFound` ], [ 404 ], [ Il gateway richiesto non esiste nel DB locale o nel registro. ],
      [ `ErrInvalidFactoryCredentials` ], [ 401 ], [ Le credenziali fornite sono rifiutate dal Provisioning Service. ],
      [ `ErrGatewayAlreadyProvisioned` ], [ 409 ], [ Tentativo di onboard su un gateway già attivo nel cloud. ],
      [ `ErrInvalidSensorRange` ], [ 400 ], [ Configurazione sensore errata (`MinRange >= MaxRange`). ],
    )
  )

  === Flussi di Esecuzione

  Per comprendere l'orchestrazione interna del microservizio, vengono delineati i flussi delle operazioni principali, tracciando le chiamate attraverso gli strati esagonali dell'architettura.

  ==== 1. Flusso di Provisioning e Avvio
  1. Il client effettua una chiamata `POST /sim/gateways`.
  2. Il `GatewayHandler` converte il payload in DTO di dominio e invoca il `GatewayRegistry`.
  3. Il Registry orchestra l'operazione delegando l'`Onboard` (`ProvisioningServiceClient`).
  4. Il Client genera una coppia di chiavi *RSA a 2048 bit* e crea un file *CSR*.
  5. Il CSR viene inviato tramite HTTP POST al Provisioning Service in Cloud.
  6. Alla ricezione del certificato X.509 e della *Chiave AES in Base64*, questa viene convertita nell'entità protetta `EncryptionKey`.
  7. Il `GatewayStore` SQLite salva l'entità completa (comprese le chiavi PEM locali).
  8. Il Registry crea un nuovo `GatewayWorker`, istanzia una connessione NATS isolata con i nuovi certificati, e avvia la goroutine di background.

  ==== 2. Flusso di Pubblicazione Telemetria
  1. Il `GatewayWorker` esegue ciclicamente operazioni non bloccanti basate sul `time.Ticker` della frequenza configurata.
  2. Per ogni `SimSensor` associato, viene invocata l'interfaccia `Generator.Next()` (es. onda sinusoidale o outlier forzato).
  3. Il payload JSON interno viene passato all'`AESGCMEncryptor`.
  4. L'Encryptor genera un *IV univoco di 12 byte*, cifra i dati utilizzando il materiale crittografico locale e appende l'AuthTag di validazione.
  5. La `TelemetryEnvelope` finale (con campi offuscati in Base64) viene spinta nel `MessageBuffer`.
  6. Il Buffer tenta l'invio a JetStream; in caso di congestione o offline, scarta l'elemento più vecchio in coda per far spazio al nuovo, aggiornando le metriche Prometheus (`notip_sim_buffer_dropped_total`).

  ==== 3. Flusso di Decommissioning
  1. L'adapter `NATSDecommissionListener` rimane in perenne ascolto sul subject wildcard `gateway.decommissioned.>`.
  2. Ricevuto l'evento, estrae UUID e TenantID dalla rotta NATS.
  3. Tramite l'interfaccia (Porta) `DecommissionEventReceiver`, inoltra la richiesta al Core applicativo chiamando il metodo `HandleDecommission`.
  4. Il `GatewayRegistry`, che implementa tale interfaccia, riceve la chiamata. Acquisisce un lock di scrittura (`RWMutex`), cerca il worker corrispondente, lo arresta inviando un segnale al `context.CancelFunc` e disconnette il suo socket NATS.
  5. I dati persistenti vengono eliminati dallo `Store` locale in SQLite in via definitiva.

  == Metodologie di Testing

  Il microservizio garantisce standard qualitativi tramite una pipeline di test automatizzata.

  === Test di unità

  I test di unità verificano i singoli componenti in isolamento, sostituendo le dipendenze esterne con implementazioni mock delle interfacce (Ports). Le aree coperte sono:

  - *Generator*: verifica della correttezza matematica di ogni algoritmo (`sine_wave`, `uniform_random`, `spike`, `constant`) rispetto ai parametri `minRange`/`maxRange` e del meccanismo `InjectOutlier`.
  - *AESGCMEncryptor*: verifica che la cifratura produca output distinti per ogni invocazione (unicità IV) e che la decifratura restituisca il payload originale.
  - *GatewayRegistry*: verifica della gestione concorrente dei lock (`RWMutex`) mediante goroutine parallele, assenza di data race rilevabili con `-race`.
  - *MessageBuffer*: verifica della politica drop-oldest al raggiungimento della capienza e dell'aggiornamento delle metriche associate.
  - *config*: verifica del caricamento e della validazione delle variabili d'ambiente, compreso il fallimento atteso su variabili obbligatorie mancanti.

  === Test di integrazione

  I test di integrazione verificano la collaborazione tra i componenti reali del microservizio, senza mock dell'infrastruttura esterna:

  - *SQLiteStore*: verifica delle operazioni CRUD su gateway e sensori con database SQLite reale in memoria (`?mode=memory`), inclusi i test di atomicità delle transazioni e di esecuzione delle migrazioni.
  - *HTTP Handler*: verifica end-to-end degli handler REST tramite `httptest.Server`, coprendo i casi nominali e le risposte di errore (404, 409, 400) con `GatewayRegistry` reale.
  - *RecoveryMode*: verifica che al riavvio del processo con `RECOVERY_MODE=true` i gateway persistiti nel DB vengano correttamente reidratati e i worker riavviati.
  - *NATSDecommissionListener*: verifica dell'integrazione con un broker NATS embedded che il listener gestisca correttamente gli eventi di decommissioning e che il cleanup del DB avvenga.

  === Obiettivi di copertura funzionale

  Le attività di test automatizzate garantiscono che il microservizio sia verificato almeno rispetto ai seguenti scenari e metriche:

  - *Copertura minima dell'80%* del codice di dominio e del core applicativo.
  - Test di stress per verificare la gestione concorrente dei lock (`RWMutex`) nel `GatewayRegistry` senza data races.
  - Verifica della persistenza atomica tramite transazioni SQLite durante le migrazioni.
  - Corretta estrazione e avvio dei gateway in caso di riavvio del demone (`RecoveryMode`).
  - Tolleranza e resilienza di fronte a NATS congestionato o assente, validando la politica di *Drop-Oldest* del buffer in memoria.

  = Parte II — notip-simulator-cli

  == Introduzione

  Il `notip-simulator-cli` è un binario Go autonomo (`sim-cli`) che funge da piano di controllo operativo per il `notip-simulator-backend`. È progettato per essere eseguito come container Docker effimero o direttamente da terminale. La sua unica responsabilità è tradurre comandi leggibili dall'operatore in chiamate HTTP verso le API REST del backend simulatore.

  La CLI *non contiene logica di business*. Non persiste stato, non comunica con NATS e non interagisce con alcun database. Ogni operazione corrisponde a una singola richiesta HTTP (o a una coppia di richieste quando è necessaria la risoluzione dell'UUID del gateway).

  == Dipendenze e Configurazione

  === Variabili d'ambiente

  #figure(
    caption: [Variabili d'ambiente del microservizio notip-simulator-cli],
    table(
      columns: (1fr, 1.5fr, 1fr, 1fr),
      [ *Campo* ], [ *Variabile d'ambiente* ], [ *Default* ], [ *Note* ],
      [ SimulatorURL ], [ `SIMULATOR_URL` ], [ `http://simulator:8090` ], [ Base URL del backend. Letta una sola volta all'avvio del processo; non viene riletta durante l'esecuzione. ],
    )
  )

  === Rilevamento TTY

  All'avvio, la CLI verifica se `os.Stdout` è un terminale interattivo tramite `golang.org/x/term.IsTerminal`. Se *non* lo è (output rediretto, pipeline CI), PTerm disabilita globalmente stile e colori, garantendo output pulito e analizzabile da strumenti automatici. Il controllo viene eseguito una sola volta in `cmd.init()` e non è riconfigurabile a runtime.

  Questa scelta progettuale ha due implicazioni dirette:
  - In ambienti non interattivi, lo spinner animato viene sostituito da un `noopSpinner` (nessuna operazione), prevenendo la creazione di goroutine PTerm che causerebbero un noto problema con il flag `-race` in `pterm v0.12.79`.
  - Le tabelle e i messaggi di output mantengono la stessa struttura sia in modalità TTY che non-TTY, ma senza codici ANSI di colore nella seconda.

  == Scelte Architetturali

  Di seguito sono descritte le scelte progettuali principali adottate nella CLI e la loro motivazione.

  #figure(
    caption: [Pattern architetturali adottati nel notip-simulator-cli],
    table(
      columns: (1.2fr, 2.8fr),
      [ *Pattern* ], [ *Motivazione e comportamento* ],
      [ *Builder / propagazione del contesto* ], [ `Client.WithContext(ctx)` restituisce una copia superficiale del client legata a un nuovo `context.Context`. Ogni comando passa `cmd.Context()` tramite questo metodo, assicurando che la gestione dei segnali di Cobra si propaghi alle richieste HTTP in corso. ],
      [ *Reset dei flag sul riuso REPL* ], [ `resetAllCommandFlags` percorre l'intero albero dei comandi Cobra e reimposta ogni flag al suo default dichiarato prima di ogni iterazione della shell. Cobra non resetta lo stato dei flag tra chiamate successive di `Execute()` nello stesso processo; omettere questo reset causerebbe flag persistenti tra comandi della shell. ],
      [ *Adapter no-op per spinner non-TTY* ], [ L'interfaccia `spinner` è soddisfatta sia da `ptermSpinner` (spinner animato reale) sia da `noopSpinner` (tutti i metodi sono no-op). La factory `startSpinner` restituisce l'implementazione corretta in base a `pterm.RawOutput`, evitando la creazione di goroutine in ambienti non interattivi o di test. ],
      [ *Identificatori UUID-first* ], [ Tutti gli identificatori di gateway e sensori sono stringhe UUID nell'intera API. `resolveGatewayID` chiama `GetGateway(uuid)` e restituisce `gw.ID` (stringa). I comandi sensore accettano UUID direttamente — non viene eseguito alcun parsing di ID numerici. ],
      [ *Validazione backend-first* ], [ La maggior parte dei vincoli numerici e di dominio (es. durata positiva, range packet loss) sono trattati come regole contrattuali del backend. La CLI impone solo i flag obbligatori e il parsing numerico, senza aggiungere una validazione semantica ampia prima dell'invio delle richieste. ],
    )
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

  Tutti i tipi sono struct di dati puri con tag JSON. Nessun metodo eccetto su `Client`.

  ==== `Gateway` — value object

  Rispecchia il DTO `GatewayResponse` restituito dal backend simulatore. `ID` è l'identificatore pubblico del gateway (stringa UUID) usato in tutti i path API. `ManagementGatewayID` è un UUID aggiuntivo del piano di management presente su alcuni backend.

  #figure(
    caption: [Campi della struct Gateway],
    table(
      columns: (1fr, 1fr, 1.2fr, 2fr),
      [ *Campo* ], [ *Tipo* ], [ *Tag JSON* ], [ *Note* ],
      [ `ID` ], [ `string` ], [ `id` ], [ Identificatore pubblico (UUID); usato in tutti i path gateway e sensore. ],
      [ `ManagementGatewayID` ], [ `string` ], [ `managementGatewayId,omitempty` ], [ UUID del piano di management; opzionale. ],
      [ `FactoryID` ], [ `string` ], [ `factoryId` ], [ ],
      [ `Model` ], [ `string` ], [ `model` ], [ ],
      [ `FirmwareVersion` ], [ `string` ], [ `firmwareVersion` ], [ ],
      [ `Provisioned` ], [ `bool` ], [ `provisioned` ], [ ],
      [ `SendFrequencyMs` ], [ `int` ], [ `sendFrequencyMs` ], [ Intervallo di emissione telemetria in ms. ],
      [ `Status` ], [ `string` ], [ `status` ], [ Stato runtime (es. `"online"`, `"offline"`). ],
      [ `TenantID` ], [ `string` ], [ `tenantId` ], [ ],
      [ `CreatedAt` ], [ `string` ], [ `createdAt` ], [ Stringa ISO-8601; non viene effettuato il parsing. ],
    )
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
    )
  )

  === Tipi di Richiesta (`internal/client`)

  Le struct di richiesta sono serializzate in JSON e inviate come corpo delle richieste HTTP. I campi marcati `omitempty` vengono omessi dal payload JSON quando assumono il valore zero.

  ==== `CreateGatewayRequest`

  Payload per `POST /sim/gateways`.

  #figure(
    caption: [Campi di CreateGatewayRequest],
    table(
      columns: (1fr, 1fr, 1.2fr, 0.6fr, 2fr),
      [ *Campo* ], [ *Tipo* ], [ *Tag JSON* ], [ *Req.* ], [ *Note* ],
      [ `FactoryID` ], [ `string` ], [ `factoryId` ], [ Sì ], [ ],
      [ `FactoryKey` ], [ `string` ], [ `factoryKey` ], [ Sì ], [ ],
      [ `Model` ], [ `string` ], [ `model,omitempty` ], [ No ], [ ],
      [ `FirmwareVersion` ], [ `string` ], [ `firmwareVersion,omitempty` ], [ No ], [ ],
      [ `SendFrequencyMs` ], [ `int` ], [ `sendFrequencyMs,omitempty` ], [ No ], [ Default: 1000 ms via flag CLI. ],
    )
  )

  ==== `BulkCreateGatewaysRequest`

  Payload per `POST /sim/gateways/bulk`.

  #figure(
    caption: [Campi di BulkCreateGatewaysRequest],
    table(
      columns: (1fr, 1fr, 1.2fr, 0.6fr, 2fr),
      [ *Campo* ], [ *Tipo* ], [ *Tag JSON* ], [ *Req.* ], [ *Note* ],
      [ `Count` ], [ `int` ], [ `count` ], [ Sì ], [ Numero di gateway da creare. ],
      [ `FactoryID` ], [ `string` ], [ `factoryId` ], [ Sì ], [ ],
      [ `FactoryKey` ], [ `string` ], [ `factoryKey` ], [ Sì ], [ ],
      [ `Model` ], [ `string` ], [ `model,omitempty` ], [ No ], [ ],
      [ `FirmwareVersion` ], [ `string` ], [ `firmwareVersion,omitempty` ], [ No ], [ ],
      [ `SendFrequencyMs` ], [ `int` ], [ `sendFrequencyMs,omitempty` ], [ No ], [ Default: 1000 ms via flag CLI. ],
    )
  )

  ==== `BulkCreateResponse`

  Risposta di `POST /sim/gateways/bulk`. HTTP 201 indica successo totale; HTTP 207 indica errori parziali.

  #figure(
    caption: [Campi di BulkCreateResponse],
    table(
      columns: (1fr, 1fr, 1fr, 2fr),
      [ *Campo* ], [ *Tipo* ], [ *Tag JSON* ], [ *Note* ],
      [ `Gateways` ], [ `[]Gateway` ], [ `gateways` ], [ Gateway creati con successo. ],
      [ `Errors` ], [ `[]string` ], [ `errors` ], [ Slice parallela: stringa vuota all'indice i significa che il gateway i è stato creato con successo. ],
    )
  )

  ==== `AddSensorRequest`

  Payload per `POST /sim/gateways/{id}/sensors`. Il parametro `{id}` è l'UUID del gateway.

  #figure(
    caption: [Campi di AddSensorRequest],
    table(
      columns: (1fr, 1fr, 1fr, 0.6fr, 2fr),
      [ *Campo* ], [ *Tipo* ], [ *Tag JSON* ], [ *Req.* ], [ *Note* ],
      [ `Type` ], [ `string` ], [ `type` ], [ Sì ], [ `temperature`, `humidity`, `pressure`, `movement`, `biometric`. ],
      [ `MinRange` ], [ `float64` ], [ `minRange` ], [ Sì ], [ ],
      [ `MaxRange` ], [ `float64` ], [ `maxRange` ], [ Sì ], [ ],
      [ `Algorithm` ], [ `string` ], [ `algorithm` ], [ Sì ], [ `uniform_random`, `sine_wave`, `spike`, `constant`. ],
    )
  )

  ==== `NetworkDegradationRequest`

  Payload per `POST /sim/gateways/{id}/anomaly/network-degradation`.

  #figure(
    caption: [Campi di NetworkDegradationRequest],
    table(
      columns: (1fr, 1fr, 1.2fr, 2.5fr),
      [ *Campo* ], [ *Tipo* ], [ *Tag JSON* ], [ *Note* ],
      [ `DurationSeconds` ], [ `int` ], [ `duration_seconds` ], [ Obbligatorio da policy flag CLI; la CLI non impone `> 0`, il backend valida la semantica. ],
      [ `PacketLossPct` ], [ `float64` ], [ `packet_loss_pct,omitempty` ], [ Frazione 0–1; omesso quando 0; il backend applica il default 0.3. ],
    )
  )

  ==== `DisconnectRequest`

  Payload per `POST /sim/gateways/{id}/anomaly/disconnect`.

  #figure(
    caption: [Campi di DisconnectRequest],
    table(
      columns: (1fr, 1fr, 1.2fr, 2.5fr),
      [ *Campo* ], [ *Tipo* ], [ *Tag JSON* ], [ *Note* ],
      [ `DurationSeconds` ], [ `int` ], [ `duration_seconds` ], [ Obbligatorio da policy flag CLI; il backend valida la semantica. ],
    )
  )

  ==== `OutlierRequest`

  Payload per `POST /sim/sensors/{sensorId}/anomaly/outlier`.

  #figure(
    caption: [Campi di OutlierRequest],
    table(
      columns: (1fr, 1fr, 1.2fr, 2.5fr),
      [ *Campo* ], [ *Tipo* ], [ *Tag JSON* ], [ *Note* ],
      [ `Value` ], [ `*float64` ], [ `value,omitempty` ], [ Puntatore opzionale; omesso quando nil. Il campo è assente dal JSON quando il flag `--value` non è stato esplicitamente impostato; il backend applica il proprio fallback. ],
    )
  )

  === HTTP Client (`internal/client`)

  ==== Struct `Client`

  Il singolo client HTTP per tutte le interazioni con il backend simulatore. Mantiene una base URL, un `*http.Client` standard con timeout fisso di 30 secondi e un `context.Context` per la cancellazione per-richiesta.

  #figure(
    caption: [Campi della struct Client],
    table(
      columns: (1fr, 1fr, 2fr),
      [ *Campo* ], [ *Tipo* ], [ *Note* ],
      [ `baseURL` ], [ `string` ], [ Impostato alla costruzione; mai mutato. ],
      [ `httpClient` ], [ `*http.Client` ], [ Condiviso tra tutti i metodi; timeout 30 s. ],
      [ `ctx` ], [ `context.Context` ], [ Contesto per-richiesta; sostituito da `WithContext`. ],
    )
  )

  Le costanti interne definiscono i prefissi dei path: `defaultTimeout` (30 s), `pathGateways` (`"/sim/gateways/"`), `pathSensors` (`"/sim/sensors/"`).

  Il costruttore `New(baseURL string) *Client` crea un `Client` con un nuovo `*http.Client` (timeout 30 s) e `context.Background()`. Il metodo `WithContext(ctx context.Context) *Client` restituisce una copia superficiale con `ctx` impostato; se `ctx` è nil, ricade su `context.Background()`. Tutti i comandi invocano `client.New(simulatorURL).WithContext(cmd.Context())` per legare il contesto segnali di Cobra al client HTTP.

  ==== Metodi Gateway

  #figure(
    caption: [Metodi HTTP del Client per i Gateway],
    table(
      columns: (1.5fr, 0.6fr, 1.5fr, 1fr, 1fr),
      [ *Metodo* ], [ *HTTP* ], [ *Path* ], [ *Body* ], [ *Ritorna* ],
      [ `ListGateways` ], [ GET ], [ `/sim/gateways` ], [ — ], [ `([]Gateway, error)` ],
      [ `GetGateway` ], [ GET ], [ `/sim/gateways/{uuid}` ], [ — ], [ `(*Gateway, error)` ],
      [ `CreateGateway` ], [ POST ], [ `/sim/gateways` ], [ `CreateGatewayRequest` ], [ `(*Gateway, error)` ],
      [ `BulkCreateGateways` ], [ POST ], [ `/sim/gateways/bulk` ], [ `BulkCreateGatewaysRequest` ], [ `(*BulkCreateResponse, error)` ],
      [ `StartGateway` ], [ POST ], [ `/sim/gateways/{uuid}/start` ], [ nessuno ], [ `error` ],
      [ `StopGateway` ], [ POST ], [ `/sim/gateways/{uuid}/stop` ], [ nessuno ], [ `error` ],
      [ `DeleteGateway` ], [ DELETE ], [ `/sim/gateways/{uuid}` ], [ — ], [ `error` ],
    )
  )

  ==== Metodi Sensori

  #figure(
    caption: [Metodi HTTP del Client per i Sensori],
    table(
      columns: (2fr, 0.6fr, 2fr, 2fr),
      [ *Metodo* ], [ *HTTP* ], [ *Path* ], [ *Note* ],
      [ `AddSensor(gatewayID, req)` ], [ POST ], [ `/sim/gateways/{gatewayID}/sensors` ], [ Usa UUID gateway. ],
      [ `ListSensors(gatewayID)` ], [ GET ], [ `/sim/gateways/{gatewayID}/sensors` ], [ Usa UUID gateway. ],
      [ `DeleteSensor(sensorID)` ], [ DELETE ], [ `/sim/sensors/{sensorID}` ], [ Usa UUID sensore. ],
    )
  )

  ==== Metodi Anomalie

  #figure(
    caption: [Metodi HTTP del Client per le Anomalie],
    table(
      columns: (2.2fr, 0.6fr, 2fr, 1.5fr),
      [ *Metodo* ], [ *HTTP* ], [ *Path* ], [ *Note* ],
      [ `InjectNetworkDegradation(gatewayID, durationSeconds, packetLossPct)` ], [ POST ], [ `/sim/gateways/{uuid}/anomaly/network-degradation` ], [ Usa UUID gateway. ],
      [ `Disconnect(gatewayID, durationSeconds)` ], [ POST ], [ `/sim/gateways/{uuid}/anomaly/disconnect` ], [ Usa UUID gateway. ],
      [ `InjectOutlier(sensorID, value *float64)` ], [ POST ], [ `/sim/sensors/{sensorID}/anomaly/outlier` ], [ Usa UUID sensore. ],
    )
  )

  ==== Helper Privati

  Il metodo privato `post(path string, body any) (*http.Response, error)` serializza `body` in JSON se non nil, imposta `Content-Type: application/json` e usa `http.NewRequestWithContext` con `c.ctx`. La funzione `checkStatus(resp *http.Response) error` restituisce nil per i codici 2xx; per qualsiasi altro codice legge il corpo della risposta e restituisce un errore formattato.

  === Strato dei Comandi (`cmd`)

  Tutti i comandi sono variabili `*cobra.Command` a livello di pacchetto registrate nelle funzioni `init()`. Nessun comando è esportato. I comandi sono stateless: ogni invocazione costruisce un nuovo `*client.Client`.

  ==== Root

  La variabile `rootCmd` (`*cobra.Command`) costituisce il comando radice `sim-cli`. La variabile di pacchetto `simulatorURL` (stringa) è impostata dalla variabile d'ambiente `SIMULATOR_URL` in `init()`. La funzione `Execute() error` delega a `rootCmd.Execute()` ed è chiamata da `main()`. La funzione `resetAllCommandFlags(c *cobra.Command)` visita ricorsivamente ogni flag nell'albero dei comandi, reimpostando ciascuno al suo valore default dichiarato e azzerando `Changed = false`; è obbligatoria prima di ogni iterazione della REPL shell.

  ==== Sottocomandi `gateways`

  Il comando padre `gatewaysCmd` (`sim-cli gateways`) raggruppa sette sottocomandi, tutti registrati in `cmd/gateways.go init()`.

  #figure(
    caption: [Sottocomandi gateways e loro flag],
    table(
      columns: (1fr, 1.5fr, 2fr),
      [ *Sottocomando* ], [ *Argomenti / Flag* ], [ *Comportamento* ],
      [ `gateways list` ], [ Nessun flag. ], [ Elenca tutti i gateway come tabella PTerm con colonne: ID, UUID, Status (color-coded), Model, Freq (ms), Tenant. ],
      [ `gateways get <uuid>` ], [ 1 argomento posizionale: UUID gateway. ], [ Mostra una tabella chiave–valore verticale con: ID, UUID, Factory ID, Model, Firmware, Status, Provisioned, Send Freq (ms), Tenant, Created At. ],
      [ `gateways create` ], [ `--factory-id` (req.), `--factory-key` (req.), `--model` (req.), `--firmware` (req.), `--freq` int default 1000 (req.). ], [ In caso di successo, mostra il gateway creato come tabella. ],
      [ `gateways bulk` ], [ `--count` int default 1 (req.), `--factory-id` (req.), `--factory-key` (req.), `--model` (req.), `--firmware` (req.), `--freq` int default 1000 (req.). ], [ HTTP 207 (parziale) non è un errore a livello comando: viene mostrato uno stato `Warning` con il conteggio dei fallimenti; i gateway creati con successo vengono comunque renderizzati. ],
      [ `gateways start <uuid>` ], [ 1 argomento posizionale: UUID gateway. ], [ Avvia il worker del gateway. ],
      [ `gateways stop <uuid>` ], [ 1 argomento posizionale: UUID gateway. ], [ Arresta il worker del gateway. ],
      [ `gateways delete <uuid>` ], [ 1 argomento posizionale: UUID gateway. ], [ Rimuove permanentemente il gateway e i suoi sensori. ],
    )
  )

  ==== Sottocomandi `sensors`

  Il comando padre `sensorsCmd` (`sim-cli sensors`) raggruppa tre sottocomandi registrati in `cmd/sensors.go init()`. La funzione `resolveGatewayID(c *client.Client, input string) (string, error)` chiama sempre `c.GetGateway(input)` e restituisce `gw.ID`, eseguendo una richiesta HTTP aggiuntiva per validare l'UUID.

  #figure(
    caption: [Sottocomandi sensors e loro flag],
    table(
      columns: (1fr, 1.5fr, 2fr),
      [ *Sottocomando* ], [ *Argomenti / Flag* ], [ *Comportamento* ],
      [ `sensors add <gateway-uuid>` ], [ `--type` (req.), `--min` float64 default 0 (req.), `--max` float64 default 100 (req.), `--algorithm` (req.). ], [ Chiama sempre prima `GetGateway` per validare e risolvere l'ID gateway (2 richieste HTTP totali). ],
      [ `sensors list <gateway-uuid>` ], [ 1 argomento posizionale. ], [ Chiama `resolveGatewayID` (1 richiesta `GetGateway` aggiuntiva). Mostra tabella PTerm con colonne: ID, UUID, Type, Min, Max, Algorithm. ],
      [ `sensors delete <sensor-uuid>` ], [ 1 argomento posizionale: UUID sensore. ], [ Nessuna validazione oltre la presenza dell'argomento. ],
    )
  )

  ==== Sottocomandi `anomalies`

  Il comando padre `anomaliesCmd` (`sim-cli anomalies`) raggruppa tre sottocomandi registrati in `cmd/anomalies.go init()`.

  #figure(
    caption: [Sottocomandi anomalies e loro flag],
    table(
      columns: (1fr, 1.5fr, 2fr),
      [ *Sottocomando* ], [ *Argomenti / Flag* ], [ *Comportamento* ],
      [ `anomalies disconnect <gateway-uuid>` ], [ `--duration` int default 0 (req.). ], [ Il backend impone la validità semantica della durata. ],
      [ `anomalies network-degradation <gateway-uuid>` ], [ `--duration` int default 0 (req.), `--packet-loss` float64 default 0 (opz.). ], [ Quando `--packet-loss` non è fornito (`Changed == false`), il valore 0 viene passato a `InjectNetworkDegradation`; il tag `omitempty` lo esclude dal JSON e il backend applica il proprio default di 0.3. ],
      [ `anomalies outlier <sensor-uuid>` ], [ `--value` float64 default 0 (opz.). ], [ La presenza del flag è controllata esplicitamente via `cmd.Flags().Changed("value")`. Solo quando il flag è stato impostato esplicitamente, il valore è convertito in `*float64` e incluso nella richiesta. Quando omesso, `OutlierRequest.Value` è nil e il campo è assente dal JSON. ],
    )
  )

  ==== Comando `shell`

  `sim-cli shell` apre una REPL interattiva che esegue più comandi senza riavviare il container. Il comportamento è il seguente:

  1. Stampa un banner di benvenuto: in modalità styled usa PTerm `BigText` + `DefaultBox`; in modalità raw-output `BigText` viene saltato ma il testo di aiuto nel `DefaultBox` viene comunque stampato.
  2. Imposta `rootCmd.SilenceUsage = true` per la durata della sessione (ripristinato all'uscita via `defer`).
  3. Sceglie la modalità di input: se sia stdin che stdout sono TTY, entra in modalità raw e usa `term.NewTerminal` come line editor (supporto cronologia/editing); altrimenti ricade su `bufio.Reader` riga per riga.
  4. Per ogni riga non vuota: `exit` o `quit` stampa "Goodbye!" e ritorna nil; `shell` come primo token stampa un avviso e continua (impedisce l'annidamento); qualsiasi altro input chiama `resetAllCommandFlags(rootCmd)`, imposta `rootCmd.SetArgs(parts)` e chiama `rootCmd.Execute()`. Gli errori dei sottocomandi vengono stampati via `pterm.Error.Println` ma *non* terminano la sessione shell.
  5. Su `io.EOF` (da entrambe le modalità) stampa "Goodbye!" e ritorna nil.

  ==== Interfaccia `spinner`

  Definita in `cmd/spinner.go` e usata da tutti i command handler.

  #figure(
    caption: [Interfaccia spinner e implementazioni],
    table(
      columns: (1fr, 1fr, 2fr),
      [ *Tipo* ], [ *Metodi* ], [ *Comportamento* ],
      [ Interfaccia `spinner` ], [ `Success(text)`, `Fail(text)`, `Warning(text)` ], [ Contratto comune per i due adattatori. ],
      [ `noopSpinner` ], [ Tutti no-op. ], [ Usato in raw-output mode e nei test per evitare la creazione di goroutine PTerm. ],
      [ `ptermSpinner` ], [ Delega a `*pterm.SpinnerPrinter`. ], [ Gestisce il caso nil di `inner` (PTerm può restituire nil su fallimento di `Start`). ],
    )
  )

  La factory `startSpinner(text string) spinner` restituisce `noopSpinner` quando `pterm.RawOutput` è true; altrimenti avvia uno spinner PTerm e restituisce `ptermSpinner`.

  ==== Funzioni di supporto

  #figure(
    caption: [Funzioni di supporto nel package cmd],
    table(
      columns: (1fr, 3fr),
      [ *Funzione* ], [ *Comportamento* ],
      [ `mustMarkRequired(cmd, flagName)` ], [ Chiama `cmd.MarkFlagRequired`; in caso di errore scrive su stderr e chiama `exitProcess(1)`. `exitProcess` è una variabile di pacchetto (default `os.Exit`) per permettere l'iniezione nei test. ],
      [ `statusStyle(status string) string` ], [ Restituisce lo status avvolto in verde PTerm per `"online"`/`"connected"`, rosso per `"offline"`/`"disconnected"`, stringa plain altrimenti. No-op in raw-output mode. ],
      [ `gatewayUUID(gw Gateway) string` ], [ Restituisce `gw.ManagementGatewayID` se non vuoto; altrimenti ricade su `gw.ID`. Usato da `gateways list`, `gateways get` e `printGatewayTable` per popolare la colonna UUID. ],
      [ `printGatewayTable(gateways)` ], [ Mostra una tabella PTerm con colonne: ID, UUID, Status, Model, Freq (ms). No-op su slice vuota. A differenza di `gateways list`, questo helper non include la colonna Tenant. ],
      [ `printSensorTable(sensors)` ], [ Mostra una tabella PTerm con colonne: ID, UUID, Type, Min, Max, Algorithm. No-op su slice vuota. Entrambe le colonne ID e UUID mostrano `Sensor.ID` (la stringa UUID), poiché nel modello attuale non esiste una chiave numerica separata. ],
    )
  )

  === Entry Point (`main.go`)

  #figure(
    caption: [Variabili iniettabili dell'entry point],
    table(
      columns: (1fr, 1fr, 1fr, 2fr),
      [ *Variabile* ], [ *Tipo* ], [ *Default* ], [ *Scopo* ],
      [ `execute` ], [ `func() error` ], [ `cmd.Execute` ], [ Iniettabile per i test; `main` chiama `execute()`. ],
      [ `osExit` ], [ `func(int)` ], [ `os.Exit` ], [ Iniettabile per i test; chiamata con codice 1 in caso di errore. ],
    )
  )

  `main()` chiama `execute()` e chiama `osExit(1)` se restituisce un errore non nil. L'iniettabilità permette a `main_test.go` di verificare il comportamento del path di errore senza avviare un sottoprocesso.

  == Metodologie di Testing

  === Test di unità

  I test di unità (`cmd/spinner_test.go`, `cmd/anomalies_test.go`, `cmd/request_mapping_test.go`, `internal/client/client_test.go`, `internal/client/request_construction_test.go`) verificano i singoli componenti in isolamento:

  - *Client HTTP*: metodo, path, serializzazione del body della richiesta, decodifica della risposta e gestione degli errori di `checkStatus` — tutto senza alcun coinvolgimento di Cobra o PTerm.
  - *Costruzione richieste*: verifica che i flag CLI siano mappati correttamente nei campi delle struct di richiesta, inclusa la logica `omitempty` per `PacketLossPct` e il comportamento del puntatore `*float64` per `OutlierRequest.Value`.
  - *Validazione flag anomalie*: verifica che i flag obbligatori siano effettivamente imposti e che la logica `Changed` per i flag opzionali funzioni correttamente.
  - *Spinner*: verifica che `noopSpinner` sia restituito in raw-output mode e che `ptermSpinner` deleghi correttamente senza panic su `inner` nil.

  === Test di integrazione

  I test di integrazione (`cmd/commands_test.go`, `cmd/shell_test.go`) verificano l'intera pipeline CLI contro un server HTTP mock:

  - *`newMockServer`*: avvia un `httptest.Server` con un `http.HandlerFunc` configurabile, imposta la variabile di pacchetto `simulatorURL` all'URL del server e registra `t.Cleanup` per fermarlo e ripristinare `simulatorURL` a `"http://simulator:8090"`.
  - *`runCmd`*: reimposta tutti i flag via `resetAllFlags(rootCmd)`, imposta `rootCmd.SetArgs(args)`, redirige stdout e stderr di Cobra su `bytes.Buffer` separati e chiama `rootCmd.Execute()`.
  - *Comandi gateway, sensore e anomalia*: per ogni sottocomando viene verificato che la richiesta HTTP inviata al mock server abbia il metodo, il path e il body corretti, e che l'output a schermo corrisponda al comportamento atteso.
  - *REPL shell*: verifica che `exit`/`quit` terminino la sessione, che `shell` annidato produca un avviso, che gli errori dei sottocomandi siano stampati senza terminare la sessione e che `io.EOF` concluda la sessione pulitamente.

  === Obiettivi di copertura funzionale

  Le attività di test automatizzate garantiscono che il binario CLI sia verificato almeno rispetto ai seguenti scenari:

  - Verifica che ogni sottocomando produca la richiesta HTTP corretta (metodo, path, body) verso il backend.
  - Corretta gestione di HTTP 207 nel comando `gateways bulk`: i gateway creati con successo vengono renderizzati e i fallimenti parziali generano un warning senza interrompere l'esecuzione.
  - Comportamento della REPL shell in modalità TTY e non-TTY: corretto funzionamento del line editor, gestione di `io.EOF`, prevenzione dell'annidamento shell.
  - Verifica che i flag sticky tra iterazioni REPL siano eliminati da `resetAllCommandFlags`.
  - Verifica che in ambienti non-TTY (`pterm.RawOutput = true`) nessuna goroutine spinner venga creata, garantendo assenza di data race rilevabili con `-race`.
  - Propagazione corretta del `context.Context` di Cobra alle richieste HTTP in-flight per la gestione della cancellazione via segnale.

]
