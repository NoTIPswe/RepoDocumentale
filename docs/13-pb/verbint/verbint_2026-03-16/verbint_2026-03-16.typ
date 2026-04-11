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
    discussion_point: [Conclusione della fase di progettazione],
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
    discussion_point: [Avvio dello sviluppo dei servizi backend],
    discussion: [
      È stato confermato l'avvio dello sviluppo dei servizi già progettati. Il gruppo ha discusso la necessità di
      procedere in parallelo, suddividendo l'implementazione tra i vari membri in base ai servizi assegnati e alle
      responsabilità definite internamente.
    ],
    decisions: [
      Si è deciso di iniziare immediatamente lo sviluppo dei servizi progettati, distribuendo il lavoro tra i membri del
      team secondo la suddivisione concordata.
    ],
    actions: (
      (
        desc: "Sviluppo Simulator-Backend",
        url: "https://notipswe.atlassian.net/browse/NT-623",
      ),
      (
        desc: "Sviluppo Data-Consumer",
        url: "https://notipswe.atlassian.net/browse/NT-629",
      ),
      (
        desc: "Sviluppo Provisioning-Service",
        url: "https://notipswe.atlassian.net/browse/NT-645",
      ),
      (
        desc: "Sviluppo Data-Api",
        url: "https://notipswe.atlassian.net/browse/NT-602",
      ),
      (
        desc: "Sviluppo Management-Api",
        url: "https://notipswe.atlassian.net/browse/NT-593",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Avvio progettazione e sviluppo frontend],
    discussion: [
      Parallelamente alle attività backend, è stata avviata la riflessione sulla componente frontend. La riunione ha
      evidenziato la necessità di iniziare dalla progettazione dell'interfaccia e dei flussi principali, così da poter
      procedere subito dopo con lo sviluppo in modo coerente con i servizi backend in realizzazione.
    ],
    decisions: [
      Si è deciso di dare avvio alla progettazione del frontend e di proseguire successivamente con il suo sviluppo,
      coordinando le attività con l'evoluzione dei servizi backend.
    ],
    actions: (
      (
        desc: "Progettazione Leonardo",
        url: "https://notipswe.atlassian.net/browse/NT-620",
      ),
      (
        desc: "Progettazione Valerio",
        url: "https://notipswe.atlassian.net/browse/NT-626",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Aggiornamento norme di progetto],
    discussion: [
      Nel gruppo è emersa l'esigenza di formalizzare i processi di sviluppo finora decisi all'interno delle Norme di
      Progetto per garantire uniformità tra i membri.
    ],
    decisions: [
      Si è deciso di andare a completare la sezione riguardante il processo di sviluppo, andando a riportare quelle che
      sono le decisioni condivise che il gruppo ha preso a riguardo dello stesso.
    ],
    actions: (
      (
        desc: "doc-norme_progetto-v1.2.0 - Inserimento Norme per sviluppo",
        url: "https://notipswe.atlassian.net/browse/NT-561",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Setup infrastruttura di sviluppo e CI/CD],
    discussion: [
      Per minimizzare i tempi di configurazione e garantire la coerenza tra i diversi sistemi operativi dei membri, è
      stata discussa l'adozione di Dev Containers. Inoltre, è stata sottolineata l'importanza di automatizzare i test e
      il linting tramite GitHub Workflows per mantenere alto lo standard qualitativo del codice fin dai primi commit.
    ],
    decisions: [
      Si è deciso di configurare in ogni repository i file necessari per i Dev Containers e di predisporre i workflow di
      GitHub per l'integrazione continua.
    ],
    actions: (
      (
        desc: "Setup repo servizi MVP",
        url: "https://notipswe.atlassian.net/browse/NT-521",
      ),
      (
        desc: "Setup devcontainers MVP",
        url: "https://notipswe.atlassian.net/browse/NT-552",
      ),
    ),
  )

][

  #pagebreak()

  = Esiti e decisioni finali
  La riunione si è conclusa con l'allineamento del gruppo sulle priorità operative immediate. È stata confermata la
  necessità di chiudere a breve la progettazione, preservandone comunque la qualità, avviare lo sviluppo dei servizi già
  definiti con una distribuzione del lavoro tra i membri del team e iniziare la progettazione del frontend in vista del
  successivo sviluppo.
]
