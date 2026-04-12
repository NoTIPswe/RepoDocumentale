#import "../../00-templates/base_verbale.typ" as base-report

#let metadata = yaml("verbest_2026-03-17.meta.yaml")

#base-report.apply-base-verbale(
  date: "2026-03-17",
  scope: base-report.EXTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Francesco Marcon \
        Mario De Pasquale \
        Alessandro Contarini \
        Alessandro Mazzariol \
        Valerio Solito \
        Leonardo Preo \
        Matteo Mantoan \
      ],
    ),
  ),
  abstract: "Il presente documento riporta il resoconto dell'incontro tenutosi con la proponente M31.
Durante la riunione sono stati affrontati il setup delle repository, la definizione dell’infrastruttura di sviluppo, l’avvio delle attività di implementazione e la disponibilità della documentazione progettuale.",
  changelog: metadata.changelog,
)[
  Il presente documento attesta formalmente che, in data *17 marzo 2026*, si è tenuto un incontro in remoto tramite
  Microsoft Teams con la proponente _M31_. A rappresentare l'Azienda erano presenti Cristian Pirlog e Moones Mobaraki.
][
  L’incontro è stato finalizzato alla definizione operativa delle attività di sviluppo e alla verifica dello stato della
  documentazione disponibile.
][
  #base-report.report-point(
    discussion_point: [Setup repository],

    discussion: [
      Il Team sta completando il setup iniziale delle repository di progetto, predisponendo la struttura necessaria per
      l’avvio delle attività di sviluppo.
    ],

    decisions: [
      - Il completamento del setup delle repository viene considerato un task prioritario, al fine di garantire la
        continuità dello sviluppo dei servizi.
    ],

    actions: (),
  )

  #base-report.report-point(
    discussion_point: [Definizione infrastruttura],

    discussion: [
      È emerso che il supporto degli strumenti per i Dev Container risulta ancora in una fase sperimentale, con
      possibili limitazioni operative.
    ],

    decisions: [
      - Nonostante le limitazioni riscontrate, il Team procederà con l’utilizzo dei Dev Container, prestando attenzione
        a non incidere negativamente sulle tempistiche di sviluppo.
    ],

    actions: (),
  )

  #base-report.report-point(
    discussion_point: [Avvio sviluppo],

    discussion: [
      Il Team ha confermato che, a partire dai due giorni successivi all’incontro, inizierà lo sviluppo effettivo del
      codice.
    ],

    decisions: [
      - L’avvio ufficiale delle attività di implementazione è previsto a partire dai due giorni successivi alla
        riunione.
    ],

    actions: (),
  )

  #base-report.report-point(
    discussion_point: [Stato della progettazione],

    discussion: [
      È stato verificato lo stato della documentazione progettuale. Il Team dispone di documenti interni relativi a
      tutti i servizi previsti, ad eccezione dei componenti frontend, per i quali la documentazione risulta ancora
      mancante.
    ],

    decisions: [
      - Il Team procederà con lo sviluppo delle parti backend già documentate.
      - La documentazione relativa al frontend dovrà essere definita con priorità.
    ],
  )


  = Epilogo della riunione
  L’incontro si è concluso in maniera proficua e ha consentito di chiarire le priorità operative per il proseguimento
  del progetto. In particolare, ha permesso di:
  - definire le attività necessarie per l’avvio dello sviluppo;
  - individuare le criticità legate all’utilizzo dei Dev Container;
  - evidenziare le lacune nella documentazione relativa al frontend.
  Il Team proseguirà con le attività di sviluppo secondo quanto stabilito, approfondendo i punti ancora aperti nelle
  prossime riunioni.

  Il gruppo _NoTIP_ ringrazia l'Azienda per la disponibilità e per i suggerimenti forniti durante la riunione.

  #pagebreak()

  = Approvazione aziendale
  La presente sezione certifica che il verbale è stato esaminato e approvato dai rappresentanti di _M31_. L’avvenuta
  approvazione è formalmente confermata dalle firme riportate di seguito dei referenti Aziendali.

  #align(right)[
    #image("assets/sign.png")
  ]


]
