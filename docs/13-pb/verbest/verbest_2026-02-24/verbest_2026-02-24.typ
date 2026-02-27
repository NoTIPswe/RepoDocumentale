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
  Microsoft Teams con la proponente _M31_. L'incontro si è tenuto tra le *15:45* e le *16:40*.

  A rappresentare l’Azienda era presente Cristian Pirlog e Moones Mobaraki.
][
  L'incontro è stato dedicato principalmente alla risoluzione di dubbi e blocchi riguardanti l'infrastruttura di
  comunicazione e la sicurezza dei dati. Il Team ha posto all'Azienda quesiti specifici sulle modalità di distribuzione
  e mantenimento delle chiavi per la decifrazione dei payload. Questi elementi sono fondamentali in un'architettura
  che sfrutta la crittografia E2EE.

  Durante la riunione si sono anche trattati temi riguardanti l'implementazione di funzionalità accessorie come il
  Logging e l'Auditing.
][
  #base-report.report-point(
    discussion_point: [Chiarimenti sull'End-to-End Encryption (E2EE)],

    discussion: [
      Il Team ha esposto il problema emerso nelle prime fasi della progettazione. Il problema riguarda il momento e il
      luogo in cui i dati devono essere decriptati lato utilizzatore. Si è discusso anche come recapitare le chiavi
      crittografiche al Gateway (in fase di provisioning) e all'utente finale. \

      È emerso che l'utilizzo di una API per restituire all'utente la chiave di decifrazione fa venire meno il concetto
      di E2EE puro.

      Si è discusso inoltre del livello di granularità della chiave: per Tenant, per Gateway o per singolo Utente.
    ],

    decisions: [
      È stato deciso di non inserire l'E2EE puro come requisito obbligatorio a causa dell'elevata complessità di
      definizione e progettazione. Come compromesso per gestire il rischio in modo ottimale, è stato concordato di
      generare chiavi specifiche per ogni Gateway. Le chiavi saranno mantenute in una tabella dedicata. Si rinuncia
      così alla gestione centralizzata basata sulla singola chiave per Tenant.
    ],
  )

  #base-report.report-point(
    discussion_point: [Logging e Auditing],

    discussion: [
      Il Team ha chiesto all'Azienda indicazioni su come gestire il tracciamento e l'auditing. Si è domandato se fosse
      preferibile adottare strumenti dedicati oppure integrare i log nel database centrale.

      Il referente aziendale ha precisato che l'auditing è una funzionalità opzionale. Ha sconsigliato di investire
      troppo tempo nell'integrazione con tecnologie esterne complesse.
    ],

    decisions: [
      Si è convenuto di adottare una soluzione semplice. Si utilizzerà una tabella di log nel database per registrare
      le operazioni di maggior rilievo (es. creazione di utenti o modifiche a configurazioni critiche). Per ogni evento
      sarà sufficiente tracciare timestamp, Utente e Azione. \

      Di conseguenza, il Team manterrà questo requisito con priorità "desiderabile".
    ],
  )

  #base-report.report-point(
    discussion_point: [Servizio di Log tramite NATS],

    discussion: [
      Il Team ha proposto la creazione di un servizio dedicato all'osservazione dei topic NATS. Lo scopo è intercettare
      le informazioni e inserirle nel database dei log.
    ],

    decisions: [
      La proposta è stata accolta positivamente. Poiché i servizi comunicano tutti tramite NATS, l'Azienda ha confermato
      che questo servizio semplifica l'aggregazione e il salvataggio delle informazioni.
    ],
  )

  #base-report.report-point(
    discussion_point: [NATS come motore principale e gestione degli Alert],

    discussion: [
      Il Team ha discusso la validità di NATS come motore principale di comunicazione, portando come esempio il pattern
      Request-Reply tra i servizi. Successivamente, è stata affrontata la criticità della gestione centralizzata degli
      alert. A causa della crittografia E2EE, i dati in transito risultano illeggibili per l'infrastruttura centrale.
      Di conseguenza, intercettare le fluttuazioni dei sensori per generare avvisi automatici risulta molto complesso.
    ],

    decisions: [
      L'Azienda ha confermato che NATS è una soluzione solida e coerente con i servizi ipotizzati. Per gli alert, si
      è convenuto di evitare logiche di micro-management interne. L'analisi e la generazione di allarmi sui dati saranno
      demandate agli utilizzatori terzi tramite API. Il sistema centrale si limiterà a fornire alert di stato o
      diagnostica (es. disconnessione di un Gateway).
    ],
  )

  = Epilogo della Riunione
  L'incontro è stato fondamentale per superare alcuni blocchi progettuali. L'abbandono dell'E2EE puro a favore di una
  crittografia per singolo Gateway riduce la complessità dell'infrastruttura.

  Il Team continuerà la progettazione seguendo le indicazioni emerse durante la riunione.

  Il prossimo incontro è stato fissato a *martedì 3 marzo*.

  = Approvazione Aziendale
  La presente sezione certifica che il verbale è stato esaminato e approvato dai rappresentanti di _M31_.
  L’approvazione è confermata dalle firme dei referenti aziendali riportate di seguito.

  // #align(right)[
  //   #image("assets/sign.png")
  // ]
]
