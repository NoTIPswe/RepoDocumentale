#import "../../00-templates/base_document.typ" as base-document
#import "st_lib.typ" as st

#let metadata = yaml(sys.inputs.meta-path)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Documento contenente la specifica tecnica del progetto, con particolare attenzione alle scelte tecnologiche e all'architettura di alto livello del sistema.",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione
  == Scopo e struttura della documentazione
  Il presente documento costituisce la Specifica Tecnica di Sistema e ha lo scopo di fornire una descrizione strutturata
  dell'architettura macroscopica, delle componenti che la compongono e delle policy globali (es. sicurezza e testing).

  Per evitare ridondanze e mantenere un alto livello di manutenibilità, la documentazione tecnica è divisa in due
  livelli:
  - *Specifica Tecnica di Sistema* (questo documento): fornisce la visione d'insieme dell'infrastruttura, le policy di
    sicurezza trasversali e le scelte tecnologiche macroscopiche.
  - *Specifica Tecnica di Servizio*: dettagli implementativi interni (es. adozione dell'Architettura Esagonale,
    Dependency Injection, diagrammi di sequenza) sono demandati ai documenti specifici presenti nei repository dei
    singoli microservizi (es. `notip-data-consumer`).

  == Glossario
  Per tutte le definizioni, acronimi e abbreviazioni utilizzati in questo documento, si faccia riferimento al #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf",
  )[Glossario v2.0.0], fornito come documento separato. Le parole che possiedono un riferimento nel Glossario saranno
  indicate nel modo che segue:
  #align(center)[#emph([parola#sub[G]])]

  == Riferimenti
  === Riferimenti normativi
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato d'appalto C7 - Sistema di
      acquisizione dati da sensori]\ _Ultimo accesso: 2026-03-25_
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/norme_di_progetto.pdf")[Norme di Progetto
      v1.1.0]
  === Riferimenti informativi
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf")[Glossario v2.0.0]
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/PD1.pdf")[PD1 - Regolamento del Progetto Didattico]\
    _Ultimo Accesso: 2026-03-09_
  - #link("https://c4model.com/")[C4 Model]\ _Ultimo Accesso: 2026-03-11_
  - #link("https://docs.nats.io/")[Documentazione NATS] \ _Ultimo Accesso: 2026-03-11_
  - #link("https://docs.docker.com/")[Documentazione Docker] \ _Ultimo Accesso: 2026-03-11_
  - #link("https://grafana.com/docs/")[Documentazione Grafana] \ _Ultimo Accesso: 2026-03-11_
  - #link("https://prometheus.io/docs/introduction/overview/")[Documentazione Prometheus] \ _Ultimo Accesso: 2026-03-11_
  - #link("https://docs.timescale.com/")[Documentazione TimescaleDB] \ _Ultimo Accesso: 2026-03-11_

  #pagebreak()

  = Tecnologie

  Le tecnologie adottate sono state selezionate per supportare l'ingestione di flussi telemetrici ad alto throughput e
  l'isolamento multi-tenant, demandando i dettagli implementativi alle rispettive documentazioni di servizio.

  == Linguaggi e framework principali
  #table(
    columns: (1fr, auto, 4fr),
    [Tecnologia], [Versione], [Descrizione],
    [Go],
    [],
    [Impiegato per il `notip-data-consumer` e il `Simulator Backend` per le alte prestazioni nell'elaborazione
      concorrente necessaria all'ingestione massiva di telemetria.],

    [Typescript],
    [],
    [Linguaggio principale per i microservizi backend e la Web Application, scelto per garantire robustezza tramite
      tipizzazione statica.],

    [NestJS],
    [],
    [Framework backend adottato per Management API, Data API e Provisioning Service per la sua architettura modulare
      nativa, il sistema di Dependency Injection e il supporto nativo a moduli, guard, interceptor e filtri globali.],

    [Angular],
    [],
    [Framework frontend impiegato per la Web Application e la Simulation Dashboard. Il modello a componenti e il
      supporto nativo ai Web Worker consentono di isolare la decifratura AES-256-GCM (tramite WebCrypto API) in un
      thread dedicato, separandola completamente dal thread UI.],
  )

  == Librerie Backend Principali
  #table(
    columns: (1fr, auto, 4fr),
    [Libreria], [Versione], [Descrizione],

    [TypeORM],
    [],
    [ORM utilizzato nei microservizi NestJS (Data API e Management API) per la definizione delle entità, la
      costruzione delle query e la gestione delle connessioni a PostgreSQL e TimescaleDB. Consente l'integrazione
      nativa con il sistema di Dependency Injection di NestJS tramite `TypeOrmModule`.],

    [pgx / pgxpool],
    [],
    [Driver Go ad alte prestazioni per PostgreSQL, adottato nel Data Consumer per la gestione del pool di connessioni
      a TimescaleDB. Supporta SSL/TLS configurabile e lettura sicura della password tramite Docker secret file.],

    [node-forge],
    [],
    [Libreria per operazioni PKI/X.509 in Node.js, utilizzata nel Provisioning Service per il parsing delle
      Certificate Signing Request (CSR) dei gateway e per la firma dei certificati foglia con la CA interna.],

    [class-validator / class-transformer],
    [],
    [Coppia di librerie usata nei servizi NestJS per la validazione dichiarativa e la trasformazione dei DTO di
      input. Integrata tramite `ValidationPipe` globale con `whitelist: true` per rifiutare automaticamente i campi
      non dichiarati.],

    [Passport.js + JWKS],
    [],
    [Strategia di autenticazione JWT adottata nel Management API. Valida i token emessi da Keycloak in modalità
      stateless recuperando le chiavi pubbliche tramite l'endpoint JWKS del realm configurato, senza necessità di
      chiamate sincrone al provider per ogni richiesta.],

    [prom-client],
    [],
    [Libreria client Prometheus per Node.js, integrata nel Provisioning Service per l'esposizione di metriche
      applicative (tentativi di provisioning, durate operazioni PKI, retry NATS).],
  )

  == Archiviazione dati e messaggistica
  #table(
    columns: (1fr, auto, 4fr),
    [Tecnologia], [Versione], [Descrizione],

    [PostgreSQL],
    [],
    [Ospita il Management DB per i dati relazionali della piattaforma. Gestisce l'anagrafica e l'isolamento logico di
      tenant, utenti, gateway, configurazioni di alert e memorizza le chiavi crittografiche AES-256 cifrate _at-rest_
      tramite chiave di cifratura applicativa (`DB_ENCRYPTION_KEY`).],

    [TimescaleDB],
    [],
    [Estensione di PostgreSQL dedicata al Measures DB. Gestisce l'ipertabella partizionata per serie temporali (chunk
      interval giornaliero e compressione automatica a 7 giorni) su cui vengono memorizzati esclusivamente i payload
      telemetrici sotto forma di blob opachi (`encrypted_data`, `iv`, `auth_tag`).],

    [NATS JetStream],
    [],
    [Broker esclusivo per l'intera piattaforma, che elimina totalmente le comunicazioni HTTP interne tra microservizi.
      Offre pattern Request-Reply per le chiamate sincrone (es. `internal.mgmt.factory.validate`) e stream durevoli
      per gli eventi asincroni (telemetria `telemetry.data.*.*`, comandi, alert), garantendo la segregazione
      multi-tenant tramite rigorosi _subject permissions_.],

    [Server-Sent Events (SSE)],
    [],
    [Protocollo HTTP unidirezionale impiegato dal Data API per il fan-out real-time dei payload crittografati verso il
      frontend. Supporta meccanismi di _catch-up_ (parametro `since`) e permette l'iniezione del Bearer token per
      l'autenticazione tramite la libreria `\@microsoft/fetch-event-source`.],
  )

  == Osservabilità
  #table(
    columns: (1fr, auto, 4fr),
    [Tecnologia], [Versione], [Descrizione],

    [Prometheus],
    [],
    [Sistema di raccolta e aggregazione delle metriche applicative. I microservizi Go (Data Consumer) e NestJS
      (Provisioning Service) espongono endpoint `/metrics` compatibili con il formato Prometheus per il monitoraggio
      di throughput, latenze, retry e contatori di errore.],

    [Grafana],
    [],
    [Piattaforma di visualizzazione delle metriche raccolte da Prometheus. Fornisce dashboard operative per il
      monitoraggio in tempo reale dello stato dei microservizi, dei flussi di ingestione telemetrica e degli
      indicatori di liveness dei gateway.],
  )

  == Infrastruttura e sicurezza
  #table(
    columns: (1fr, auto, 4fr),
    [Tecnologia], [Versione], [Descrizione],

    [Docker & Compose],
    [],
    [Garantiscono l'isolamento a livello di processo dei microservizi. Coordinano il networking interno, l'iniezione a
      runtime delle credenziali e dei segreti (tramite Docker secrets, per evitare l'hardcoding) e persistono la
      Certification Authority interna sul volume named isolato `notip_ca_certs`.],

    [Nginx],
    [],
    [Unico punto di ingresso HTTP/HTTPS esposto all'esterno. Agisce da reverse proxy, applica _rate limiting_ sugli
      endpoint sensibili (es. provisioning), inietta gli header di sicurezza obbligatori (CSP _frame-src 'none'_, HSTS,
      X-Frame-Options) e configura il passthrough ottimizzato degli stream SSE disabilitando il buffering.],

    [Keycloak],
    [],
    [Provider IAM centralizzato per flussi OIDC (utenti web) e OAuth2 (Client API e Service Account). Tramite custom
      _Protocol Mapper_, inietta forzatamente i claim `tenant_id` e `role` in ogni JWT emesso, rappresentando il
      fondamento per la validazione stateless e l'isolamento multi-tenant nei backend.],

    [WebCrypto API],
    [],
    [API nativa dei browser moderni per operazioni crittografiche hardware-accelerate. Utilizzata dalla Web
      Application per eseguire la decifratura AES-256-GCM dei payload telemetrici all'interno di un Web Worker
      dedicato, senza mai trasmettere le chiavi al di fuori del contesto browser dell'utente.],
  )

  #pagebreak()

  = Architettura di sistema

  == Architettura di deployment e Single Source of Truth
  L'architettura del sistema è basata su un modello a microservizi. Ogni microservizio ha la propria repository
  dedicata, con il proprio DB e le proprie migrations.

  *Importante (Single Source of Truth):* Per i contratti delle API (siano esse interfacce REST HTTP o stream NATS), il
  codice e i repository costituiscono l'unica fonte di verità. I payload esatti e gli endpoint sono documentati e
  mantenuti aggiornati esclusivamente tramite le specifiche OpenAPI e AsyncAPI incluse nei rispettivi repository.

  #align(center)[

  ]

  Il Cloud Layer è strutturato per ospitare i seguenti microservizi:
  - *Management API*: Servizio NestJS che agisce come centro di controllo per tenant, gateway, utenti, configurazioni di
    alert ed emissione e il tracciamento dei comandi verso i gateway via JetStream.
  - *Data API*: Servizio NestJS responsabile dell'esposizione REST e SSE dei dati telemetrici storici e real-time.
  - *Provisioning Service*: CA interna che firma le richieste di certificato dei gateway (mTLS) e genera le chiavi
    AES-256.
  - *Data Consumer*: Modulo Go che consuma la telemetria da NATS, la persiste su TimescaleDB e gestisce il meccanismo di
    heartbeat.
  - *Simulator Backend*: Servizio Go che emula il comportamento dei gateway IoT fisici in parallelo.
  - *Web Application*: Frontend Angular che rappresenta il punto di decifratura esclusivo (tramite Web Worker)
    dell'intera pipeline.
  - *Simulator Dashboard*: Frontend Angular dedicato alla creazione e monitoraggio dello stato dei simulatori e alla
    generazione di anomalie telemetriche ad hoc.

  == Design pattern macro-architetturali

  #st.design-pattern(
    name: "Pipeline Opaca (Zero-Knowledge Server-Side)",
    problem: [
      I payload contengono misurazioni classificate come dati sensibili. La piattaforma deve garantire che i dati
      restino inaccessibili anche in caso di compromissione di un servizio backend o del database.
    ],
    decision: [
      Nessun componente cloud (Data Consumer, Data API, Management API) decifra MAI i payload telemetrici. I campi
      crittografici (`EncryptedData`, `IV`, `AuthTag`) viaggiano come blob opachi e la decifratura avviene
      esclusivamente nel browser dell'utente finale via WebCrypto API.
    ],
    alternatives: [
      - *Cifratura del solo canale (TLS):* Ritenuta insufficiente in quanto i dati risulterebbero in chiaro nella RAM
        dei microservizi e sul DB, rendendo ogni componente un Single Point of Failure.
    ],
    consequences: [
      - *Sicurezza:* La superficie di attacco server-side sui dati sensore è azzerata.
      - *Limitazione funzionale:* Il backend non può effettuare filtraggi o alert (Livello 2) sul valore del dato, che
        devono essere elaborati client-side.
    ],
  )

  #st.design-pattern(
    name: "Event-Driven & NATS Request-Reply",
    problem: [
      Microservizi multipli necessitano di comunicare dati di configurazione, comandi ed eventi in modo affidabile,
      limitando l'accoppiamento diretto tipico delle API HTTP point-to-point.
    ],
    decision: [
      Tutti i microservizi comunicano internamente tramite NATS Request-Reply (per la comunicazione sincrona) e NATS
      Jetstream (per l'asincrona). Non esistono endpoint REST interni tra microservizi.
    ],
    alternatives: [
      - *API REST:* Scartate per ragioni di semplicità architetturale. Essendo NATS JetStream già uno dei componenti
        scelti per l'ingestione della telemetria IoT, estenderne l'uso anche alla comunicazione interna sincrona ha
        evitato l'introduzione e la manutenzione di un secondo stack comunicativo inutile.
    ],
    consequences: [
      - *Disaccoppiamento:* I servizi produttori non hanno bisogno di conoscere l'indirizzo IP dei consumatori.
      - *Resilienza:* L'utilizzo di stream durevoli JetStream permette ai consumatori (o ai gateway che ricevono
        comandi) di processare messaggi anche a seguito di un proprio downtime temporaneo.
    ],
  )

  #pagebreak()

  = Descrizione dei Microservizi

  Questa sezione fornisce una descrizione sintetica di ciascun microservizio del sistema NoTIP, con l'obiettivo di
  chiarirne il ruolo nell'infrastruttura e le relazioni con gli altri componenti. Per i dettagli implementativi
  (architettura interna, contratti API, schema del database, strategia di test) si rimanda ai documenti di specifica
  tecnica di servizio collegati.

  == Management API

  Il `notip-management-api` è il fulcro di controllo della piattaforma. Implementato in NestJS, è responsabile della
  gestione di tutte le entità di configurazione del sistema e funge da intermediario tra il frontend, Keycloak e gli
  altri microservizi backend. È l'unico servizio che scrive sul Management DB (PostgreSQL) e l'unico che interagisce
  direttamente con le API amministrative di Keycloak per la gestione degli utenti.

  Le responsabilità principali sono:

  - *Gestione anagrafica:* CRUD di tenant, gateway, utenti e configurazioni di soglie di alert, con isolamento
    multi-tenant applicato su ogni operazione.
  - *Autenticazione e autorizzazione:* integrazione OIDC con Keycloak per la validazione stateless dei JWT. I claim
    `tenant_id` e `role` vengono iniettati da Keycloak e validati a ogni richiesta tramite guard globali.
  - *Interfaccia NATS per servizi interni:* risponde ai subject `internal.mgmt.factory.validate` e
    `internal.mgmt.provisioning.complete` per supportare il flusso di onboarding del Provisioning Service. Pubblica
    comandi verso i gateway tramite JetStream.
  - *Persistenza sicura delle chiavi AES:* le chiavi crittografiche ricevute dal Provisioning Service sono cifrate
    _at-rest_ nel Management DB tramite una chiave di cifratura applicativa (`DB_ENCRYPTION_KEY`).
  - *Configurazione degli alert:* espone endpoint per la gestione delle soglie di alert. Le configurazioni sono
    distribuite al Data Consumer tramite NATS per abilitare il rilevamento delle anomalie lato ingestione.

  Per la specifica tecnica dettagliata si rimanda al documento
  #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_management_api.pdf")[Specifica
    Tecnica — Management API].

  == Provisioning Service

  Il `notip-provisioning-service` è il punto di ingresso del ciclo di vita di ogni gateway fisico nella piattaforma.
  Espone un unico endpoint HTTP (`POST /provision/onboard`) raggiungibile solo al momento dell'attivazione iniziale del
  dispositivo. Non gestisce sessioni autenticate con JWT: l'autenticazione avviene tramite credenziali di fabbrica
  monouso (`factory_id` e `factory_key`) presenti nel body della richiesta.

  Il servizio svolge le seguenti responsabilità principali:

  - *Validazione delle credenziali di fabbrica:* invoca il subject NATS `internal.mgmt.factory.validate` verso il
    Management API per verificare che il gateway sia atteso e non sia già stato provisionato.
  - *Firma del certificato mTLS:* agisce da Certificate Authority (CA) interna, firmando il CSR fornito dal gateway con
    la propria CA residente su volume Docker dedicato (`notip_ca_certs`). Il certificato foglia ha un TTL configurabile
    (default 90 giorni).
  - *Generazione della chiave crittografica:* produce una chiave AES-256 casuale tramite CSPRNG del sistema operativo,
    da utilizzare per la cifratura E2EE della telemetria.
  - *Completamento del provisioning:* persiste il materiale chiave nel dominio Management API tramite il subject NATS
    `internal.mgmt.provisioning.complete`. Successivamente la credenziale di fabbrica viene invalidata.
  - *Audit logging:* registra ogni tentativo di onboarding con esito, `factory_id` e IP sorgente, escludendo
    esplicitamente dai log i campi sensibili (`factory_key`, materiale AES, chiave CA).

  Il servizio è implementato in NestJS (TypeScript) e non espone endpoint interni né interfacce REST verso altri
  microservizi: tutta la comunicazione post-validazione avviene esclusivamente via NATS Request-Reply.

  Per la specifica tecnica dettagliata si rimanda al documento
  #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_provisioning_service.pdf")[Specifica
    Tecnica — Provisioning Service].

  == Data Consumer

  Il `notip-data-consumer` è il componente Go responsabile dell'ingestione della telemetria nell'infrastruttura cloud.
  Opera esclusivamente nel backend, senza esporre endpoint HTTP funzionali verso i client: l'unica interfaccia HTTP
  pubblica è `/healthz` per il monitoraggio e `/metrics` per Prometheus.

  Le responsabilità principali sono:

  - *Consumo da NATS JetStream:* si sottoscrive al subject `telemetry.data.*.*` tramite un consumer durevole, riceve i
    payload cifrati prodotti dai gateway e li persiste in batch su TimescaleDB.
  - *Persistenza opaca:* i payload telemetrici vengono scritti sul Measures DB (TimescaleDB) come blob cifrati
    (`encrypted_data`, `iv`, `auth_tag`), senza mai tentare la decifratura. Il servizio non ha accesso alle chiavi
    AES-256.
  - *Heartbeat dei gateway:* mantiene in memoria una mappa di liveness per ogni gateway, aggiornata a ogni messaggio
    ricevuto. Un ticker periodico (default ogni 10 secondi) pubblica gli stati su NATS; i gateway non attivi entro il
    grace period (default 120 secondi) vengono marcati offline.
  - *Distribuzione delle configurazioni di alert:* recupera periodicamente dal Management API (via NATS) le soglie di
    alert attive e, lato data consumer, può attivare logica di rilevamento anomalie senza accedere al contenuto
    cifrato del dato.

  Per la specifica tecnica dettagliata si rimanda al documento
  #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_data_consumer.pdf")[Specifica
    Tecnica — Data Consumer].

  == Data API

  Il `notip-data-api` è il punto di accesso applicativo ai dati telemetrici cifrati persistiti su TimescaleDB. Espone
  interfacce REST e SSE verso il frontend Angular, restituendo esclusivamente payload cifrati e metadati tecnici: il
  servizio non dispone di accesso alle chiavi AES e non effettua mai operazioni di decifratura.

  Le responsabilità principali sono:

  - *Query paginata* (`GET /measures/query`): interrogazione filtrata delle misure per intervallo temporale, gateway,
    sensore e tipo di sensore, con paginazione basata su cursore. Il limite massimo per pagina è 999 elementi; la
    finestra temporale massima è 24 ore.
  - *Export completo* (`GET /measures/export`): restituisce l'insieme non paginato delle misure per un intervallo
    temporale, soggetto agli stessi filtri della query.
  - *Streaming real-time* (`SSE /measures/stream`): espone un canale Server-Sent Events alimentato da NATS JetStream
    tramite `TelemetryStreamBridgeService`. Se il parametro `since` è presente, esegue prima un replay storico da
    TimescaleDB e poi prosegue in real-time. Il fan-out verso i client connessi è isolato per tenant tramite il
    `tenant_id` estratto dal JWT.
  - *Elenco sensori* (`GET /sensor`): aggrega le misure degli ultimi dieci minuti per restituire la lista dei sensori
    attivi con il relativo ultimo timestamp osservato.

  Il servizio è implementato in NestJS (TypeScript) con TypeORM per l'accesso a TimescaleDB e segue il pattern
  Controller-Service-Persistence con mapper dedicati tra entity, model di dominio e DTO esposti.

  Per la specifica tecnica dettagliata si rimanda al documento
  #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_data_api.pdf")[Specifica
    Tecnica — Data API].

  // TODO: aggiungere sezione dedicata al Simulator Backend (Go) quando la specifica tecnica di servizio sarà disponibile.
  // La sezione dovrà coprire: ruolo nel sistema, responsabilità di emulazione gateway IoT, interfacce NATS,
  // modalità di generazione anomalie e rimando al documento di dettaglio.

  // TODO: aggiungere sezione dedicata alla Web Application (Angular) quando la specifica tecnica di servizio sarà disponibile.
  // La sezione dovrà coprire: ruolo come unico punto di decifratura dell'intera pipeline (WebCrypto API + Web Worker),
  // integrazione con Keycloak (OIDC), consumo SSE tramite @microsoft/fetch-event-source e rimando al documento di dettaglio.

  // TODO: aggiungere sezione dedicata alla Simulator Dashboard (Angular) quando la specifica tecnica di servizio sarà disponibile.
  // La sezione dovrà coprire: interfaccia di creazione e monitoraggio simulatori, generazione anomalie telemetriche ad hoc
  // e rimando al documento di dettaglio.

  #pagebreak()

  = Sicurezza

  == Segregazione multi-tenant
  Il sistema NoTIP gestisce l'isolamento dei tenant su molteplici livelli infrastrutturali e applicativi, garantendo che
  l'accesso alle risorse rimanga strettamente confinato:
  - *Identity & Access (Keycloak)*: Il provider IAM inietta il claim `tenant_id` all'interno di ogni JWT emesso,
    costituendo l'unica fonte di verità per l'identità del tenant nell'intero sistema.
  - *Application Layer*: Ogni microservizio backend esegue la validazione stateless del JWT, estrae il `tenant_id` e lo
    impone come vincolo architetturale e filtro obbligatorio per qualsiasi operazione di lettura o scrittura sui
    database.
  - *Messaging Layer (NATS)*: L'isolamento a livello di broker è applicato tramite convenzioni di naming dei subject
    (es. `telemetry.data.{tenantId}.{gwId}`) combinate con liste di permessi statiche che confinano i gateway al proprio
    perimetro operativo.

  == Gestione certificati e Zero Touch Provisioning
  L'autenticazione dei gateway fisici si basa su certificati mTLS rilasciati dinamicamente tramite un processo di
  provisioning automatizzato:
  + *Bootstrap:* Il gateway, configurato in fabbrica con credenziali monouso (`factory_id` e `factory_key`), invoca un
    endpoint HTTPS dedicato esposto dal Provisioning Service.
  + *Firma mTLS e Generazione Chiavi:* Il Provisioning Service, operando come Certificate Authority (CA) interna
    isolata, convalida le credenziali, firma il certificato del gateway e genera la chiave AES-256 definitiva per
    l'E2EE.
  + *Transizione Operativa:* Una volta consegnati il certificato e la chiave crittografica, la credenziale di fabbrica
    viene invalidata a livello di sistema. Da questo momento, il gateway comunica esclusivamente via mTLS con il message
    broker.

  #pagebreak()

  = Metodologie di testing

  Oltre alle metodologie unitarie demandate ai singoli servizi, la validazione globale dell'architettura distribuita
  segue specifiche direttrici strategiche:
  - *Test di Integrazione Inter-Service:* Per validare le interazioni di rete, l'infrastruttura di test si avvale
    dell'orchestrazione programmatica di container effimeri a runtime. Questo approccio permette di testare i servizi
    contro istanze reali dei database (TimescaleDB) e del broker (NATS), garantendo l'affidabilità dei contratti di
    comunicazione ed evitando i falsi positivi tipici dei mock infrastrutturali.
  - *Test End-to-End (E2E):* Mirano a validare la catena del valore completa nel rigoroso rispetto della Regola Zero
    (Pipeline Opaca). Il flusso parte dall'iniezione di telemetria tramite gateway simulati (Simulator Backend),
    attraversa il layer di persistenza e il fan-out SSE, per concludersi con la decifratura e il matching delle soglie
    eseguiti con successo dal Web Worker all'interno della Single Page Application.
]
