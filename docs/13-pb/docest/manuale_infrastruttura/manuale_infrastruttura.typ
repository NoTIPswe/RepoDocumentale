#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml("manuale_infrastruttura.meta.yaml")

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Documento relativo al Manuale Amministratore di Sistema realizzato dal Gruppo NoTIP per la realizzazione del progetto Sistema di Acquisizione Dati da Sensori BLE",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione
  == Scopo del documento
  Il presente documento ha lo scopo di fornire una guida dettagliata riguardo a come far partire l'infrastruttura del
  Sistema. Il manuale è rivolto principalmente agli amministratori dell'infrastruttura, ma può rivelarsi utile anche in
  casi di testing durante lo sviluppo.


  == Glossario
  La realizzazione di un Sistema software, richiede l'utilizzo di termini tecnici specifici che potrebbero non essere
  immediatamente comprensibili a tutti gli utenti. Per facilitare la comprensione del manuale, è stato deciso di
  realizzare un Glossario, nel quale vengono elencate definizioni e spiegazioni relative ai termini utilizzati. Tale
  documento è sempre in fase di sviluppo e aggiornamento e può essere consultato nella sua versione attuale al seguente
  link: #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf",
  )[Glossario v2.0.0]. Le parole che possiedono un riferimento nel Glossario saranno identificati con pedice _G_.

  == Riferimenti

  === Riferimenti Informativi
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf")[Glossario v2.0.0]

  = Flussi per l'utilizzo del Sistema

  == Prerequisiti
  - Repository *Notip-infra*: #link("https://github.com/NoTIPswe/notip-infra.git")[Notip-infra Repository]
  - Docker: #link("https://docs.docker.com/get-docker/")[Installazione di Docker]
  - Make: #link("https://www.gnu.org/software/make/")[Installazione di Make]
  - Terminale *Bash* o *PowerShell* >= *7.0*
  == Avvio del Sistema
  Spostandosi nella directory `infra/` è possibile eseguire questi comandi `make` con le seguenti definizioni:
  - _*make bootstrap*_
    - esegue lo script `scripts/bootstrap.sh` e genera un file `.env` con le variabili d'ambiente necessarie per l'avvio
      del sistema. Eseguire questo file con i volumi docker già presenti, comporta ad una invalidazione dei dati
      presenti.
  - _*make up*_
    - esegue il comando `docker compose --project-directory . -f compose/docker-compose.yml up -d` per avviare i
      container docker del sistema. Fatto ciò è possibile accedere al frontend del sistema all'indirizzo
      `http://localhost/` e all'area riservata di Keycloak all'indirizzo `http://localhost/auth`.
  - _*make up-local LOCAL=""*_
    - esegue il comando `docker compose --project-directory . -f compose/docker-compose.yml up -d` ma fa il pull delle
      immagini locali scelte tra management-api, data-api, data-consumer, provisioning-service, frontend, simulator,
      sim-cli (si possono scegliere più immagini separandole con una virgola).
  - _*make up-monitoring*_
    - esegue il comando `docker compose -f compose/docker-compose-monitoring.yml up -d` e avvia i container docker di
      prometheus e grafana.
  - _*make down*_
    - esegue il comando `docker compose --project-directory . -f compose/docker-compose.yml down`
  - _*make reset*_
    - ripulisce i volumi docker tranne CA, i container e le immagini e riesegue il processo di make up
  - _*make reset-all*_
    - ripulisce tutto incluso i volumi docker CA, i container e le immagini e riesegue il processo di make up
  - _*make logs*_
    - esegue il comando `docker compose --project-directory . -f compose/docker-compose.yml logs -f`
  - _*make logs-svc*_
    - esegue il comando `docker compose --project-directory . -f compose/docker-compose.yml logs -f --services`
  - _*make ps*_
    - esegue il comando `docker compose --project-directory . -f compose/docker-compose.yml ps`
  - _*make keycloak-import*_
    - esegue lo script `scripts/keycloak-import.sh`
  - _*make health*_
    - esegue lo script `scripts/healthcheck.sh`
  - _*make lint*_
    - esegue il comando `pre-commit run --all-files`

  Il comando *`make up`* non avvia il monitoring di prometheus e grafana, per questo, eseguire anche
  *`make up-monitoring`*.

  == Autenticazione e piattaforma di Keycloak

  Per accedere all'area riservata di Keycloak, spostarsi all'URL `http://localhost/auth` questo passando per Nginx
  porterà alla pagina di keycloak all'indirizzo
  `http://localhost/auth/realms/master/protocol/openid-connect/auth?client_id=`

  #figure(caption: "Keycloak Login")[
    #image("assets/admin-login.png")]

  Per effettuare l'accesso inserire le credenziali trovate nel `.env` generato da `make bootstrap` con le seguenti
  chiavi: *`KEYCLOAK_ADMIN_USER`* e *`KEYCLOAK_ADMIN_PASSWORD`*. Una volta inserite le credenziali, cliccare su "Sign
  in" per accedere al pannello di amministrazione di Keycloak. Se è stato effettuato il primo accesso, è necessario
  creare un nuovo admin user che sarà quello definitivo con i seguenti dati:
  - Username: *`administrator`*;
  - Password: una nuova, oppure la stessa di `KEYCLOAK_ADMIN_PASSWORD`;
  - Email: una email a scelta, per comodità con *`notip.it`* come dominio.
  Successivamente fare logout e accedere con l'account appena creato ed eliminare quello di default.
  #figure(caption: "Keycloak utente temporaneo")[
    #image("assets/admin-user.png")]
  #figure(caption: "Keycloak utente definitivo")[
    #image("assets/user-deleted.png")]

  All'interno, keycloak sarà configurato pronto per l'uso, grazie all'utilizzo di script di importazione.

  Qualora fosse necessario modificare la configurazione di Keycloak, è possibile farlo attraverso l'interfaccia grafica,
  oppure modificando il file json di importazione presente nella cartella `infra/keycloak/` e rieseguendo lo script di
  importazione con `make keycloak-import`.

  Per visualizzare i dettagli del Realm notip si può accedere alla sezione "Manage Realms" e cliccare su "notip".
  All'interno sarà possibile visualizzare i dettagli del Realm, come i client configurati e creati, gli utenti, i ruoli
  e le relative mappature. Per accedere al frontend del sistema, è necessario dirigersi all'URL `http://localhost/` al
  termine del caricamento, servirà autenticarsi con le credenziali di amministrazione reperibili nel file .env:
  - Username: *admin*
  - Password: *KEYCLOAK_ADMIN_PASSWORD*

  = Metriche e monitoraggio
  Dopo aver eseguito `make up-monitoring`, è possibile accedere a Prometheus e Grafana per monitorare le metriche del
  sistema. Per accedere a Grafana, è necessario dirigersi all'URL `http://localhost:13000/` appena terminato il
  caricamento, servirà autenticarsi.

  #figure(caption: "Grafana Login")[
    #image("assets/gf_login.png")
  ]
  Usare le seguenti credenziali per accedere a Grafana:
  - Username: *admin*
  - Password: *admin*
  Successivamente, per questioni di sicurezza verrà richiesto di cambiare la password, è possibile impostare una nuova
  password a scelta, oppure mantenere quella di default.
  #figure(caption: "Grafana cambio password")[
    #image("assets/gf_changepassword.png")
  ]
  Una volta effettuato l'accesso, andare nella sezione dashboard:

  #figure(caption: "Grafana Dashboard")[
    #image("assets/gf_dashboard.png")
  ]

  == Dashboards
  === Dashboard Data API e Management API
  #figure(caption: "Dashboard Data API e Management API")[
    #image("assets/data-api_dashboard.png")
  ]

  Le misure di monitoraggio presenti in questa dashboard sono:
  - *HTTP Request Rate*: misura il numero di richieste HTTP ricevute dalla Data API al secondo.
  - *HTTP Error Rates*: misura il numero di errori HTTP (codici di stato 4xx e 5xx) restituiti dalla Data API ogni 15
    secondi.
  - *HTTP Latency*: misura il tempo medio di risposta delle richieste HTTP alla Data API ogni 15 secondi.
  - *In-flight Requests*: misura il numero di richieste HTTP attualmente in corso alla Data API in tempo reale.
  - *Process Memory*: misura la quantità di memoria utilizzata dalla Data API in tempo reale in bytes.
  - *CPU Usage*: misura la percentuale di utilizzo della CPU da parte della Data API in tempo reale.

  === Dashboard Data Consumer
  #figure(caption: "Dashboard Data Consumer")[
    #image("assets/data-consumer_dashboard.png")
  ]
  Le misure di monitoraggio presenti in questa dashboard sono:
  - *Telemetry Throughput*: misura il numero di messaggi telemetrici inviati dalla Data Consumer ogni 5 secondi.
  - *Error Rates*: misura il numero di errori restituiti dalla Data Consumer ogni 5 secondi.
  - *TimescaleDB Write Latency*: misura il tempo medio di scrittura dei dati su TimescaleDB da parte della Data Consumer
    ogni 5 secondi.
  - *Tracked Gateways*: misura il numero di gateway attualmente monitorati dalla Data Consumer in tempo reale.
  - *Backpressure and Connectivity*: misura la presenza di backpressure o problemi di connettività tra Data Consumer e
    TimescaleDB in tempo reale.
  - *Alerts and Config Cache Errors*: misura il numero di errori nella cache di configurazione e il numero di alert
    generati dalla Data Consumer ogni 5 secondi.

  === Dashboard Provisioning Service
  #figure(caption: "Dashboard Provisioning Service")[
    #image("assets/provisioning_dashboard.png")
  ]
  Le misure di monitoraggio presenti in questa dashboard sono:
  - *Provisioning Outcomes*: misura il numero di operazioni di provisioning tentate, riuscite e fallite ogni 5 secondi.
  - *NATS Retry Rate*: misura il numero di tentativi di retry per la connessione a NATS da parte del Provisioning
    Service ogni 5 secondi.
  - *Critical Operation Latency*: misura il tempo medio di completamento delle operazioni critiche di provisioning
    (firma CSR, validazione NATS e completamento NATS) ogni 5 secondi.

  - *Process Health*: "misura la salute complessiva del processo del Provisioning Service in tempo reale, basata su
    metriche di performance, errori e disponibilità."

  === Dashboard Simulatore
  #figure(caption: "Dashboard Simulatore")[
    #image("assets/simulatore_dashboard.png")
  ]
  Le misure di monitoraggio presenti in questa dashboard sono:
  - *Gateways Running*: misura il numero di istanze del simulatore attualmente in esecuzione in tempo reale.
  - *Publish Throughput and Errors*: misura il numero di messaggi pubblicati dal simulatore e il numero di errori di
    pubblicazione ogni 5 secondi.
  - *Buffer Health*: misura la salute del buffer del simulatore in tempo reale, basata su metriche di utilizzo della
    memoria, latenza di pubblicazione e presenza di errori.
  - *Provisioning*: misura il numero di operazioni di provisioning riuscite e fallite per i dispositivi simulati ogni 5
    secondi.
  - *NATS Reconnects*: misura il numero di riconnessioni a NATS da parte del simulatore ogni 5 secondi.
  - *Anomalies Injected*: misura il numero di anomalie simulate (ad esempio, dati fuori soglia, perdita di pacchetti)
    ogni 5 secondi.

  === NATS Monitoring
  #figure(caption: "Dashboard NATS")[
    #image("assets/nats_dashboard.png")
  ]
  Le misure di monitoraggio presenti in questa dashboard sono:
  - *Connections*: misura il numero di connessioni attive al server NATS in tempo reale.

  = Troubleshooting
  Problemi comuni che potrebbero verificarsi durante l'avvio del sistema:

  - *Container Docker bloccato in waiting*
    - Soluzione: Verificare i log del container direttamente in app Desktop o eseguendo `make logs-svc` via terminale.
      Eseguire di nuovo `make-up` per riavviare il container. Se il problema persiste, eseguire `make reset` per
      ripulire i volumi docker e riavviare il sistema.
  - *HTTPS Required al momento dell'accesso a Keycloak (MacOS)*
    - Soluzione: Chiudere manualmente il processo di Docker e riavviarlo, successivamente eseguire
      `make reset-all && make up` e restartare il browser. \
      Via terminale invece eseguire: ```bash osascript -e 'quit app "Docker"' && sleep 3 && open -a Docker``` e
      successivamente `make reset-all && make up` e restartare il browser.







]


