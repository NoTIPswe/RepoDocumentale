#import "../../00-templates/base_document.typ" as base-document
#import "st_lib.typ" as st

#let metadata = yaml(sys.inputs.meta-path)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Documento contenente la specifica tecnica del progetto, con particolare attenzione alle scelte tecnologiche e di design adottate",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione
  == Scopo del Documento
  Il presente documento costituisce la Specifica Tecnica del prodotto software e ha lo scopo di fornire una descrizione
  esaustiva e strutturata della sua architettura, delle componenti che la compongono, delle relative interazioni e della
  loro distribuzione nell'ambiente di esecuzione.

  La Specifica Tecnica rappresenta il riferimento autorevole per le attività di progettazione e sviluppo del prodotto,
  assicurando la coerenza con il Proof of Concept (PoC) preliminare e introducendo raffinamenti architetturali volti ad
  accrescerne la solidità e la maturità. In particolare, il documento si prefigge i seguenti obiettivi:

  - Definire l'*architettura logica* del prodotto, illustrandone le componenti principali, i rispettivi *ruoli
    funzionali* e le *interdipendenze*;
  - Descrivere l'*architettura di deployment*, specificando le modalità di *distribuzione* e *orchestrazione* delle
    componenti nell'ambiente di esecuzione;
  - Documentare i *design pattern architetturali* adottati, motivando le scelte progettuali in relazione alle tecnologie
    selezionate e ai requisiti del sistema
  - Identificare gli *idiomi implementativi* impiegati a livello di dettaglio, con riferimento alle ottimizzazioni
    apportate alla *qualità* e alla *leggibilità* del codice;
  - Fornire approfondimenti progettuali a supporto della comprensione, della *manutenibilità* e dell'*evoluzione futura*
    del prodotto.

  == Glossario
  Per tutte le definizioni, acronimi e abbreviazioni utilizzati in questo documento, si faccia riferimento al #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf",
  )[Glossario v2.0.0], fornito come documento separato, che contiene tutte le spiegazioni necessarie per garantire una
  comprensione uniforme dei termini tecnici e dei concetti rilevanti per il progetto. Le parole che possiedono un
  riferimento nel Glossario saranno indicate nel modo che segue:
  #align(center)[#emph([parola#sub[G]])]
  == Riferimenti
  === Riferimenti Normativi
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato d'appalto C7 - Sistema di
      acquisizione dati da sensori]\ _Ultimo accesso: 2026-03-09_
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/norme_di_progetto.pdf")[Norme di Progetto
      v1.1.0]
  === Riferimenti Informativi
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf")[Glossario v2.0.0]
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/PD1.pdf")[PD1 - Regolamento del Progetto Didattico]\
    _Ultimo Accesso: 2026-03-09_
  - #link("https://c4model.com/")[C4 Model]\ _Ultimo Accesso: 2026-03-11_
  - #link("https://go.dev/doc/")[Documentazione Go] \ _Ultimo Accesso: 2026-03-11_
  - #link("https://www.typescriptlang.org/docs/")[Documentazione Typescript] \ _Ultimo Accesso: 2026-03-11_
  - #link("https://docs.nestjs.com/")[Documentazione NestJS] \ _Ultimo Accesso: 2026-03-11_
  - #link("https://angular.dev/overview")[Documentazione Angular] \ _Ultimo Accesso: 2026-03-11_
  - #link("https://docs.nats.io/")[Documentazione NATS] \ _Ultimo Accesso: 2026-03-11_
  - #link("https://docs.docker.com/")[Documentazione Docker] \ _Ultimo Accesso: 2026-03-11_
  - #link("https://grafana.com/docs/")[Documentazione Grafana] \ _Ultimo Accesso: 2026-03-11_
  - #link("https://prometheus.io/docs/introduction/overview/")[Documentazione Prometheus] \ _Ultimo Accesso: 2026-03-11_
  - #link("https://docs.timescale.com/")[Documentazione TimescaleDB] \ _Ultimo Accesso: 2026-03-11_

  #pagebreak()

  = Tecnologie

  == Linguaggi di Programmazione
  #table(
    columns: (1fr, auto, 4fr),
    [Tecnologia], [Versione], [Descrizione],
    [Go],
    [],
    [Go è un linguaggio compilato e staticamente tipizzato che combina semplicità sintattica e prestazioni di alto
      livello in contesti distribuiti. La sua gestione nativa della concorrenza, basata su goroutine e channel, consente
      di eseguire numerosi processi simultanei con un consumo minimo di risorse. Nel progetto viene impiegato per il
      Data Consumer, responsabile della sottoscrizione ai flussi telemetrici JetStream e della scrittura su TimescaleDB,
      e per il Simulator Backend, in cui ogni gateway simulato è gestito da una goroutine indipendente che emula in
      parallelo il comportamento dei sensori BLE.],

    [Typescript],
    [],
    [TypeScript è un linguaggio di programmazione a tipizzazione statica che estende JavaScript introducendo un sistema
      di tipi opzionale e strumenti di analisi del codice a tempo di compilazione. Favorisce la manutenibilità e la
      robustezza del codice in progetti di medio-grande scala. Nel progetto costituisce il linguaggio principale per
      tutti i microservizi backend sviluppati con NestJS — Management API, Data API, Command API e Provisioning Service
      — e per la Web Application Angular, incluso il Web Worker dedicato alla decifratura AES-256-GCM lato client
      tramite WebCrypto API.],
  )

  == Framework per la Codifica
  #table(
    columns: (1fr, auto, 4fr),
    [Tecnologia], [Versione], [Descrizione],
    [NestJS],
    [],
    [NestJS è un framework Node.js per la costruzione di applicazioni server-side modulari e scalabili, ispirato
      all'architettura di Angular e basato su decoratori TypeScript. Fornisce un sistema di dependency injection, guard,
      interceptor e moduli che strutturano il codice in modo coerente e testabile. Nel progetto è adottato per tutti e
      quattro i microservizi backend: la Management API per la gestione di tenant, gateway e chiavi crittografiche; la
      Data API per l'esposizione dei dati telemetrici via REST e SSE; la Command API per l'emissione di comandi ai
      gateway; il Provisioning Service per la firma dei certificati mTLS e la generazione delle chiavi AES.],

    [Angular],
    [],
    [Angular è un framework frontend sviluppato da Google per la realizzazione di Single Page Application
      enterprise-grade. Adotta un'architettura basata su componenti, moduli e servizi, con supporto nativo per la
      programmazione reattiva tramite RxJS. Nel progetto viene utilizzato per la Web Application principale, che integra
      keycloak-angular per la gestione del ciclo OIDC/PKCE e un Web Worker dedicato alla decifratura client-side dei
      payload telemetrici. Angular è impiegato anche per la Simulation Dashboard, l'interfaccia di controllo del
      Simulator Backend.],

    [TypeORM],
    [],
    [TypeORM è un Object-Relational Mapper per TypeScript e Node.js che consente di definire le entità del dominio come
      classi tipizzate e di gestire le migrazioni del database in modo incrementale e versionato. Nel progetto è
      integrato nei microservizi NestJS per l'accesso al Management DB (PostgreSQL) e al Measures DB (TimescaleDB),
      garantendo coerenza tra il modello applicativo e lo schema relazionale sottostante.],
  )

  == Tecnologie per la Gestione di Dati Temporali
  #table(
    columns: (1fr, auto, 4fr),
    [Tecnologia], [Versione], [Descrizione],
    [PostgreSQL],
    [],
    [PostgreSQL è un sistema di gestione di database relazionale open-source, noto per la sua conformità agli standard
      SQL, l'estensibilità e l'affidabilità in ambienti di produzione. Nel progetto ospita il Management DB, che
      contiene le tabelle di dominio principali: tenant, gateway, chiavi di cifratura, comandi, configurazioni di alert
      e audit log. Viene anche utilizzato come base per l'estensione TimescaleDB nel Measures DB.],

    [TimescaleDB],
    [],
    [TimescaleDB è un'estensione di PostgreSQL ottimizzata per la gestione di serie temporali, che introduce il concetto
      di ipertabella con partizionamento automatico per intervalli temporali (chunk). Nel progetto gestisce la tabella
      telemetry_data del Measures DB, su cui convergono tutti i messaggi telemetrici cifrati pubblicati dai gateway. La
      tabella è configurata con un chunk interval giornaliero e compressione automatica dei dati dopo 7 giorni,
      ottimizzando le query per intervalli temporali e riducendo l'occupazione su disco nel lungo periodo.],
  )

  == Tecnologie per la Comunicazione e Messaggistica
  #table(
    columns: (1fr, auto, 4fr),
    [Tecnologia], [Versione], [Descrizione],
    [NATS Jetstream],
    [],
    [NATS JetStream è un sistema di messaggistica ad alte prestazioni con supporto nativo alla persistenza dei messaggi,
      alla consegna garantita e al modello publish-subscribe. JetStream estende il core NATS aggiungendo stream
      durevoli, consumer con politiche di acknowledgement esplicito e retention configurabile. Nel progetto rappresenta
      il motore unico di comunicazione tra tutti i microservizi: gestisce l'ingestione della telemetria IoT via mTLS
      sulla porta 4222, il pattern Request-Reply sincrono per la comunicazione interna tra servizi, la distribuzione
      degli alert infrastrutturali e i comandi verso i gateway, eliminando completamente qualsiasi canale HTTP
      service-to-service.],

    [Server-Sent Events],
    [],
    [Server-Sent Events (SSE) è un protocollo HTTP unidirezionale che permette al server di inviare eventi in streaming
      al client senza che quest'ultimo debba effettuare polling ripetuto. Nel progetto è il meccanismo adottato dal Data
      API per la distribuzione real-time dei payload telemetrici crittografati verso il frontend Angular. Poiché il
      nativo EventSource del browser non supporta header custom, la comunicazione SSE è gestita tramite la libreria
      \@microsoft/fetch-event-source, che consente l'invio del Bearer token JWT a ogni connessione o riconnessione.],
  )

  == Tecnologie per Virtualizzazione e Deployment
  #table(
    columns: (1fr, auto, 4fr),
    [Tecnologia], [Versione], [Descrizione],
    [Docker],
    [],
    [Docker è una piattaforma di containerizzazione che consente di impacchettare applicazioni e relative dipendenze in
      unità isolate e portabili, eseguibili in modo coerente su qualsiasi ambiente. Nel progetto ogni microservizio,
      database e componente infrastrutturale è distribuito come container Docker indipendente, garantendo isolamento a
      livello di processo e riproducibilità dell'ambiente tra sviluppo e produzione.],

    [Docker Compose],
    [],
    [Docker Compose è uno strumento per la definizione e l'orchestrazione di applicazioni multi-container tramite file
      di configurazione dichiarativi. Nel progetto coordina l'avvio, la rete interna e il ciclo di vita di tutti i
      container della piattaforma NoTIP. Gestisce i volumi named — tra cui notip_ca_certs, che persiste la CA interna
      del Provisioning Service — e i Docker secrets utilizzati per l'iniezione sicura delle credenziali a runtime, senza
      che queste compaiano nel codice sorgente o nelle immagini.],

    [Nginx],
    [],
    [Nginx è un web server e reverse proxy ad alte prestazioni, largamente adottato per la gestione del traffico
      HTTP/HTTPS in architetture a microservizi. Nel progetto funge da unico punto di ingresso esterno per il traffico
      HTTP, esponendo le porte 80 e 443. Applica gli header di sicurezza obbligatori (CSP, HSTS, X-Frame-Options),
      gestisce il passthrough degli stream SSE con le opportune configurazioni di buffering e applica rate limiting
      sull'endpoint di provisioning per mitigare tentativi di brute-force sulle factory key.],
  )

  == Tecnologie per Monitoraggio dei Microservizi
  #table(
    columns: (1fr, auto, 4fr),
    [Tecnologia], [Versione], [Descrizione],
    [Prometheus],
    [],
    [Prometheus è un sistema open-source di monitoraggio e alerting progettato per ambienti cloud-native e architetture
      a microservizi. Adotta un modello di raccolta dati basato su scraping periodico degli endpoint /metrics esposti
      dai servizi, archiviando le misurazioni come serie temporali identificate da metriche e label. Nel progetto viene
      impiegato per la raccolta delle metriche operative dei microservizi NestJS e dei componenti infrastrutturali,
      consentendo di monitorare in modo continuo indicatori quali latenza delle richieste, throughput dei messaggi NATS
      e stato dei container.],

    [Grafana],
    [],
    [Grafana è una piattaforma open-source per la visualizzazione e l'esplorazione di dati provenienti da sorgenti
      eterogenee, tra cui Prometheus, database relazionali e sistemi di log. Permette di costruire dashboard interattive
      con grafici, soglie di allerta e pannelli configurabili. Nel progetto è integrata come frontend di osservabilità
      per le metriche raccolte da Prometheus, offrendo una visione centralizzata dello stato della piattaforma NoTIP:
      throughput della telemetria, latenza dei microservizi, stato dei gateway e anomalie nei flussi di messaggistica
      NATS.],
  )

  == Librerie
  #table(
    columns: (1fr, auto, 4fr),
    [Tecnologia], [Versione], [Descrizione],
    [keycloak-angular],
    [],
    [keycloak-angular è una libreria Angular che integra il client JavaScript ufficiale di Keycloak, semplificando la
      gestione del ciclo di vita OIDC all'interno di un'applicazione Angular. Nel progetto gestisce il flusso
      Authorization Code con PKCE, il silent refresh tramite refresh token rotation — in sostituzione dell'approccio
      deprecato basato su iframe — e l'aggiunta automatica del Bearer token alle chiamate HTTP tramite un interceptor. I
      token non vengono mai scritti in localStorage o sessionStorage: l'access token è mantenuto in memoria e il refresh
      token è gestito tramite cookie HttpOnly di Keycloak.],

    [\@nestjs/passport + passport-jwt],
    [],
    [\@nestjs/passport e passport-jwt sono librerie per l'implementazione di strategie di autenticazione nei
      microservizi NestJS. Nel progetto abilitano la validazione JWT in modalità completamente stateless: ogni richiesta
      viene autenticata verificando la firma del token contro l'endpoint JWKS di Keycloak, senza alcuna chiamata a
      runtime al server di identità. La JWKS è cachata all'avvio e aggiornata ogni 24 ore, o immediatamente in caso di
      kid sconosciuto.],

    [jwks-rsa],
    [],
    [jwks-rsa è una libreria Node.js per il recupero e il caching delle chiavi pubbliche da un endpoint JWKS. Nel
      progetto è integrata con passport-jwt per garantire che la rotazione delle chiavi di firma di Keycloak non
      interrompa la validazione dei JWT nei microservizi NestJS, gestendo in modo trasparente l'aggiornamento del
      keystore locale.],

    [\@microsoft/fetch-event-source],
    [],
    [\@microsoft/fetch-event-source è una libreria che sostituisce il nativo EventSource del browser con
      un'implementazione basata su fetch, aggiungendo il supporto per header HTTP custom — tra cui Authorization: Bearer
      — necessari per l'autenticazione delle connessioni SSE. Nel progetto è il meccanismo client-side attraverso cui il
      frontend Angular apre e gestisce lo stream real-time verso il Data API, con supporto alla riconnessione automatica
      e al parametro since per il catch-up degli eventi persi.],

    [WebCrypto API],
    [],
    [WebCrypto API è un'API nativa del browser per operazioni crittografiche sicure, eseguita in un contesto isolato
      rispetto al thread principale. Nel progetto è utilizzata all'interno di un Web Worker Angular dedicato per la
      decifratura AES-256-GCM dei payload telemetrici ricevuti via SSE. Le chiavi vengono importate con extractable:
      false, impedendo l'estrazione dei byte raw dopo l'import. L'oggetto CryptoKey risiede esclusivamente nel contesto
      del Worker e viene distrutto alla chiusura del tab, senza mai transitare su disco o storage persistente.],

    [PapaParse],
    [],
    [PapaParse è una libreria JavaScript per il parsing e la serializzazione di file CSV, con supporto per dataset di
      grandi dimensioni tramite elaborazione in streaming. Nel progetto è impiegata nel flusso di export client-side:
      una volta che il Web Worker ha decifrato in batch i payload telemetrici richiesti, PapaParse li serializza in
      formato CSV e il frontend forza il download direttamente nel browser, senza che i dati in chiaro transitino mai
      verso il server.],
  )

  == Tecnologie per Analisi Statica
  #table(
    columns: (1fr, auto, 4fr),
    [Tecnologia], [Versione], [Descrizione],

    [golangci-lint],
    [],
    [Aggrega vari linter per Go che integra oltre cinquanta analizzatori statici in un'unica esecuzione parallelizzata.
      Nel progetto è configurato per i servizi Go (Data Consumer, Simulator Backend) con controlli su errori non
      gestiti, shadow di variabili, complessità ciclomatica e conformità alle convenzioni idiomatiche del linguaggio.
      Integrato nella pipeline CI come gate bloccante: il merge è impedito in presenza di violazioni non risolte.],

    [ESLint],
    [],
    [Strumento di analisi statica per TypeScript e JavaScript che applica regole di stile, individua anti-pattern e
      verifica la conformità alle best practice dei framework adottati. Nel progetto è configurato per tutti i
      microservizi NestJS e le applicazioni Angular, con regole specifiche per la gestione delle promise, l'uso corretto
      dei decoratori e le convenzioni di denominazione del team.],

    [SonarCloud],
    [],
    [Piattaforma di analisi continua della qualità del codice che identifica bug, vulnerabilità di sicurezza, code smell
      e duplicazioni. Nel progetto è integrata nella pipeline GitHub Actions e analizza l'intero codebase a ogni pull
      request. Le quality gate bloccano il merge di modifiche che non soddisfano le soglie configurate per copertura,
      tasso di duplicazione e affidabilità complessiva.],
  )

  == Tecnologie per Analisi Dinamica
  #table(
    columns: (1fr, auto, 4fr),
    [Tecnologia], [Versione], [Descrizione],

    [Go test + Race Detector],
    [],
    [Framework di testing nativo di Go, utilizzato con il flag `-race` per il rilevamento di data race a runtime tramite
      strumentazione del compilatore. Nel progetto viene impiegato per i test unitari e di integrazione dei servizi Go,
      garantendo la correttezza della concorrenza nelle goroutine del Data Consumer e del Simulator Backend. Il race
      detector è abilitato in tutte le esecuzioni CI.],

    [Testcontainers-go],
    [],
    [Libreria per l'avvio programmatico di container Docker effimeri durante i test di integrazione. Nel progetto viene
      utilizzata per simulare la creazione di ambienti NATS con mTLS e database TimescaleDB reali, consentendo di
      verificare il comportamento end-to-end dei servizi Go contro infrastruttura autentica, senza ricorrere a mock
      infrastrutturali.],

    [Jest],
    [],
    [Framework di testing per TypeScript e JavaScript con supporto nativo per mock, snapshot testing e code coverage.
      Nel progetto esegue test unitari e di integrazione per i microservizi NestJS (Management API, Data API, Command
      API, Provisioning Service) e per le applicazioni Angular, inclusi i test dei componenti e dei servizi reattivi.],
  )

  #pagebreak()

  = Architettura
  == Architettura Logica

  === notip-data-consumer
  Il `notip-data-consumer` adotta l'architettura esagonale (Ports & Adapters) come principio organizzativo primario. La
  logica di dominio, interamente contenuta nel servizio `HeartbeatTracker`, è isolata da ogni dipendenza
  infrastrutturale tramite interfacce (_port_) che definiscono i confini del sistema.

  ==== Strati architetturali
  Il servizio è decomposto in tre livelli con dipendenze unidirezionali verso l'interno:

  - *Dominio* (`internal/domain`, `internal/service`): contiene gli "oggetti" puri (`TelemetryEnvelope`, `TelemetryRow`,
    `AlertPayload`, `GatewayStatusUpdate`, `OpaqueBlob`), le definizioni dei port e il servizio `HeartbeatTracker`.
    Questo parte volontariamente non importa alcun package di infrastruttura e non ha dipendenze verso l'esterno. In
    particolare, conosce solo la definizione delle interfacce che esso stesso definisce.

  - *Driving adapter* (`internal/adapter/driving`): traducono eventi esterni in chiamate ai driving port del dominio.
    Tre adapter coprono le tre sorgenti di eventi: messaggi telemetrici da JetStream, eventi di decommission da
    JetStream e tick periodici da un timer interno.

  - *Driven adapter* (`internal/adapter/driven`): implementano i driven port per raggiungere risorse esterne. Cinque
    adapter coprono: persistenza su TimescaleDB, pubblicazione alert su JetStream, notifica di stato al Management API
    via NATS Request-Reply, cache delle configurazioni di alert e astrazione del clock di sistema.

  ==== Flusso dei dati
  Il dati attraversano il servizio in modo lineare e unidirezionale:

  + Un driving adapter riceve il messaggio NATS, estrae il `tenantID` dal subject e deserializza l'envelope.
  + Il driving adapter invoca il driving port `TelemetryMessageHandler`, che registra l'heartbeat del gateway e gestisce
    eventuali transizioni di stato (prima comparsa o recupero da offline).
  + Lo stesso driving adapter accumula il record normalizzato in un buffer e, al raggiungimento della soglia o alla
    scadenza del timer di flush, invoca il driven port `TelemetryWriter` per la persistenza batch.
  + I tre campi crittografici (`EncryptedData`, `IV`, `AuthTag`) attraversano tutti gli strati come `OpaqueBlob` senza
    mai essere ispezionati, nel completo rispetto della pipeline opaca.

  In parallelo, il timer di heartbeat invoca periodicamente `HeartbeatTicker.Tick`, che valuta se effettivamente di ogni
  gateway è "vivo" confrontando `lastSeen` con il timeout consentito, ottenuto da `AlertConfigProvider`. Le transizioni
  a offline generano la pubblicazione di un alert tramite `AlertPublisher` e una notifica asincrona tramite
  `GatewayStatusUpdater`.

  ==== Confini del microservizio
  Il `notip-data-consumer` interagisce con quattro sistemi esterni, ciascuno mediato da un driven port dedicato:
  - *TimescaleDB* tramite `TelemetryWriter`: persistenza dei blob di dati opachi;
  - *NATS JetStream* tramite `AlertPublisher`: pubblicazione degli alert gateway-offline;
  - *Management API* tramite `GatewayStatusUpdater` e `AlertConfigProvider`: notifica delle transizioni di stato e
    recupero delle configurazioni di timeout;
  - *Clock di sistema* tramite `ClockProvider`: astrazione del tempo per rendere i test deterministici.

  Il servizio non espone API REST né comunica direttamente con altri microservizi: le uniche interfacce HTTP sono
  l'endpoint Prometheus `/metrics` per l'osservabilità e `/healthz` per la verifica della raggiungibilità del database.
  Tutto il traffico in ingresso e in uscita transita attraverso NATS.

  == Architettura di Deployment
  L'architettura del sistema è basata su un *modello a microservizi*, in cui ogni componente funzionale viene eseguito
  come un'unità indipendente e isolata all'interno di un container Docker, garantendo portabilità tra gli ambienti di
  esecuzione e semplificando le procedure di *manutenzione* e *aggiornamento*. L'orchestrazione dell'intero sistema è
  affidata a Docker Compose, che coordina il ciclo di vita di tutti i container, gestisce la rete interna tra i servizi
  e provvede all'iniezione sicura delle credenziali tramite Docker secrets.

  Il Cloud Layer è strutturato per ospitare i seguenti microservizi:
  - *Management API*: il servizio centrale per la gestione dei tenant, dei gateway, degli utenti e delle chiavi
    crittografiche. Espone le API REST consumate dalla Web Application e si interfaccia con Keycloak per le operazioni
    di amministrazione dell'identità.
  - *Data API*: il modulo responsabile dell'esposizione dei dati telemetrici verso i client autorizzati, tramite query
    storiche su TimescaleDB e streaming real-time mediante Server-Sent Events.
  - *Command API*: il servizio dedicato all'emissione di comandi verso i gateway IoT, con verifica dell'ownership del
    gateway e gestione dell'acknowledgement tramite NATS JetStream.
  - *Provisioning Service*: il componente che opera come Certification Authority interna, firma le richieste di
    certificato dei gateway e genera le chiavi AES-256 consegnate al momento del provisioning. La CA è persistita su un
    volume Docker named dedicato (notip_ca_certs), condiviso con il broker NATS per la verifica mTLS.
  - *Data Consumer*: il modulo sviluppato in Go responsabile della sottoscrizione ai flussi telemetrici su NATS
    JetStream, della scrittura dei payload crittografati su TimescaleDB e del monitoraggio della liveness dei gateway
    tramite un meccanismo di heartbeat.
  - *Simulator Backend*: il servizio in Go che emula il comportamento dei gateway IoT fisici, in cui ogni gateway
    simulato è gestito da una goroutine indipendente che pubblica telemetria cifrata verso NATS. È accompagnato da una
    Simulation Dashboard Angular per il controllo della simulazione.
  - *Web Application*: il frontend Angular che rappresenta il punto di decifratura dell'intera pipeline. Tramite un Web
    Worker dedicato e la WebCrypto API, decifra i payload AES-256-GCM ricevuti via SSE direttamente nel browser
    dell'utente, senza che i dati in chiaro transitino mai verso il backend.

  Nginx funge da unico punto di ingresso esterno per il traffico HTTP/HTTPS, operando come reverse proxy verso i
  microservizi interni e applicando gli header di sicurezza obbligatori. La porta 4222 è esposta esclusivamente per le
  connessioni mTLS dei gateway IoT verso il broker NATS.

  Tutta la comunicazione interna tra microservizi è mediata da NATS JetStream, che sostituisce completamente qualsiasi
  canale HTTP service-to-service. I servizi comunicano in modo sincrono tramite il pattern Request-Reply e in modo
  asincrono tramite stream JetStream con persistenza configurabile, garantendo disaccoppiamento e resilienza ai riavvii
  temporanei dei singoli componenti.

  La gestione dell'identità è centralizzata in Keycloak, deployato in modalità self-hosted, che emette JWT contenenti il
  claim `tenant_id` iniettato tramite Protocol Mapper. Questo claim è il fondamento dell'isolamento multi-tenant: ogni
  microservizio lo estrae e lo applica come filtro implicito su ogni operazione, garantendo che ciascun tenant acceda
  esclusivamente alle proprie risorse, a ogni livello dello stack — dall'API al database fino ai subject NATS.

  == Design Pattern
  I design pattern architetturali adottati nel progetto sono stati selezionati in base alla loro capacità di soddisfare
  i requisiti funzionali e non funzionali del sistema, nonché di facilitare la manutenibilità, la scalabilità e
  l'evoluzione futura del prodotto.

  Di seguito vengono descritti i principali pattern utilizzati, con una spiegazione dettagliata delle motivazioni alla
  base della loro scelta e del loro impiego all'interno dell'architettura complessiva del sistema.
  #st.design-pattern(
    name: "Architettura Esagonale",
    problem: [
      Alcuni servizi della piattaforma NoTIP interagiscono con molteplici tecnologie infrastrutturali (NATS JetStream,
      TimescaleDB, NATS Request-Reply, Prometheus) che evolvono indipendentemente dalla logica applicativa. Un
      accoppiamento diretto tra dominio e infrastruttura renderebbe i test unitari troppo dipendenti da componenti
      esterni e l'eventuale sostituzione di una tecnologia si tramuterebbe in un intervento estremamente invasivo.
    ],
    decision: [
      Ogni servizio Go adotta l'architettura esagonale, in cui il dominio dipende esclusivamente da interfacce (_port_)
      e non da implementazioni concrete. Le _driving port_ sono interfacce implementate dal dominio e invocate dagli
      adapter per immettere eventi nel sistema. I _driven port_ sono interfacce invocate dal dominio e implementate
      dagli adapter per raggiungere risorse esterne. Nessun tipo concreto interno all'infrastruttura fuoriesce dal
      confine del dominio.
    ],
    alternatives: [
      *Architettura layered tradizionale:* più semplice da implementare, ma crea dipendenze discendenti rigide tra i
      livelli. Un cambio di tecnologia di persistenza si propaga verso l'alto, violando il principio di inversione delle
      dipendenze.
    ],
    consequences: [
      - *Testabilità:* ogni driven port può essere sostituito da un mock, rendendo i test unitari deterministici e
        indipendenti dall'infrastruttura.
      - *Sostituibilità:* un adapter può essere sostituito senza modificare il dominio, quindi è resa estremamente più
        semplice la possibilità di migrare da TimescaleDB a un altro servizio di storage, richiedendo solamente un nuovo
        adapter che implementi `TelemetryWriter`.
      - *Trade-off:* il numero di interfacce e adapter è particolarmente elevato e proporzionale alle dipendenze
        esterne.
    ],
  )

  #st.design-pattern(
    name: "Pipeline Opaca (Zero-Knowledge Server-Side)",
    problem: [
      I payload contengono misurazioni che il committente ha classificato come dati sensibili. La piattaforma deve, di
      conseguenza, garantire che, anche in caso di compromissione di un servizio backend o del database, i dati restino
      inaccessibili.
    ],
    decision: [
      I payload sono cifrati con AES-256-GCM dal gateway al momento dell'acquisizione (nel nostro caso simulata). I tre
      campi crittografici (`EncryptedData`, `IV`, `AuthTag`) attraversano l'intero backend come blob opachi in base64,
      senza mai essere decifrati, ispezionati o trasformati. La decifratura avviene esclusivamente nel browser
      dell'utente tramite la WebCrypto API. Un tipo di dominio nominale (`OpaqueBlob`) rende questa invariante visibile
      nel type system: qualsiasi tentativo di decodifica è un'evidente violazione di tipo.
    ],
    alternatives: [
      - *End-to-End Encryption (E2EE):* Questa era l'impostazione iniziale. Sebbene garantisca il massimo livello di
        cifratura, come inizialmente richiesto dall'azienda proponente, è stato scartato a seguito di discussioni
        approfondite con la stessa a causa della sua complessità troppo elevata rispetto alle tempistiche disponibili.
      - *Cifratura del solo canale (TLS):* Protegge i dati esclusivamente durante il transito tra gateway e backend. È
        stata ritenuta insufficiente in quanto i dati risulterebbero in chiaro sia nella memoria volatile dei
        microservizi (RAM) sia sul database, rendendo ogni componente del sistema un Single Point of Failure per la
        riservatezza delle informazioni sensibili.
    ],
    consequences: [
      - *Sicurezza:* la superficie di attacco server-side è ridotta.
      - *Limitazione architetturale:* l'elaborazione server-side è possibile sui dati telemetrici, in quanto le chiavi
        vengono salvate sul DB. Comunque l'applicazione non sfrutta questa decisione presa in fase di progettazione per
        l'MVP, ad esempio, per gli alert di soglia, i quali possono essere valutati solo nel client.
      - *Responsabilità del client:* la correttezza della decifratura e la gestione sicura delle chiavi nel browser
        diventano critiche. Le chiavi sono importate con `extractable: false` e risiedono esclusivamente nel contesto
        del Web Worker.
    ],
  )

  #st.design-pattern(
    name: "Dependency Injection tramite Costruttore",
    problem: [
      L'architettura esagonale introduce numerose interfacce (port) che separano dominio e infrastruttura. Cercare di
      stabilire _chi_ crea le implementazioni concrete e _come_ vengono collegate ai componenti che le richiedono, senza
      vanificare il disaccoppiamento ottenuto dai port.
    ],
    decision: [
      Ogni componente riceve le proprie dipendenze come parametri del costruttore. Un unico _Composition Root_
      (`cmd/consumer/main.go`) istanzia l'intero grafo delle dipendenze all'avvio, rendendo il cablaggio esplicito e
      leggibile in un solo punto.
    ],
    consequences: [
      - *Verificabilità statica:* il compilatore rileva dipendenze mancanti o incompatibili prima dell'esecuzione.
      - *Testabilità diretta:* sostituire un adapter con un mock o uno stub richiede solo il passaggio al costruttore.
      - *Trade-off:* il codice di inizializzazione nel Composition Root cresce linearmente con il numero di componenti.
    ],
  )

  #st.design-pattern(
    name: "Dispatch Asincrono Non-bloccante",
    problem: [
      Il Data Consumer esegue operazioni di I/O secondarie (come la notifica di stato online/offline al Management API
      via NATS Request-Reply) il cui tempo di risposta è variabile e non predicibile. Se eseguite in modo sincrono
      all'interno del ciclo di heartbeat o del handler telemetrico, una singola chiamata lenta bloccherebbe
      l'elaborazione di tutti i messaggi in coda, degradando il throughput complessivo.
    ],
    decision: [
      Le operazioni di I/O secondarie sono accodate in un canale con capacità limitata e processate serialmente da un
      goroutine worker dedicato in background. Il path dove la velocità è un fattore critico non attende mai il
      completamento di queste operazioni. Se il canale è pieno, l'aggiornamento viene scartato e una metrica Prometheus
      dedicata viene incrementata, rendendo la perdita osservabile.
    ],
    alternatives: [
      - *Dispatch sincrono:* garantisce la consegna ma accoppia la latenza del path critico a quella delle operazioni
        secondarie, creando un collo di bottiglia sotto carico.
      - *Goroutine per ogni operazione:* disaccoppia la latenza ma crea un numero illimitato di goroutine sotto carico,
        con rischio di esaurimento delle risorse e impossibilità di applicare backpressure.
      - *Worker pool con coda illimitata:* bilancia il parallelismo ma una coda illimitata può consumare memoria
        indefinitamente durante picchi prolungati.
    ],
    consequences: [
      - *Throughput costante:* il path critico non è mai bloccato da operazioni secondarie.
      - *Perdita controllata:* sotto carico estremo, gli aggiornamenti di stato vengono scartati in modo deterministico
        e osservabile, anziché causare degradazione imprevedibile.
      - *Trade-off:* la semantica è _at-most-once_ per gli aggiornamenti di stato: un aggiornamento scartato non viene
        ritentato. Questo è accettabile solamente perché il successivo ciclo di heartbeat genererà un nuovo
        aggiornamento se la condizione persiste.
    ],
  )
  == Microservizi Sviluppati
  Questa sezione documenta la progettazione architetturale di ciascun microservizio sviluppato internamente dal team,
  con focus sulle decisioni progettuali, la decomposizione in livelli e la definizione dei confini tramite port.

  #include "services/data-consumer.typ"

  // insert all the other services

  #pagebreak()

  = Stato dei requisiti funzionali
]
