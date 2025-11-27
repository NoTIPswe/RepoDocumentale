#import "../../00-templates/base_verbale.typ" as base-report
#import "../../00-templates/base_configs.typ" as base

#let metadata = yaml(sys.inputs.meta-path)

#base-report.apply-base-verbale(
  date: "2025-11-14",
  scope: base-report.INTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Francesco Marcon \
        Valerio Solito \
        Leonardo Preo \
        Alessandro Mazzariol \
        Matteo Mantoan \
        Alessandro Contarini
      ],
    ),
  ),
  abstract: "",
  changelog: metadata.changelog,
)[
  In data *14 novembre 2025*, alle ore *08:56*, si è svolta una riunione interna del gruppo NoTIP in modalità virtuale sul server *Discord* ufficiale del team.
  La riunione si è conclusa alle ore *09:19*.

  Ordine del giorno:
  - Definizione della rotazione dei ruoli per sprint
  - Scelta del tool per la gestione del progetto
  - Organizzazione dell'incontro con l'azienda proponente M31
][
  #base-report.report-point(
    discussion_point: [Definizione della rotazione dei ruoli per sprint],
    discussion: [
      Il gruppo ha deciso di approfondire la necessità della definizione finale del metodo scelto per la rotazione dei ruoli all'inizio di ogni sprint.\
      L'idea era di lavorare su ciò già scritto all'interno delle Norme di Progetto e della Dichiarazione di Impegni, facendo in modo che, mediamente, ogni componente del gruppo svolga le stesse ore degli altri in ogni ruolo.
    ],
    decisions: [
      - Si rielabora ciò già riportato nella *Dichiarazione di Impegni*, specificando i criteri per la rotazione all'inizio di ogni sprint nelle *Norme di Progetto*.
      - Creazione ed assegnamento del task
    ],
    actions: (
      (
        desc: "Rotazione ruoli - redazione criteri specifici",
        url: "https://github.com/NoTIPswe/NoTIPswe.github.io/issues/53",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Scelta del tool per la gestione del progetto],
    discussion: [
      Il gruppo si è espresso sulla possibilità del cambio del tool per la gestione del progetto.\
      L'attuale in uso, GitHub Projects, non permette la definizione di campi custom, di metriche per la qualità dei task. Si aggiunge che non permette di estrarre nulla dal task: manca la possibilità di creare grafici ed indicatori dalle issue.
    ],
    decisions: [
      Dalla discussione si decide di chiedere all'azienda M31, che funge anche da *mentore* nei confronti del gruppo, con lo scopo di utilizzare dei tool per la gestione del progetto che poi trovino applicazioni nell'ambito lavorativo. Si ricercano quindi tecnologie e tecniche normalmente utilizzate in ambito aziendale.
    ],
    actions: (),
  )

  #base-report.report-point(
    discussion_point: [Organizzazione dell'incontro con l'azienda proponente M31],
    discussion: [
      L'obbiettivo della discussione è stato quello di capire come gestire il primo incontro con la proponente, decidendo su cosa vertire la discussione al momento dell'incontro, programmato per il giorno *2025-11-18*, ore *10:00* nella sede aziendale in Via Niccolò Tommaseo 77.\
      Durante la discussione emerge che la proponente eserciti due ruoli nei confronti del gruppo: quello di *mentoring* e quello di *cliente*.
    ],
    decisions: [
      Per quanto riguarda il ruolo di mentoring assunto da M31 si richiede:
      - Consiglio sulla scelta del tool di gestione del progetto
      - Una introduzione alle tecnologie da utilizzare per lo sviluppo di un progetto di questa tipologia
      - Consiglio sulla gestione del progetto e degli sprint
      Per quanto riguarda il ruolo di cliente invece:
      - Il gruppo si impegna alla lettura e comprensione da parte di ogni componente del capitolato, in modo da presentarsi il più preparati possibile all'incontro
      - Si richiede un'introduzione all'analisi dei requisiti, con indicazioni generali atte allo svolgimento di questa.
    ],
    actions: (),
  )
][
  = Esiti e decisioni finali
  La riunione si è conclusa alle ore 09:19, in seguito all'organizzazione e preparazione all'incontro con l'azienda, finalizzato anche alla scelta finale del tool di gestione del progetto. Inoltre si riporta l'assegnazione del task riguardante la riscrittura della rotazione dei ruoli ai componenti Leonardo Preo e Valerio Solito.\
  L'incontro è stato teatro di collaborazione e produttività, nonostante la sua corta durata ognuno ha espresso i propri pareri riguardo i vari punti all'ordine del giorno.
]
