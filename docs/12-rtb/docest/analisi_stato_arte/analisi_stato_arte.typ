#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Il documento si prefigge di presentare la ricerca fatta dal gruppo riguardo l'oggetto del capitolato. In particolare verranno analizzati i concetti fondamentali, confrontate le architetture software e le soluzioni per la gestione dei dati, presentando gli approcci alla base di quelle che sono le attuali soluzioni disponibili sul mercato.",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[

  = Introduzione

  == Obiettivi del Documento

  Questo documento raccoglie i risultati della nostra ricerca preliminare (lo "Stato dell'Arte") necessaria per
  progettare il sistema richiesto dal capitolato della proponente M31. L'obiettivo è spiegare in modo chiaro quali sono
  le tecnologie oggi disponibili per raccogliere dati da sensori (come quelli Bluetooth) e portarli nel Cloud in modo
  sicuro. Inoltre, il documento serve a giustificare le scelte tecniche che faremo nello sviluppo del prototipo (Proof
  of Concept), dimostrando che non sono casuali ma basate su uno studio del mercato e delle migliori pratiche attuali.

  == Aree di Indagine

  L'analisi si sviluppa lungo tre direttrici:
  + *Piattaforme:* verrà presentata una valutazione comparativa tra soluzioni managed proprietarie e soluzioni Open
    Source, per determinare l'approccio più adeguato alle esigenze espresse dal progetto.
  + *Architettura:* confronto tra i principali paradigmi di organizzazione del software (Edge Computing, Serverless,
    Microservizi) per individuare quello maggiormente adatto a un sistema di ingestione dati in tempo reale.
  + *Sicurezza e Multi-tenancy:* studio delle strategie per garantire l'isolamento dei dati tra clienti distinti che
    condividono la stessa infrastruttura.

  = Analisi del Flusso Dati e Tecnologie

  == Modalità di Comunicazione BLE

  Per la gestione dell'interazione con i sensori, è fondamentale comprendere le due modalità operative principali
  offerte dallo standard *Bluetooth Low Energy (BLE)*, ciascuna adatta a specifici requisiti applicativi:

  - *Advertising:* Il dispositivo periferico trasmette periodicamente pacchetti di dati (payload). Questa modalità
    consente a qualsiasi ricevitore nel raggio di copertura di acquisire le informazioni senza la necessità di stabilire
    un handshake formale, ottimizzando il consumo energetico.

  - *GATT:* È l'architettura utilizzata quando è richiesta una connessione stabile e bidirezionale. Il GATT definisce
    una struttura gerarchica per l'organizzazione dei dati, suddivisi in *Servizi* (raggruppamenti logici di
    funzionalità) e *Caratteristiche* (i singoli valori e i loro metadati).

  == La Pipeline di Acquisizione Dati

  Il processo che trasforma il rilevamento fisico in informazione disponibile all'utente finale è stato modellato
  attraverso una pipeline a stadi successivi. Ogni componente della catena svolge un ruolo specifico nel trattamento e
  nel trasporto dei singoli dati:

  #figure(
    table(
      columns: (1fr, 3fr),
      align: (center, left),
      [*Componente*], [*Responsabilità Funzionale*],
      [Sensore BLE], [Campiona la grandezza fisica e la trasmette via radio utilizzando il protocollo BLE.],
      [Gateway],
      [Agisce da intermediario traducendo il protocollo locale (BLE) in protocolli di rete standard (MQTT su TCP/IP) per
        l'inoltro verso il Cloud.],

      [Message Broker],
      [Gestore dell'ingestione dati, riceve i flussi ad alta frequenza dai Gateway e ne gestisce il buffering,
        disaccoppiando la velocità di ricezione da quella di elaborazione per prevenire perdite di dati.],

      [Backend & Storage],
      [Elaborazione e persistenza, consuma i messaggi dalla coda e storicizza i dati strutturati nel database.],

      [Frontend],
      [Interroga il database tramite API e renderizza i dati grezzi in dashboard comprensibili per l'utente finale.],
    ),
    caption: [Pipeline architetturale: dal sensore alla visualizzazione],
  )

  = Scelta della Piattaforma

  Un altro aspetto che ci siamo trovati a valutare ed approfondire è stato se appoggiarci a servizi a pagamento già
  pronti o utilizzare software libero e configurarlo noi.

  == Soluzioni Cloud Managed

  Esistono piattaforme IoT complete offerte dalle più grosse aziende del Tech (Amazon AWS, Microsoft Azure, Google
  Cloud).
  - *Vantaggi:* È tutto pronto all'uso, inoltre la sicurezza e la gestione dei server sono curate dal fornitore. Questo
    permette di poter iniziare ad essere operativi molto velocemente.
  - *Svantaggi:* Si crea il *"Vendor Lock-in"*: una volta entrati nel loro ecosistema, è difficilissimo e costoso
    uscirne o cambiare fornitore. Inoltre, i costi possono salire in modo imprevedibile se il traffico dati aumenta. Non
    rappresenta quindi una soluzione adeguatamente flessibile.

  == Soluzioni Open Source

  L'ecosistema open source offre alternative consolidate che permettono di realizzare piattaforme proprietarie senza
  dipendere da servizi gestiti di terze parti. Queste però comportano un maggiore onere operativo, richiedendo
  competenze specifiche per l'installazione, la configurazione sicura e la manutenzione dell'infrastruttura.

  *Strategia di Progetto:* Considerando la natura del progetto, il nostro obiettivo è dimostrare la capacità di
  governare l'architettura a ogni livello. Pertanto abbiamo deciso di evitare scatole nere proprietarie per mantenere il
  massimo controllo sulle scelte implementative.

  = Analisi delle Architetture Software

  Un aspetto cruciale dell'analisi ha riguardato l'organizzazione logica del codice e dei componenti del sistema.
  Abbiamo valutato le tre proposte architetturali moderne maggiormente in voga per determinare quale rispondesse meglio
  ai requisiti di scalabilità, manutenibilità e sviluppo parallelo richiesti dal progetto.

  == Edge Computing

  Questo approccio prevede di decentralizzare l'elaborazione, eseguendo calcoli direttamente sul Gateway, nelle zone
  "periferiche" della rete, anziché inviare dati grezzi al Cloud.

  - *Vantaggi:* Riduzione drastica della latenza e del consumo di banda passante. Garantisce continuità operativa
    (resilienza) anche in caso di disconnessione dalla rete internet.
  - *Svantaggi:* La gestione e l'aggiornamento del software su una flotta distribuita di dispositivi eterogenei
    introduce una notevole complessità.

  == Serverless

  Il modello Serverless delega completamente la gestione dell'infrastruttura al Cloud Provider. Gli sviluppatori
  scrivono singole funzioni che vengono eseguite on-demand in risposta a specifici eventi.

  - *Vantaggi:* Elimina la necessità di provisioning e gestione dei server. Offre scalabilità automatica e un modello di
    costo basato sull'effettivo utilizzo.
  - *Svantaggi:* Soffre del problema del *"Cold Start"*: la latenza iniziale necessaria per istanziare le funzioni
    inattive può risultare inaccettabile per sistemi real-time.

  == Microservizi

  L'architettura a microservizi decompone l'applicazione monolitica in un insieme di servizi piccoli, indipendenti e
  focalizzati su specifiche funzionalità di business.

  - *Vantaggi:* Garantisce isolamento dei guasti, quindi nel caso in cui un servizio cadesse, gli altri restano attivi.
    Inoltre permette di avere flessibilità tecnologica in quanto ogni servizio può usare il linguaggio più adatto al
    contesto. Facilita notevolmente il lavoro parallelo del team.
  - *Svantaggi:* Introduce complessità nella comunicazione tra servizi e richiede strumenti di orchestrazione (es.
    containerizzazione).
  - *Decisione:* È l'approccio selezionato. Offre il miglior bilanciamento tra modularità e scalabilità, permettendo al
    team di lavorare su componenti distinti senza blocchi reciproci.

  = Analisi dei Message Broker

  Il Message Broker costituisce il componente dell'infrastruttura di ingestione dati. Il suo ruolo è garantire la
  ricezione affidabile e l'ordinamento di migliaia di messaggi al secondo provenienti dai sensori, assicurando che
  nessuna informazione vada persa prima di essere elaborata.

  == Valutazione delle Alternative

  Per individuare la soluzione più idonea, abbiamo confrontato tre tecnologie:

  1. *Apache Kafka:* Rappresenta lo standard per lo streaming di dati enterprise. Sebbene garantisca un throughput
    elevatissimo e una robustezza indiscutibile, la sua architettura è complessa da configurare e mantenere, risultando
    sovradimensionata per le esigenze del nostro PoC.

  2. *Google Cloud Pub/Sub:* È una soluzione completamente gestita offerta da Google. Offre scalabilità, ma presenta un
    limite architetturale critico per il nostro caso d'uso: non supporta nativamente il protocollo *MQTT*. Questo ci
    costringerebbe a sviluppare e mantenere degli adapter intermedi, aumentando la complessità e (presumibilmente) la
    latenza del sistema.

  3. *NATS JetStream:* È un sistema di messaging moderno, *cloud-native* e scritto in Go. Si distingue per l'estrema
    leggerezza e per le prestazioni a bassissima latenza. Punto di forza decisivo è il supporto nativo per MQTT, che
    consente ai gateway di connettersi direttamente al broker senza intermediari che possano rallenatarne la
    comunicazione.

  == La Scelta: NATS JetStream

  La scelta è ricaduta su *NATS JetStream*. Questa tecnologia offre il miglior compromesso tra prestazioni e usabilità
  nel contesto di un progetto universitario con risorse di tempo limitate riduce drasticamente la complessità
  infrastrutturale. Richiede risorse minime per l'esecuzione e si allinea tecnologicamente con il linguaggio scelto per
  il simulatore (Go), facilitando l'integrazione.

  #figure(
    table(
      columns: (1fr, 1fr, 1fr, 1fr),
      align: center,
      [*Caratteristica*], [*Kafka*], [*NATS JetStream*], [*GCP Pub/Sub*],
      [Performance], [Alto Throughput], [Bassa Latenza], [Scalabile],
      [Supporto MQTT], [No], [Sì (Nativo)], [No],
      [Complessità], [Alta], [Bassa], [Nulla (Managed)],
    ),
    caption: [Matrice decisionale per la selezione del Broker],
  )

  = Strategie di Sicurezza e Multi-tenancy

  La sfida consiste nel servire molteplici clienti (tenant) su un'infrastruttura condivisa garantendo livelli di
  isolamento comparabili a quelli di ambienti fisicamente separati. Le best practices di settore adottano un approccio
  "Zero Trust", dove nessuna entità (utente o dispositivo) è considerata affidabile per default, e la sicurezza è
  applicata a più livelli (Defense in Depth).

  == Isolamento dei Dati

  A livello enterprise, esistono diverse strategie per garantire la segregazione dei dati, ciascuna con un diverso
  trade-off tra costi e sicurezza:

  - *Database per Tenant:* Ogni cliente ha un database dedicato. Offre il massimo isolamento ma comporta costi operativi
    estremamente elevati su larga scala.
  - *Row-Level Security (RLS):* È lo standard de-facto per applicazioni scalabili. I dati risiedono in tabelle
    condivise, distinte da una colonna discriminante (`tenant_id`). A differenza dei filtri applicativi (vulnerabili a
    errori umani), la RLS delega la sicurezza al motore del database, che applica policy di accesso mandatorie a ogni
    query. Questo garantisce che nessun bug software possa accidentalmente esporre dati.

  == Protezione del Payload

  Per settori regolamentati o dati altamente sensibili, le architetture cloud moderne adottano pattern di cifratura
  *End-to-End (E2EE)*. Il principio è che il cloud provider agisca come un "trasportatore cieco", in quanto i dati
  vengono cifrati all'origine (Gateway nella nostra architettura) e decifrati solo a destinazione (Client/Dashboard). A
  livello professionale, questo si traduce spesso in modelli *BYOK (Bring Your Own Key)*, dove le chiavi crittografiche
  sono gestite esclusivamente dal cliente e mai esposte all'infrastruttura di backend.

  = Conclusioni e Scelte Finali

  Grazie a questa analisi, abbiamo evitato di scegliere tecnologie "per moda" o troppo complesse per le nostre esigenze.

  In sintesi, ecco il nostro piano di battaglia tecnologico:
  1. Costruiremo il sistema a *Microservizi* (a piccoli pezzi indipendenti) per lavorare meglio in gruppo.
  2. Useremo *NATS JetStream* per gestire il traffico dati perché è veloce e parla la lingua dei sensori.
  3. Useremo un database speciale (*TimescaleDB*) che è bravo sia a gestire i dati dei clienti (relazionale) sia lo
    storico delle misure (temporale).
  4. La sicurezza sarà garantita da *Certificati Digitali* e dalla *Cifratura* dei dati alla fonte.

  Crediamo che questa combinazione sia la più solida ed efficace per realizzare il progetto richiesto.
]
