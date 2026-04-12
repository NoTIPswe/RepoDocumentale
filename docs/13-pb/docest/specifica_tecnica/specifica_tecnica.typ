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
  dell'architettura macroscopica, delle componenti che la compongono e delle policy globali.

  Per evitare ridondanze e mantenere un alto livello di manutenibilità, la documentazione tecnica è divisa in due
  livelli:
  - *Specifica Tecnica di Sistema* (questo documento): fornisce la visione d'insieme dell'infrastruttura, le policy di
    sicurezza trasversali e le scelte tecnologiche macroscopiche.
  - *Specifica Tecnica di Servizio*: dettagli implementativi interni (es. adozione dell'Architettura Esagonale,
    Dependency Injection, diagrammi delle classi) sono demandati ai documenti specifici dei singoli microservizi
    presenti sul sito del gruppo.

  == Glossario
  Per tutte le definizioni, acronimi e abbreviazioni utilizzati in questo documento, si faccia riferimento al #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf",
  )[Glossario v3.0.0], fornito come documento separato. Le parole che possiedono un riferimento nel Glossario saranno
  indicate nel modo che segue:
  #align(center)[#emph([parola#sub[G]])]

  == Riferimenti
  === Riferimenti normativi
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato d'appalto C7 - Sistema di
      acquisizione dati da sensori]\ _Ultimo accesso: 2026-03-25_
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/norme_di_progetto.pdf")[Norme di Progetto
      v2.0.0]
  === Riferimenti informativi
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf")[Glossario v3.0.0]
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/PD1.pdf")[PD1 - Regolamento del Progetto Didattico]\
    _Ultimo Accesso: 2026-03-09_
  - #link("https://c4model.com/")[C4 Model]\ _Ultimo Accesso: 2026-04-07_
  - #link("https://docs.nats.io/")[Documentazione NATS] \ _Ultimo Accesso: 2026-04-02_
  - #link("https://docs.docker.com/")[Documentazione Docker] \ _Ultimo Accesso: 2026-04-01_
  - #link("https://grafana.com/docs/")[Documentazione Grafana] \ _Ultimo Accesso: 2026-04-11_
  - #link("https://prometheus.io/docs/introduction/overview/")[Documentazione Prometheus] \ _Ultimo Accesso: 2026-03-31_
  - #link("https://docs.timescale.com/")[Documentazione TimescaleDB] \ _Ultimo Accesso: 2026-04-12_

  #pagebreak()

  = Tecnologie

  Le tecnologie adottate sono state selezionate per supportare l'ingestione di flussi telemetrici ad alto throughput e
  l'isolamento multi-tenant, demandando i dettagli implementativi alle rispettive documentazioni di servizio. Le
  versioni riportate corrispondono ai valori definiti nei file di lock (`package-lock.json`, `go.sum`) e nelle immagini
  Docker dei singoli servizi alla data di rilascio corrente.

  == Linguaggi, runtime e framework
  #table(
    columns: (1fr, auto, 4fr),
    [Tecnologia], [Versione], [Descrizione],

    [Go],
    [1.26],
    [Runtime e linguaggio impiegato per `notip-data-consumer` e `notip-simulator-backend`. Scelto per le alte
      prestazioni nell'elaborazione concorrente (goroutine, canali) necessaria all'ingestione massiva di telemetria e
      alla gestione in parallelo di flotte di gateway virtuali.],

    [Node.js],
    [24.14 LTS],
    [Runtime su cui eseguono tutti i microservizi NestJS (Management API, Data API, Provisioning Service) e la build
      della Web Application. Versione LTS garantisce stabilità e supporto a lungo termine in produzione.],

    [TypeScript],
    [5.7 (backend) \ 5.9 (frontend)],
    [Linguaggio principale per tutti i microservizi Node.js e la Web Application. Tipizzazione statica con strictness
      completa abilitata in tutti i progetti; riduce i bug di runtime nei DTO, contratti NATS ed entità TypeORM.],

    [NestJS],
    [11.0],
    [Framework backend adottato per Management API, Data API e Provisioning Service. Architettura modulare con
      Dependency Injection nativa, guard, interceptor e filtri globali.],

    [Angular],
    [21.2],
    [Framework frontend della Web Application. Il modello a componenti, il router con route guard e il supporto nativo
      ai Web Worker consentono di isolare la decifratura AES-256-GCM in un thread dedicato, separandola completamente
      dal thread UI.],
  )

  == Librerie Backend Node.js
  #table(
    columns: (1.5fr, auto, 4fr),
    [Libreria], [Versione], [Descrizione],

    [TypeORM],
    [0.3],
    [ORM utilizzato in Management API e Data API per la definizione delle entità, la costruzione delle query e la
      gestione delle connessioni a PostgreSQL e TimescaleDB. Integrazione nativa con NestJS tramite `TypeOrmModule`;
      ogni servizio gestisce le proprie migrations indipendenti.],

    [nats.js],
    [2.29],
    [Client NATS ufficiale per Node.js. Adottato da Management API, Data API e Provisioning Service per la connessione
      mTLS al broker, il pattern Request-Reply sincrono e la sottoscrizione agli stream JetStream con riconnessione
      automatica e backoff esponenziale.],

    [pg (node-postgres)],
    [8.20],
    [Driver PostgreSQL nativo per Node.js, utilizzato da TypeORM come adattatore sottostante per le connessioni al
      Management DB e al Measures DB.],

    [bcrypt],
    [6.0],
    [Libreria per l'hashing crittografico, impiegata nel Management API per la verifica sicura della `factory_key` dei
      gateway durante il flusso di provisioning, senza mai memorizzare la chiave in chiaro.],

    [node-forge],
    [1.3],
    [Libreria PKI/X.509 per Node.js, utilizzata nel Provisioning Service per il parsing delle Certificate Signing
      Request (CSR) dei gateway e per la firma dei certificati foglia con la CA interna.],

    [class-validator \ class-transformer],
    [0.14 \ 0.5],
    [Coppia di librerie usata nei servizi NestJS per la validazione dichiarativa e la trasformazione dei DTO di input.
      Integrata tramite `ValidationPipe` globale con `whitelist: true` per rifiutare automaticamente i campi non
      dichiarati.],

    [Passport.js \ passport-jwt \ jwks-rsa],
    [0.7 \ 4.0 \ 4.0],
    [Stack di autenticazione JWT nel Management API. `passport-jwt` estrae e verifica il token Bearer; `jwks-rsa`
      recupera e mette in cache (TTL 24h) le chiavi pubbliche dall'endpoint JWKS di Keycloak, eliminando round-trip
      sincroni al provider per ogni richiesta.],

    [prom-client],
    [15.1],
    [Client Prometheus per Node.js. Integrato nel Provisioning Service per l'esposizione di metriche applicative
      (tentativi di onboarding, durate PKI, retry NATS) sull'endpoint `/metrics`.],

    [RxJS],
    [7.8],
    [Libreria per la programmazione reattiva. Impiegata nella Data API per il fan-out SSE (un `Subject` per tenant
      alimenta tutti i client connessi) e nei servizi NestJS per la gestione di pipeline di eventi asincrone.],
  )

  == Librerie Backend Go
  #table(
    columns: (1fr, auto, 4fr),
    [Libreria], [Versione], [Descrizione],

    [pgx / pgxpool],
    [5.8],
    [Driver Go ad alte prestazioni per PostgreSQL, adottato nel Data Consumer per il pool di connessioni a TimescaleDB.
      Supporta SSL/TLS `verify-full` e lettura sicura della password tramite Docker secret file.],

    [nats.go],
    [1.49],
    [Client NATS ufficiale per Go. Impiegato da Data Consumer e Simulator Backend per la connessione mTLS, il consumo
      JetStream durevole e il pattern Request-Reply con timeout e backoff configurabili.],

    [prometheus/client\_golang],
    [1.23],
    [Client Prometheus per Go. Espone le metriche applicative sull'endpoint `/metrics` in Data Consumer e Simulator
      Backend (throughput ingestione, latenze batch, contatori heartbeat).],

    [modernc.org/sqlite],
    [1.47],
    [Implementazione pure-Go di SQLite senza dipendenze CGo. Adottata dal Simulator Backend per la Simulation DB.],

    [cobra],
    [1.8],
    [Framework CLI per Go, impiegato nel Simulator CLI per la definizione dei comandi (`gateways`, `sensors`,
      `anomalies`, `shell`) con flag tipizzati e generazione automatica dell'help.],

    [pterm],
    [0.12],
    [Libreria Go per output stilizzato nel terminale, utilizzata nel Simulator CLI per tabelle, spinner e
      formattazione.],
  )

  == Librerie Client e SDK
  #table(
    columns: (1fr, auto, 4fr),
    [Libreria], [Versione], [Descrizione],

    [\@notip/crypto-sdk],
    [2.0.0],
    [Pacchetto npm interno che incapsula la logica di decifratura client-side della telemetria NoTIP. Importato dalla
      Web Application e utilizzabile da API client esterni. Distribuito in formato ESM e CJS con dichiarazioni
      TypeScript incluse.],

    [\@microsoft/fetch-event-source],
    [2.0],
    [Libreria per il consumo di stream Server-Sent Events con supporto all'iniezione di header HTTP personalizzati
      (necessario per il Bearer token). Adottata dal `@notip/crypto-sdk` e dalla Web Application per la ricezione della
      telemetria real-time.],

    [Zod],
    [4.3],
    [Libreria di validazione e parsing runtime per TypeScript, utilizzata nel `@notip/crypto-sdk` per validare
      strutturalmente il payload decifrato prima di restituirlo al chiamante come `PlaintextMeasure`.],

    [keycloak-angular \ keycloak-js],
    [21.0 \ 26.2],
    [Integrazione tra Keycloak e Angular. `keycloak-js` gestisce il protocollo OIDC Authorization Code con PKCE;
      `keycloak-angular` espone il contesto di autenticazione ai componenti e gestisce il refresh automatico dei token e
      le route guard.],

    [Chart.js],
    [4.5],
    [Libreria JavaScript per la visualizzazione di dati con canvas. Impiegata nella Web Application per i grafici della
      dashboard di telemetria (serie temporali decifrate, andamento valori sensor).],
  )

  == Archiviazione dati e messaggistica
  #table(
    columns: (1fr, auto, 4fr),
    [Tecnologia], [Versione], [Descrizione],

    [PostgreSQL],
    [18.3],
    [Ospita il Management DB per i dati relazionali della piattaforma. Gestisce l'anagrafica e l'isolamento logico di
      tenant, utenti, gateway, configurazioni di alert e memorizza le chiavi crittografiche AES-256 cifrate _at-rest_
      tramite chiave di cifratura applicativa (`DB_ENCRYPTION_KEY`).],

    [TimescaleDB],
    [pg17],
    [Estensione di PostgreSQL 17 dedicata al Measures DB. Gestisce l'ipertabella partizionata per serie temporali (chunk
      interval giornaliero, compressione automatica a 7 giorni) su cui vengono memorizzati esclusivamente i payload
      telemetrici come blob opachi (`encrypted_data`, `iv`, `auth_tag`).],

    [SQLite],
    [1.47],
    [Database relazionale embedded impiegato dal Simulator Backend come Simulation DB. Persiste lo stato dei gateway e
      dei sensori virtuali, consentendo il ripristino automatico della flotta simulata al riavvio senza bisogno di un
      database separato.],

    [NATS JetStream],
    [2.12],
    [Broker esclusivo per la comunicazione interna. Offre pattern Request-Reply per le interazioni sincrone tra
      microservizi e stream durevoli per gli eventi asincroni (telemetria `telemetry.data.*.*`, comandi, alert, audit
      log, decommissioning). I gateway si autenticano tramite certificati mTLS.],

    [Server-Sent Events (SSE)],
    [HTTP/1.1],
    [Protocollo unidirezionale impiegato dal Data API per il fan-out real-time dei payload crittografati verso il
      frontend. Supporta meccanismi di _catch-up_ (parametro `since`) e l'iniezione del Bearer token tramite
      `@microsoft/fetch-event-source`.],
  )

  == Testing
  #table(
    columns: (1fr, auto, 4fr),
    [Framework], [Versione], [Descrizione],

    [Jest],
    [30.0],
    [Framework di testing per Node.js, impiegato per unit test e test di integrazione di Management API, Data API e
      Provisioning Service. Integrato con `ts-jest` per l'esecuzione diretta di TypeScript e con `jest-sonar` per
      l'export dei risultati verso SonarQube.],

    [Vitest],
    [4.0 / 4.1],
    [Framework di testing moderno basato su Vite, adottato per la Web Application e il `@notip/crypto-sdk`. Esecuzione
      nativa di ESM, integrazione con `@vitest/coverage-v8` per la copertura del codice e `vitest-sonar-reporter` per
      SonarQube.],

    [Supertest],
    [7.0],
    [Libreria per il testing HTTP in Node.js, utilizzata negli E2E test dei servizi NestJS per simulare richieste HTTP
      reali verso i controller senza avviare un server di rete.],

    [testcontainers-go],
    [0.41],
    [Libreria Go per l'orchestrazione programmatica di container Docker efimeri nei test. Utilizzata da Data Consumer e
      Simulator Backend per avviare istanze reali di NATS e TimescaleDB durante i test di integrazione, evitando i falsi
      positivi tipici dei mock infrastrutturali.],
  )

  == Osservabilità
  #table(
    columns: (1fr, auto, 4fr),
    [Tecnologia], [Versione], [Descrizione],

    [Prometheus],
    [3.10],
    [Sistema di raccolta e aggregazione delle metriche applicative. Effettua lo scraping degli endpoint `/metrics`
      esposti dai microservizi Go (Data Consumer, Simulator Backend), NestJS (Provisioning Service) e dal NATS Exporter.
      Retention configurata a 15 giorni.],

    [Grafana],
    [12.3],
    [Piattaforma di visualizzazione delle metriche raccolte da Prometheus. Fornisce dashboard operative per il
      monitoraggio di throughput di ingestione, latenze, stato dei gateway e metriche NATS.],

    [NATS Prometheus Exporter],
    [0.19.1],
    [Esportatore di metriche del server NATS in formato Prometheus. Espone statistiche di connessione, throughput dei
      messaggi e stato degli stream JetStream, consentendo il monitoraggio del broker all'interno dell'unico stack di
      osservabilità della piattaforma.],
  )

  == Infrastruttura e sicurezza
  #table(
    columns: (1fr, auto, 4fr),
    [Tecnologia], [Versione], [Descrizione],

    [Docker & Docker Compose],
    [Compose v2],
    [Garantiscono l'isolamento a livello di processo dei microservizi. Coordinano il networking interno (rete bridge
      `notip_internal`), l'iniezione a runtime dei segreti tramite Docker secrets e la persistenza della CA interna sul
      volume named isolato `notip_ca_certs`.],

    [Nginx],
    [1.27],
    [Unico punto di ingresso HTTP/HTTPS esposto all'esterno. Reverse proxy con rate limiting sull'endpoint di
      provisioning, header di sicurezza obbligatori e passthrough SSE con buffering disabilitato.],

    [Keycloak],
    [26.5],
    [Provider IAM centralizzato per flussi OIDC (utenti web, Authorization Code + PKCE) e OAuth2 (`client_credentials`
      per API client e service account). Protocol Mapper personalizzato che permette l'iniezione dei claim `tenant_id` e
      `role` in ogni JWT emesso.],

    [WebCrypto API],
    [W3C — nativa],
    [API nativa dei browser moderni per operazioni crittografiche hardware-accelerate. Utilizzata dal
      `@notip/crypto-sdk` per la decifratura AES-256-GCM dei payload telemetrici, senza richiedere dipendenze JavaScript
      aggiuntive per le primitive crittografiche.],
  )

  #pagebreak()

  = Architettura di Sistema

  == Visione d'insieme

  NoTIP è una piattaforma IoT multi-tenant per l'acquisizione, il trasporto e la visualizzazione di telemetria
  proveniente da gateway BLE fisici o simulati. Il sistema è progettato attorno a un principio architetturale fondante
  ovvero la *Pipeline Opaca*: nessun componente server-side decifra mai i payload telemetrici. I dati vengono cifrati
  AES-256-GCM all'origine (il gateway), viaggiano come blob opachi attraverso l'intera infrastruttura cloud, e vengono
  decifrati esclusivamente nel browser dell'utente finale tramite WebCrypto API. La compromissione di qualsiasi
  componente cloud — database incluso — non espone mai il contenuto in chiaro delle misurazioni.

  La piattaforma supporta più tenant in isolamento completo: ogni tenant gestisce il proprio insieme di gateway, i
  propri utenti e le proprie configurazioni di alert. L'isolamento è applicato su tre livelli indipendenti: a livello di
  identità (Keycloak inietta `tenant_id` in ogni JWT), a livello applicativo (ogni servizio backend impone il
  `tenant_id` come filtro obbligatorio) e a livello di messaggistica (NATS confina ogni gateway al proprio namespace di
  subject tramite _subject permissions_ statiche).

  Il sistema è strutturato in due strati logici:
  - *Cloud System*: microservizi responsabili del controllo della piattaforma, dell'ingestione e dell'esposizione dei
    dati, dell'autenticazione e del provisioning dei gateway.
  - *Strato di Simulazione*: servizi separati che emulano il comportamento di gateway IoT fisici, utilizzati in fase di
    sviluppo, test e dimostrazione funzionale senza necessità di hardware reale.

  Tutti i microservizi sono containerizzati con Docker e gestiti tramite Docker Compose. La comunicazione interna tra
  microservizi avviene esclusivamente tramite NATS JetStream, sia per le interazioni sincrone (pattern Request-Reply)
  sia per quelle asincrone (stream durevoli JetStream), eliminando completamente le dipendenze HTTP point-to-point tra
  servizi, a seguito di una decisione architetturale presa in fase di progettazione del sistema.

  *Single Source of Truth:* Per i contratti delle API (interfacce REST, stream NATS, payload crittografici), il codice
  sorgente e i repository dei singoli servizi costituiscono l'unica fonte di verità. I payload esatti e gli endpoint
  sono documentati e mantenuti aggiornati tramite le specifiche OpenAPI e AsyncAPI incluse in ciascun repository.

  #align(center)[
    #image("./assets/Containers.svg", width: 100%)
    Architettura Logica del Simulator Backend.
  ]

  == Componenti della piattaforma

  === Cloud System

  Il Cloud System è composto dalle seguenti componenti, ognuna con responsabilità ben definite:

  - *Nginx*: unico punto di ingresso HTTP/HTTPS per tutti i client esterni. Gestisce TLS termination, routing per
    prefisso di path verso i microservizi interni, rate limiting sugli endpoint sensibili e iniezione degli header di
    sicurezza obbligatori.
  - *NATS JetStream*: broker di messaggistica esclusivo per la comunicazione interna. Ospita gli stream durevoli per
    telemetria (`TELEMETRY`), comandi (`COMMANDS`), ACK (`COMMAND_ACKS`), alert (`ALERTS`), decommissioning
    (`DECOMMISSION`) e log di audit (`AUDIT_LOG`). Autentica i gateway tramite mTLS.
  - *Keycloak*: provider IAM per tutti i flussi di autenticazione e autorizzazione. Gestisce il realm `notip` con OIDC
    PKCE per gli utenti web e OAuth2 `client_credentials` per i client API. Inietta i claim `tenant_id` e `role` in ogni
    JWT tramite Protocol Mapper.
  - *Management API*: funge da centro di controllo dell'intera piattaforma. Gestisce il ciclo di vita di tenant, utenti,
    gateway, chiavi AES, comandi, soglie di alert e API client.
  - *Provisioning Service*: CA interna per il provisioning Zero Touch dei gateway. Firma i certificati mTLS e genera le
    chiavi AES-256 al momento del primo onboarding del dispositivo.
  - *Data Consumer*: servizio Go per l'ingestione ad alto throughput della telemetria da NATS verso TimescaleDB.
    Gestisce il monitoraggio di liveness dei gateway.
  - *Data API*: interfaccia di lettura per la telemetria cifrata. Espone endpoint REST paginati, bulk export e streaming
    real-time via SSE verso il frontend.
  - *Web Application*: SPA Angular e unico punto di decifratura dell'intera pipeline. Integra il `@notip/crypto-sdk` per
    eseguire la decifratura AES-256-GCM esclusivamente nel browser dell'utente.
  - *\@notip/crypto-sdk*: libreria TypeScript che incapsula la logica di risoluzione delle chiavi, fetching dei dati
    cifrati e decifratura. Utilizzata dalla Web Application e disponibile per client esterni.
  - *Management DB* (PostgreSQL): archivia tutti i dati di gestione della piattaforma (tenant, utenti, gateway, chiavi
    AES cifrate _at-rest_, alert, comandi, audit log).
  - *Measures DB* (TimescaleDB): archivia esclusivamente i blob cifrati della telemetria in una ipertabella partizionata
    per serie temporali.
  - *Prometheus + Grafana*: stack di osservabilità per il monitoraggio delle metriche applicative e infrastrutturali.

  === Strato di Simulazione

  Lo strato di simulazione opera come gruppo Docker Compose separato e include:

  - *Simulator Backend*: servizio Go che orchestra l'insiemde dei gateway IoT virtuali. Gestisce il provisioning
    automatizzato, genera telemetria cifrata AES-256-GCM e la pubblica su NATS emulando fedelmente il comportamento di
    hardware fisico.
  - *Simulator CLI*: interfaccia a riga di comando Go (cobra + bubbletea) per la gestione operativa della flotta
    simulata. Consente la creazione di gateway, la configurazione dei sensori e l'iniezione di anomalie telemetriche ad
    hoc.
  - *Simulation DB* (SQLite): database embedded per la persistenza dello stato della flotta simulata, con supporto al
    ripristino automatico al riavvio del servizio.

  == Design Pattern Macro-architetturali

  #st.design-pattern(
    name: "Pipeline Opaca (Zero-Knowledge Server-Side)",
    problem: [
      I payload contengono misurazioni classificate come dati sensibili. La piattaforma deve garantire che i dati
      restino inaccessibili anche in caso di compromissione di un servizio backend o del database.
    ],
    decision: [
      Nessun componente cloud (Data Consumer, Data API, Management API) decifra MAI i payload telemetrici. I campi
      crittografici (`EncryptedData`, `IV`, `AuthTag`) viaggiano come blob opachi e la decifratura avviene
      esclusivamente nel browser dell'utente finale via WebCrypto API, orchestrata dal `@notip/crypto-sdk`.
    ],
    alternatives: [
      - *Cifratura del solo canale (TLS):* Ritenuta insufficiente in quanto i dati risulterebbero in chiaro nella
        memoria dei microservizi e sul DB, rendendo ogni componente un Single Point of Failure.
    ],
    consequences: [
      - *Sicurezza:* La superficie di attacco server-side sui dati sensore si riduce sensibilmente.
      - *Limitazione funzionale:* Il backend non può effettuare filtraggi o alert sul valore del dato, che devono essere
        elaborati client-side.
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
      JetStream (per l'asincrona). Non esistono endpoint REST interni tra microservizi.
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

  #st.design-pattern(
    name: "Database per Service",
    problem: [
      In un'architettura a microservizi, la condivisione di un database tra servizi diversi crea accoppiamento
      strutturale che vincola il ciclo di deploy e impedisce l'adozione di tecnologie di storage eterogenee.
    ],
    decision: [
      Ogni servizio possiede e gestisce il proprio datastore: Management API su PostgreSQL (Management DB), Data
      Consumer e Data API su TimescaleDB (Measures DB, uno in scrittura e uno in lettura), Simulator Backend su SQLite
      (Simulation DB). I servizi non accedono mai direttamente al database altrui; la condivisione di stato avviene
      esclusivamente tramite messaggi NATS.
    ],
    alternatives: [
      - *Database condiviso:* Avrebbe semplificato le interrogazioni cross-service ma avrebbe creato accoppiamento
        strutturale tra schema e deploy, impedendo l'adozione di TimescaleDB solo per la telemetria.
    ],
    consequences: [
      - *Isolamento:* Ogni servizio può evolvere il proprio schema indipendentemente tramite migrations dedicate.
      - *Scelta tecnologica mirata:* TimescaleDB per serie temporali, PostgreSQL per dati relazionali, SQLite per stato
        locale embedded.
      - *Complessità query:* Query che richiedono dati da più servizi devono essere composte a livello applicativo o
        tramite chiamate NATS.
    ],
  )

  #pagebreak()

  = Descrizione dei Microservizi

  Questa sezione fornisce una descrizione sintetica di ciascun microservizio del sistema NoTIP, con l'obiettivo di
  chiarirne il ruolo nell'infrastruttura e le relazioni con gli altri componenti. Per i dettagli implementativi
  (architettura interna, contratti API, schema del database, strategia di test) si rimanda ai documenti di specifica
  tecnica di servizio collegati.

  == Management API

  #align(center)[
    #image("./assets/ManagementAPIComponents.svg", width: 50%)
    Architettura Logica del Management API.
  ]

  Il `notip-management-api` è il fulcro di controllo della piattaforma. Implementato in NestJS, è responsabile della
  gestione di tutte le entità di configurazione del sistema e funge da intermediario tra il frontend, Keycloak e gli
  altri microservizi backend. È l'unico servizio che scrive sul Management DB (PostgreSQL) e l'unico che interagisce
  direttamente con le API amministrative di Keycloak per la gestione degli utenti.

  La presenza di questo servizio nel sistema è giustificata dalla necessità di separare nettamente il piano di controllo
  (gestione di utenti, gateway, chiavi, alert, comandi) dal piano dati (ingestione ed esposizione della telemetria).

  Il Management API centralizza tutta la logica di business relativa alla configurazione della piattaforma, consentendo
  a Data API e Data Consumer di rimanere servizi focalizzati esclusivamente sul trattamento dei dati telemetrici.

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

  Per la specifica tecnica dettagliata si rimanda al documento #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_management_api.pdf",
  )[Specifica Tecnica — Management API].

  == Provisioning service

  #align(center)[
    #image("./assets/ProvisioningComponents.svg", width: 100%)
    Architettura Logica del Provisioning Service.
  ]

  Il `notip-provisioning-service` è il punto di ingresso del ciclo di vita di ogni gateway fisico nella piattaforma. La
  sua esistenza è motivata dall'esigenza di isolare il processo di onboarding — che richiede operazioni PKI sensibili
  (firma di certificati e generazione di chiavi crittografiche) — in un servizio dedicato con una superficie di attacco
  minima e un ciclo di vita operativo ben definito.

  Il servizio espone un unico endpoint HTTP (`POST /provision/onboard`) raggiungibile solo al momento dell'attivazione
  iniziale del dispositivo. Non gestisce sessioni autenticate con JWT: l'autenticazione avviene tramite credenziali di
  fabbrica monouso (`factory_id` e `factory_key`) presenti nel body della richiesta.

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

  Per la specifica tecnica dettagliata si rimanda al documento #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_provisioning_service.pdf",
  )[Specifica Tecnica — Provisioning Service].

  == Data consumer

  #align(center)[
    #image("./assets/DataConsumerComponents.svg", width: 100%)
    Architettura Logica del Data Consumer.
  ]

  Il `notip-data-consumer` è il componente Go responsabile dell'ingestione della telemetria nell'infrastruttura cloud.
  La sua separazione dal resto del sistema è giustificata da requisiti di performance: l'ingestione massiva di
  telemetria da potenzialmente migliaia di gateway richiede un throughput e una concorrenza che Go garantisce
  nativamente grazie alle goroutine, rendendolo la scelta ideale rispetto a runtime event-loop come Node.js.

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
    alert attive e, lato data consumer, attiva la logica di rilevamento anomalie senza accedere al contenuto cifrato del
    dato.

  Per la specifica tecnica dettagliata si rimanda al documento #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_data_consumer.pdf",
  )[Specifica Tecnica — Data Consumer].

  == Data API

  #align(center)[
    #image("./assets/DataAPIComponents.svg", width: 100%)
    Architettura Logica del Data API.
  ]

  Il `notip-data-api` è il punto di accesso applicativo ai dati telemetrici cifrati persistiti su TimescaleDB. La sua
  separazione dal Data Consumer incarna il principio CQRS (Command Query Responsibility Segregation): il Consumer è
  ottimizzato per la scrittura ad alto throughput, mentre la Data API è ottimizzata per la lettura, il filtraggio e lo
  streaming verso i client. Questo disaccoppiamento consente di scalare i due path indipendentemente in funzione del
  carico.

  Espone interfacce REST e SSE verso il frontend Angular, restituendo esclusivamente payload cifrati e metadati tecnici:
  il servizio non dispone di accesso alle chiavi AES e non effettua mai operazioni di decifratura.

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

  Per la specifica tecnica dettagliata si rimanda al documento #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_data_api.pdf",
  )[Specifica Tecnica — Data API].

  == Simulator backend

  #align(center)[
    #image("./assets/SimulatorBackendComponents.svg", width: 100%)
    Architettura Logica del Simulator Backend.
  ]

  Il `notip-simulator-backend` è il componente Go che emula il comportamento di un'insieme di gateway IoT fisici. La sua
  presenza nel sistema risponde a un'esigenza pratica fondamentale: lo sviluppo, il testing e la dimostrazione
  funzionale della piattaforma non possono dipendere dalla disponibilità di hardware fisico.

  Il Simulator Backend consente di generare telemetria realistica — incluse anomalie controllate — riproducendo
  fedelmente il comportamento di un gateway reale: provisioning via Provisioning Service, connessione mTLS a NATS,
  emissione periodica di payload cifrati e gestione dei comandi.

  Il servizio interagisce con la piattaforma esattamente come farebbe un gateway fisico: esegue il provisioning
  automatico tramite chiamata all'endpoint `POST /api/provision/onboard`, ottiene un certificato mTLS firmato dalla CA
  interna e una chiave AES-256, si connette a NATS tramite tale certificato e pubblica le telemetrie prodotte sullo
  stream `TELEMETRY`. Ogni gateway virtuale è gestito da una goroutine dedicata, permettendo la simulazione parallela di
  intere flotte, rendendo l'utilizzo del simulatore più aderente alla realtà.

  Le responsabilità principali sono:

  - *Orchestrazione della flotta:* gestione del ciclo di vita completo dei gateway virtuali (creazione, avvio, arresto,
    decommissioning) tramite un'API HTTP interna su `:8090`.
  - *Provisioning autonomo:* ogni gateway virtuale esegue in autonomia il flusso di onboarding, generando una propria
    coppia di chiavi ECDSA e un CSR, invocando il Provisioning Service e conservando il materiale crittografico
    ottenuto.
  - *Emissione di telemetria cifrata:* ogni worker genera valori sensor secondo profili configurabili (temperatura,
    umidità, pressione, movimento, biometria) con diversi algoritmi di generazione (`uniform_random`, `sine_wave`,
    `spike`, `constant`). I payload vengono cifrati AES-256-GCM con la chiave assegnata al gateway e pubblicati su
    `telemetry.data.{tenantId}.{gatewayId}`.
  - *Iniezione di anomalie:* supporta la simulazione di disconnessioni, degradazione di rete con packet loss
    configurabile e iniezione di valori fuori soglia (`outlier`), consentendo la verifica del sistema di alert senza
    hardware fisico.
  - *Persistenza e recovery:* lo stato dell'intera flotta (gateway, sensori, chiavi, certificati) è persistito su
    SQLite, consentendo il ripristino completo della simulazione al riavvio del servizio.

  Per la specifica tecnica dettagliata si rimanda al documento #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_simulator_backend_cli.pdf",
  )[Specifica Tecnica — Simulator Backend].

  == Web application (Frontend)

  #align(center)[
    #image("./assets/WebAppComponents.svg", width: 100%)
    Architettura Logica del Web Application.
  ]

  Il `notip-frontend` è la Single Page Application Angular che costituisce l'interfaccia utente principale della
  piattaforma. Il suo ruolo nel sistema è duplice e inscindibile: da un lato è il punto di accesso visuale per tutte le
  operazioni di gestione e monitoraggio, dall'altro è — per design — l'unico punto dell'intera pipeline in cui la
  *telemetria viene decifrata* (oltre ai Client API autorizzati). Questo secondo ruolo non è voluto architetturalmente:
  senza la Web Application (o un API client che integri il `@notip/crypto-sdk`), i dati telemetrici rimarrebbero cifrati
  e inaccessibili.

  L'autenticazione avviene tramite OIDC Authorization Code + PKCE con Keycloak; il token JWT ottenuto contiene i claim
  `tenant_id` e `role` che guidano il routing con guardie di ruolo e il comportamento di ogni componente
  dell'interfaccia.

  Le responsabilità principali sono:

  - *Interfaccia di gestione:* CRUD completo per gateway, utenti, soglie di alert, API client e audit log, con accesso
    differenziato per ruolo (System Admin, Tenant Admin, Tenant User).
  - *Dashboard real-time:* visualizzazione in tempo reale della telemetria decifrata ricevuta via SSE, con annotazione
    automatica delle misure fuori soglia tramite valutazione client-side delle `sensor_threshold_configs`.
  - *Decifratura client-side:* integra il `@notip/crypto-sdk` per delegare la risoluzione delle chiavi, il fetching dei
    dati cifrati e la decifratura AES-256-GCM. La decifratura avviene nel contesto del browser dell'utente, mai nel
    server.
  - *Supporto alla modalità impersonation:* il System Admin può impersonare gli utenti di un tenant tramite token
    exchange Keycloak (RFC 8693). In questa modalità, la dashboard visualizza i dati telemetrici in forma offuscata,
    impedendo la decifratura.
  - *Query storica ed export:* accesso ai dati storici con filtri per gateway, sensore, tipo e intervallo temporale, con
    funzionalità di export bulk.

  Per la specifica tecnica dettagliata si rimanda al documento #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_frontend.pdf",
  )[Specifica Tecnica — Frontend].

  == Simulator CLI

  Il `notip-simulator-cli` è l'interfaccia a riga di comando (CLI) per la gestione operativa della flotta di gateway
  simulati esposta dal Simulator Backend. Il suo scopo è fornire agli operatori uno strumento rapido e scriptabile per
  interagire con la simulazione senza dover invocare direttamente le API HTTP del Simulator Backend.

  Il CLI è distribuito come container Docker effimero: viene avviato on-demand, esegue il comando richiesto e viene
  immediatamente rimosso. Supporta sia l'esecuzione di singoli comandi (adatta a script e CI) sia una modalità shell
  interattiva per sessioni operative prolungate.

  Le responsabilità principali sono:

  - *Gestione gateway:* creazione singola e bulk di gateway virtuali con parametri configurabili (modello, firmware,
    frequenza di emissione), avvio e arresto dell'emissione, eliminazione.
  - *Gestione sensori:* aggiunta, configurazione e rimozione di profili sensore per ogni gateway, con scelta del tipo
    (`temperature`, `humidity`, `pressure`, `movement`, `biometric`) e dell'algoritmo di generazione (`uniform_random`,
    `sine_wave`, `spike`, `constant`).
  - *Iniezione anomalie:* simulazione di disconnessioni temporanee, degradazione di rete con packet loss configurabile e
    iniezione di valori outlier su singoli sensori.

  Per la specifica tecnica dettagliata si rimanda al documento #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_simulator_backend_cli.pdf",
  )[Specifica Tecnica — Simulator CLI].

  == \@notip/crypto-sdk

  Il `@notip/crypto-sdk` è una libreria TypeScript pubblicata come pacchetto npm (`@notip/crypto-sdk`, versione 2.0.0)
  che incapsula l'intera logica di decifratura client-side della telemetria NoTIP. A differenza degli altri componenti
  del sistema, non è un microservizio ma una libreria riutilizzabile: viene importata dalla Web Application e può essere
  integrata da qualsiasi API client esterno che necessiti di accedere ai dati telemetrici in chiaro.

  === Ruolo nel sistema

  La presenza di questa libreria è direttamente imposta dall'*Opaque Pipeline*: poiché nessun componente server-side
  decifra i payload, chiunque voglia accedere ai dati in chiaro deve eseguire localmente la decifratura. Senza l'SDK (o
  un'implementazione equivalente), i dati resterebbero opachi. Il pacchetto centralizza questa logica in un modulo
  testato, versionato e con interfacce chiare, evitando che la complessità del processo di decifratura (risoluzione
  delle chiavi, caching, gestione degli errori, parsing e validazione del payload) venga replicata in ogni consumer.

  === Integrazione nel sistema

  L'SDK interagisce con due endpoint della piattaforma:
  + *Management API* (`GET /api/mgmt/keys/{gatewayId}`): per recuperare la chiave AES-256 associata a un gateway,
    presentando il Bearer token JWT dell'utente autenticato.
  + *Data API* (`/api/data/measures/query`, `/api/data/measures/export`, `/api/data/measures/stream`): per ottenere i
    payload cifrati e i metadati delle misurazioni.

  L'SDK riceve un `baseUrl` e un `tokenProvider` (callback che restituisce il token JWT corrente) come parametri di
  configurazione. Tutti i dettagli di trasporto, autenticazione e parsing sono incapsulati internamente; il chiamante
  interagisce esclusivamente con le interfacce di alto livello.

  === Architettura interna

  Il pacchetto è strutturato attorno a cinque componenti principali:

  - *`CryptoSdk`*: entry point principale. Implementa tre interfacce (`MeasureQuerier`, `MeasureStreamer`,
    `MeasureExporter`) e orchestra il pipeline completo: fetching dei dati cifrati, risoluzione della chiave,
    decifratura e validazione del payload.
  - *`KeyManager`*: cache per-gateway delle chiavi AES-256. Al primo accesso per un dato gateway recupera la chiave
    dalla Management API tramite `ManagementApiService`; i successivi accessi vengono serviti dalla cache in memoria
    senza ulteriori chiamate di rete. Supporta la gestione del `keyVersion` per gestire la rotazione delle chiavi.
  - *`CryptoEngine`*: motore di decifratura stateless. Implementa AES-256-GCM tramite la WebCrypto API nativa del
    browser (o del runtime), accettando i tre componenti crittografici del payload (`encrypted_data`, `iv`, `auth_tag`)
    e restituendo i dati in chiaro.
  - *`DataApiService`*: orchestratore dei due client di trasporto. Delega le operazioni di query ed export al
    `DataApiRestClient` (HTTP `fetch`) e lo streaming al `DataApiSseClient` (basato su `@microsoft/fetch-event-source`).
  - *`ManagementApiService` + `ManagementApiClient`*: strato di accesso alla Management API per il recupero delle chiavi
    crittografiche.

  === Flusso di decifratura

  Per ogni `EncryptedEnvelopeDTO` ricevuto dalla Data API:
  + Il `KeyManager` risolve la chiave AES-256 associata a `gatewayId` + `keyVersion` (dalla cache o dalla Management
    API).
  + Il `CryptoEngine` esegue la decifratura AES-256-GCM usando la chiave, l'`iv` e l'`auth_tag` presenti nell'envelope.
  + Il payload decifrato viene validato con uno schema Zod prima di essere restituito come `PlaintextMeasure`.

  In caso di fallimento in qualsiasi fase, viene sollevata una delle seguenti eccezioni tipizzate, tutte derivate da
  `SdkError`:
  - *`ApiError`*: risposta HTTP non-2xx dalla Management API o Data API.
  - *`DecryptionError`*: fallimento della decifratura AES-GCM (chiave errata o payload corrotto).
  - *`ValidationError`*: il payload decifrato non supera la validazione Zod (struttura inattesa).

  === Interfacce pubbliche

  Il pacchetto espone tre interfacce narrow che i consumer dovrebbero preferire rispetto alla dipendenza diretta dalla
  classe concreta `CryptoSdk`:

  - *`MeasureQuerier`*: `queryMeasures(query: QueryModel): Promise<QueryResponsePage>` — lettura paginata basata su
    cursore.
  - *`MeasureStreamer`*: `streamMeasures(query: StreamModel, signal?: AbortSignal): AsyncGenerator<PlaintextMeasure>` —
    streaming real-time via SSE con supporto all'abort.
  - *`MeasureExporter`*: `exportMeasures(query: ExportModel): AsyncGenerator<PlaintextMeasure>` — export bulk non
    paginato.

  La separazione in interfacce narrow consente di iniettare sostituti nei test senza dover istanziare la classe
  concreta, che richiederebbe connessioni di rete funzionanti.

  #pagebreak()

  = Contratti di Interfaccia

  Questa sezione cataloga tutti gli endpoint HTTP e i subject NATS esposti dal sistema NoTIP. Gli endpoint HTTP pubblici
  sono raggiungibili esclusivamente tramite Nginx; quelli interni (health, metriche, Simulator Backend) rimangono sulla
  rete Docker e non sono accessibili dall'esterno.

  I percorsi riportati nelle tabelle sono i percorsi *interni* al servizio. I prefissi Nginx per gli endpoint pubblici
  sono i seguenti:

  #table(
    columns: (2fr, 3fr, 3fr),
    [Servizio], [Prefisso esterno (via Nginx)], [Servizio interno],
    [Management API], [`/api/mgmt/*`], [`management-api:3000`],
    [Data API], [`/api/data/*`], [`data-api:3000`],
    [Provisioning Service], [`/api/provision/*`], [`provisioning-service:3000`],
    [Keycloak (IAM)], [`/auth/*`], [`keycloak:8080`],
  )

  == Management API

  === Autenticazione e sessione
  #table(
    columns: (auto, 3fr, 4fr),
    [Metodo], [Percorso], [Descrizione],
    [GET], [`/auth/me`], [Profilo, ruolo e `tenant_id` dell'utente corrente estratti dal JWT.],
    [GET],
    [`/auth/tenant-status`],
    [Stato del tenant (attivo, sospeso, `read_only`). Riattiva automaticamente le sospensioni scadute.],

    [POST],
    [`/auth/impersonate`],
    [Avvia impersonation di un tenant (solo `system_admin`). Restituisce un token di breve durata via Keycloak token
      exchange (RFC 8693).],
  )

  === Amministrazione (solo `system_admin`)
  #table(
    columns: (auto, 3fr, 4fr),
    [Metodo], [Percorso], [Descrizione],
    [GET], [`/admin/tenants`], [Elenco di tutti i tenant della piattaforma.],
    [POST], [`/admin/tenants`], [Creazione di un nuovo tenant con relativo gruppo Keycloak.],
    [PATCH], [`/admin/tenants/{id}`], [Modifica del tenant (nome, stato, intervallo di sospensione).],
    [DELETE], [`/admin/tenants/{id}`], [Eliminazione del tenant con cascata su DB e Keycloak.],
    [GET], [`/admin/tenants/{id}/users`], [Elenco degli utenti di un tenant specifico.],
    [GET], [`/admin/gateways`], [Elenco di tutti i gateway (cross-tenant).],
    [POST], [`/admin/gateways`], [Registrazione di un nuovo gateway con le sue credenziali di fabbrica.],
  )

  === Gateway
  #table(
    columns: (auto, 3fr, 4fr),
    [Metodo], [Percorso], [Descrizione],
    [GET], [`/gateways`], [Elenco dei gateway del tenant corrente.],
    [GET], [`/gateways/{id}`], [Dettaglio di un singolo gateway.],
    [PATCH], [`/gateways/{id}`], [Aggiornamento metadati (nome, frequenza di invio).],
    [DELETE],
    [`/gateways/{id}`],
    [Eliminazione del gateway, revoca della chiave AES e pubblicazione dell'evento `gateway.decommissioned`.],
  )

  === Utenti
  #table(
    columns: (auto, 3fr, 4fr),
    [Metodo], [Percorso], [Descrizione],
    [GET], [`/users`], [Elenco degli utenti del tenant.],
    [POST], [`/users`], [Creazione utente su DB e Keycloak.],
    [GET], [`/users/{id}`], [Dettaglio utente.],
    [PATCH], [`/users/{id}`], [Aggiornamento utente.],
    [POST], [`/users/bulk-delete`], [Eliminazione di massa di utenti.],
  )

  === Chiavi crittografiche
  #table(
    columns: (auto, 3fr, 4fr),
    [Metodo], [Percorso], [Descrizione],
    [GET],
    [`/keys`],
    [Recupero della chiave AES-256 associata a un gateway. Consumato dal `@notip/crypto-sdk`. Bloccato durante
      l'impersonation.],
  )

  === Alert
  #table(
    columns: (auto, 3fr, 4fr),
    [Metodo], [Percorso], [Descrizione],
    [GET], [`/alerts`], [Elenco degli alert scattati (gateway offline) per il tenant.],
    [GET], [`/alerts/config`], [Configurazioni di alert attive (default + override per gateway).],
    [PUT], [`/alerts/config/default`], [Impostazione della configurazione di alert di default per il tenant.],
    [PUT], [`/alerts/config/gateway/{gatewayId}`], [Override della configurazione per un gateway specifico.],
    [DELETE], [`/alerts/config/gateway/{gatewayId}`], [Rimozione dell'override per un gateway.],
  )

  === Soglie sensore
  #table(
    columns: (auto, 3fr, 4fr),
    [Metodo], [Percorso], [Descrizione],
    [GET], [`/thresholds`], [Elenco delle soglie di alert configurate per il tenant.],
    [PUT], [`/thresholds/default`], [Configurazione della soglia default per un tipo di sensore.],
    [PUT], [`/thresholds/sensor/{sensorId}`], [Soglia specifica per un singolo sensore (priorità su quella di tipo).],
    [DELETE], [`/thresholds/sensor/{sensorId}`], [Rimozione soglia per sensore.],
    [DELETE], [`/thresholds/type/{sensorType}`], [Rimozione soglia per tipo di sensore.],
  )

  === API Client OAuth2
  #table(
    columns: (auto, 3fr, 4fr),
    [Metodo], [Percorso], [Descrizione],
    [GET], [`/api-clients`], [Elenco dei client API OAuth2 del tenant.],
    [POST], [`/api-clients`], [Creazione di un client Keycloak confidenziale con service account e claim `tenant_id`.],
    [DELETE], [`/api-clients/{id}`], [Revoca e rimozione del client Keycloak.],
  )

  === Audit, costi e comandi
  #table(
    columns: (auto, 3fr, 4fr),
    [Metodo], [Percorso], [Descrizione],
    [GET], [`/audit`], [Log di audit del tenant con filtro obbligatorio sull'intervallo temporale.],
    [GET],
    [`/costs`],
    [Costo stimato per il tenant: storage TimescaleDB (via RR `internal.cost`) + contatori alert e comandi da DB.],

    [POST],
    [`/cmd/{gatewayId}/config`],
    [Dispatching di un comando `config_update` verso un gateway via stream COMMANDS.],

    [POST], [`/cmd/{gatewayId}/firmware`], [Dispatching di un comando `firmware_push` verso un gateway.],
    [GET],
    [`/cmd/{gatewayId}/status/{commandId}`],
    [Stato di un comando (`queued`, `ack`, `nack`, `expired`, `timeout`).],
  )

  == Provisioning Service

  #table(
    columns: (auto, 3fr, 4fr),
    [Metodo], [Percorso], [Descrizione],
    [POST],
    [`/provision/onboard`],
    [Onboarding iniziale di un gateway: valida le credenziali di fabbrica, firma il CSR mTLS, genera la chiave AES-256,
      completa il provisioning via NATS. Autenticazione tramite `factory_id` + `factory_key` nel body. Rate-limited: 5
      req/min per IP via Nginx.],
  )

  == Data API

  #table(
    columns: (auto, 3fr, 4fr),
    [Metodo], [Percorso], [Descrizione],
    [GET],
    [`/measures/query`],
    [Lettura paginata delle misure cifrate. Parametri: `from`, `to` (finestra max 24h), `limit` (max 999), `cursor`,
      `gatewayId[]`, `sensorId[]`, `sensorType[]`.],

    [GET],
    [`/measures/export`],
    [Export non paginato delle misure per un intervallo temporale con gli stessi filtri della query.],

    [GET],
    [`/measures/stream`],
    [Stream real-time via *SSE* dei payload cifrati, isolato per `tenant_id`. Parametro opzionale `since` per catch-up
      storico (replay 10s + flusso live da NATS).],

    [GET], [`/sensor`], [Elenco dei sensori attivi negli ultimi 10 minuti, opzionalmente filtrati per `gatewayId`.],
  )

  == Simulator Backend (interno, `:8090`)

  _Non esposto via Nginx. Accessibile esclusivamente dalla rete Docker interna tramite il Simulator CLI o altri client
  interni._

  #table(
    columns: (auto, 3fr, 4fr),
    [Metodo], [Percorso], [Descrizione],
    [GET], [`/health`], [Health check del servizio.],
    [POST], [`/sim/gateways`], [Creazione di un gateway virtuale (singolo).],
    [POST],
    [`/sim/gateways/bulk`],
    [Creazione di più gateway da un elenco di `factory_id` con configurazione condivisa.],

    [GET], [`/sim/gateways`], [Elenco di tutti i gateway simulati con il loro stato.],
    [GET], [`/sim/gateways/{id}`], [Dettaglio di un gateway simulato.],
    [POST], [`/sim/gateways/{id}/start`], [Avvio dell'emissione di telemetria per un gateway.],
    [POST], [`/sim/gateways/{id}/stop`], [Arresto dell'emissione di telemetria.],
    [DELETE], [`/sim/gateways/{id}`], [Decommissioning del gateway simulato (include cleanup NATS).],
    [POST], [`/sim/gateways/{id}/sensors`], [Aggiunta di un profilo sensore a un gateway (tipo, range, algoritmo).],
    [GET], [`/sim/gateways/{id}/sensors`], [Elenco dei sensori configurati per un gateway.],
    [DELETE], [`/sim/sensors/{sensorId}`], [Rimozione di un sensore.],
    [POST],
    [`/sim/gateways/{id}/anomaly/disconnect`],
    [Simulazione di una disconnessione temporanea del gateway per una durata configurabile.],

    [POST],
    [`/sim/gateways/{id}/anomaly/network-degradation`],
    [Simulazione di degradazione di rete con packet loss configurabile (0–1).],

    [POST], [`/sim/sensors/{sensorId}/anomaly/outlier`], [Iniezione di un valore outlier su un singolo sensore.],
  )

  == Health e Metriche (interni)

  _Non esposti via Nginx. Accessibili solo dalla rete Docker interna (scraping Prometheus)._

  #table(
    columns: (2fr, auto, auto, 3fr),
    [Servizio], [Endpoint], [Porta], [Descrizione],
    [Management API], [`GET /`], [`:3000`], [Health check (status 200/404 → servizio attivo).],
    [Data API], [`GET /`], [`:3000`], [Health check.],
    [Provisioning Service], [`GET /`], [`:3000`], [Health check.],
    [Data Consumer], [`GET /healthz`], [`:9090`], [Health check con ping a TimescaleDB.],
    [Data Consumer], [`GET /metrics`], [`:9090`], [Metriche Prometheus (throughput, latenze, heartbeat).],
    [Simulator Backend], [`GET /health`], [`:8090`], [Health check.],
    [Simulator Backend], [`GET /metrics`], [`:9090`], [Metriche Prometheus.],
  )

  == Comunicazione NATS

  Tutti i subject sono accessibili esclusivamente sulla rete Docker interna (porta `:4222` con mTLS obbligatorio). I
  gateway si autenticano tramite certificati firmati dalla CA interna; i microservizi backend tramite credenziali TLS
  con `verify_and_map`.

  === Stream JetStream (persistenti, asincroni)

  #table(
    columns: (auto, auto, auto, auto),
    [Subject], [Stream], [Publisher], [Consumer],
    [`telemetry.data.{tenantId}.{gatewayId}`], [TELEMETRY], [Gateway], [Data Consumer (durable)],
    [`command.gw.{tenantId}.{gatewayId}`], [COMMANDS], [Management API], [Gateway (push durable)],
    [`command.ack.{tenantId}.{gatewayId}`], [COMMAND\_ACKS], [Gateway], [Management API (durable)],
    [`alert.{tenantId}.gw_offline`], [ALERTS], [Data Consumer], [Management API (durable)],
    [`gateway.decommissioned.{tenantId}.{gatewayId}`],
    [DECOMMISSION],
    [Management API],
    [Data Consumer, Simulator Backend],

    [`log.audit.{tenantId}`], [AUDIT\_LOG], [Mgmt API, Provisioning], [Management API (durable)],
  )

  === Subject Request-Reply (sincroni, service-to-service)

  _Timeout 5 s. Retry 3× con backoff 1 s / 2 s / 4 s. Non accessibili dai gateway._

  #table(
    columns: (auto, 2fr, 2fr, 4fr),
    [Subject], [Requester], [Responder], [Descrizione],
    [`internal.mgmt.factory.validate`],
    [Provisioning Service],
    [Management API],
    [Valida le credenziali di fabbrica (`factory_id` + `factory_key`) durante l'onboarding.],

    [`internal.mgmt.provisioning.complete`],
    [Provisioning Service],
    [Management API],
    [Persiste la chiave AES-256, il certificato e marca il gateway come provisionato. Atomico: salva chiave, setta
      `provisioned=true`, azzera `factory_key_hash`.],

    [`internal.mgmt.alert-configs.list`],
    [Data Consumer],
    [Management API],
    [Recupera tutte le configurazioni di alert attive. Chiamato all'avvio e ogni 5 minuti con backoff fino a 30 s.],

    [`internal.mgmt.gateway.update-status`],
    [Data Consumer],
    [Management API],
    [Notifica la transizione di stato di un gateway (`online`/`offline`) a seguito di un evento heartbeat.],

    [`internal.mgmt.gateway.get-status`],
    [Data Consumer],
    [Management API],
    [Interroga lo stato lifecycle di un gateway (`online`, `offline`, `paused`, `provisioning`) prima di emettere un
      alert offline — soppresso se lo stato è `paused`.],

    [`internal.cost`],
    [Management API],
    [Data API],
    [Recupera la dimensione dello storage TimescaleDB per un tenant, utilizzato dal calcolo di `GET /costs`.],
  )

  #pagebreak()

  = Sicurezza, Scalabilità e Architettura a Microservizi

  Questa sezione discute le scelte architetturali trasversali che governano il sistema NoTIP, con l'obiettivo di rendere
  esplicite le motivazioni alla base di come il sistema è strutturato oggi e le garanzie che tale struttura fornisce.

  == Architettura a Microservizi

  === Motivazioni e benefici

  L'adozione di un'architettura a microservizi risponde a esigenze specifiche del dominio e non a una scelta puramente
  tecnologica. Il sistema NoTIP presenta requisiti di performance, sicurezza e isolamento che rendono problematica
  l'adozione di un monolite:

  - *Eterogeneità dei requisiti di performance:* l'ingestione massiva di telemetria (Data Consumer) richiede throughput
    e concorrenza che Go gestisce nativamente, mentre la logica di business della gestione della piattaforma (Management
    API) beneficia dell'ecosistema NestJS. Un monolite avrebbe imposto un compromesso su entrambi i fronti.
  - *Isolamento dei confini di sicurezza:* il Provisioning Service gestisce materiale crittografico sensibile (chiavi
    CA, chiavi AES). Isolarlo in un servizio dedicato con accesso esclusivo al volume `notip_ca_certs` riduce
    drasticamente la superficie di attacco: una compromissione del Management API o del Data Consumer non implica
    l'accesso alle chiavi della CA.
  - *Scalabilità indipendente:* il path di ingestione (Data Consumer) e il path di lettura (Data API) hanno profili di
    carico potenzialmente molto diversi. La separazione consente di scalare orizzontalmente ciascuno in modo
    indipendente.
  - *Cicli di deploy indipendenti:* ogni microservizio ha il proprio repository, il proprio schema di database con
    migrations dedicate, e il proprio ciclo di rilascio tramite immagini Docker versionata su GHCR.

  === Decomposizione dei servizi

  I confini tra i microservizi riflettono i bounded context del dominio:

  - *Gestione* (Management API): tutto ciò che riguarda _chi è nel sistema_ (tenant, utenti, gateway) e _come è
    configurato_ (alert, comandi, chiavi).
  - *Onboarding* (Provisioning Service): il processo di attivazione sicura di un gateway, isolato per la sua natura
    PKI-intensiva e il principio di monouso delle credenziali di fabbrica.
  - *Ingestione* (Data Consumer): il path critico per la performance di scrittura della telemetria; non espone API e non
    contiene logica di business complessa.
  - *Esposizione dati* (Data API): il path di lettura, con logica di paginazione, streaming e aggregazione; non scrive
    mai nel database.
  - *Simulazione* (Simulator Backend + Simulator CLI): interamente separato dal Cloud System, avviabile in modo
    indipendente tramite profilo Docker Compose, non accessibile dai client di produzione.

  == Sicurezza

  === Pipeline Opaca e segregazione crittografica

  Il meccanismo di sicurezza più significativo del sistema è la *Pipeline Opaca*: i payload telemetrici sono cifrati dal
  gateway con AES-256-GCM prima di essere trasmessi, e nessun componente cloud — neanche il database — vede mai i dati
  in chiaro. Questo garantisce che la compromissione di qualsiasi componente server-side (database incluso) non esponga
  le misurazioni.

  La decifratura avviene esclusivamente nel browser dell'utente tramite WebCrypto API, orchestrata dal
  `@notip/crypto-sdk`. Le chiavi AES-256 vengono recuperate dalla Management API solo al momento della decifratura, sono
  presenti in memoria nel browser per il tempo strettamente necessario, e non transitano mai in forma in chiaro su rete
  (sono distribuite via HTTPS con cifratura di trasporto TLS).

  Le chiavi AES-256 sono cifrate _at-rest_ nel Management DB tramite una chiave di cifratura applicativa
  (`DB_ENCRYPTION_KEY`) iniettata come Docker secret. In questo modo, un accesso diretto al database non consente di
  ricavare le chiavi senza conoscere anche la chiave applicativa.

  === Isolamento multi-tenant

  Il sistema NoTIP gestisce l'isolamento dei tenant su tre livelli indipendenti e complementari:

  - *Identity Layer (Keycloak)*: il provider IAM inietta il claim `tenant_id` in ogni JWT tramite Protocol Mapper
    dedicato. Non esiste token valido privo di questo claim; Keycloak costituisce l'unica fonte di verità per l'identità
    del tenant.
  - *Application Layer*: ogni microservizio backend estrae il `tenant_id` dal JWT validato e lo impone come filtro
    obbligatorio su ogni operazione di lettura e scrittura. La validazione avviene in modo stateless tramite JWKS
    caching (24 ore), senza chiamate sincrone a Keycloak per ogni richiesta.
  - *Messaging Layer (NATS)*: ogni gateway è confinato al proprio namespace di subject tramite _subject permissions_
    statiche basate sul Common Name del certificato mTLS. Un gateway non può pubblicare su subject appartenenti ad altri
    tenant o gateway.

  === Zero Touch Provisioning e autenticazione mTLS

  L'autenticazione dei gateway fisici si basa su certificati mTLS rilasciati dinamicamente tramite un processo di
  provisioning automatizzato progettato per eliminare la necessità di intervento manuale dopo la configurazione in
  fabbrica:

  + *Bootstrap:* il gateway, configurato con credenziali monouso in fabbrica (`factory_id` e `factory_key`), invoca
    l'endpoint HTTPS dedicato del Provisioning Service.
  + *Firma mTLS e generazione chiavi:* il Provisioning Service valida le credenziali tramite NATS verso il Management
    API, firma il certificato del gateway con la CA interna e genera la chiave AES-256 definitiva per l'E2EE.
  + *Transizione operativa:* consegnati il certificato e la chiave, la credenziale di fabbrica viene invalidata. Il
    gateway comunica da quel momento esclusivamente tramite il certificato mTLS firmato.

  La CA interna risiede su un volume Docker dedicato (`notip_ca_certs`) accessibile esclusivamente dal Provisioning
  Service e da NATS (in sola lettura, per la verifica dei certificati client). La distruzione di questo volume invalida
  tutti i gateway provisionati.

  === Perimetro di rete e riduzione della superficie di attacco

  Nginx è l'unico punto di ingresso HTTP/HTTPS esposto all'esterno. Tutti gli altri servizi comunicano esclusivamente
  sulla rete Docker interna e non sono raggiungibili dall'esterno. Nginx applica:
  - *TLS termination*: tutto il traffico esterno è cifrato.
  - *Rate limiting*: l'endpoint di provisioning è limitato a 5 richieste/minuto per IP.
  - *Security headers*: CSP (`frame-src 'none'`), HSTS, X-Frame-Options DENY, X-Content-Type-Options nosniff.
  - *SSE passthrough*: buffering disabilitato per lo stream SSE, evitando latenze artificiali nel fan-out real-time.

  Le credenziali e i segreti applicativi (password database, chiavi di cifratura, client secret Keycloak) non sono mai
  hardcoded o presenti in variabili d'ambiente non protette: vengono iniettati a runtime tramite Docker secrets e letti
  dai servizi tramite file montati.

  == Scalabilità

  === Comunicazione event-driven e NATS JetStream

  La scelta di NATS JetStream come backbone di comunicazione interna porta con sé benefici diretti in termini di
  scalabilità. Gli stream durevoli consentono a più consumer dello stesso gruppo di condividere il carico (consumer
  group JetStream), permettendo lo scaling orizzontale del Data Consumer senza modifiche al codice: è sufficiente
  avviare più istanze che si uniscano allo stesso durable consumer group per distribuire automaticamente la telemetria
  in arrivo.

  Analogamente, la durabilità degli stream garantisce che un downtime temporaneo di un consumer (es. restart per deploy)
  non comporti perdita di messaggi: i payload in coda vengono processati al ripristino del servizio.

  === Servizi stateless e scaling orizzontale

  I tre servizi NestJS — Management API, Data API e Provisioning Service — sono progettati come stateless: non
  mantengono stato di sessione in memoria tra le richieste. Questo li rende candidati naturali allo scaling orizzontale
  tramite load balancer davanti a Nginx. La validazione stateless dei JWT tramite JWKS elimina la necessità di sessioni
  condivise o di un coordinamento tra istanze.

  === TimescaleDB per dati di serie temporali

  La scelta di TimescaleDB per il Measures DB è motivata dalle caratteristiche specifiche del carico di lavoro:
  scritture continue di dati temporali con query prevalentemente per intervalli di tempo. L'ipertabella con chunk
  giornaliero garantisce che le query temporali coinvolgano solo i chunk rilevanti (partizionamento trasparente), mentre
  la compressione automatica a 7 giorni riduce l'occupazione su disco senza impattare le query sui dati recenti.

  === Fan-out SSE senza subscription per client

  Un potenziale collo di bottiglia nell'architettura SSE real-time è la creazione di una subscription NATS per ogni
  client connesso. Il `TelemetryStreamBridgeService` della Data API risolve questo problema mantenendo una *singola
  subscription NATS per tenant*, pubblicando i messaggi ricevuti su un `Subject` RxJS interno. Il fan-out verso tutti i
  client SSE connessi per quel tenant avviene a livello applicativo tramite l'Observable, senza moltiplicare le
  connessioni al broker. Questo approccio scala linearmente con il numero di tenant, non con il numero di client
  connessi per tenant.

  #pagebreak()

  = Metodologie di testing

  Oltre alle metodologie unitarie demandate ai singoli servizi, la validazione globale dell'architettura distribuita
  segue specifiche direttrici strategiche:
  - *Test di Integrazione:* Per validare le interazioni di rete, l'infrastruttura di test si avvale dell'orchestrazione
    programmatica di container effimeri a runtime. Questo approccio permette di testare i servizi contro istanze reali
    dei database (TimescaleDB) e del broker (NATS), garantendo l'affidabilità dei contratti di comunicazione ed evitando
    i falsi positivi tipici dei mock infrastrutturali.
  - *Test End-to-End (E2E):* Mirano a validare l'intera catena del valore completa nel rispetto della Pipeline Opaca. Il
    flusso parte dall'iniezione di telemetria tramite gateway simulati (Simulator Backend), attraversa il layer di
    persistenza e il fan-out SSE, per concludersi con la decifratura e il matching delle soglie eseguiti con successo
    dal `@notip/crypto-sdk` all'interno della Single Page Application.
]
