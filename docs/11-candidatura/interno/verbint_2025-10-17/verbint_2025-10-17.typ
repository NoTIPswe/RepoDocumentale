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
        Mario De Pasquale \
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
  == Discussione sul versionamento e pubblicazione verbali
  Il primo punto affrontato ha riguardato la definizione delle modalità di versionamento e pubblicazione dei verbali, al fine di garantire un processo ordinato e tracciabile per la gestione della documentazione ufficiale del gruppo.\
  È stato concordato che:
  Ogni commit dovrà essere *atomico*, cioè riguardare un solo documento per volta, evitando modifiche simultanee a file diversi.\

  L’editor incaricato della redazione del verbale dovrà seguire rigorosamente il template ufficiale del gruppo, impostando la versione del documento. \
  E' stato proposto, provvisoriamente, l'utilizzo del versionamento in modo *sequenziale* (v1, v2, ...).\

  La pubblicazione di un documento dovrà avvenire mediante *pull request* (PR) verso il branch principale (main), utilizzando il proprio account personale GitHub.\

  Ogni PR dovrà essere *revisionata* e approvata prima del merge.\


  Le PR dovranno essere redatte con il seguente formato:
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
  L’amministratore (in qualità di verificatore) avrà il compito di controllare la correttezza formale e contenutistica del verbale.\
  Nel caso in cui il documento non risultasse conforme, l’amministratore potrà:
  #list(
    [segnalare i problemi tramite commento sulla PR],
    [modificare direttamente la PR per correggere piccoli errori (previa verifica dei permessi)],
  )

  In caso di revisione richiesta, l’editor dovrà creare una nuova PR correttiva.\
  Una volta approvata, la PR verrà unita al branch principale e il verbale aggiornato sarà *automaticamente pubblicato* sul sito ufficiale del gruppo, tramite una automazione.

  == Applicazione della metodologia Scrum e Sprint Planning
  Il secondo punto ha riguardato la definizione pratica dell’applicazione del metodo *Scrum* nel contesto del progetto.
  È stato stabilito che:
  #list(
    [La durata di ogni sprint sarà di due settimane solari, consentendo un equilibrio tra pianificazione e flessibilità],
    [All’inizio di ogni sprint, durante la fase di planning, verrà valutata la disponibilità dei membri per determinare chi assumerà il ruolo di *Scrum Master*. \
      Tale ruolo verrà rotato ad ogni ciclo, in modo da garantire un’equa distribuzione delle responsabilità e delle opportunità di gestione.],
  )

  Il gruppo ha sottolineato che questa impostazione è da considerarsi provvisoria: la decisione definitiva verrà presa in accordo con l’azienda proponente, per allineare il metodo di lavoro interno a quello richiesto dal contesto progettuale.

  == Rendicontazione delle ore
  Il terzo punto ha riguardato le modalità di rendicontazione delle ore di lavoro.
  Si è deciso che:
  #list(
    [In ogni verbale di riunione verranno riportati in modo esplicito l’ora di inizio e l’ora di fine dell’incontro, così da rendere immediata la tracciabilità del tempo dedicato alle attività organizzative.],
    [Per ogni task completato, l’autore dovrà indicare nel commit il numero di ore impiegate per la realizzazione del lavoro.],
  )

  Questa scelta ci auguriamo che consentirà al gruppo di mantenere una rendicontazione precisa e verificabile del tempo dedicato da ciascun membro, favorendo la trasparenza e una migliore pianificazione.
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
