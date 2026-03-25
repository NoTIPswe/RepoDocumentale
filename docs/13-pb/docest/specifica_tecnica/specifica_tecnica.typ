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
  == Scopo e Struttura della Documentazione
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
  === Riferimenti Normativi
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato d'appalto C7 - Sistema di
      acquisizione dati da sensori]\ _Ultimo accesso: 2026-03-25_
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/norme_di_progetto.pdf")[Norme di Progetto
      v1.1.0]
  === Riferimenti Informativi
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

  == Linguaggi e Framework Principali
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
      nativa e perché opinionato.],

    [Angular],
    [],
    [Framework frontend impiegato per la Web Application e la Simulation Dashboard, essenziale per isolare la
      decifratura asincrona in un Web Worker dedicato.],
  )

  == Archiviazione Dati e Messaggistica
  #table(
    columns: (1fr, auto, 4fr),
    [Tecnologia], [Versione], [Descrizione],

    [PostgreSQL],
    [],
    [Ospita il Management DB per i dati relazionali della piattaforma. Gestisce l'anagrafica e l'isolamento logico di
      tenant, utenti, gateway, configurazioni di alert e memorizza le chiavi crittografiche AES-256 cifrate _at-rest_.],

    [TimescaleDB],
    [],
    [Estensione di PostgreSQL dedicata al Measures DB. Gestisce l'ipertabella partizionata per serie temporali (chunk
      interval giornaliero e compressione automatica a 7 giorni) su cui vengono memorizzati esclusivamente i payload
      telemetrici sotto forma di blob opachi.],

    [NATS Jetstream],
    [],
    [Broker esclusivo per l'intera piattaforma, che elimina totalmente le comunicazioni HTTP interne tra microservizi.
      Offre pattern Request-Reply per le chiamate sincrone e stream durevoli per gli eventi asincroni (telemetria,
      comandi, alert), garantendo la segregazione multi-tenant tramite rigorosi _subject permissions_.],

    [Server-Sent Events (SSE)],
    [],
    [Protocollo HTTP unidirezionale impiegato dal Data API per il fan-out real-time dei payload crittografati verso il
      frontend. Supporta meccanismi di _catch-up_ (parametro `since`) e permette l'iniezione del Bearer token per
      l'autenticazione tramite la libreria `\@microsoft/fetch-event-source`.],
  )

  == Infrastruttura e Sicurezza
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
      _Protocol Mapper_, inietta forzatamente i claim `tenant_id` e `role` in ogni JWT emesso, costituendo la base
      fondante per la validazione stateless e l'isolamento multi-tenant nei backend.],
  )

  #pagebreak()

  = Architettura di Sistema

  == Architettura di Deployment e Single Source of Truth
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

  == Design Pattern Macro-Architetturali

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

  = Sicurezza

  == Segregazione Multi-Tenant
  Il sistema NoTIP gestisce l'isolamento dei tenant su molteplici livelli infrastrutturali e applicativi, garantendo che
  l'accesso alle risorse rimanga strettamente confinato:
  - *Identity & Access (Keycloak)*: Il provider IAM inietta il claim `tenant_id` all'interno di ogni JWT emesso,
    costituendo l'unica fonte di verità per l'identità del tenant nell'intero sistema.
  - *Application Layer*: Ogni microservizio backend esegue la validazione stateless del JWT, estrae il `tenant_id` e lo
    impone come vincolo architetturale e filtro obbligatorio per qualsiasi operazione di lettura o scrittura sui
    database.
  - *Messaging Layer (NATS)*: L'isolamento a livello di broker è applicato tramite convenzioni di naming dei
    subject (es. `telemetry.data.{tenantId}.{gwId}`) combinate con liste di permessi statiche che confinano i
    gateway al proprio perimetro operativo.

  == Gestione Certificati e Zero Touch Provisioning
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

  = Metodologie di Testing

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
