#import "lib.typ": ROLES, activity, cite-norm, norm


/*
-Project Management,
-MEtodologia Agile ma mi sa sta già,
-Backlog
-SUb-task ?
- Conventional Commits?
- Velocity Chart
- Burndown chart
- Sprint ma penso sta già
- Pull-Request ?
*/
==== Jira
Jira è la piattaforma di Project Management selezionata dal gruppo NoTIP per adottare correttamente la metodologia
Agile. Lo strumento viene utilizzato per la pianificazione degli Sprint, la gestione del Backlog e il tracciamento delle
Task. Grazie all'integrazione con Git, Jira funge da punto centrale di controllo per garantire la tracciabilità tra le
attività e il codice prodotto.

===== Norme di Configurazione

Di seguito si elencano le varie norme legate al funzionamento di Jira.
#norm(
  title: "Identificazione",
  label: <identificazione>,
  level: 5,
  rationale: [Per quanto riguarda la chiave univoca delle Sub-task, esse vengono assegnate con i numeri immediatamente
    successivi al numero della Issue madre, quindi continuando l'esempio con NT-220, la Sub-task di Esecuzione sarà la
    221 e quella di Verifica la 222.
  ],
)[
  Ogni attività su Jira è una Issue con una chiave univoca (es. NT-220) e tale chiave viene assegnata automaticamente
  dal Sistema di Jira. Ogni task viene suddivisa in due Sub-task, una di Esecuzione ed una di Verifica:
  - Nell'Esecuzione vengono rendicontate le ore produttive che il membro del gruppo ha svolto per portare a termine la
    Task.
  - Nella Verifica un membro diverso dal precedente rendiconterà il tempo impiegato per la verifica del lavoro svolto.
]

#norm(
  title: "Workflow e Ciclo di vita",
  level: 5,
  label: <workflow>,
  rationale: [
    Per quanto riguarda le Sub-task, l'avvio e la chiusura delle Sub-task di Esecuzione innescano le transizioni verso
    'In Execution' e 'To Verify' della task madre.

    Invece per le Sub-task di Verifica, fanno passare la task madre da 'In Verification' con l'avvio della verifica, a
    'Completata' nel caso in cui la verifica non richiede modifiche e si chiude la sub-task, e a 'In Execution' se
    invece c'è bisogno di apportare modifiche.

    Questo meccanismo impone che una task non possa risultare "Completata" se non ha superato obbligatoriamente la fase
    di verifica.
  ],
)[
  Il ciclo di vita di ogni attività principale (*Task Madre*) è governato da un workflow che ne traccia l'evoluzione
  dalla presa in carico fino al completamento. Gli stati ammessi e le transizioni vincolanti sono rappresentati nel
  diagramma di riferimento @fig-workflow.

  #v(0.5em)
  #figure(
    image(height: 14.1%, "../assets/workflow.png"),
    caption: [Workflow operativo della Task Madre],
  ) <fig-workflow>
  #v(0.5em)
  Il percorso da seguire prevede le seguenti fasi:
  - *Da Completare*: Dove la task è stata creata ma non ancora avviata.
  - *In Execution*: La task è in fase di sviluppo.
  - *To Verify*: L'attività attende di essere verificata.
  - *In Verification*: L'attività è stata presa in carico dal verificatore.
  - *Completata*: L'attività ha superato la verifica e può considerarsi conclusa.
  - *Waiting*: Stato iniziale della Sub-Task di Verifica, che passa allo stato *Da Completare* solo quando la Sub-Task
    di Esecuzione passa allo stato *In Verification*
  Le transizioni invece sono:
  - *Create*: La task viene creata.
  - *Start Execution*: Inizia lo sviluppo della task.
  - *Discard Execution*: Regressione dallo stato 'In Execution' allo stato 'Da Completare'
  - *Submit*: Passaggio dalla fase esecutiva a quella di verifica.
  - *Start Verification*: Inizia l'attività di verifica del lavoro svolto.
  - *Discard Verification*: Regressione dallo stato 'In Verification' allo stato 'To Verify'
  - *Reject*: In caso di modifiche da apportare al lavoro svolto, la task retrocede dallo stato 'In Verification' allo
    stato 'Changes Requested', richiedendo un intervento da parte dell'autore prima di poter ritornare alla fase di
    verifica.
]

#norm(
  title: "Gestione delle Risorse",
  label: <gestione-risorse>,
  level: 5,
  rationale: [
    L'assegnazione singola e specifica del ruolo è indispensabile per la rendicontazione delle ore. Poiché ogni membro
    dovrà ricoprire più ruoli all'interno del progetto (o anche all'interno dello stesso sprint), l'etichetta permette
    di calcolare correttamente il consumo delle risorse rispetto al preventivo, e di rendicontare nella maniera corretta
    le ore di lavoro svolte.
  ],
)[
  Per la gestione delle risorse su Jira abbiamo deciso di avere:
  - *Assegnazione Singola:* Ogni entità (Task Madre o Sub-task) deve avere sempre un solo assegnatario. Non è corretto
    lasciare task in lavorazione (stati attivi diversi da 'Da Completare') senza un responsabile assegnato.
  - *Specifica del Ruolo:* È obbligatorio indicare il ruolo che il membro del gruppo ricopre durante lo svolgimento di
    quella specifica attività (es. `Programmatore`, `Verificatore`, `Analista`).
]

#norm(
  title: "Integrazione con Git",
  label: <integrazione-git>,
  level: 5,
  rationale: [
    L'inclusione dell'id nel messaggio di commit crea un collegamento automatico tra la Issue su Jira e il codice su
    GitHub (Smart Commits). Questo garantisce la tracciabilità bidirezionale: dalla Task è possibile risalire al codice
    che lo soddisfa, e dal codice è possibile risalire alla task che lo ha generato. Per ulteriori informazioni o esempi
    sui Conventional Commits si consiglia di visionare la seguente pagina #link(
      "https://www.conventionalcommits.org/en/v1.0.0/",
    )[*Conventional Commits*]
  ],
)[
  Jira riceve aggiornamenti diretti dal repository remoto. Per garantire il funzionamento del tracciamento, è necessario
  rispettare rigorosamente la nomenclatura:
  - *Branching:* Il nome di ogni branch deve contenere l'id del Task (es. NT-67-norme-di-progetto-v-1-0-0)
  - *Commit Message:* I messaggi devono seguire lo standard *Conventional Commits* e includere l'id del task nella
    seguente maniera:
  feature(auth): implementazione login NT-100.

  oppure

  fix(api): correzione timeout endpoint [NT-102].

]

#norm(
  title: "Dashboard e Metriche",
  level: 5,
  label: <jira-metriche>,
)[
  Jira è configurato per tracciare automaticamente le metriche di processo attraverso una *Dashboard di Progetto*
  condivisa. I principali indicatori monitorati sono:
  - *Distribuzione delle Ore:* Grafici a torta e tabelle che mostrano le ore assegnate per persona e per ruolo e in
    quali sprint sono state svolte. Questo permette di verificare il rispetto della rotazione dei ruoli e anche per
    capire quali sprint sono stati i più produttivi.

  - *Velocity Chart e Burndown Chart:* Il *Burndown Chart* confronta visivamente l'andamento ideale di consumo delle ore
    rispetto alle ore effettivamente consumate dal team, permettendo di identificare ritardi o anticipi rispetto alla
    scadenza. Il *Velocity Chart*, invece, storicizza la quantità di lavoro completata in ogni Sprint precedente,
    fornendo un dato medio fondamentale per stimare con precisione la capacità produttiva futura del team.
]

===== Attività operative

#activity(
  level: 5,
  title: "Creazione e Pianificazione",
  roles: (ROLES.aut, ROLES.ver),
  norms: ("identificazione", "gestione-risorse"),
  input: [Attività da svolgere da trasformare in Task],
  output: [Task correttamente realizzate e assegnate allo Sprint Backlog],
  procedure: (
    (
      name: "Creazione Task Madre",
      desc: [
        - Chiunque debba svolgere una qualsiasi attività è tenuto a creare la relativa Task madre nel Backlog e
          assegnarla allo Sprint corrente.
      ],
    ),
    (
      name: "Sub-Task",
      desc: [
        - Immediatamente per ogni Task madre verranno create e associate in maneira automatica le Sub-Task di Esecuzione
          e Verifica.
      ],
    ),
    (
      name: "Assegnazione",
      desc: [
        - A questo punto l'autore della task deve assegnare a se stesso la sub-task di Esecuzione e un altro membro del
          Team dovrà assegnarsi alla sub-task di Verifica.
        - Tutto questo deve sempre essere fatto assegnando correttamente la Label del ruolo che varia in base
          all'attività da svolgere.
      ],
    ),
    (
      name: "Stima temporale",
      desc: [
        - Bisogna anche inserire una stima realistica del tempo necessario per completare l'attività. La stima deve
          essere fatta distintamente sia per la Sub-Task di Esecuzione che per quella di Verifica.
      ],
    ),
    (
      name: "Avvio",
      desc: [
        - Adesso la Task sarà stata correttamente inizializzata e assegnata e nello stato '*Da Completare*'.
      ],
    ),
  ),
)

#activity(
  title: "Ciclo di Avanzamento",
  level: 5,
  roles: (ROLES.aut, ROLES.ver),
  norms: ("workflow", "integrazione-git"),
  input: [Task in stato '*Da Completare*'],
  output: [Task in stato '*Completata*'],
  procedure: (
    (
      name: "Sviluppo",
      desc: [
        - L'autore porta la Sub-Task di esecuzione nello stato '*In Execution*'
        - Crea il branch ed effettua i commit secondo le norme precedentemente descritte
        - Fa avanzare la Sub-Task allo stato '*In Verification*' e apre una Pull-Request su GitHub
        - Verifica che la Task Madre sia passata allo stato *To Verify* grazie alle automazioni.
      ],
    ),
    (
      name: "Verifica",
      desc: [
        - Prende in carico la Sub-Task di Verifica e fa avanzare allo stato '*In Corso*'
        - Se la verifica và a buon fine, anche su GitHub viene approvata la Pull-Request e questa Sub-Task viene fatta
          avanzare allo stato '*Completata*'.
        - Nel caso in cui siano richieste delle modifiche, allora il verificatore farà la Reject del lavoro svolto,
          mandando la Sub-Task di Esecuzione allo stato *Changes Requested*, e la Sub-Task di Verifica allo stato
          *Waiting*.
      ],
    ),
    (
      name: "Completamento",
      desc: [
        - Il verificatore completerà la Pull-Request su GitHub.
        - La Sub-Task di Verifica è *Completata*, e quindi anche la Sub-Task di Esecuzione passerà allo stesso stato,
          rendendo infine anche la Task madre completata.
      ],
    ),
  ),
  rationale: [
    Le transizioni della Task Madre sono automatiche. È tuttavia necessario attendere il completamento dell'automazione
    (visibile dall'aggiornamento dell'interfaccia) prima di considerare conclusa l'operazione, per evitare problemi di
    allineamento dovuti alla latenza di Jira.
  ],
)
