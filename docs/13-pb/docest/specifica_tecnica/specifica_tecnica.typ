#import "../../00-templates/base_document.typ" as base-document

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
  - Identificare gli *idiomi implementativi* impiegati a livello di dettaglio, con riferimento alle
    ottimizzazioniapportate alla *qualità* e alla *leggibilità* del codice;
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

  = Tecnologie


  == Linguaggi di Programmazione
  #table(
    columns: (1fr, auto, 4fr),
    [Tenologia], [Versione], [Descrizione],
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
    [Tenologia], [Versione], [Descrizione],
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
    [Tenologia], [Versione], [Descrizione],
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
    [Tenologia], [Versione], [Descrizione],
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
    [Tenologia], [Versione], [Descrizione],
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
    [Tenologia], [Versione], [Descrizione],
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
    [Tenologia], [Versione], [Descrizione],
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
    [Tenologia], [Versione], [Descrizione],
    [], [], [],
    [], [], [],
  )

  == Tecnologie per Analisi Dinamica
  #table(
    columns: (1fr, auto, 4fr),
    [Tenologia], [Versione], [Descrizione],
    [], [], [],
    [], [], [],
  )

  = Architettura
  == Architettura Logica


  == Architettura di Deployment
  L'architettura del sistema è basata su un *modello a microservizi*, in cui ogni componenete funzionale viene eseguito
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
  === pattern1
  ==== Descrizione
  ==== Motivi per la Scelta
  ==== Utilizzo nel Progetto
  == Microservizi Sviluppati

  = Stato dei requisiti funzionali
]
