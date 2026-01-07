#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Questo documento contiene un'analisi effettuata da parte del gruppo rispetto ai vari capitolati di progetto proposti dalle aziende nel corso del corso di Ingegneria del Software",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  #heading(level: 1, numbering: none)[Introduzione]
  La stesura del presente documento ha lo scopo di illustrare le motivazioni che hanno guidato il gruppo _NoTIP_ nella
  scelta del capitolato per cui ha presentato la candidatura. \
  Il capitolato selezionato è *“Sistema di acquisizione dati da sensori”*ª della proponente _M31_, la cui analisi e
  motivazione saranno approfondite nella sezione specificamente dedicata. \
  Nelle pagine seguenti verranno inoltre riportate brevi sintesi delle valutazioni, prodotte durante le varie riunioni
  ed incontri, corrispondenti ad una sintesi delle opinioni espresse da ciascun membro del gruppo, evidenziando i
  principali pro e contro per ogni capitolato esaminato.

  #pagebreak()

  = Capitolato C1
  Il *Capitolato C1*: *Automated EN18031 Compliance Verification, proposto* da _Bluewind_, pone come obiettivo lo
  sviluppo di un sistema che automatizzi la verifica della conformità allo standard tecnico EN 18031. \
  == Pro
  Il gruppo ha trovato il capitolato interessante, in quanto la norma sopra citata è estremamente attuale, essendo stata
  solo recentemente introdotta oltre che per la rilevanza che essa ha ed avrà nel settore industriale dei prossimi anni.
  L’idea di automatizzare il processo di verifica che, per ogni lavoro, risulta rinomatamente lungo e pieno di insidie,
  è stata inoltre considerata un punto particolarmente interessante, soprattutto per la concretezza di tale progetto. \
  == Contro
  Nonostante ciò, il gruppo ha individuato alcune criticità significative. In particolare, il progetto richiede una
  profonda analisi e conoscenza tecnica della norma in esame (EN18031). Questa attività verterà, con tutta probabilità,
  sulla compliance normativa, lasciando poco spazio alla creatività o a scelte progettuali autonome. \
  == Considerazioni
  Un’ulteriore difficoltà è rappresentata dal fatto che gran parte dello sviluppo si basa su aspetti di analisi e
  verifica documentale, piuttosto che su componenti software dinamiche o architetturali, ambiti di maggiore interesse
  per il gruppo. \
  In conclusione, pur riconoscendo la validità e la rilevanza pratica del capitolato, _NoTIP_ ha deciso di non
  proseguire con la candidatura per questo progetto, preferendo orientarsi verso una proposta con un ambito più vicino
  alle proprie aree di interesse.

  #pagebreak()

  = Capitolato C2
  Il *Capitolato C2*: *“Code Guardian: Piattaforma ad agenti per l’audit e la remediation dei repository software”*,
  proposto da _Var Group_, richiedere la realizzazione di una piattaforma web in grado di analizzare repository software
  per fornire un responso sulla qualità, la sicurezza e la manutenibilità del codice, fornendo suggerimenti
  all’utilizzatore per il miglioramento della stessa. \
  == Pro
  Questo capitolato ha generato particolare interesse inizialmente all’interno di vari membri del gruppo, soprattutto in
  vista dell’utilizzabilità che tale progetto avrebbe e per il suo approccio decisamente improntato al futuro,
  chiaramente identificabile, ad esempio, dall’impiego di standard di sicurezza come OWASP e l’integrazione con GitHub.
  \
  == Contro
  Tuttavia, nel corso delle diverse discussioni, in _NoTIP_ sono emersi vari elementi che, a nostro avviso,
  rappresentano dei punti critici rispetto a tale progetto. La complessità architetturale dello stesso, dovuta in prima
  istanza dalla gestione della comunicazione e del coordinamento tra gli agenti, comporta un livello di difficoltà
  elevato che, dopo varie valutazioni, potrebbe rivelarsi un ostacolo non gestibile da parte del gruppo. Un ulteriore
  elemento di difficoltà è rappresentato dalla necessità di garantire una copertura minima dei test tutto sommato
  elevata. Oltre a ciò è emerso anche come, dal capitolato fornitoci, ci risultasse, a differenza di altre proponenti,
  molto più sintetico sul problema mirato ad essere risolto.\
  == Considerazioni
  Per queste motivazioni abbiamo deciso di orientarci verso altri capitolati, nonostante la propensione iniziale.\
  In conclusione, pur riconoscendo l’interesse maturato nei confronti del progetto, il gruppo _NoTIP_ ha deciso di non
  proseguire con la candidatura per il capitolato C2.

  #pagebreak()

  = Capitolato C3
  Il *Capitolato C3*: *“Progetto DIPReader”*, proposto da _Sanmarco Informatica_, si prefigge la realizzazione di uno
  strumento che vertesse sulla consultazione e ricerca di documenti digitali in modalità offline, a partire da pacchetti
  di conservazione forniti da un sistema centralizzato.\
  == Pro
  Il capitolato è sicuramente interessante per la sua utilità pratica legata alla gestione documentale digitale, alla
  consultazione dei dati in totale indipendenza dalle condizioni della rete, oltre che all'idea di sviluppare una
  soluzione multi-piattaforma e autoconsistente. \
  == Contro
  Questo progetto non ha fatto particolarmente presa, fin dall’inizio, all'interno del gruppo.\
  Oltre a ciò, dall’analisi che abbiamo svolto sul documento di capitolato abbiamo individuato alcune sfide
  significative, come la gestione delle prestazioni su grandi volumi di dati in ambiente locale, oppure il requisito di
  autoconsistenza dell’applicativo.\
  == Considerazioni
  In conclusione, pur riconoscendo la pragmaticità dello stesso, il gruppo _NoTIP_ ha deciso di non proseguire con la
  candidatura per il capitolato C3, preferendo altri approcci più allineati con gli interessi del gruppo.

  #pagebreak()

  = Capitolato C4
  Il *Capitolato C4*: *“L’app che Protegge e Trasforma”*, proposto da _Miriade_, ha come obiettivo la realizzazione di
  un’applicazione mobile che mira alla prevenzione e il supporto delle vittime di violenza di genere, attraverso
  strumenti intelligenti, sicuri e facilmente accessibili.\
  == Pro
  E’ sicuramente una proposta molto interessante, sia per l’impatto sociale del progetto che per l'integrazione con
  l’Intelligenza Artificiale. \
  == Contro
  Il gruppo non ha dimostrato alcun interesse nei confronti del capitolato fin dalla presentazione avvenuta in aula,
  individuando diverse criticità. In primo luogo, la complessità tecnica e normativa legata alla gestione di dati
  estremamente sensibili la quale richiede una profonda competenza in sicurezza informatica, crittografia e conformità
  GDPR, ambiti poco consolidati tra gli elementi del gruppo. Inoltre, lo sviluppo di funzionalità avanzate basate
  sull’Intelligenza Artificiale, come il rilevamento linguistico dei segnali di abuso o la gestione del “panic button”
  intelligente, è risultato poco chiaro.\
  == Considerazioni
  In conclusione, pur riconoscendo l’elevato valore a livello etico e sociale del progetto, il gruppo _NoTIP_ ha deciso
  di non proseguire con la candidatura per il capitolato C4.

  #pagebreak()

  = Capitolato C5
  Il *Capitolato C5*: *“[NEXUM] BRD-FASE02-2025 – Business Requirements Document”*, proposto da _Eggon_, ci presenta
  l’idea di andare ad integrare dei moduli di Intelligenza Artificiale all’interno della piattaforma, proprietaria della
  società, *NEXUM*, dedicata alla gestione delle risorse umane e alla comunicazione aziendale. \
  == Pro
  Il gruppo ha apprezzato fin dal primo momento il fatto che *NEXUM* fosse un prodotto già commercializzato dall’azienda
  proponente, il che sottolinea l’interesse che c’è nei confronti dello stesso. \
  Abbiamo trovato inoltre il progetto stimolante per l’elevato grado di innovazione e per l’applicazione dell’AI a
  processi concreti, come la gestione documentale intelligente.\
  Anche l’utilizzo di tecnologie moderne, come AWS, Ruby on Rails, Angular e sistemi OCR avanzati, è stato valutato
  positivamente per la sua pronunciata attualità architetturale ed approccio, ancora una volta, particolarmente
  orientato al futuro.\
  Durante il confronto effettuato con Eggon, sono emersi diversi aspetti positivi che hanno contribuito a valorizzare
  ulteriormente il capitolato. L’azienda si è mostrata molto disponibile e collaborativa, evidenziando fin da subito un
  approccio molto più orientato alla crescita reciproca.\
  In particolare, il gruppo ha apprezzato la flessibilità tecnologica proposta, chiarendo che non rappresentano vincoli
  rigidi, l’approccio incentrato sull’apprendimento del processo e la forte attenzione al supporto formativo. Tutto ciò
  è consultabile in modo più dettagliato nel #link(
    "https://notipswe.github.io/docs/11-candidatura/esterno/verbest_2025-10-25.pdf",
  )[verbale esterno] dedicato. L’incontro ha quindi lasciato una valutazione complessivamente molto positiva, facendo
  percepire l’azienda come un collaboratore disponibile ed attento alla crescita degli studenti.\
  == Contro
  Nonostante il feedback positivo del team nei confronti di tale capitolato, _NoTIP_ riconosce che la sfida lanciata da
  Eggon è assai ambiziosa, in particolare ritenuta al di sopra delle possibilità attuali del gruppo.\
  == Considerazioni
  In conclusione, pur maturando un forte interesse nei confronti del progetto in analisi e in seguito ad un incontro
  conoscitivo molto positivo, il gruppo _NoTIP_ ha deciso di non proseguire con la candidatura per il capitolato C5.

  #pagebreak()

  = Capitolato C6
  Il *Capitolato C6*: *“Second Brain: Estendere il note-taking con i Large Language Models”*, presentato da _Zucchetti_,
  si prefigge come obiettivo la realizzazione di un’applicazione che cerchi di integrare le note capacità dei Large
  Language Models (LLM) ad un editor di testo, basato su MarkDown, con il fine di fornire all’utente un “aiutante
  intelligente”, che lo supporti nella scrittura, correzione e generazione di contenuti.\
  == Pro
  Abbiamo trovato il capitolato interessante per l’opportunità di sperimentare concretamente l’utilizzo dei modelli
  linguistici avanzati nel contesto delle applicazioni dedicate al note-taking. \
  == Contro
  Fin dal primo momento, tale progetto, non ha riscosso particolare entusiasmo all’interno del gruppo. _NoTIP_ ha
  infatti individuato alcuni aspetti che l'hanno portato a confermare il non interesse iniziale nei confronti del
  progetto. In particolare, il capitolato si sofferma, ponendo una forte enfasi sulla progettazione e calibrazione dei
  prompt. Questa attività, pur essendo interessante, richiede molta teoria dei concetti ad essi legati, oltre a quella
  applicativa. Inoltre, la dipendenza dall’integrazione con un servizio LLM esterno, con conseguente ottimizzazione
  richiesta dalle interazioni tramite API introducono un ulteriore livello di complessità gestionale e di testing. \
  == Considerazioni
  In conclusione, pur riconoscendo lo stampo futuristico che tale progetto incarna, il gruppo _NoTIP_ ha deciso di non
  proseguire con la candidatura per il capitolato C6.

  #pagebreak()

  = Capitolato C7
  Il *Capitolato C7*: *“Sistema di acquisizione dati da sensori”*, proposto da _M31_, propone la sfida della
  realizzazione di un sistema distribuito per l’acquisizione, la gestione e la visualizzazione di dati provenienti da
  sensori Bluetooth Low Energy (BLE), con particolare attenzione allo sviluppo dell’infrastruttura Cloud. \
  == Pro
  Il gruppo si è dimostrato caldamente interessato alla proposta fin dalla presentazione. E’ stato trovato
  particolarmente stimolante per la struttura architetturale ben definita e precisa nel capitolato di progetto fornito,
  per diversi livelli che sono richiesti di realizzare (sensori, gateway, Cloud) e della gestione multi-tenant. Anche
  l’utilizzo di tecnologie moderne, come Nest.js e Kubernetes, è stato valutato positivamente, poiché riflettono un
  contesto realistico e professionale. \
  Durante l’incontro tenutosi con _M31_, sono emersi numerosi aspetti positivi che hanno confermato l’interesse del
  gruppo verso il capitolato. L’azienda si è mostrata molto chiara, disponibile e aperta al dialogo, dimostrando fin da
  subito un atteggiamento di supporto nei confronti degli studenti. Apprezzata è stata la flessibilità tecnologica
  dimostrata. In particolare i vari punti che sono stati toccati durante l’incontro sono disponibili e consultabili nel
  #link("https://notipswe.github.io/docs/11-candidatura/esterno/verbest_2025-10-24.pdf")[verbale esterno] ad esso
  associato. \
  Nel complesso, l’incontro ha lasciato un’impressione molto positiva che ha ulteriormente arricchito l’interesse
  presente fin dall’inizio.\
  == Contro
  _NoTIP_ è consapevole delle richieste dell’azienda e che molti dei requisiti siano di difficile esecuzione, ma, grazie
  alla disponibilità dimostrata da parte dell’azienda alla contrattazione e al supporto da parte di professionisti,
  ritiene di essere in grado di andare a realizzare efficacemente tale capitolato. \
  == Considerazioni
  _NoTIP_ si candida quindi, all’unanimità all’interno del gruppo, per la realizzazione del progetto proposto e la
  presentazione della candidatura.

  #pagebreak()

  = Capitolato C8
  Il *Capitolato C8*: *“SmartOrder: Analisi multimodale per la creazione automatica di ordini”*, presentato da _Ergon
  Informatica_, si propone di andare ad realizzare una piattaforma in grado di andare ad automatizzare la ricezione e
  l’elaborazione di ordini d’acquisto, pratica ripetitiva e che può andare ad inserire errori umani. Ciò verrebbe fatto
  trasformando dati non strutturati in ordini strutturati pronti per l’inserimento nei sistemi gestionali aziendali
  (ERP). \
  == Pro
  Il progetto è sembrato interessante sia per l'idea che per la combinazione di diverse tecnologie all’avanguardia (AI,
  NLP, ML, OCR). \
  == Contro
  Vari sono i dubbi che si sono formati all’interno del gruppo, in quanto risulta essere il processo descritto risulta
  essere particolarmente ambizioso. \
  Un esempio è la complessità tecnica che una architettura multimodale richiede oppure l’impiego di modelli di AI
  avanzati, che richiedono competenze specifiche nel campo ad esso legate che, come emerso, non sono ancora consolidate
  dal gruppo. Un’ulteriore criticità riguarda la validazione e normalizzazione dei dati, che deve garantire coerenza tra
  le informazioni provenienti da fonti eterogenee, compito da noi valutato particolarmente complesso.
  == Considerazioni
  In conclusione, nonostante il progetto abbia una chiara direzione verso il futuro, il gruppo _NoTIP_ ha deciso di non
  proseguire con la candidatura per il capitolato C8.

  #pagebreak()

  = Capitolato C9
  Il *Capitolato C9*: *“Vimar View4Life”*, proposto dalla _Vimar_, pone come obiettivo il realizzare una piattaforma web
  e cloud per la gestione degli impianti Smart nelle residenze protette, con particolare focus sugli aspetti legati alla
  sicurezza e l’efficienza energetica degli ambienti.\
  == Pro
  Il _NoTIP_ ha trovato C9 particolarmente interessante sia per la presentazione, decisamente accattivante e
  coinvolgente, oltre che per l’approccio estremamente concreto dell’applicativo richiesto. Inoltre, nelle riunioni
  interne, vari membri del gruppo avevano esposto il loro interesse per la possibilità di interfacciarsi con tecnologie
  di domotica intelligente. \
  == Contro
  Anche l’impiego di tecnologie moderne come Docker, OAuth2, Angular o React sono stati considerati elementi positivi.\
  Nonostante ciò, abbiamo riscontrato alcune criticità significative, in quanto viene richiesto un livello di competenze
  in campo DevOps particolarmente elevato. Inoltre, il progetto dipendendo fortemente da dispositivi fisici e da API
  proprietarie, lo sviluppo e il testing vengono resi più complessi e meno flessibili. \
  == Considerazioni
  Sempre riguardo a questi ultimi, anche le richieste riguardanti i requisiti dei test sono particolarmente rigide ed
  ambiziose. Detto ciò il gruppo ha deciso quindi di non proseguire con la candidatura per il capitolato C9.

]
