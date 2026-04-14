#import "../../00-templates/base_document.typ" as base-document
#import "uc_lib.typ": * /*CA, CLOUD_SYS, SA, SIM_SYS, tag-uc, uc */
#import "req_lib.typ": *

#let metadata = yaml("analisi_requisiti.meta.yaml")


#show figure.where(kind: table): set block(breakable: true)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Documento relativo all'Analisi dei Requisiti condotta dal Gruppo NoTIP per la realizzazione del progetto Sistema di Acquisizione Dati da Sensori BLE",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione
  == Scopo del documento
  Il presente documento descrive i risultati del processo di analisi dei requisiti per il progetto "Sistema di
  Acquisizione Dati da Sensori BLE" proposto da M31 S.r.l. (capitolato C7). L'analisi è stata condotta attraverso lo
  studio approfondito del capitolato, il confronto con il proponente e la discussione tra gli analisti del gruppo.

  == Scopo del prodotto
  Il sistema ha l'obiettivo di fornire un'infrastruttura cloud scalabile e sicura per la raccolta, gestione e
  distribuzione di dati provenienti da sensori Bluetooth Low Energy (BLE) distribuiti. \
  Il sistema deve garantire:
  - Acquisizione dati da sensori eterogenei tramite gateway simulati
  - Gestione multi-tenant con segregazione completa dei dati
  - Esposizione di API sicure per accesso on-demand e streaming real-time
  - Interfaccia utente per configurazione, monitoraggio e visualizzazione
  - Sicurezza end-to-end e autenticazione robusta

  == Glossario
  I termini tecnici utilizzati sono definiti nel documento #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf",
  )[Glossario v3.0.0], identificati con pedice _G_.

  == Riferimenti
  === Riferimenti normativi
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato d'appalto C7 - Sistema di
      acquisizione dati da sensori] \
    _Ultimo accesso: 2026-03-19_
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docint/norme_progetto.pdf")[Norme di Progetto v2.0.1] \
    _Ultimo accesso: 2026-03-23_

  === Riferimenti informativi
  - #link("https://ieeexplore.ieee.org/document/720574")[Standard IEEE] \ _Ultimo accesso: 2026-03-26_
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/T05.pdf")[T05 - Analisi dei Requisiti] \ _Ultimo
    accesso: 2026-03-09_
  - *Documentazione tecnologie di riferimento* \
    Di seguito i riferimenti alla documentazione ufficiale delle tecnologie impiegate:
    - Node.js: #link("https://nodejs.org/en/docs/")[Node.js Official Documentation] \ _Ultimo accesso: 2026-03-09_
    - NestJS: #link("https://docs.nestjs.com/")[NestJS Official Documentation] \ _Ultimo accesso: 2026-03-18_
    - Go: #link("https://go.dev/doc/")[Go Official Documentation] \ _Ultimo accesso: 2026-03-16_
    - Kubernetes: #link("https://kubernetes.io/docs/home/")[Kubernetes Official Documentation] \ _Ultimo accesso:
      2026-03-16_
    - MongoDB: #link("https://www.mongodb.com/docs/")[MongoDB Official Documentation] \ _Ultimo accesso: 2026-03-21_
    - PostgreSQL: #link("https://www.postgresql.org/docs/")[PostgreSQL Official Manuals] \ _Ultimo accesso: 2026-03-21_
    - NATS: #link("https://docs.nats.io/")[NATS Official Documentation] \ _Ultimo accesso: 2026-03-21_
    - Apache Kafka: #link("https://kafka.apache.org/documentation/")[Apache Kafka Official Documentation] \ _Ultimo
      accesso: 2026-03-12_

  = Descrizione del prodotto
  == Obiettivi del prodotto
  Il sistema si propone di risolvere le sfide dell'acquisizione e gestione dati in contesti IoT distribuiti, fornendo:
  1. *Scalabilità*: gestione di decine/centinaia di gateway e migliaia di sensori
  2. *Sicurezza*: isolamento multi-tenant, cifratura end-to-end, autenticazione robusta
  3. *Affidabilità*: tolleranza ai guasti, nessuna perdita di dati
  4. *Flessibilità*: supporto sensori eterogenei, API estensibili, integrazioni esterne
  5. *Usabilità*: interfaccia intuitiva per configurazione e monitoraggio

  == Architettura del sistema
  Il sistema è organizzato su tre livelli logici: Field Layer (Sensori BLE), Edge Layer (Gateway) e Cloud Layer
  (Piattaforma Centrale).\
  Nel nostro caso si andrà a simulare i primi due livelli, attraverso un simulatore di Gateway, permettendo lo sviluppo
  ed il testing della piattaforma Cloud.

  === Field layer (Sensori BLE)
  Dispositivi periferici non oggetto del progetto, utilizzati come riferimento per la simulazione. \
  Caratteristiche:
  - Sensori eterogenei (4-5 tipologie: temperatura, umidità, movimento, pressione, biometrici)
  - Comunicazione BLE tramite profili GATT standard o custom
  - Basso consumo energetico

  === Edge layer (Gateway Simulato)
  Componente da sviluppare che simula il comportamento di gateway fisici BLE-WiFi:
  - Generazione dati realistici per sensori configurati
  - Formattazione dati in formato interno standardizzato
  - Invio sicuro al cloud (HTTPS/MQTT su TLS)
  - Buffering locale in caso di disconnessione
  - Ricezione comandi dal cloud
  - Persistenza configurazione (commissioning)

  === Cloud layer (piattaforma centrale)
  Cuore del sistema, include:
  - API Gateway: autenticazione, autorizzazione, rate limiting
  - Data Ingestion Service: ricezione e validazione dati da gateway
  - Data Storage: persistenza multi-tenant (MongoDB/PostgreSQL)
  - Query API: accesso on-demand a dati storici
  - Streaming API: distribuzione real-time via WebSocket/SSE
  - Web Console: interfaccia amministrazione e visualizzazione
  - Event Management: alert configurabili e notifiche (opzionale)
  - Monitoring: Prometheus + Grafana per metriche sistema

  == Caratteristiche degli utenti
  === Amministratore di sistema (God User)
  - Competenze tecniche avanzate
  - Gestisce configurazione globale, tenant, infrastruttura
  - Pre-configura gateway
  - Accede a metriche e log completi del sistema

  === Amministratore Tenant
  - Competenze tecniche medio-alte
  - Gestisce gateway, sensori e utenti del proprio tenant
  - Configura alert e visualizza dati del tenant

  === Utente del Tenant
  - Competenze tecniche base-medie
  - Consulta dati via dashboard
  - Non richiede conoscenze infrastrutturali

  == Vincoli e assunzioni
  === Vincoli tecnologici
  - Backend: Node.js con Nest.js (TypeScript) o Go per componenti critici
  - Message Broker: NATS o Apache Kafka
  - Database: MongoDB (dati non strutturati) e PostgreSQL (dati strutturati)
  - Caching: Redis
  - Orchestrazione: Kubernetes su Google Cloud Platform
  - Frontend: Angular (SPA)
  - Version Control: Git/GitHub

  === Vincoli di sicurezza
  - Comunicazione cifrata (TLS)
  - Autenticazione: JWT, OAuth2, mTLS
  - Segregazione dati tenant (logica e fisica)
  - Certificati digitali per gateway

  === Vincoli di progetto
  - Sensori e gateway fisici non realizzati (solo simulazione)
  - PoC con infrastruttura locale (es: simulatore e comunicazione), MVP con deployment cloud
  - Test automatici (e non) con coverage minimo da concordare
  - Documentazione completa (tecnica, architetturale, utente)

  = Casi d'uso - parte A: sistema cloud
  == Attori del sistema

  #figure(
    image("assets/attori_cloud.png"),
    caption: "Attori relativi al Sistema Cloud",
  )

  #table(
    columns: (1fr, 2fr),
    [Attore], [Descrizione],
    [Amministratore Sistema],
    [(Super Admin) Personale di M31. Unico abilitato a creare nuovi Tenant e ad effettuare il provisioning fisico/logico
      dei Gateway.],

    [Amministratore Tenant],
    [Il cliente di M31. Gestisce i propri utenti, configura i sensori, imposta gli alert e visualizza i dati del proprio
      Tenant.],

    [Utente del Tenant],
    [Utente semplice del Tenant che può solo visualizzare dashboard e dati senza permessi di modifica.],

    [Utente non Autenticato], [Utente generico non ancora autenticato dal sistema.],
    [Client Esterno],
    [Software di terze parti sviluppato dal cliente che interroga le API del sistema per ottenere dati storici o stream
      real-time.],

    [Gateway non Provisionato],
    [Dispositivo hardware fisico non ancora configurato nel sistema; non è associato ad alcun Tenant e non può ancora
      trasmettere dati validi.],

    [Gateway Provisionato],
    [Dispositivo hardware correttamente configurato, associato a un Tenant specifico e abilitato alla ricezione e
      all'invio dei dati dai sensori verso la piattaforma.],
  )

  == Diagrammi e descrizioni casi d'uso

  // DON'T TOUCH - this gets injected by the build system
  #include "generated/_yaml_uc_index_cloud.typ"

  = Casi d'uso - parte B: simulatore gateway

  == Attori del sistema

  #figure(
    image("assets/attori_sim.png", width: 50%),
    caption: "Attori relativi al Simulatore Gateway",
  )

  #table(
    columns: (1fr, 2fr),
    [Attore], [Descrizione],
    [Sistema Cloud],
    [Piattaforma esterna (rispetto al simulatore) che riceve i dati inviati dal gateway simulato e trasmette comandi di
      configurazione remota.],

    [Utente del Simulatore],
    [Operatore tecnico (Sviluppatore o Tester) che configura ed esegue il software di simulazione per generare traffico
      dati, testare il carico o iniettare anomalie.],
  )

  == Diagrammi e descrizioni casi d'uso

  // DON'T TOUCH - this gets injected by the build system
  #include "generated/_yaml_uc_index_sim.typ"

  = Requisiti
  Qui di seguito verranno definiti i requisiti che sono stati individuati dal Team e raggruppati nelle seguenti
  categorie:
  - Funzionali: sono i requisiti che esprimono funzionalità che il sistema deve eseguire, a seguito della richiesta o
    dell'azione di un utente, questi sono ulteriormente divisi per la parte del Sistema e parte simulatore;

  - Qualitativi: sono i requisiti che devono essere soddisfatti per accertare la qualità del prodotto realizzato dal
    Team;

  - Vincolo: sono i requisiti tecnologici necessari per il funzionamento del prodotto;

  - Prestazione: sono i requisiti che definiscono i parametri di efficienza e reattività del sistema;

  - Sicurezza: sono i requisiti che stabiliscono le misure di protezione necessarie per garantire l'integrità, la
    riservatezza e la disponibilità dei dati del sistema;

  Per la nomenclatura usata di seguito si faccia riferimento alla sezione relativa all'interno del documento #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docint/norme_progetto.pdf",
  )[Norme di Progetto v2.0.1].


  // DON'T TOUCH - this gets injected by the build system
  #include "generated/_yaml_req_index.typ"

  = Tracciamento requisiti

  // DON'T TOUCH - this gets injected by the build system
  #include "generated/_yaml_traceability.typ"

  == Riepilogo requisiti per categoria

  // DON'T TOUCH - this gets injected by the build system
  #include "generated/_yaml_req_summary.typ"
]
