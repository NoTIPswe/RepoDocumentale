#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Documento relativo al Manuale Infrastruttura realizzato dal Gruppo NoTIP per il progetto Sistema di Acquisizione Dati da Sensori BLE",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
  glossary-highlighted: false,
)[

  #let _terms = (
    "API Gateway": "Componente architetturale che funge da punto di accesso centralizzato per le API, gestendo autenticazione, autorizzazione e rate limiting delle richieste.",
    "Docker": "Tecnologia di containerizzazione che consente di confezionare applicazioni e le loro dipendenze in container portabili, facilitando deployment coerente su diverse piattaforme.",
    "Docker Compose": "Strumento che facilita la definizione e l'esecuzione di applicazioni multi-contenitore Docker attraverso file di configurazione YAML.",
    "Gateway": "Dispositivo fisico o software che funge da punto di accesso e intermediario per la comunicazione tra reti, sensori o sistemi diversi.",
    "JetStream": "Estensione nativa di NATS che aggiunge persistenza dei dati e consegna garantita, permettendo l'archiviazione dei messaggi e il loro recupero successivo.",
    "JWT": "Acronimo di JSON Web Token, standard aperto per la creazione di token di accesso che consentono l'autenticazione e lo scambio sicuro di informazioni tra parti.",
    "KeyCloak": "Piattaforma Open Source che permette di centralizzare l'autenticazione e l'autorizzazione per applicazioni e servizi moderni.",
    "Message Broker": "Componente architetturale che gestisce l'ingestione, buffering e distribuzione di messaggi tra produttori e consumatori.",
    "mTLS": "Acronimo di mutual TLS, estensione del protocollo TLS in cui sia il client sia il server si autenticano reciprocamente tramite certificati digitali.",
    "Multi-tenancy": "Architettura in cui una singola istanza dell'applicazione serve molteplici tenant con segregazione completa dei dati e delle risorse.",
    "NATS": "Sistema di messaggistica Open Source sviluppato da Cloud Native Computing Foundation.",
    "NestJS": "Framework Node.js basato su TypeScript per la costruzione di applicazioni server-side scalabili con architettura modulare e dependency injection.",
    "OAuth2": "Standard di autorizzazione che consente l'accesso delegato ai servizi, permettendo l'autenticazione tramite provider terzi senza esporre le credenziali.",
    "OIDC": "Acronimo di OpenID Connect, livello di identità costruito sopra OAuth2 che consente di autenticare un utente e ottenere informazioni standard sulla sua identità.",
    "PostgreSQL": "Database relazionale open source caratterizzato da robustezza, conformità SQL avanzata e supporto di estensioni per casi d'uso specializzati.",
    "Provisioning": "Processo di allocazione e configurazione di risorse necessarie per il funzionamento di un sistema.",
    "Tenant": "Entità cliente in un'architettura multi-tenancy che condivide l'infrastruttura ma con segregazione completa dei dati e delle risorse.",
    "TimescaleDB": "Estensione PostgreSQL specializzata per dati time-series, ottimizzata per archiviazione efficiente e query ad alte prestazioni su dati temporali.",
    "TLS": "Acronimo di Transport Layer Security, protocollo crittografico che garantisce comunicazione sicura su rete proteggendo dati in transito.",
  )
  #let _term-keys = _terms.keys().sorted(key: k => -k.len())
  #let _term-regex = regex("(?i)" + _term-keys.map(k => "\b" + k.replace(".", "\\.") + "\b").join("|"))
  #show _term-regex: it => [_#it#sub[G]_]

  = Introduzione
  == Scopo del documento
  Il presente documento ha lo scopo di fornire una guida operativa completa per gli amministratori dell'infrastruttura
  del Sistema NoTIP. Descrive l'architettura dei servizi, le procedure di avvio e gestione, la configurazione della
  sicurezza e del monitoraggio, e le scelte compiute in ottica di scalabilità. Il manuale è rivolto principalmente agli
  amministratori di sistema, ma può essere utile anche durante lo sviluppo e il testing.

  == Glossario
  I termini tecnici rilevanti per la comprensione del manuale sono definiti nella sezione *Glossario* a fondo documento;
  nel testo tali termini sono contrassegnati con pedice _G_. Per il glossario completo del progetto, si rimanda al
  #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf")[Glossario v3.0.0].

  == Riferimenti

  === Riferimenti Informativi
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf")[Glossario v3.0.0]
  - #link("https://github.com/NoTIPswe/notip-infra")[Repository Notip-infra]
  - #link("https://docs.docker.com/")[Docker Documentation]
  - #link("https://docs.nats.io/")[NATS JetStream Documentation]

  = Panoramica dell'Architettura

  == Struttura generale
  L'infrastruttura NoTIP è basata su container Docker orchestrati tramite Docker Compose. Tutti i servizi comunicano su
  una rete interna (`internal`) e non sono esposti direttamente all'esterno: il punto di ingresso unico per il traffico
  HTTP è *Nginx*, che funge da reverse proxy e API gateway.

  I servizi che compongono lo stack sono i seguenti:

  #table(
    columns: (auto, 1fr),
    align: (left, left),
    table.header([*Servizio*], [*Ruolo*]),
    [`nginx`], [Reverse proxy e API gateway. Instrada il traffico verso i servizi interni.],
    [`frontend`], [Applicazione web Angular servita tramite Nginx interno al container.],
    [`management-api`], [API REST per la gestione di tenant, gateway e configurazioni (NestJS).],
    [`data-api`], [API REST e streaming SSE per l'accesso ai dati telemetrici (NestJS).],
    [`data-consumer`], [Consumatore NATS → TimescaleDB. Persiste la telemetria e monitora i gateway (Go).],
    [`provisioning-service`], [Servizio di onboarding gateway: emette certificati TLS e chiavi AES (NestJS).],
    [`nats`], [Message broker con JetStream abilitato. Usa mTLS per autenticare i client.],
    [`mgmt-db`], [Database PostgreSQL per i dati gestionali (tenant, gateway, configurazioni).],
    [`measures-db`], [Database TimescaleDB (PostgreSQL + estensione time-series) per i dati telemetrici.],
    [`keycloak-db`], [Database PostgreSQL dedicato a Keycloak.],
    [`keycloak`], [Identity Provider OIDC. Gestisce autenticazione e autorizzazione degli utenti.],
    [`simulator`], [Simulatore di gateway IoT BLE (Go). Attivabile tramite profilo Docker Compose.],
    [`sim-cli`], [Interfaccia a riga di comando per controllare il simulatore.],
  )

  Oltre ai servizi applicativi, lo stack prevede tre servizi di *inizializzazione one-shot* che vengono eseguiti una
  sola volta all'avvio e poi terminano:

  - *`provisioning-init`*: genera la CA interna e i certificati mTLS per tutti i servizi.
  - *`nats-streams-init`*: crea gli stream JetStream su NATS (TELEMETRY, ALERTS, COMMANDS, ecc.).
  - *`keycloak-init`*: importa il realm `notip` con client, ruoli e configurazioni in Keycloak.

  == Routing Nginx
  Nginx espone la porta `80` dell'host e instrada le richieste come segue:

  #table(
    columns: (auto, 1fr),
    align: (left, left),
    table.header([*Percorso*], [*Destinazione*]),
    [`/auth/`], [Keycloak (`:8080`) — autenticazione OIDC.],
    [`/api/mgmt/`], [Management API (`:3000`) — gestione tenant e gateway.],
    [`/api/data/`], [Data API (`:3000`) — query e streaming dati telemetrici.],
    [`/api/data/*/stream`], [Data API — endpoint SSE con buffering disabilitato per streaming in tempo reale.],
    [`/api/provision/`], [Provisioning Service (`:3000`) — onboarding dei gateway.],
    [`/`], [Frontend Angular (`:8080`).],
    [`/internal/`], [Bloccato (404) — rotte interne mai esposte.],
  )

  == Sicurezza
  L'infrastruttura implementa più livelli di sicurezza:

  - *mTLS su NATS*: ogni servizio backend si autentica con un certificato firmato dalla CA interna. NATS verifica il
    certificato del client (`verify_and_map`) e associa i permessi tramite il Distinguished Name del certificato stesso.
  - *Keycloak*: gestisce l'autenticazione degli utenti e dei client OAuth2 tramite token JWT. I servizi backend validano
    i token prima di elaborare le richieste.
  - *Docker Secrets*: le password più sensibili (ad esempio `measures_db_password`) vengono montate come file segreti
    nei container, evitando l'esposizione tramite variabili d'ambiente.
  - *Cifratura a riposo*: le chiavi AES dei gateway sono cifrate nel database con una chiave `DB_ENCRYPTION_KEY`
    (AES-256). La perdita di questa chiave rende irrecuperabili tutte le chiavi dei gateway.
  - *Security headers HTTP*: Nginx aggiunge intestazioni di sicurezza (`X-Content-Type-Options`, `Referrer-Policy`) a
    tutte le risposte.

  = Prerequisiti

  Prima di avviare il sistema, assicurarsi di avere installato:

  - *Docker* (con Docker Compose v2): #link("https://docs.docker.com/get-docker/")[Installazione Docker]
  - *Make*: #link("https://www.gnu.org/software/make/")[Installazione Make]
  - Terminale *Bash* o *PowerShell* >= *7.0*
  - Accesso al repository: #link("https://github.com/NoTIPswe/notip-infra")[Notip-infra Repository]

  = Avvio del Sistema (Prima Installazione)

  Tutti i comandi devono essere eseguiti dalla directory `infra/`.

  == Passo 1 — Generazione dei segreti e del file `.env`

  ```bash
  make bootstrap
  ```

  Questo comando copia `.env.example` in `.env` e genera automaticamente valori casuali per tutti i segreti (password
  dei database, segreti OAuth2 Keycloak, chiave di cifratura AES). Al termine, aprire il file `.env` e verificare i
  valori non-segreti (hostname, nomi dei database, ecc.).

  #figure(caption: [Variabili generate da `make bootstrap`])[
    #table(
      columns: (auto, 1fr),
      align: (left, left),
      table.header([*Variabile*], [*Descrizione*]),
      [`DB_ENCRYPTION_KEY`], [Chiave AES-256 per cifrare le chiavi gateway a riposo.],
      [`MGMT_DB_PASSWORD`], [Password del database PostgreSQL gestionale.],
      [`MEASURES_DB_PASSWORD`], [Password di TimescaleDB. Scritta anche in `secrets/`.],
      [`KEYCLOAK_ADMIN_PASSWORD`], [Password dell'admin bootstrap di Keycloak.],
      [`KEYCLOAK_MGMT_CLIENT_SECRET`], [Segreto OAuth2 del client `notip-mgmt-backend`.],
      [`KEYCLOAK_SIMULATOR_CLIENT_SECRET`], [Segreto OAuth2 del client del simulatore.],
      [`KEYCLOAK_DB_PASSWORD`], [Password del database PostgreSQL di Keycloak.],
    )
  ]

  *Attenzione*: eseguire di nuovo `make bootstrap` con i volumi Docker già presenti sovrascrive i segreti nel `.env` ma
  *non* aggiorna i dati già scritti nei database, causando inconsistenze. Eseguirlo solo su un ambiente pulito oppure
  dopo `make reset-all`.

  == Passo 2 — Avvio dello stack

  ```bash
  make up
  ```

  Docker Compose scarica le immagini più recenti da `ghcr.io/notipswe` e avvia tutti i container nell'ordine corretto,
  rispettando le dipendenze (healthcheck inclusi). L'avvio completo richiede alcuni minuti, in particolare per Keycloak.

  Al termine, il frontend è raggiungibile all'indirizzo `http://localhost/`.

  == Passo 3 — Esecuzione delle migrazioni del database

  Al primo avvio è necessario applicare le migrazioni TypeORM ai database:

  ```bash
  make migration-run-all
  ```

  In alternativa, i passi 2 e 3 possono essere combinati in un unico comando:

  ```bash
  make up-with-migrations
  ```

  == Passo 4 — Verifica dello stato dei servizi

  ```bash
  make health
  ```

  Lo script controlla lo stato di tutti i container: i servizi applicativi devono essere in stato `running/healthy`,
  mentre i servizi one-shot (`provisioning-init`, `nats-streams-init`, `keycloak-init`) devono risultare `exited` con
  codice di uscita `0`.

  = Operazioni Quotidiane

  == Comandi principali

  Tutti i comandi vanno eseguiti dalla directory `infra/`.

  #table(
    columns: (auto, 1fr),
    align: (left, left),
    table.header([*Comando*], [*Effetto*]),
    [`make up`], [Avvia (o riavvia) tutti i container. Non tocca i volumi.],
    [`make down`], [Ferma e rimuove i container. I volumi (e i dati) vengono preservati.],
    [`make ps`], [Mostra lo stato di tutti i container.],
    [`make logs`], [Segue i log di tutti i servizi in tempo reale.],
    [`make logs-svc SVC=<nome>`], [Segue i log di un singolo servizio, es. `SVC=data-api`.],
    [`make health`], [Controlla lo stato di salute di tutti i servizi.],
    [`make keycloak-import`], [Reimporta la configurazione del realm Keycloak da `infra/keycloak/`.],
    [`make lint`], [Esegue i controlli di qualità del codice tramite `pre-commit`.],
  )

  == Reset dell'ambiente

  Quando è necessario ripartire da zero, esistono due livelli di reset:

  - *`make reset`*: ferma i container, elimina tutti i volumi Docker tranne `ca_certs` (i certificati gateway vengono
    preservati), e riavvia lo stack.
  - *`make reset-all`*: elimina *tutto*, incluso il volume della CA interna. Questo invalida tutti i certificati gateway
    precedentemente emessi. Richiede conferma esplicita.

  == Sviluppo con immagini locali

  Per sostituire una o più immagini con build locali (utile durante lo sviluppo), usare:

  ```bash
  # Singolo servizio
  make up-local LOCAL=management-api

  # Più servizi (separati da virgola)
  make up-local LOCAL=management-api,data-api
  ```

  Valori accettati: `management-api`, `data-api`, `data-consumer`, `provisioning-service`, `frontend`, `simulator`,
  `sim-cli`.

  Il Makefile compila l'immagine locale con `docker build --target prod` a partire dalla directory del repository
  sibling corrispondente, quindi avvia lo stack con quell'immagine al posto di quella remota.

  == Gestione delle migrazioni del database

  #table(
    columns: (auto, 1fr),
    align: (left, left),
    table.header([*Comando*], [*Effetto*]),
    [`make migration-run-all`], [Applica le migrazioni pending su tutti i database.],
    [`make migration-revert-all`], [Annulla l'ultima migrazione su tutti i database.],
    [`make migration-run-management`], [Applica le migrazioni solo al database gestionale.],
    [`make migration-run-data`], [Applica le migrazioni solo al database delle misure.],
    [`make migration-revert-management`], [Annulla l'ultima migrazione del database gestionale.],
    [`make migration-revert-data`], [Annulla l'ultima migrazione del database delle misure.],
  )

  = Autenticazione e Keycloak

  == Accesso al pannello di amministrazione

  Per accedere all'area riservata di Keycloak, aprire l'URL `http://localhost/auth`. Inserire le credenziali presenti
  nel file `.env` generato da `make bootstrap`:

  - *Username*: valore di `KEYCLOAK_ADMIN_USER` (default: `admin`).
  - *Password*: valore di `KEYCLOAK_ADMIN_PASSWORD`.

  #figure(caption: "Keycloak Login")[
    #image("assets/admin-login.png")]

  == Configurazione dell'utente amministratore definitivo

  Al primo accesso è necessario creare un utente amministratore definitivo:

  + Cliccare su *Users* → *Add user* e creare un nuovo utente con:
    - *Username*: `administrator`.
    - *Email*: una email valida (es. con dominio `notip.it`).
    - *Password*: una nuova password sicura (oppure la stessa di `KEYCLOAK_ADMIN_PASSWORD`).
  + Fare logout e accedere con l'account appena creato.
  + Eliminare l'utente temporaneo di default.

  #figure(caption: "Keycloak utente temporaneo")[
    #image("assets/admin-user.png")]
  #figure(caption: "Keycloak utente definitivo")[
    #image("assets/user-deleted.png")]

  == Realm `notip`

  All'avvio del sistema, lo script `keycloak-init` importa automaticamente il realm `notip` con client, ruoli e
  mappature preconfigurati. Per visualizzare i dettagli, accedere a *Manage Realms* → `notip`.

  Per modificare la configurazione di Keycloak è possibile:
  - Usare l'interfaccia grafica di Keycloak (le modifiche vengono applicate immediatamente).
  - Modificare il file JSON di esportazione in `infra/keycloak/realm-export.json` e reimportarlo con
    `make keycloak-import`.

  == Accesso al Frontend

  Per accedere all'applicazione web, navigare su `http://localhost/` e autenticarsi con:

  - *Username*: `admin`.
  - *Password*: valore di `KEYCLOAK_ADMIN_PASSWORD` dal file `.env`.

  = Simulatore di Gateway

  Il simulatore è un componente opzionale che permette di simulare gateway IoT BLE senza hardware fisico. Viene avviato
  tramite il profilo Docker Compose `simulator`.

  == Avvio del simulatore

  Il simulatore è già incluso nello stack standard avviato con `make up` (il Makefile include il profilo
  `--profile simulator` di default). Il servizio `simulator` è accessibile internamente sulla porta `8090`, ma non è
  esposto tramite Nginx: vi si accede tramite il `sim-cli`.

  == Utilizzo del Simulator CLI

  Il `sim-cli` permette di gestire il parco gateway simulati. Lo stack principale deve essere già in esecuzione.

  Aprire una sessione interattiva:

  ```bash
  cd infra
  docker compose --project-directory . -f compose/docker-compose.yml run --rm sim-cli shell
  ```

  All'interno della shell sono disponibili i seguenti comandi:

  #table(
    columns: (1.5fr, 1fr),
    align: (left, left),
    table.header([*Comando*], [*Descrizione*]),
    [`gateways list`], [Elenca tutti i gateway simulati registrati.],
    [`gateways create --factory-id ID --factory-key KEY --model M --firmware F --freq N`],
    [Crea un singolo gateway simulato.],

    [`gateways bulk ...`],
    [Crea N gateway simulati, in base al numero di factory ids inseriti, con i parametri specificati.],

    [`gateways delete <uuid>`], [Elimina un gateway simulato.],
    [`sensors add <gateway-id> --type TYPE --min N --max N --algorithm ALG`],
    [Aggiunge un sensore a un gateway esistente.],

    [`anomalies disconnect <uuid> --duration N`], [Simula una disconnessione del gateway per N secondi.],
  )

  In alternativa, è possibile eseguire un singolo comando senza aprire la shell:

  ```bash
  docker compose --project-directory . -f compose/docker-compose.yml run --rm -it sim-cli gateways list
  ```

  = Metriche e Monitoraggio

  == Avvio dello stack di monitoraggio

  Il monitoraggio (Prometheus + Grafana) è separato dallo stack principale e va avviato esplicitamente:

  ```bash
  make up-monitoring
  ```

  Per fermarlo:

  ```bash
  make down-monitoring
  ```

  Lo stack di monitoraggio si collega alla rete interna Docker del progetto principale per poter raccogliere le metriche
  dai servizi.

  == Accesso a Grafana

  Navigare su `http://localhost:13000/` e autenticarsi con:

  - *Username*: `admin`.
  - *Password*: `admin`.

  Al primo accesso verrà richiesto di cambiare la password.

  #figure(caption: "Grafana Login")[
    #image("assets/gf_login.png")
  ]

  #figure(caption: "Grafana cambio password")[
    #image("assets/gf_changepassword.png")
  ]

  Una volta effettuato l'accesso, navigare nella sezione *Dashboards*:

  #figure(caption: "Grafana Dashboards")[
    #image("assets/gf_dashboard.png")
  ]

  == Dashboard disponibili

  === Dashboard Data API e Management API
  #figure(caption: "Dashboard Data API e Management API")[
    #image("assets/data-api_dashboard.png")
  ]

  Le misure di monitoraggio presenti in questa dashboard sono:
  - *HTTP Request Rate*: numero di richieste HTTP ricevute al secondo.
  - *HTTP Error Rates*: numero di errori HTTP (4xx e 5xx) ogni 15 secondi.
  - *HTTP Latency*: tempo medio di risposta delle richieste HTTP ogni 15 secondi.
  - *In-flight Requests*: numero di richieste HTTP attualmente in elaborazione (tempo reale).
  - *Process Memory*: memoria utilizzata dal processo in bytes (tempo reale).
  - *CPU Usage*: percentuale di utilizzo della CPU (tempo reale).

  === Dashboard Data Consumer
  #figure(caption: "Dashboard Data Consumer")[
    #image("assets/data-consumer_dashboard.png")
  ]

  Le misure di monitoraggio presenti in questa dashboard sono:
  - *Telemetry Throughput*: numero di messaggi telemetrici processati ogni 5 secondi.
  - *Error Rates*: numero di errori ogni 5 secondi.
  - *TimescaleDB Write Latency*: tempo medio di scrittura su TimescaleDB ogni 5 secondi.
  - *Tracked Gateways*: numero di gateway attualmente monitorati (tempo reale).
  - *Backpressure and Connectivity*: presenza di backpressure o problemi di connettività verso TimescaleDB.
  - *Alerts and Config Cache Errors*: errori nella cache di configurazione e alert generati ogni 5 secondi.

  === Dashboard Provisioning Service
  #figure(caption: "Dashboard Provisioning Service")[
    #image("assets/provisioning_dashboard.png")
  ]

  Le misure di monitoraggio presenti in questa dashboard sono:
  - *Provisioning Outcomes*: operazioni di provisioning tentate, riuscite e fallite ogni 5 secondi.
  - *NATS Retry Rate*: tentativi di retry per la connessione a NATS ogni 5 secondi.
  - *Critical Operation Latency*: tempo medio di completamento delle operazioni critiche (firma CSR, validazione NATS,
    completamento NATS) ogni 5 secondi.
  - *Process Health*: salute complessiva del processo basata su metriche di performance ed errori.

  === Dashboard Simulatore
  #figure(caption: "Dashboard Simulatore")[
    #image("assets/simulatore_dashboard.png")
  ]

  Le misure di monitoraggio presenti in questa dashboard sono:
  - *Gateways Running*: numero di istanze del simulatore in esecuzione (tempo reale).
  - *Publish Throughput and Errors*: messaggi pubblicati ed errori di pubblicazione ogni 5 secondi.
  - *Buffer Health*: salute del buffer del simulatore basata su utilizzo memoria e latenza.
  - *Provisioning*: operazioni di provisioning riuscite e fallite per i dispositivi simulati ogni 5 secondi.
  - *NATS Reconnects*: riconnessioni a NATS ogni 5 secondi.
  - *Anomalies Injected*: anomalie simulate (dati fuori soglia, perdita di pacchetti) ogni 5 secondi.

  === NATS Monitoring
  #figure(caption: "Dashboard NATS")[
    #image("assets/nats_dashboard.png")
  ]

  Le misure di monitoraggio presenti in questa dashboard sono:
  - *Connections*: numero di connessioni attive al server NATS (tempo reale).

  = Scalabilità dell'Infrastruttura

  L'infrastruttura NoTIP è progettata per supportare una crescita graduale del numero di gateway, tenant e volumi di
  dati. Di seguito vengono descritte le scelte architetturali che abilitano la scalabilità.

  == Disaccoppiamento tramite NATS JetStream

  Il cuore della pipeline di acquisizione dati è *NATS JetStream*, un message broker persistente che disaccoppia i
  produttori di dati (gateway e simulatore) dai consumatori (Data Consumer, Data API).

  Gli stream JetStream sono configurati con politiche di retention basate su limiti temporali:

  #table(
    columns: (auto, auto, 1fr),
    align: (left, left, left),
    table.header([*Stream*], [*Soggetti*], [*Retention / Note*]),
    [`TELEMETRY`], [`telemetry.data.>`], [30 giorni. Storage su file. Dati telemetrici dai gateway.],
    [`ALERTS`], [`alert.>`], [Illimitata. Alert generati dal Data Consumer.],
    [`COMMANDS`], [`command.gw.>`], [75 secondi. Comandi inviati ai gateway (breve TTL).],
    [`COMMAND_ACKS`], [`command.ack.>`], [Acknowledgment dei comandi ricevuti dai gateway.],
    [`AUDIT_LOG`], [`log.audit.>`], [90 giorni. Audit log delle operazioni.],
    [`DECOMMISSION`], [`gateway.decommissioned.>`], [24 ore. Notifiche di decommissioning gateway.],
  )

  Grazie alla persistenza su file di JetStream, i messaggi non vengono persi in caso di riavvio del Data Consumer. Il
  broker assorbe i picchi di carico e garantisce la consegna anche in caso di temporanea indisponibilità dei consumer.

  == TimescaleDB per i dati telemetrici

  I dati telemetrici sono archiviati su *TimescaleDB*, un'estensione di PostgreSQL ottimizzata per serie temporali. Le
  principali caratteristiche che abilitano la scalabilità sono:
  - *Hypertables*: partizionamento automatico dei dati per intervalli temporali, che mantiene le performance di query
    costanti all'aumentare del volume di dati.
  - *Compressione nativa*: possibilità di comprimere automaticamente i chunk più vecchi, riducendo lo spazio su disco.
  - *Separazione del database delle misure*: TimescaleDB è un servizio indipendente da PostgreSQL gestionale, che
    permette di scalare i due database separatamente in base al carico.

  == Separazione dei database

  L'infrastruttura utilizza *tre database distinti*:
  - *`keycloak-db`*: esclusivamente per Keycloak. Isola i dati di autenticazione dal resto del sistema.
  - *`mgmt-db`*: dati gestionali (tenant, gateway, configurazioni). Volume di dati moderato e a bassa frequenza di
    scrittura.
  - *`measures-db`*: dati telemetrici. Alto volume, alta frequenza di scrittura. Ottimizzato con TimescaleDB.

  Questa separazione consente di allocare risorse (CPU, RAM, storage) in modo indipendente e di applicare policy di
  backup differenziate in base alla criticità e alla frequenza di aggiornamento.

  == Buffer e backpressure nel Data Consumer

  Il Data Consumer gestisce il flusso di dati in ingresso da NATS con un meccanismo di buffering configurabile tramite
  variabili d'ambiente:

  - `GATEWAY_BUFFER_SIZE` (default: `1000`): dimensione del buffer per gateway. Aumentare questo valore consente di
    assorbire picchi di telemetria senza perdita di dati.
  - `HEARTBEAT_GRACE_PERIOD_MS` (default: `120000` ms): periodo di grazia prima di considerare un gateway offline.
    Permette di tollerare temporanee interruzioni di connettività.
  - `ALERT_CONFIG_MAX_RETRIES` e `ALERT_CONFIG_MAX_BACKOFF_MS`: configurano il comportamento di retry per il recupero
    delle configurazioni di alerting, con backoff esponenziale.

  La dashboard Grafana *Data Consumer* espone la metrica *Backpressure and Connectivity* per rilevare situazioni di
  sovraccarico e intervenire tempestivamente.

  == Containerizzazione e portabilità

  Tutti i servizi sono distribuiti come immagini Docker (`linux/amd64`) e pubblicati su GitHub Container Registry
  (`ghcr.io/notipswe`). Questa scelta consente di:
  - Spostare lo stack su qualsiasi host che esegua Docker, indipendentemente dall'architettura hardware.
  - Aggiornare singoli servizi sostituendo l'immagine senza interrompere gli altri.
  - Effettuare il pin di versioni specifiche tramite le variabili `*_IMAGE` nel file `.env`.

  == Limiti dello stack attuale e percorso di crescita

  Lo stack Docker Compose attuale è ottimizzato per un singolo host. Per una crescita ulteriore verso ambienti
  multi-nodo, i componenti che beneficerebbero maggiormente dello scaling orizzontale sono:

  #table(
    columns: (auto, 1fr),
    align: (left, left),
    table.header([*Componente*], [*Percorso di scala*]),
    [Management API / Data API],
    [Istanze multiple dietro un load balancer (Nginx upstream group o un orchestratore come Kubernetes).],

    [NATS JetStream], [Cluster NATS con `num_replicas > 1` per alta disponibilità degli stream.],
    [TimescaleDB],
    [Replica in lettura per distribuire il carico delle query. Upgrade a Timescale Cloud per scaling gestito.],

    [Data Consumer], [Più istanze con partizionamento dei soggetti NATS per distribuire la pipeline di persistenza.],
  )

  = Troubleshooting

  == Container bloccato in attesa o in crash loop

  *Sintomi*: `make ps` mostra un servizio in stato `restarting` oppure `make health` riporta un errore.

  *Soluzione*:
  + Eseguire `make logs-svc SVC=<nome-servizio>` per leggere i log del container problematico.
  + Se il problema è una dipendenza non ancora pronta (es. database non healthy), attendere qualche secondo e riprovare
    con `make health`.
  + Se il problema persiste, eseguire `make down && make up` per riavviare lo stack.
  + Se i volumi sono corrotti o i segreti sono cambiati, eseguire `make reset` per ripulire i volumi (tranne i
    certificati CA) e ripartire.

  == HTTPS Required al momento dell'accesso a Keycloak (macOS)

  *Sintomi*: Il browser viene reindirizzato a una pagina HTTPS che non risponde.

  *Soluzione*: Chiudere e riavviare Docker Desktop, quindi eseguire `make reset-all && make up` e restartare il browser.

  Via terminale:

  ```bash
  osascript -e 'quit app "Docker"' && sleep 3 && open -a Docker
  ```

  Attendere che Docker si avvii, poi:

  ```bash
  make reset-all && make up
  ```

  == Segreti non allineati tra `.env` e database

  *Sintomi*: I servizi si avviano ma falliscono la connessione al database o a Keycloak con errori di autenticazione.

  *Causa*: `make bootstrap` è stato rieseguito con volumi già presenti, sovrascrivendo le password nel `.env` senza
  aggiornare quelle già scritte nei database.

  *Soluzione*: Eseguire `make reset-all` (che elimina tutti i volumi) e poi ricominciare dalla procedura di
  installazione al Passo 1.

  == Importazione del realm Keycloak fallita

  *Sintomi*: `make keycloak-import` termina con errori, oppure il realm `notip` non compare nell'interfaccia di
  Keycloak.

  *Soluzione*:
  + Verificare che Keycloak sia in stato `healthy` con `make ps`.
  + Controllare i log di Keycloak con `make logs-svc SVC=keycloak`.
  + Riprovare l'importazione con `make keycloak-import` una volta che Keycloak è completamente avviato.

  == Il simulatore non invia dati

  *Sintomi*: La dashboard Grafana *Simulatore* mostra `Gateways Running = 0` oppure `Publish Throughput = 0`.

  *Soluzione*:
  + Verificare che il servizio `simulator` sia in esecuzione con `make ps`.
  + Controllare i log con `make logs-svc SVC=simulator`.
  + Usare `sim-cli` per verificare che esistano gateway registrati: `gateways list`.
  + Se non ci sono gateway, crearne uno con `gateways create`.

  #[
    #show _term-regex: it => it

    #pagebreak()

    = Glossario

    #for (term, def) in _terms.pairs().sorted(key: p => p.first()) [
      / #term: #def
    ]
  ]
]
