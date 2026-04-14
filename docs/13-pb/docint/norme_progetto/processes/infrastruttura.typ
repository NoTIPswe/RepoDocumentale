#import "lib.typ": ROLES, activity, cite-norm, norm

Per supportare le attività di gestione, sviluppo e coordinamento, il gruppo ha adottato il seguente set di strumenti:
Telegram, Google Mail, Microsoft Teams, Zoom, Jira, Git, GitHub, Discord, Typst e Google Sheets. Di seguito si trovano
le norme relative a ciascuno.

=== Norme e strumenti del processo di infrastruttura

#norm(title: "Strumenti di comunicazione", label: <strumenti-comunicazione>)[
  Il gruppo adotta i seguenti strumenti per la comunicazione:
  - *Telegram*: programma di messaggistica utilizzato per aggiornarsi giornalmente sui progressi del progetto e per
    qualsiasi tipo di comunicazione, nel quale è anche possibile fissare i messaggi più importanti in un determinato
    periodo. Il gruppo Telegram è stato inoltre suddiviso in sotto-canali dedicati ai diversi ruoli di progetto (ad
    esempio *Progettisti*, *Programmatori* e *Verificatori*), così da organizzare meglio le comunicazioni operative;
  - *Google Mail*: servizio di posta elettronica utilizzato per gestire le comunicazioni esterne al gruppo. A tal
    proposito è stata creata una mail dedicata al team chiamata #link("mailto:notip.swe@gmail.com")[#raw(
      "notip.swe@gmail.com",
    )]. All'interno di Google Mail è anche collegato un Calendario che registra in maniera autonoma a partire dalle mail
    ricevute i prossimi incontri a cui il team dovrà partecipare;
  - *Microsoft Teams*: piattaforma adottata per lo svolgimento degli incontri a distanza con l'azienda proponente _M31_;
  - *Zoom*: piattaforma designata per i ricevimenti e la discussione dei *Diari di Bordo* con il docente referente
    (Prof. Vardanega). Al fine di garantire l'indipendenza operativa dai singoli membri, il gruppo utilizza un'utenza
    condivisa, registrata direttamente con l'indirizzo e-mail ufficiale del progetto;
  - *Discord*: programma di messaggistica utilizzato per svolgere riunioni interne in modalità virtuale e anche per
    lavorare insieme in chiamata sugli stessi documenti.
]

#norm(title: "Strumenti di gestione e versionamento", label: <strumenti-gestione>)[
  Il gruppo adotta i seguenti strumenti per la gestione del progetto e il versionamento:
  - *Jira*: piattaforma di Project Management selezionata per adottare correttamente la metodologia Agile. Lo strumento
    viene utilizzato per la pianificazione degli Sprint, la gestione del Backlog e il tracciamento delle Task. Grazie
    all'integrazione con Git, Jira funge da punto centrale di controllo per garantire la tracciabilità tra le attività e
    il codice prodotto;
  - *Git*: strumento adottato per gestire il versionamento. Esso funge da "Single Source of Truth" per l'intero ciclo di
    vita del prodotto, garantendo l'integrità, la tracciabilità e la disponibilità storica di ogni artefatto. L'utilizzo
    di Git è strettamente vincolato all'hosting remoto su *GitHub*, che funge da repository centrale autoritativo;
  - *GitHub*: piattaforma selezionata per la gestione del repository Git e il supporto allo sviluppo collaborativo.
    Permette la sincronizzazione del lavoro tra i membri del team, garantendo la disponibilità e l'integrità degli
    artefatti di progetto.
]

#norm(title: "Utilizzo di GitHub", label: <github-platform>)[
  L'adozione di GitHub è trasversale a diversi processi di supporto. Di seguito si riporta la mappatura delle
  funzionalità della piattaforma sulle norme di progetto:
  - *Collaborazione e verifica (Pull Request):* GitHub abilita il lavoro asincrono tramite il meccanismo delle *Pull
    Request* (PR). Le PR costituiscono il punto di controllo obbligatorio (Quality Gate) per la revisione del codice e
    la risoluzione dei conflitti prima dell'integrazione nel ramo stabile. Il processo operativo di verifica tramite PR
    è dettagliato nella sezione #link(<verifica-doc>)[@verifica-doc];
  - *Organizzazione degli Artefatti:* La struttura delle directory ospitate sulla piattaforma non è arbitraria, ma deve
    rispecchiare fedelmente l'architettura informativa definita in #link(<struttura-repo-docs>)[@struttura-repo-docs];
  - *Gestione della Configurazione:* Le politiche di interazione con il repository remoto, incluse le strategie di
    *branching* e la sintassi dei *commit messages*, devono conformarsi rigorosamente a quanto stabilito in #link(
      <branching-commit-docs>,
    )[@branching-commit-docs] e nella norma di integrazione #cite-norm("integrazione-git").
]

#norm(title: "Strumenti di documentazione", label: <strumenti-documentazione>)[
  Il gruppo adotta *Typst* come sistema per la redazione di tutta la documentazione. L'approccio *Docs as Code*
  garantisce coerenza stilistica e validazione strutturale tramite l'uso di librerie e template condivisi.
]

#norm(title: "Strumenti per la raccolta e l'analisi delle metriche", label: <strumenti-metriche>)[
  Gli strumenti di raccolta e analisi delle metriche si dividono in due livelli distinti:

  *Metriche di processo e di prodotto* (pianificazione, qualità documentale, avanzamento Sprint):
  - *Google Sheets*: centro di inserimento, classificazione e storicizzazione delle metriche di processo e di prodotto.
    I dati vengono elaborati tramite script automatici e aggregati in grafici per i report di qualità;
  - *Git e GitHub*: interrogati per estrarre metriche di sviluppo (es. qualità dei commit, tempi di risoluzione delle
    Pull Request), i cui risultati vengono aggregati su Google Sheets.

  *Metriche applicative e di sistema* (osservabilità del prodotto a runtime):
  - *Prometheus*: raccoglie in modalità pull le metriche esposte dai singoli microservizi e dall'infrastruttura NATS. La
    configurazione dei target di scraping è versionata in `notip-infra/infra/monitoring/prometheus/`;
  - *Grafana*: visualizza le metriche raccolte da Prometheus tramite dashboard pre-configurate e versionare in
    `notip-infra/infra/monitoring/grafana/` (es. `nats-overview.json`). Costituisce il pannello di controllo principale
    per verificare la salute del sistema distribuito in tempo reale.
]

#norm(
  title: "Identificazione Jira",
  label: <identificazione-jira>,
  rationale: [
    Sequenzialità degli ID: La creazione contestuale delle sub-task garantisce che esse ricevano identificativi
    immediatamente successivi alla Task Madre (es. Madre `NT-220` $->$ Esecuzione `NT-221`, Verifica `NT-222`),
    preservando l'ordine logico e visivo nel backlog.
  ],
)[
  Ogni attività censita su Jira è rappresentata da una *Issue* dotata di una chiave univoca assegnata automaticamente
  dal sistema (es. `NT-XXX`). Al fine di garantire una corretta rendicontazione temporale e la qualità del prodotto,
  ogni Task Madre deve essere scomposta in due sub-task distinte:
  - *Sub-task di Esecuzione:* utilizzata per tracciare le ore produttive impiegate nello svolgimento dell'attività;
  - *Sub-task di Verifica:* utilizzata per tracciare le ore impiegate nelle attività di controllo.
]

#norm(
  title: "Workflow e ciclo di vita Jira",
  label: <workflow-jira>,
  rationale: [
    Sincronizzazione automatica: l'evoluzione della task madre è guidata automaticamente dallo stato delle sue sub-task
    (Esecuzione e Verifica), garantendo l'allineamento tra il lavoro svolto e lo stato riportato nel Project Management.

    Quality Gate: il workflow impone un vincolo bloccante: nessuna attività può raggiungere lo stato _Completata_ senza
    aver superato con successo la fase di verifica formale, garantendo la qualità del prodotto in uscita.
  ],
)[
  Il ciclo di vita di ogni attività (*task madre*) è governato da una macchina a stati finiti che ne traccia
  l'evoluzione dalla presa in carico fino al rilascio. Il diagramma di riferimento è riportato in #link(
    <fig-workflow>,
  )[@fig-workflow].

  #figure(
    image(height: 14%, "../assets/workflow.png"),
    caption: [Workflow operativo della task madre],
  ) <fig-workflow>
  #v(0.5em)

  Il percorso da seguire prevede le seguenti fasi:
  - *Da Completare*: dove la task è stata creata ma non ancora avviata;
  - *In Execution*: la task è in fase di sviluppo;
  - *To Verify*: l'attività attende di essere verificata;
  - *In Verification*: l'attività è stata presa in carico dal verificatore;
  - *Completata*: l'attività ha superato la verifica e può considerarsi conclusa;
  - *Waiting*: stato iniziale della sub-task di Verifica, che passa allo stato *Da Completare* solo quando la sub-task
    di Esecuzione passa allo stato *In Verification*;
  - *Changes requested*: stato della sub-task di Esecuzione raggiungibile soltanto se il Verificatore ha richiesto dei
    cambiamenti al lavoro svolto selezionando *Reject* nella sub-task di Verifica quando essa era nello stato *In
    Verification*. Richiede che l'autore del documento ritorni alla fase *In Execution* per poter così apportare le
    modifiche richieste.

  Le transizioni invece sono:
  - *Create*: la task viene creata;
  - *Start Execution*: inizia lo sviluppo della task;
  - *Discard Execution*: regressione dallo stato 'In Execution' allo stato 'Da Completare';
  - *Submit*: passaggio dalla fase esecutiva a quella di verifica;
  - *Start Verification*: inizia l'attività di verifica del lavoro svolto;
  - *Discard Verification*: regressione dallo stato 'In Verification' allo stato 'To Verify';
  - *Reject*: in caso di modifiche da apportare al lavoro svolto, la task retrocede dallo stato 'In Verification' allo
    stato 'Changes Requested', richiedendo un intervento da parte dell'autore prima di poter ritornare alla fase di
    verifica.
]

#norm(
  title: "Gestione delle risorse Jira",
  label: <gestione-risorse>,
  rationale: [
    L'assegnazione singola e specifica del ruolo è indispensabile per la rendicontazione delle ore. Poiché ogni membro
    dovrà ricoprire più ruoli all'interno del progetto (o anche all'interno dello stesso sprint), l'etichetta permette
    di calcolare correttamente il consumo delle risorse rispetto al preventivo, e di rendicontare nella maniera corretta
    le ore di lavoro svolte.
  ],
)[
  Per la gestione delle risorse su Jira abbiamo deciso di avere:
  - *Assegnazione singola:* ogni entità (task madre o sub-task) deve avere sempre un solo assegnatario. Non è corretto
    lasciare task in lavorazione (stati attivi diversi da 'Da Completare') senza un responsabile assegnato;
  - *Specifica del ruolo:* è obbligatorio indicare il ruolo che il membro del gruppo ricopre durante lo svolgimento di
    quella specifica attività (es. `Programmatore`, `Verificatore`, `Analista`).
]

#norm(
  title: "Integrazione Jira-Git",
  label: <integrazione-git>,
  rationale: [
    L'inclusione dell'id nel messaggio di commit crea un collegamento automatico tra la Issue su Jira e il codice su
    GitHub (Smart Commits). Questo garantisce la tracciabilità bidirezionale: dalla Task è possibile risalire al codice
    che lo soddisfa, e dal codice è possibile risalire alla task che lo ha generato. Per ulteriori informazioni o esempi
    sui Conventional Commits si consiglia di visionare la seguente pagina #link(
      "https://www.conventionalcommits.org/en/v1.0.0/",
    )[*Conventional Commits*] o di rileggere la #link(<branching-commit-docs>)[@branching-commit-docs].
  ],
)[
  Jira riceve aggiornamenti diretti dal repository remoto. Per garantire il funzionamento del tracciamento, è necessario
  rispettare rigorosamente la nomenclatura:
  - *Branching:* il nome di ogni branch deve contenere l'id del task (es. `NT-67-norme-di-progetto-v-1-0-0`);
  - *Commit Message:* i messaggi devono seguire lo standard #link(
      "https://www.conventionalcommits.org/en/v1.0.0/",
    )[*Conventional Commits*] e includere l'id del task.
]

#norm(title: "Dashboard e metriche Jira", label: <jira-metriche>)[
  Jira è configurato per tracciare automaticamente le metriche di processo attraverso una *Dashboard di progetto*
  condivisa. I principali indicatori monitorati sono:
  - *Distribuzione delle ore:* grafici a torta e tabelle che mostrano le ore assegnate per persona e per ruolo e in
    quali sprint sono state svolte. Questo permette di verificare il rispetto della rotazione dei ruoli e anche per
    capire quali sprint sono stati i più produttivi;
  - *Velocity Chart e Burndown Chart:* il *Burndown Chart* confronta visivamente l'andamento ideale di consumo delle ore
    rispetto alle ore effettivamente consumate dal team, permettendo di identificare ritardi o anticipi rispetto alla
    scadenza. Il *Velocity Chart*, invece, storicizza la quantità di lavoro completata in ogni sprint precedente,
    fornendo un dato medio fondamentale per stimare con precisione la capacità produttiva futura del team.
]

#norm(
  title: "Configurazione dell'ambiente locale Git",
  label: <git-config-env>,
)[
  Ogni membro del team è tenuto a configurare il proprio ambiente locale prima del primo commit, rispettando i seguenti
  vincoli:

  Il ramo principale deve essere denominato `main` (e non `master`) per conformità con le policy del repository remoto.
]

#norm(
  title: "Politiche di esclusione (.gitignore)",
  label: <git-ignore-policy>,
  rationale: [
    Il versionamento di file binari generati, dipendenze scaricate o file di configurazione locali appesantisce il
    repository e crea conflitti non risolvibili.
  ],
)[
  È severamente vietato effettuare commit di file derivati o specifici dell'ambiente locale. Il repository deve
  contenere nella radice un file `.gitignore` condiviso che escluda tassativamente:
  - cartelle di build e dist (es. `bin/`, `build/`, `dist/`);
  - dipendenze esterne (es. `node_modules/`, `venv/`, `target/`);
  - file di configurazione (es. `.vscode/`, `.idea/`);
  - credenziali o file `.env`.

  _Nota:_ non utilizzare mai `git add --force` per aggirare queste regole senza previa approvazione del Responsabile.
]

#norm(
  title: "Libreria dei processi (lib.typ)",
  label: <lib-typ-standard>,
  rationale: [
    Standardizzazione: l'uso di funzioni dedicate per norme e attività vincola gli autori a definire tutti i metadati
    necessari (ruoli, input/output, tracciabilità), rendendo la documentazione conforme agli standard di qualità.
  ],
)[
  Il file `lib.typ` espone le primitive fondamentali per la stesura delle Norme di Progetto. È obbligatorio utilizzare
  le seguenti funzioni:
  - `#norm`: definisce regole statiche o vincoli di progetto.
    - `title`: identificativo univoco della norma;
    - `label`: etichetta per i riferimenti incrociati (es. `<etichetta>`);
    - `rationale`: (opzionale) giustificazione o note esplicative che appariranno in un blocco "Note".
  - `#activity`: definisce procedure operative e flussi di lavoro.
    - `roles`: elenco dei ruoli coinvolti, da selezionare esclusivamente dal dizionario `ROLES` (es. `ROLES.anal`,
      `ROLES.ver`);
    - `input` / `output`: descrizione degli artefatti in ingresso e uscita;
    - `norms`: lista delle label delle norme citate (es. `("norma-1", "norma-2")`);
    - `procedure`: array di oggetti contenenti `name` (nome del passo) e `desc` (descrizione operativa).
]

#norm(
  title: "Adozione dei template Typst",
  label: <templates-standard>,
  rationale: [
    I template astraggono la formattazione e la struttura obbligatoria (front-matter, changelog, indici), permettendo
    agli autori di concentrarsi sul contenuto.
  ],
)[
  Ogni tipologia di documento deve estendere il relativo *base template* per garantire la presenza delle sezioni
  obbligatorie:
  - Documenti generici: utilizzare `base_document.typ` per Analisi, Piani e Norme;
  - Verbali: utilizzare `apply-base-verbale` da `base_verbale.typ`. La discussione deve essere strutturata tramite la
    funzione `report-point`, definendo esplicitamente `discussion`, `decisions` e `actions`;
  - Diari di Bordo: utilizzare `apply-base-ddb` da `base_ddb.typ`, compilando le sezioni di risultati, obiettivi e
    difficoltà;
  - Presentazioni: utilizzare `base_slides.typ` per le slide di avanzamento (SAL).
]

#norm(title: "Specifica tecnica degli Use Case", label: <uc-lib-standard>)[
  La definizione dei Casi d'Uso è vincolata all'utilizzo della funzione `#uc` (libreria `uc_lib.typ`), che richiede
  obbligatoriamente `id` e `title` univoci, l'uso di costanti tipizzate per gli attori, la specifica degli scenari
  (`main-scen` e `alt-scen` con `cond`), il contratto (`preconds`/`postconds`) e l'importazione dei diagrammi UML
  tramite `#uml-schema`.
]

#norm(title: "Organizzazione dei canali Discord", label: <discord>)[
  Il server è strutturato in diverse categorie:
  - *Discussions:* categoria dedicata alle decisioni asincrone.
    - `tech`: per dubbi su tecnologie, librerie e condivisione di snippet di codice;
    - `management`: per scadenze, organizzazione informale o per raggruppare in un unico luogo considerazioni su unico
      argomento.
  - *Meetings:* categoria per le riunioni.
    - Il canale testuale `meeting-notes` è riservato a brevi appunti o link condivisi durante la call.
  - *Cowork:* canali vocali dedicati al lavoro di gruppo informale.
]

#norm(title: "Manutenzione dell'infrastruttura", label: <manutenzione-infrastruttura>)[
  A causa del continuo avanzamento del progetto, il gruppo è consapevole che l'infrastruttura subirà nel tempo
  cambiamenti e potrebbe causare possibili problemi. Per questo spetta all'amministratore il compito della manutenzione,
  aggiornando le funzionalità qualora errori o cambiamenti lo rendano necessario.
]

#norm(
  title: "DevContainers",
  label: <devcontainers>,
  rationale: [
    *Zero Onboarding*: i nuovi sviluppatori non devono installare Node, Go o configurare variabili d'ambiente sul
    proprio sistema. È sufficiente clonare la repository e aprire l'IDE.

    *Consistenza*: elimina definitivamente il problema "sul mio computer funziona". Tutto il team utilizza lo stesso
    identico ambiente.

    *Ambienti puliti*: le dipendenze rimangono confinate nel container, senza inquinare il sistema operativo host.
  ],
)[
  Il gruppo adotta DevContainers per garantire isolamento, portabilità e riproducibilità degli ambienti di sviluppo.

  *Organizzazione (centralizzazione e specializzazione)*

  In `notip-infra/devcontainers/` sono definiti i Dockerfile base per stack tecnologico: uno per NestJS, uno per
  Angular, uno per Go.

  Ogni repository (o singolo servizio nel caso del monorepo `notip-infra`) ha il proprio file
  `.devcontainer/devcontainer.json`, che estende l'immagine base di `notip-infra` iniettando tool specifici, permessi
  utente e le estensioni IDE necessarie per quel particolare dominio.

  I Dockerfile base e i file `devcontainer.json` sono elementi di configurazione soggetti a versionamento (vedi #link(
    <config-items>,
  )[@config-items]). La manutenzione dei Dockerfile base in `notip-infra` è responsabilità dell'amministratore, in
  coerenza con quanto definito nella #link(<manutenzione-infrastruttura>)[@manutenzione-infrastruttura].

  *Architettura Multi-Stage dei Dockerfile base*

  I Dockerfile base sono strutturati a strati (multi-stage) per ottimizzare i pesi e separare le responsabilità:
  - `base`: fondamenta comuni, contenente il sistema operativo e il runtime del linguaggio (es. Node o Go);
  - `dev`: utilizzato dallo sviluppatore tramite DevContainer e dalla CI di validazione (test e linting). Contiene le
    devDependencies e i tool di sistema (git, curl). Il codice sorgente non fa parte dell'immagine, ma viene montato
    dinamicamente come volume;
  - `builder`: utilizzato esclusivamente dalla CI di rilascio. È l'ambiente in cui viene copiato il codice sorgente per
    essere compilato (es. transpile TypeScript → JavaScript o build binario Go);
  - `prod`: utilizzato dai server in produzione. È l'artefatto finale immutabile, privo dei tool di sviluppo del livello
    `dev` e del codice sorgente del livello `builder`. Contiene solo il compilato e le dipendenze di runtime
    strettamente necessarie.

  Per il setup dell'ambiente DevContainer da parte di ogni sviluppatore si rimanda alla #link(
    <setup-devcontainer>,
  )[@setup-devcontainer].
]

#norm(
  title: "Container registry (GHCR)",
  label: <ghcr>,
)[
  Il gruppo utilizza *GitHub Container Registry (GHCR)* come registry per le immagini Docker dei servizi applicativi. La
  scelta è motivata dalla semplicità di integrazione con GitHub Actions e dall'assenza di quote sui pull, a differenza
  di Docker Hub.

  I servizi applicativi eseguono il push automatico delle proprie immagini su GHCR ad ogni merge su `main`. Il
  repository `notip-infra` seleziona le versioni delle immagini da comporre e le avvia tramite le logiche di deploy e
  orchestrazione.

  La documentazione relativa alla build e al publish delle immagini dev è disponibile in
  `notip-infra/containers/README.md`.
]

#norm(
  title: "Processo di build e rilascio dei servizi",
  label: <build-release-process>,
  rationale: [
    *Manutenzione centralizzata (Single Source of Truth)*: se è necessario aggiornare la versione di un linguaggio (es.
    un aggiornamento di sicurezza di Node.js o Go), basta modificare un solo file in `notip-infra`. Tutti i microservizi
    erediteranno automaticamente il miglioramento alla loro successiva build, senza dover aggiornare decine di
    repository.

    *Zero Duplicazioni (DRY)*: le logiche infrastrutturali vivono esclusivamente nel repository dell'infrastruttura,
    evitando la duplicazione delle istruzioni di compilazione in ogni servizio.

    *Autonomia e isolamento*: il repository centrale non accede al codice né conosce la logica di business dei
    microservizi. Ogni servizio rimane indipendente e decide autonomamente quando avviare la propria pipeline di
    rilascio.

    *Consistenza assoluta*: tutti i servizi basati sulla stessa tecnologia vengono impacchettati, ottimizzati e messi in
    sicurezza nello stesso identico modo, azzerando discrepanze e comportamenti anomali in produzione.
  ],
)[
  Per la build e il rilascio dei servizi vengono utilizzate le immagini definite dai Dockerfile base contenuti in
  `notip-infra/containers/`, separate per tecnologia. Durante la fase di rilascio tramite CI/CD, la pipeline di ogni
  singolo microservizio utilizza il Dockerfile centralizzato di `notip-infra` come ricetta, applicandola al proprio
  codice sorgente per generare l'artefatto finale pronto per la produzione.

  I Dockerfile base in `notip-infra/containers/` sono elementi di configurazione soggetti a versionamento (vedi #link(
    <config-items>,
  )[@config-items]). La manutenzione di questi Dockerfile è responsabilità dell'amministratore, in coerenza con quanto
  definito nella #link(<manutenzione-infrastruttura>)[@manutenzione-infrastruttura].

  Per la norma sul pin delle versioni dei tool e delle immagini base si rimanda alla #link(
    <pin-versioni>,
  )[@pin-versioni]. Per la gestione del container registry si rimanda alla #link(<ghcr>)[@ghcr].
]

#norm(
  title: "Gateway di rete (Nginx)",
  label: <nginx-gateway>,
)[
  *Nginx* è l'unico punto d'ingresso autorizzato per il traffico esterno verso i microservizi. L'accesso diretto ai
  servizi interni bypassando il gateway è vietato in qualsiasi ambiente (sviluppo, CI, produzione).

  Le responsabilità di Nginx sono:
  - *Routing*: smistamento delle richieste in ingresso verso il microservizio appropriato in base alle regole di
    location configurate;
  - *Terminazione TLS*: gestione del certificato SSL/TLS al bordo della rete, in modo che i servizi interni comunichino
    in chiaro sulla rete privata del cluster;
  - *Iniezione degli header di sicurezza*: applicazione delle direttive definite in `security-headers.conf` (es.
    `Strict-Transport-Security`, `X-Frame-Options`, `Content-Security-Policy`) a tutte le risposte in uscita.

  La configurazione è versionata in `notip-infra/infra/nginx/` ed è soggetta alle regole GitOps definite nella #link(
    <gitops-infra>,
  )[@gitops-infra].
]

=== Attività del processo

#activity(
  title: "Creazione e pianificazione task su Jira",
  roles: (ROLES.aut, ROLES.ver),
  norms: ("identificazione-jira", "gestione-risorse"),
  input: [Attività da svolgere da trasformare in Task],
  output: [Task correttamente realizzate e assegnate allo Sprint Backlog],
  procedure: (
    (
      name: "Creazione task madre",
      desc: [
        Chiunque debba svolgere una qualsiasi attività è tenuto a creare la relativa task madre nel Backlog e assegnarla
        allo sprint corrente.
      ],
    ),
    (
      name: "Sub-task",
      desc: [
        Immediatamente per ogni task madre verranno create e associate in maniera automatica le sub-task di Esecuzione e
        Verifica.
      ],
    ),
    (
      name: "Assegnazione",
      desc: [
        A questo punto l'autore della task deve assegnare a se stesso la sub-task di Esecuzione e un altro membro del
        team dovrà assegnarsi alla sub-task di Verifica. Tutto questo deve sempre essere fatto assegnando correttamente
        la label del ruolo che varia in base all'attività da svolgere.
      ],
    ),
    (
      name: "Stima temporale",
      desc: [
        Bisogna anche inserire una stima realistica del tempo necessario per completare l'attività. La stima deve essere
        fatta distintamente sia per la sub-task di Esecuzione che per quella di Verifica.
      ],
    ),
    (
      name: "Avvio",
      desc: [
        Adesso la Task sarà stata correttamente inizializzata, assegnata e nello stato *Da Completare*.
      ],
    ),
  ),
)

#activity(
  title: "Ciclo di avanzamento task su Jira",
  roles: (ROLES.aut, ROLES.ver),
  norms: ("workflow-jira", "integrazione-git"),
  input: [Task in stato *Da Completare*],
  output: [Task in stato *Completata*],
  rationale: [
    Le transizioni della task madre sono automatiche. È tuttavia necessario attendere il completamento dell'automazione
    (visibile dall'aggiornamento dell'interfaccia) prima di considerare conclusa l'operazione, per evitare problemi di
    allineamento dovuti alla latenza di Jira.
  ],
  procedure: (
    (
      name: "Sviluppo",
      desc: [
        L'autore porta la sub-task di esecuzione nello stato *In Execution*, crea il branch ed effettua i commit secondo
        le norme precedentemente descritte, fa avanzare la sub-task allo stato *In Verification* e apre una Pull-Request
        su GitHub. Verifica che la task madre sia passata allo stato *To Verify* grazie alle automazioni.
      ],
    ),
    (
      name: "Verifica",
      desc: [
        Prende in carico la sub-task di Verifica e fa avanzare allo stato *In Corso*. Se la verifica va a buon fine,
        anche su GitHub viene approvata la Pull-Request e questa sub-task viene fatta avanzare allo stato *Completata*.
        Nel caso in cui siano richieste delle modifiche, allora il verificatore farà la Reject del lavoro svolto,
        mandando la sub-task di Esecuzione allo stato *Changes Requested*, e la sub-task di Verifica allo stato
        *Waiting*.
      ],
    ),
    (
      name: "Completamento",
      desc: [
        Il verificatore completerà la Pull-Request su GitHub. La sub-task di Verifica è *Completata*, e quindi anche la
        sub-task di Esecuzione passerà allo stesso stato, rendendo infine anche la task madre completata.
      ],
    ),
  ),
)

#activity(
  title: "Setup iniziale dell'ambiente di versionamento",
  label: <setup-ambiente-versionamento>,
  roles: (ROLES.aut,),
  norms: ("git-config-env", "git-ignore-policy"),
  input: [Nuova postazione di lavoro o nuovo membro del team],
  output: [Ambiente Git configurato e repository clonato],
  rationale: [Per il setup dell'ambiente di sviluppo isolato tramite DevContainer, da eseguire contestualmente, si
    rimanda alla #link(<setup-devcontainer>)[@setup-devcontainer].],
  procedure: (
    (
      name: "Installazione",
      desc: [
        Verificare l'installazione dell'ultima versione stabile di Git tramite il comando `git --version`.
      ],
    ),
    (
      name: "Configurazione completa e autenticazione",
      desc: [
        Eseguire in sequenza le configurazioni di identità, tecniche e di sicurezza:
        - impostare nome e mail (uguale a GitHub):
          `git config --global user.name "Nome Cognome"`
          `git config --global user.email "email@dominio.it"`;
        - generazione della chiave SSH.
      ],
    ),
    (
      name: "Cloning",
      desc: [Clonare il repository utilizzando la stringa di connessione SSH.],
    ),
  ),
)

#activity(
  title: "Setup dell'ambiente DevContainer",
  label: <setup-devcontainer>,
  roles: (ROLES.progr, ROLES.proge),
  norms: ("devcontainers", "gestione-segreti", "pre-commit-hooks"),
  input: [Nuova postazione di lavoro o nuovo membro del team],
  output: [Ambiente di sviluppo isolato, riproducibile e funzionante],
  procedure: (
    (
      name: "Prerequisiti",
      desc: [
        Verificare l'installazione di Docker e dell'IDE con supporto DevContainers (es. VS Code con l'estensione Dev
        Containers).
      ],
    ),
    (
      name: "Clone della repository",
      desc: [
        Clonare il repository di riferimento secondo le istruzioni della
        #link(<setup-ambiente-versionamento>)[@setup-ambiente-versionamento]
      ],
    ),
    (
      name: "Apertura nel DevContainer",
      desc: [
        Aprire la directory della repository nell'IDE e accettare il prompt di riapertura nel DevContainer. L'IDE
        scarica automaticamente l'immagine base da `notip-infra` e configura l'ambiente.
      ],
    ),
    (
      name: "Configurazione dell'ambiente",
      desc: [
        Copiare il file `.env.example` in `.env` e popolarlo con i valori locali di sviluppo. Per la politica di
        gestione dei segreti si rimanda alla #link(<gestione-segreti>)[@gestione-segreti].
      ],
    ),
    (
      name: "Verifica",
      desc: [
        Assicurarsi che l'ambiente sia operativo eseguendo il comando di verifica previsto dal `README.md` della
        repository.
      ],
    ),
    (
      name: "Installazione Pre-commit Hooks",
      desc: [
        Installare e attivare gli hook locali eseguendo `pre-commit install` nella radice della repository. Per la norma
        di riferimento si rimanda alla #link(<pre-commit-hooks>)[@pre-commit-hooks].
      ],
    ),
  ),
)

#activity(
  title: "Bootstrapping dell'ambiente locale",
  label: <bootstrapping-locale>,
  roles: (ROLES.progr, ROLES.proge),
  norms: ("devcontainers", "gitops-infra"),
  input: [Nuova postazione di lavoro o primo avvio del cluster locale],
  output: [Cluster di microservizi operativo in locale con stream NATS e database inizializzati],
  rationale: [
    I dettagli dei comandi specifici (es. `bootstrap.sh`, `nats-streams-init.sh`) sono documentati nel `README.md` di
    `notip-infra` e non vengono duplicati qui.
  ],
  procedure: (
    (
      name: "Prerequisiti",
      desc: [
        Verificare che Docker sia installato e in esecuzione e che il DevContainer della repository sia operativo (vedi
        #link(<setup-devcontainer>)[@setup-devcontainer]).
      ],
    ),
    (
      name: "Avvio del cluster",
      desc: [
        Eseguire gli script di bootstrapping forniti in `notip-infra` secondo le istruzioni del `README.md`. Gli script
        avviano i container dei microservizi tramite Docker Compose, inizializzano gli stream NATS JetStream e applicano
        le migrazioni del database.
      ],
    ),
    (
      name: "Verifica",
      desc: [
        Verificare che tutti i servizi siano raggiungibili e che gli stream NATS siano stati creati correttamente prima
        di iniziare qualsiasi attività di sviluppo.
      ],
    ),
  ),
)
