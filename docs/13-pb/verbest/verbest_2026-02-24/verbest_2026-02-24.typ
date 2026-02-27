#import "../../00-templates/base_verbale.typ" as base-report

#let metadata = yaml(sys.inputs.meta-path)

#base-report.apply-base-verbale(
  date: "2026-02-24",
  scope: base-report.EXTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Francesco Marcon \
        Mario De Pasquale \
        Alessandro Contarini \
        Alessandro Mazzariol \
        Leonardo Preo \
        Matteo Mantoan \
      ],
    ),
  ),
  abstract: "Il presente documento riporta il resoconto dell'incontro esterno tenutosi in remoto. L'incontro ha avuto
  come oggetto la discussione per sbloccare i dubbi infrastrutturali sull'implementazione dell'End-to-End Encryption (E2EE),
  sulla gestione del Logging e sull'utilizzo di NATS come motore di comunicazione.",
  changelog: metadata.changelog,
)[
  Il presente documento attesta formalmente che, in data *24 Febbraio 2026*, si è tenuto un incontro in remoto tramite
  Microsoft Teams con la proponente _M31_. L'incontro si è tenuto tra le *15:45* e le *16:40*

  A rappresentare l’Azienda era presente Cristian Pirlog e Moones Mobaraki.
][
  L'incontro è stato dedicato principalmente alla risoluzione di dubbi e blocchi riguardanti l'infrastruttura di
  comunicazione e la sicurezza dei dati. Il Team ha posto all'Azienda quesiti specifici sulle modalità di distribuzione
  e mantenimento delle chiavi per la decifrazione dei payload, fondamentali in una architettura che sfrutta la
  crittografia E2EE.

  Durante la riunione si sono anche trattati temi riguardanti l'implementazione di funzionalità accessorie come il
  Logging e l'Auditing.
][
  #base-report.report-point(
    discussion_point: [Chiarimenti sull'End-to-End Encryption (E2EE)],

    discussion: [
      Il Team ha esposto il problema, emerso nelle prime fasi della progettazione, relativo al momento e al luogo in cui
      i dati devono essere decriptati (lato utilizzatore) e su come far recapitare le chiavi crittografiche sia al
      Gateway (in fase di provisioning) che all'utente finale (potenzialmente tramite un SDK dedicata e sviluppare). \

      È emerso che l'utilizzo di una API per restituire all'utente la chiave di decifrazione fa venire meno il concetto
      di E2EE puro.

      Si è discusso inoltre del livello di granularità della chiave: per Tenant, per Gateway o per singolo Utente.
    ],

    decisions: [
      È stato deciso di non inserire l'E2EE puro come requisito obbligatorio a causa dell'elevata complessità di
      definizione e progettazione. Come compromesso per gestire il rischio in modo ottimale, è stato concordato di
      generare chiavi specifiche per ogni Gateway, mantenendole all'interno di una tabella dedicata, rinunciando ad una
      gestione centralizzata basata sulla singola chiave per Tenant.
    ],
  )

  #base-report.report-point(
    discussion_point: [Logging e Auditing],

    discussion: [
      Il Team ha chiesto all'Azienda indicazioni su come gestire il tracciamento e l'auditing delle operazioni,
      domandando se fosse preferibile adottare strumenti e tecnologie dedicate oppure integrare i log direttamente nel
      database centrale dell'applicativo.

      Il referente aziendale ha precisato che l'auditing rappresenta una funzionalità opzionale, sconsigliando pertanto
      di investire troppo tempo nell'eventuale integrazione con tecnologie esterne complesse.
    ],

    decisions: [
      Si è convenuto di adottare una soluzione più semplice ovvero l'utilizzo di una semplice tabella di log nel
      database volta a registrare esclusivamente le operazioni di maggior rilievo (es. creazione di nuovi utenti o
      modifiche a configurazioni critiche). Per ogni evento sarà sufficiente tracciare le informazioni di maggiore
      interesse, come timestamp, Utente e Azione. \

      Di conseguenza, il Team manterrà questo requisito con priorità "desiderabile".
    ],
  )

  #base-report.report-point(
    discussion_point: [Servizio di Log tramite NATS],

    discussion: [
      Il Team ha proposto la creazione di un servizio specifico dedicato esclusivamente all'osservazione dei vari topic
      di NATS, con lo scopo di intercettare le informazioni e inserirle nel database dei log.
    ],

    decisions: [
      La proposta è stata accolta molto positivamente. Poiché i servizi comunicheranno tutti tramite NATS, l'Azienda ha
      confermato che l'implementazione di un servizio del genere semplifica notevolmente l'aggregazione e il salvataggio
      centralizzato delle informazioni.
    ],
  )

  #base-report.report-point(
    discussion_point: [NATS come motore principale e gestione degli Alert],

    discussion: [
      Il Team ha discusso l'effettiva validità di NATS come motore principale di comunicazione, portando come esempio
      l'implementazione del pattern Request-Reply tra i servizi. Successivamente, è stata affrontata la criticità
      relativa alla gestione centralizzata degli alert. È stato fatto presente che, a causa della crittografia E2EE
      (End-to-End Encryption), i dati in transito risultano illeggibili per l'infrastruttura centrale. Di conseguenza,
      risulta una sfida estremamente complessa intercettare le fluttuazioni nei valori dei sensori per generare avvisi
      automatici basati sui dati in ingresso.
    ],

    decisions: [
      L'Azienda ha confermato che l'adozione di NATS come asse portante dell'architettura rappresenta una soluzione
      solida e coerente con i servizi ipotizzati. Per quanto riguarda gli alert, si è convenuto di evitare logiche di
      micro-management interne all'applicativo: l'analisi del contenuto e la generazione di allarmi sui dati saranno
      demandate interamente agli utilizzatori terzi (che posseggono le chiavi di decrittazione) tramite API. Il sistema
      centrale, se necessario, si limiterà a fornire esclusivamente alert di stato o per la diagnostica (es.
      disconnessione o assenza di trasmissione da parte di un Gateway).
    ],
  )

  = Epilogo della Riunione
  L'incontro si è rivelato fondamentale per superare alcuni blocchi progettuali del gruppo. L'abbandono dell'E2EE puro a
  favore di una crittografia segregata per singolo Gateway alleggerisce la complessità dell'infrastruttura.

  Il Team continuerà la progettazione seguendo le direttive e i consigli emersi durante questa riunione.

  Il prossimo incontro è stato fissato a *martedì 3 marzo*.

  = Approvazione Aziendale
  La presente sezione certifica che il verbale è stato esaminato e approvato dai rappresentanti di _M31_. L’avvenuta
  approvazione è formalmente confermata dalle firme riportate di seguito dei referenti Aziendali.

  // #align(right)[
  //   #image("assets/sign.png")
  // ]
]
