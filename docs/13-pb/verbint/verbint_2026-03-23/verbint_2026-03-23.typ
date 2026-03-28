#import "../../00-templates/base_verbale.typ" as base-report
#import "../../00-templates/base_configs.typ" as base

#let metadata = yaml(sys.inputs.at("meta-path", default: "verbint_2026-03-23.meta.yaml"))

#base-report.apply-base-verbale(
  date: "2026-03-23",
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
  abstract: "Meeting interno dedicato alla pianificazione dello sprint corrente, alla definizione dei ruoli, all'assegnazione dei task ai membri del team e alla revisione delle linee guida operative.",
  changelog: metadata.changelog,
)[

  In data *23 marzo 2026*, tra le ore 9:00 e le 10:00, si è svolta una riunione interna del gruppo in modalità
  telematica.

  L'ordine del giorno prevede le seguenti questioni operative:
  - Definire linee guida per il processo di sviluppo e gestione documentazione tecnica;
  - Assegnare ruoli e obiettivi per lo sprint corrente;
  - Pianificare le attività del prossimo sprint;
  - Distribuire i task tra i membri del team.

][

  #base-report.report-point(
    discussion_point: [Linee guida operative per lo sviluppo e la documentazione],
    discussion: [
      Il gruppo ha discusso alcune indicazioni operative emerse dall'esperienza degli sprint precedenti, con l'obiettivo
      di migliorare la qualità del processo di sviluppo e la coerenza della documentazione prodotta. In particolare, è
      stata sottolineata l'importanza di mantenere le integrazioni di dimensioni ridotte per facilitare le attività di
      peer review tramite pull request. È stato inoltre ricordato che i verbali devono sempre riportare i link ai task
      Jira associati alle decisioni prese. Infine, è emersa la necessità di includere un glossario interno all'interno
      dei manuali utente, distinto dal glossario generale di progetto.
    ],
    decisions: [
      Si è deciso di adottare sistematicamente integrazioni piccole e ben delimitate per agevolare la verifica tramite
      pull request. I verbali dovranno sempre includere i riferimenti ai task Jira corrispondenti alle decisioni. I
      manuali utente dovranno contenere un proprio glossario interno dedicato.
    ],
    actions: (
      (
        desc: "doc-verbint_2026-03-23-v0.0.1",
        url: "https://notipswe.atlassian.net/browse/NT-632",
      ),
      (
        desc: "doc-verbest_2026-03-24-v0.0.1",
        url: "https://notipswe.atlassian.net/browse/NT-682",
      ),
      (
        desc: "doc-manuale_utente-v0.0.1",
        url: "https://notipswe.atlassian.net/browse/NT-524",
      ),
      (
        desc: "doc-manuale_sysadm-v0.0.1",
        url: "https://notipswe.atlassian.net/browse/NT-527",
      ),
      (
        desc: "doc-manuale_infra_monitoring-v0.0.1",
        url: "https://notipswe.atlassian.net/browse/NT-533",
      ),
      (
        desc: "doc-manuale_api-v0.0.1",
        url: "https://notipswe.atlassian.net/browse/NT-530",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Definizione dei ruoli per lo sprint corrente],
    discussion: [
      Il gruppo ha formalizzato la distribuzione dei ruoli per il presente sprint, coerentemente con le responsabilità
      già emerse nelle settimane precedenti e con le attività pianificate.
    ],
    decisions: [
      I ruoli assegnati per questo sprint sono i seguenti: Matteo Mantoan assume il ruolo di Responsabile; Matteo
      Mantoan e Leonardo Preo ricoprono il ruolo di Progettisti; tutti i membri del team partecipano come Verificatori e
      Programmatori secondo le rispettive assegnazioni di task.
    ],
    actions: (
      (
        desc: "Aggiornamento PdP sprint 10",
        url: "https://notipswe.atlassian.net/browse/NT-685",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Obiettivi dello sprint corrente],
    discussion: [
      Il gruppo ha definito gli obiettivi da raggiungere entro la conclusione dello sprint in corso, con riferimento sia
      alle attività di sviluppo che a quelle documentali.
    ],
    decisions: [
      Si è stabilito che entro la fine dello sprint dovrà essere completato lo sviluppo dei singoli servizi, così da
      consentire l'avvio dell'integrazione lunedì. I documenti tecnici dovranno raggiungere almeno il 50% di
      completamento.
    ],
    actions: (
      (
        desc: "Aggiornamento PdP sprint 10",
        url: "https://notipswe.atlassian.net/browse/NT-685",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Assegnazione task ai membri del team.],
    discussion: [
      Il gruppo ha proceduto alla distribuzione puntuale dei task tra i membri, tenendo conto delle competenze, dei
      ruoli assegnati e delle priorità dello sprint. Sono stati definiti task di sviluppo, progettazione, verifica e
      redazione documentale.
    ],
    decisions: [
      I task sono stati assegnati ai membri del team secondo le responsabilità e le priorità concordate, come riportato
      su Jira.
    ],
  )

][

  #pagebreak()

  = Esiti e decisioni finali
  La riunione si è conclusa con un quadro chiaro delle priorità operative per il prosieguo del progetto. Sono state
  adottate linee guida per migliorare il processo di sviluppo e la qualità della documentazione. I ruoli sono stati
  assegnati e i task distribuiti tra i membri del team, con scadenze definite. L'obiettivo principale dello sprint è il
  completamento dello sviluppo dei singoli servizi entro la fine della settimana, così da avviare le attività di
  integrazione a partire da lunedì, parallelamente all'avanzamento dei documenti tecnici.
]

