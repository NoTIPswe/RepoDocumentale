#import "lib.typ": ROLES, activity, cite-norm, norm

Per supportare le attività di gestione, sviluppo e coordinamento, il gruppo ha adottato il seguente set di strumenti:

- Telegram;
- Google Mail;
- Microsoft Teams e Zoom.
- Jira;
- Git e GitHub;
- Discord;

Di seguito si trovano le informazioni relative a ciascun strumento utilizzato.


== Norme e strumenti del processo di infrastruttura
=== Telegram
Telegram è un programma di messaggistica utilizzato dal Gruppo per aggiornarsi giornalmente sui progressi del Progetto e
per qualsiasi tipo di comunicazione, nel quale è anche possibile fissare i messaggi più importanti in un determinato
periodo.

=== Google Mail
Google Mail è il servizio di posta elettronico che il Team utilizza per gestire le comunicazioni esterne al Gruppo. A
tal proposito è stata creata una mail dedicata al team chiamata #link("mailto:notip.swe@gmail.com")[#raw(
  "notip.swe@gmail.com",
)]. \
All'interno di Google Mail è anche collegato un Calendario che registra in maniera autonoma a partire dalle Mail
ricevute i prossimi incontri a cui il Team dovrà partecipare.

=== Microsoft Teams

La piattaforma Microsoft Teams è lo strumento adottato per lo svolgimento degli incontri a distanza con l'azienda
proponente _M31_.

=== Zoom

Zoom è la piattaforma designata per i ricevimenti e la discussione dei *Diari di Bordo* con il docente referente (Prof.
Vardanega). Al fine di garantire l'indipendenza operativa dai singoli membri, il gruppo utilizza un'utenza condivisa,
registrata direttamente con l'indirizzo e-mail ufficiale del progetto.


=== Jira
Jira è la piattaforma di Project Management selezionata dal gruppo NoTIP per adottare correttamente la metodologia
Agile. Lo strumento viene utilizzato per la pianificazione degli Sprint, la gestione del Backlog e il tracciamento delle
Task. Grazie all'integrazione con Git, Jira funge da punto centrale di controllo per garantire la tracciabilità tra le
attività e il codice prodotto.

Di seguito si elencano le varie norme legate all'utilizzo di Jira.

#norm(
  title: "Identificazione",
  label: <identificazione-jira>,
  level: 5,
  rationale: [
    Sequenzialità degli ID: La creazione contestuale delle sub-task garantisce che esse ricevano identificativi
    immediatamente successivi alla Task Madre (es. Madre `NT-220` $->$ Esecuzione `NT-221`, Verifica `NT-222`),
    preservando l'ordine logico e visivo nel backlog.
  ],
)[
  Ogni attività censita su Jira è rappresentata da una *Issue* dotata di una chiave univoca assegnata automaticamente
  dal sistema (es. `NT-XXX`). Al fine di garantire una corretta rendicontazione temporale e la qualità del prodotto,
  ogni Task Madre deve essere scomposta in due sub-task distinte:

  - *Sub-task di Esecuzione:* Utilizzata per tracciare le ore produttive impiegate nello svolgimento dell'attività.
  - *Sub-task di Verifica:* Utilizzata per tracciare le ore impiegate nelle attività di controllo.
]

#norm(
  title: "Workflow e Ciclo di vita",
  level: 5,
  label: <workflow-jira>,
  rationale: [
    Sincronizzazione Automatica: L'evoluzione della Task Madre è guidata automaticamente dallo stato delle sue Sub-task
    (Esecuzione e Verifica), garantendo l'allineamento tra il lavoro svolto e lo stato riportato nel Project Management.
    \
    Quality Gate: Il workflow impone un vincolo bloccante: nessuna attività può raggiungere lo stato _Completata_ senza
    aver superato con successo la fase di verifica formale, garantendo la qualità del prodotto in uscita.
  ],
)[
  Il ciclo di vita di ogni attività (*Task Madre*) è governato da una macchina a stati finiti che ne traccia
  l'evoluzione dalla presa in carico fino al rilascio. Il diagramma di riferimento è riportato in @fig-workflow.

  #figure(
    image(height: 15%, "../assets/workflow.png"),
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
    di Esecuzione passa allo stato *In Verification*.
  - *Changes requested*: Stato della Sub-Task di Esecuzione raggiungibile soltanto se il Verificatore ha richiesto dei
    cambiamenti al lavoro svolto selezionando *Reject* nella Sub-Task di Verifica quando essa era nello stato *In
    Verification*. Richiede che l'Autore del documento ritorni alla fase *In Execution* per poter così apportare le
    modifiche richieste.
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
    )[*Conventional Commits*] o di rileggere la sezione @branching-commit-docs
  ],
)[
  Jira riceve aggiornamenti diretti dal repository remoto. Per garantire il funzionamento del tracciamento, è necessario
  rispettare rigorosamente la nomenclatura:
  - *Branching:* Il nome di ogni branch deve contenere l'id del Task (es. NT-67-norme-di-progetto-v-1-0-0)
  - *Commit Message:* I messaggi devono seguire lo standard #link(
      "https://www.conventionalcommits.org/en/v1.0.0/",
    )[*Conventional Commits*] e includere l'id del task.
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

=== Git <git-tool>

Git è lo strumento adottato dal gruppo per gestire il versionamento. Esso funge da "Single Source of Truth" per l'intero
ciclo di vita del prodotto, garantendo l'integrità, la tracciabilità e la disponibilità storica di ogni artefatto.
L'utilizzo di Git è strettamente vincolato all'hosting remoto su *GitHub*, che funge da repository centrale
autoritativo.


#norm(
  title: "Configurazione dell'Ambiente Locale",
  label: <git-config-env>,
  level: 5,
)[
  Ogni membro del team è tenuto a configurare il proprio ambiente locale prima del primo commit, rispettando i seguenti
  vincoli:

  Il ramo principale deve essere denominato `main` (e non `master`) per conformità con le policy del repository remoto.
]

#norm(
  title: "Politiche di Esclusione (.gitignore)",
  label: <git-ignore-policy>,
  level: 5,
  rationale: [
    Il versionamento di file binari generati, dipendenze scaricate o file di configurazione locali appesantisce il
    repository e crea conflitti non risolvibili.
  ],
)[
  È severamente vietato effettuare commit di file derivati o specifici dell'ambiente locale. Il repository deve
  contenere nella radice un file `.gitignore` condiviso che escluda tassativamente:
  - Cartelle di build e dist (es. `bin/`, `build/`, `dist/`);
  - Dipendenze esterne (es. `node_modules/`, `venv/`, `target/`);
  - File di configurazione (es. `.vscode/`, `.idea/`);
  - Credenziali o file `.env`.

  _Nota:_ Non utilizzare mai `git add --force` per aggirare queste regole senza previa approvazione del Responsabile.
]

=== GitHub <github-platform>

GitHub è la piattaforma selezionata per la gestione del repository Git e il supporto allo sviluppo collaborativo. Esso
permette la sincronizzazione del lavoro tra i membri del team, garantendo la disponibilità e l'integrità degli artefatti
di progetto.

L'adozione di GitHub è trasversale a diversi processi di supporto. Di seguito si riporta la mappatura delle funzionalità
della piattaforma sulle norme di progetto:

- *Collaborazione e Verifica (Pull Request):* GitHub abilita il lavoro asincrono tramite il meccanismo delle *Pull
  Request* (PR). Le PR costituiscono il punto di controllo obbligatorio (Quality Gate) per la revisione del codice e la
  risoluzione dei conflitti prima dell'integrazione nel ramo stabile. Il processo operativo di verifica tramite PR è
  dettagliato nella sezione @verifica-doc.

- *Organizzazione degli Artefatti:* La struttura delle directory ospitate sulla piattaforma non è arbitraria, ma deve
  rispecchiare fedelmente l'architettura informativa definita in @struttura-repo-docs.

- *Gestione della Configurazione:* Le politiche di interazione con il repository remoto, incluse le strategie di
  *branching* e la sintassi dei *commit messages*, devono conformarsi rigorosamente a quanto stabilito in
  @branching-commit-docs e nella norma di integrazione #cite-norm("integrazione-git").

=== Typst <typst-tool>

Typst è il sistema adottato per la redazione di tutta la documentazione. L'approccio *Docs as Code* garantisce coerenza
stilistica e validazione strutturale tramite l'uso di librerie e template condivisi.


#norm(
  title: "Libreria dei Processi (lib.typ)",
  label: <lib-typ-standard>,
  level: 5,
  rationale: [
    Standardizzazione: L'uso di funzioni dedicate per norme e attività vincola gli autori a definire tutti i metadati
    necessari (ruoli, input/output, tracciabilità), rendendo la documentazione conforme agli standard di qualità.
  ],
)[
  Il file `lib.typ` espone le primitive fondamentali per la stesura delle Norme di Progetto. È obbligatorio utilizzare
  le seguenti funzioni:

  - `#norm`: Definisce regole statiche o vincoli di progetto.
    - `title`: Identificativo univoco della norma.
    - `label`: Etichetta per i riferimenti incrociati (es. `<etichetta>`).
    - `rationale`: (Opzionale) Giustificazione o note esplicative che appariranno in un blocco "Note".

  - `#activity`: Definisce procedure operative e flussi di lavoro.
    - `roles`: Elenco dei ruoli coinvolti, da selezionare esclusivamente dal dizionario `ROLES` (es. `ROLES.anal`,
      `ROLES.ver`).
    - `input` / `output`: Descrizione degli artefatti in ingresso e uscita.
    - `norms`: Lista delle label delle norme citate (es. `("norma-1", "norma-2")`).
    - `procedure`: Array di oggetti contenenti `name` (nome del passo) e `desc` (descrizione operativa).
]

#norm(
  title: "Adozione dei Template",
  label: <templates-standard>,
  level: 5,
  rationale: [
    I template astraggono la formattazione e la struttura obbligatoria (front-matter, changelog, indici), permettendo
    agli autori di concentrarsi sul contenuto.
  ],
)[
  Ogni tipologia di documento deve estendere il relativo *base template* per garantire la presenza delle sezioni
  obbligatorie:
  - Documenti generici: Utilizzare `base_document.typ` per Analisi, Piani e Norme.
  - Verbali: Utilizzare `apply-base-verbale` da `base_verbale.typ`. La discussione deve essere strutturata tramite la
    funzione `report-point`, definendo esplicitamente `discussion`, `decisions` e `actions`.
  - Diari di Bordo: Utilizzare `apply-base-ddb` da `base_ddb.typ`, compilando le sezioni di risultati, obiettivi e
    difficoltà.
  - Presentazioni: Utilizzare `base_slides.typ` per le slide di avanzamento (SAL).
]

#norm(
  title: "Specifica tecnica dei Casi d'Uso",
  label: <uc-lib-standard>,
  level: 5,
)[
  La definizione dei Casi d'Uso è vincolata all'utilizzo della funzione `#uc` (libreria `uc_lib.typ`), che richiede
  obbligatoriamente `id` e `title` univoci, l'uso di costanti tipizzate per gli attori, la specifica degli scenari
  (`main-scen` e `alt-scen` con `cond`), il contratto (`preconds`/`postconds`) e l'importazione dei diagrammi UML
  tramite `#uml-schema`.
]

=== Discord
Discord è un programma di messaggistica utilizzato dal Gruppo per svolgere riunioni interne in modalità virtuale e anche
per lavorare insieme in chiamata sugli stessi documenti.

#norm(
  title: "Organizzazione dei Canali",
  label: <discord>,
  level: 5,
)[
  Il server è strutturato in diverse categorie:

  - *Discussions:* Categoria dedicata alle decisioni asincrone.
    - `tech`: Per dubbi su tecnologie, librerie e condivisione di snippet di codice;
    - `management`: Per scadenze, organizzazione informale o per raggruppare in un unico luogo considerazioni su unico
      argomento.

  - *Meetings:* Categoria per le riunioni.
    - Il canale testuale `meeting-notes` è riservato a brevi appunti o link condivisi durante la call.

  - *Cowork:* Canali vocali dedicati al lavoro di gruppo informale.
]



== Attività del processo
=== Jira
#activity(
  level: 5,
  title: "Creazione e Pianificazione",
  roles: (ROLES.aut, ROLES.ver),
  norms: ("identificazione-jira", "gestione-risorse"),
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
  norms: ("workflow-jira", "integrazione-git"),
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
        - Se la verifica va a buon fine, anche su GitHub viene approvata la Pull-Request e questa Sub-Task viene fatta
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

=== Git

#activity(
  title: "Setup iniziale dell'ambiente di versionamento",
  level: 5,
  roles: (ROLES.aut,), // Si applica a tutti gli sviluppatori/autori
  norms: ("git-config-env", "git-ignore-policy"),
  input: [Nuova postazione di lavoro o nuovo membro del team],
  output: [Ambiente Git configurato e repository clonato],
  procedure: (
    (
      name: "Installazione",
      desc: [Verificare l'installazione dell'ultima versione stabile di Git tramite il comando `git --version`.],
    ),
    (
      name: "Configurazione completa e Autenticazione",
      desc: [
        Eseguire in sequenza le configurazioni di identità, tecniche e di sicurezza:
        - Impostare nome e mail (uguale a GitHub):
          `git config --global user.name "Nome Cognome"`
          `git config --global user.email "email@dominio.it"`;
        - Generazion della chiave SSH.
      ],
    ),
    (
      name: "Cloning",
      desc: [Clonare il repository utilizzando la stringa di connessione SSH.],
    ),
  ),
)
