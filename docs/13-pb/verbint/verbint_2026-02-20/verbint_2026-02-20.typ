#import "../../00-templates/base_verbale.typ" as base-report
#import "../../00-templates/base_configs.typ" as base

#let metadata = yaml(sys.inputs.meta-path)

#base-report.apply-base-verbale(
  date: "2026-02-23",
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
        Mario De Pasquale
      ],
    ),
  ),
  abstract: "La sessione si è concentrata sulla riorganizzazione dei task, sulla definizione delle regole per il tracciamento delle ore su Jira, sull'assegnazione dei ruoli in vista delle nuove attività e sulla pianificazione della palestra di progettazione e della risoluzione delle criticità documentali.",
  changelog: metadata.changelog,
)[

  In data *23 febbraio 2026* si è svolta una riunione interna del gruppo in modalità telematica.

  L'ordine del giorno prevede:
  - Presentazione dei nuovi task e revisione delle regole di tracciamento ore su Jira;
  - Organizzazione della "palestra di progettazione" e assegnazione studio diagrammi C4;
  - Discussione e riassegnazione sui ruoli di progetto;
  - Pianificazione attività di correzione per Analisi dei Requisiti (AdR), Piano di Qualifica (PdQ) e Norme di Progetto
    (NdP) a seguito della risposta dell'esito ricevuto dal Prof. Cardin.

][

  #base-report.report-point(
    discussion_point: [Definizione task e regole per il tracciamento delle ore su Jira.],
    discussion: [
      È stato presentato un nuovo set di task ed è emersa la necessità di tracciare in modo più preciso il tempo speso
      per le ore dedicate alla "palestra formativa". È stato fatto presente che, al momento, manca una pianificazione
      con ore certe proprio a causa della necessità di fare maggiore pratica (palestra).
    ],
    decisions: [
      Per migliorare la misurazione e le stime future, si è deciso di cambiare approccio al tracciamento. È stata
      stabilita una regola la quale prevede che prima di iniziare qualsiasi lavoro, deve essere stato creato il relativo
      task su Jira. Prima di spostare il task in execution, bisogna inserire un tempo previsto.
    ],
    actions: (
      (
        desc: "Jira - setup tracking ore di palestra",
        url: "https://notipswe.atlassian.net/browse/NT-440",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Organizzazione Palestra di Progettazione.],
    discussion: [
      Al fine di migliorare le competenze tecniche del team, è stata organizzata una "palestra di progettazione".
      L'approccio scelto prevede una prima fase di studio individuale e generazione di idee, seguita da un confronto di
      gruppo. Come materiale di studio individuale sono stati assegnati i diagrammi C4 in modo da poter lavorare con un
      "linguaggio" condiviso.
    ],
    decisions: [
      Valerio e Mario sono stati incaricati di continuare in via principale con la progettazione e la palestra.
    ],
    actions: (
      (
        desc: "Palestra progettazione Valerio",
        url: "https://notipswe.atlassian.net/browse/NT-456",
      ),
      (
        desc: "Palestra progettazione Mario",
        url: "https://notipswe.atlassian.net/browse/NT-493",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Chiarimenti sui ruoli e nuova assegnazione.],
    discussion: [
      Durante la riunione è emerso un dubbio procedurale riguardo alle mansioni specifiche del Verificatore durante il
      processo di sviluppo. Dopo aver chiarito questo aspetto, il gruppo ha deciso di assegnare i ruoli in modo
      leggermente più dinamico rispetto ai precedenti Sprint, provando ad adottare un approccio più "agile".
    ],
    decisions: [
      I ruoli sono stati così assegnati per lo Sprint corrente:
      - *Matteo*: Responsabile, Progettista
      - *Alessandro C.*: Amministratore, Progettista
      - *Alessandro M.*: Progettista
      - *Mario*: Progettista
      - *Leo*: Amministratore, Progettista
      - *Valerio*: Verificatore, Progettista
      - *Francesco*: Progettista
    ],
  )

  #base-report.report-point(
    discussion_point: [Pianificazione risoluzione criticità AdR, PdQ e NdP.],
    discussion: [
      È stata discussa la necessità di concludere al più presto la risoluzione dei problemi emersi dal responso fornito
      dal Prof. Cardin, relativi all'Analisi dei Requisiti e al Piano di Qualifica. Parallelamente, sarà urgente
      sistemare le Norme di Progetto per adattarle alla nuova struttura divisa tra "norme e strumenti" e "attività del
      processo".
    ],
    decisions: [
      Si decide di dividere il lavoro con la scadenza fissata per *mercoledì 25*:
      - *AdR + PdQ*: 3 persone assegnate (Matteo, Francesco, Ale M.).
      - *NdP*: 2 persone assegnate (Leonardo, Alessandro C.).
    ],
    actions: (
      (
        desc: "doc-analisi_requisiti-v1.1.0 - Implementazione processo di gestione dei cambiamenti per AdR e PdQ",
        url: "https://notipswe.atlassian.net/browse/NT-443",
      ),
      (
        desc: "doc-analisi_requisiti-v1.1.0 - Fix requisiti Cardin",
        url: "https://notipswe.atlassian.net/browse/NT-466",
      ),
      (
        desc: "doc-analisi_requisiti-v1.1.0 - Fix UC Cardin",
        url: "https://notipswe.atlassian.net/browse/NT-469",
      ),
      (
        desc: "doc-norme_progetto-v1.1.0 - adattamento primari + gestione processi",
        url: "https://notipswe.atlassian.net/browse/NT-475",
      ),
      (
        desc: "doc-norme_progetto-v.1.1.0 - adattamento infrastruttura, miglioramento, formazione",
        url: "https://notipswe.atlassian.net/browse/NT-477",
      ),
    ),
  ),

][

  #pagebreak()

  = Esiti e decisioni finali
  La riunione interna è da considerarsi conclusa con successo, in quanto il gruppo ha saputo riorganizzare
  operativamente le proprie attività sfruttando la maggiore flessibilità post-sessione invernale. Le attività imminenti
  sono state ripianificate assegnando sotto-gruppi di lavoro dedicati, ponendo come priorità assoluta la risoluzione
  delle criticità documentali.
]
