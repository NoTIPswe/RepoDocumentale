#import "../../00-templates/base_verbale.typ" as base-report
#import "../../00-templates/base_configs.typ" as base

#let metadata = yaml(sys.inputs.at("meta-path", default: "verbint_2026-03-16.meta.yaml"))

#base-report.apply-base-verbale(
  date: "2026-03-16",
  scope: base-report.INTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Valerio Solito \
        Leonardo Preo \
        Alessandro Mazzariol \
        Matteo Mantoan \
        Alessandro Contarini \
        Mario De Pasquale \
        Francesco Marcon \
      ],
    ),
  ),
  abstract: "Meeting interno dedicato al coordinamento conclusivo della progettazione dei servizi, all'avvio dello sviluppo backend e alla pianificazione delle attività frontend.",
  changelog: metadata.changelog,
)[

  In data *16 marzo 2026* si è svolta una riunione interna del gruppo in modalità telematica.

  L'ordine del giorno prevede tre questioni operative:
  - Ribadire l'importanza di una progettazione solida e definire la chiusura a breve delle attività progettuali;
  - Avviare lo sviluppo dei servizi già progettati, con suddivisione del lavoro tra i membri del gruppo;
  - Iniziare la progettazione del frontend e pianificarne il successivo sviluppo.

][

  #base-report.report-point(
    discussion_point: [Conclusione della fase di progettazione.],
    discussion: [
      Durante la riunione è stata ribadita l'importanza di mantenere un buon livello di progettazione, così da evitare
      criticità nelle fasi successive di sviluppo e integrazione. Allo stesso tempo, il gruppo ha rilevato la necessità
      di chiudere questa fase in tempi brevi, per non rallentare l'avanzamento complessivo del progetto.
    ],
    decisions: [
      Si è deciso di completare a breve le ultime attività di progettazione aperte, mantenendo il focus sugli elementi
      essenziali per consentire l'avvio ordinato dello sviluppo.
    ],
  )

  #base-report.report-point(
    discussion_point: [Avvio dello sviluppo dei servizi backend.],
    discussion: [
      È stato confermato l'avvio dello sviluppo dei servizi già progettati. Il gruppo ha discusso la necessità di
      procedere in parallelo, suddividendo l'implementazione tra i vari membri in base ai servizi assegnati e alle
      responsabilità definite internamente.
    ],
    decisions: [
      Si è deciso di iniziare immediatamente lo sviluppo dei servizi progettati, distribuendo il lavoro tra i membri del
      team secondo la suddivisione concordata.
    ],
  )

  #base-report.report-point(
    discussion_point: [Avvio progettazione e sviluppo frontend.],
    discussion: [
      Parallelamente alle attività backend, è stata avviata la riflessione sulla componente frontend. La riunione ha
      evidenziato la necessità di iniziare dalla progettazione dell'interfaccia e dei flussi principali, così da poter
      procedere subito dopo con lo sviluppo in modo coerente con i servizi backend in realizzazione.
    ],
    decisions: [
      Si è deciso di dare avvio alla progettazione del frontend e di proseguire successivamente con il suo sviluppo,
      coordinando le attività con l'evoluzione dei servizi backend.
    ],
  )

][

  #pagebreak()

  = Esiti e decisioni finali
  La riunione si è conclusa con l'allineamento del gruppo sulle priorità operative immediate. È stata confermata la
  necessità di chiudere a breve la progettazione, preservandone comunque la qualità, avviare lo sviluppo dei servizi già
  definiti con una distribuzione del lavoro tra i membri del team e iniziare la progettazione del frontend in vista del
  successivo sviluppo.
]
