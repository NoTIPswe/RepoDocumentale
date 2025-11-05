#import "../../../00-templates/base_configs.typ" as base
#import "../../../00-templates/base_verbale.typ" as base-report

#let metadata = yaml(sys.inputs.meta-path)

#base-report.apply-base-verbale(
  date: "2025-10-17",
  scope: base-report.INTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Francesco Marcon \
        Valerio Solito \
        Leonardo Preo \
        Mario de Pasquale \
        Alessandro Mazzariol \
        Matteo Mantoan \
      ],
    ),
  ),
  abstract: "Durante la riunione, il gruppo NoTIP ha discusso le regole per la gestione dei documenti, la pianificazione Scrum e la rendicontazione delle attività.",
  changelog: metadata.changelog,
)[
  Con il presente documento si attesta che in data *17 Ottobre 2025* si è tenuta una riunione interna del gruppo _NoTIP_, svoltasi in modalità virtuale sul server Discord ufficiale del gruppo.\
  La riunione ha avuto inizio alle ore *17:00* e si è conclusa alle ore *18:10*.\
  Si prevede di:
  #list(
    [Versionamento e pubblicazione dei verbali],
    [Applicazione della metodologia Scrum e definizione dello sprint planning],
    [Rendicontazione delle ore di lavoro],
  )\
][

  #base-report.report-point(
    discussion_point: [Discussione sul versionamento e pubblicazione verbali],
    discussion: [
      Definizione delle modalità di *versionamento* e *pubblicazione* dei verbali interni del gruppo, per garantire tracciabilità e uniformità della documentazione.
    ],
    decisions: [
      È stato concordato che ogni commit dovrà essere atomico, riguardando un solo documento per volta, al fine di evitare modifiche parallele su file diversi. \
      L’editor incaricato della redazione dovrà attenersi al template ufficiale del gruppo e impostare correttamente la versione del documento secondo una numerazione sequenziale (v1, v2, …). \
      La pubblicazione dei verbali avverrà tramite pull request (PR) verso il branch principale (main), utilizzando l’account personale GitHub di ciascun membro. \
      Ogni PR dovrà essere *revisionata* e *approvata* prima del merge, redatta nel seguente formato:
      #block(
        width: 100%,
        inset: 0.6em,
        stroke: 0.5pt + gray,
        fill: luma(240),
        radius: 4pt,
      )[
        `[autore]`
        #linebreak()
        `edits: [descrizione sintetica delle modifiche o changelog del documento]`
      ]
      L’amministratore, in qualità di verificatore, avrà il compito di controllare la correttezza formale e contenutistica del verbale. In caso di non conformità, potrà segnalare le problematiche tramite commento sulla PR o, per errori minori, intervenire direttamente previa verifica dei permessi. \
      Qualora sia necessaria una revisione sostanziale, l’editor dovrà presentare una nuova PR correttiva. \
      Una volta *approvata*, la PR verrà unita al branch principale e il verbale aggiornato sarà automaticamente pubblicato sul sito ufficiale del gruppo tramite automazione.
    ],
    actions: ()
  )

  \

  #base-report.report-point(
    discussion_point: [Metodologia Scrum e Sprint Planning],
    discussion: [
      È stata esaminata il modo in cui andare ad applicare la metodologia Scrum e la pianificazione sprint nel contesto del progetto
    ],
    decisions: [
      Il gruppo ha stabilito che la durata di ciascuno sprint sarà di *due settimane solari*, al fine di bilanciare la pianificazione strategica con la necessaria flessibilità operativa. \
      All’inizio di ogni sprint, durante la fase di planning, verrà valutata la disponibilità dei membri del gruppo per l’assegnazione del ruolo di Scrum Master. Tale ruolo sarà oggetto di rotazione ad ogni ciclo, così da garantire una distribuzione equa delle responsabilità e delle esperienze gestionali. \
      Questa impostazione è da considerarsi *provvisoria*: la versione definitiva sarà concordata con l’azienda proponente per garantire coerenza con le metodologie adottate in ambito progettuale.
    ],
    actions: ()
  )

  \

  #base-report.report-point(
    discussion_point: [Rendicontazione delle ore di lavoro],
    discussion: [
      Il gruppo ha esaminato le modalità di rendicontazione delle *ore* dedicate alle attività progettuali, con l’intento di assicurare trasparenza e tracciabilità del tempo di lavoro.
    ],
    decisions: [
      È stato deciso che in ogni verbale verranno riportate in modo esplicito l’*ora di inizio* e l’*ora di fine* della riunione, al fine di rendere immediatamente verificabile il tempo dedicato alle attività organizzative. \
      Per ogni task completato, l’autore dovrà indicare nel commit il numero di ore impiegate per la realizzazione del lavoro. \
      Tale modalità permetterà al gruppo di mantenere una rendicontazione accurata e verificabile, favorendo un monitoraggio continuo dell’impegno di ciascun membro e una più efficace pianificazione delle attività future.
    ],
    actions: ()
  )
][
  = Esiti e decisioni finali
  La riunione si è conclusa dopo aver affrontato tutti i punti all’ordine del giorno.\
  Il gruppo ha definito in modo chiaro e condiviso la gestione delle PR e la rendicontazione delle attività.\
  È stato inoltre delineato un modello preliminare di gestione Scrum, che sarà ulteriormente affinato in collaborazione con l’azienda proponente.\
  La prossima riunione non è ancora stata programmata.
  Si prevede di discutere, nel prossimo incontro, i seguenti punti all’ordine del giorno:
  #list(
    [Definizione del template ufficiale per i verbali],
    [Definizione e formalizzazione del metodo di versionamento adottato],
  )

  La seduta si è svolta in un clima costruttivo e di piena collaborazione.
]
