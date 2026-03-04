#import "lib.typ": ROLES, activity, cite-norm, norm

== Processo di documentazione

Il *processo di documentazione* ha lo scopo di registrare informazioni che derivano da un processo o ciclo di vita. La
documentazione ha l'obiettivo di tracciare storicamente ed in modo preciso tutte le decisioni intraprese durante lo
svolgimento del progetto.

=== Norme e strumenti del processo di documentazione

#norm(
  title: "Ciclo di vita e versionamento dei documenti",
  rationale: [
    *Differenza tra verifica e approvazione:* La verifica controlla la correttezza tecnica puntuale. L'approvazione è un
    atto formale che dichiara il documento "pronto" e stabile per gli scopi della Milestone corrente. Separare questi
    momenti permette di tracciare chi ha controllato la correttezza (Verificatore) e chi si è assunto la responsabilità
    del rilascio formale (Responsabile).
  ],
  label: <ciclo-vita-docs>,
)[
  #figure(
    image(height: 50%, "../assets/ciclo_vita_docs.png"),
    caption: [Diagramma degli stati del ciclo di vita documentale],
    placement: bottom,
  ) <ciclo_vita_docs>

  Il ciclo di vita di un documento prevede tre stati fondamentali mappati sul branch in cui si trova il file:

  - *In lavorazione* (Branch di feature): Il documento è in fase di stesura o modifica. La versione è provvisoria;
  - *Verificato* (Branch `main`): Il documento ha superato la revisione tecnica (PR) ed è stato integrato. È stabile ma
    non necessariamente rilasciato;
  - *Approvato* (Branch `main`): Il documento corrisponde a una Baseline ufficiale. Richiede l'approvazione esplicita
    del Responsabile.

  @ciclo_vita_docs raffigura un diagramma del ciclo di vita dei documenti.

  #heading(level: 5, numbering: none, outlined: false)[Standard di versionamento (SemVer)]
  L'avanzamento di versione segue lo standard `X.Y.Z` in base alla natura delle modifiche:

  #table(
    columns: (auto, auto, 1fr),
    align: (center, center, left),
    table.header([Componente], [Tipo], [Descrizione e Criterio]),
    [*Z*], [Patch], [Correzione di refusi o formattazione. \ _Azione:_ Verifica (Peer Review).],
    [*Y*], [Minor], [Aggiunta o modifica di contenuti sostanziali. \ _Azione:_ Verifica (Peer Review).],
    [*X*], [Major], [Approvazione del documento come versione stabile. \ _Azione:_ Approvazione del Responsabile.],
  )
]

#norm(
  title: "Struttura del repository",
  rationale: [
    *Perché dividere un documento in subfiles?* Separare il contenuto in file più piccoli all'interno di una cartella
    riduce drasticamente la probabilità di conflitti Git quando più persone lavorano sullo stesso documento.

    *Perché l'organizzazione semantica?* La struttura delle cartelle rispecchia la struttura del sito web pubblicato,
    facilitando la navigazione e permettendo agli script di generare il sito statico senza configurazioni aggiuntive.
  ],
  label: <struttura-repo-docs>,
)[
  Il #link("https://github.com/NoTIPswe/NoTIPswe.github.io")[repository] segue il paradigma Convention Over
  Configuration. La posizione dei file nel file system fornisce metadati impliciti necessari alla validazione e
  pubblicazione.

  #heading(level: 5, numbering: none, outlined: false)[Alberatura del progetto]
  Di seguito è riportata la struttura di riferimento del repository:
  ```
  .
  ├── .schemas/               # schemi JSON per validazione metadati
  ├── docs/                   # sorgenti della documentazione
  │   ├── 00-common_assets/   # risorse condivise (loghi, icone)
  │   └── {milestone}/        # raggruppamento per baseline (es. 12-rtb)
  │       ├── 00-templates/   # template Typst per baseline
  │       ├── {subgroup}/     # classificazione (docint, docest, verbali...)
  │       │   └── {doc}/      # directory del singolo documento
  │       │       ├── assets/         # (opzionale) immagini specifiche
  │       │       ├── {subfiles}/     # (consigliato) capitoli/sezioni .typ
  │       │       ├── {doc}.typ       # entry point di compilazione
  │       │       └── {doc}.meta.yaml # metadati del documento
  ├── notipdo/                # tool Python per automazione e CI
  └── site/                   # sorgenti del sito statico
  ```

  #heading(level: 5, numbering: none, outlined: false)[Dettaglio directory `docs`]
  - `00-common_assets/`: Asset condivisi (es. font, loghi). Vietato duplicare questi file nelle cartelle locali.
  - *Livello Milestone (`docs/xx-nome`)*: Le directory sono numerate progressivamente (`xx >= 11`) per mantenere
    l'ordine cronologico delle Baseline. Questo livello è anche chiamato _group_ all'interno della documentazione;
  - *Livello Subgroup*: Classificazione funzionale dei documenti:
    - `docint/`: Documentazione interna (e.g. Norme di Progetto);
    - `docest/`: Documentazione esterna (e.g. Analisi dei Requisiti, Piano di Progetto);
    - `verbint/` / `verbest/`: Verbali interni ed esterni;
    - `slides/`: Presentazioni e Diari di Bordo.
  - *Livello Documento*: Ogni documento deve risiedere nella propria cartella `{nome_documento}` in `snake_case`:
    - `{nome_documento}.typ`: File "master". Non scrivere contenuto qui se il documento è lungo; in tal caso, deve
      contenere solo gli `include` dei moduli e la configurazione del template;
    - `{subfiles}/`: Directory che contiene i file `.typ` parziali (es. `cap1_intro.typ`), Obbligatorio per documenti
      lunghi e/o collaborativi per limitare i conflitti di merge;
    - `{nome_documento}.meta.yaml`: Metadati (titolo, changelog) conformi allo schema;
    - _Nota_: Per i documenti periodici (`ddb`, `verbint`, `verbest`), è obbligatorio suffissare il nome con la data in
      formato ISO (`yyyy-mm-dd`) per garantire l'ordinamento cronologico (es. verbint_2025-11-21).

  #heading(level: 5, numbering: none, outlined: false)[Integrità storica delle baseline]
  È severamente vietato modificare i file appartenenti a directory di baseline passate. Eventuali correzioni a documenti
  storici devono essere discusse con il Responsabile.
]

#norm(title: "Norme tipografiche e stilistiche", label: <norme-tipog-stile>)[
  Per garantire la qualità dei documenti, ogni autore è tenuto a rispettare le seguenti convenzioni. Il verificatore
  utilizzerà queste tabelle come *checklist* durante la revisione.

  #heading(level: 5, numbering: none, outlined: false)[Convenzioni Tipografiche]
  #table(
    columns: (auto, 1fr, 1fr),
    align: (left, left, left),
    table.header([Elemento], [Utilizzo], [Esempio]),

    [*Grassetto*],
    [Concetti chiave o formattazione.],
    [
      - *Concetto A*: [...] ;
      - *Concetto B*: [...] .
    ],

    [_Corsivo_],
    [Enfasi su parole specifiche, termini di glossario.],
    [[...] perciò si decide di _non_ intraprendere questa via.\
      Il team adotta un approccio Agile.],

    [`Monospazio`],
    [Codice, nomi di file, percorsi (path), branch, nomi di variabili/funzioni.],
    [Eseguire lo script `do.py`. \
      Il file si trova nella directory `notipdo/`.],

    [Glossario],
    [Termini ambigui, poco conosciuti o malinterpretabili. La formattazione è automatica nei documenti Typst.],
    [La suddetta baseline...],

    [Maiuscole],
    [Nomi di ruoli, titoli dei documenti, espansione di acronimi.],
    [Il Responsabile è tenuto all'approvazione delle Norme di Progetto.],

    [Elenchi puntati],
    [Ogni punto elenco inizia con lettera maiuscola e termina con un punto e virgola (;), eccetto l'ultimo che termina
      con il punto (.). Se il punto contiene più frasi, usare la punteggiatura standard interna.],
    [
      - Fase di planning;
      - Fase di azione;
      - Fase di retrospettiva.
    ],
  )

  #heading(level: 5, numbering: none, outlined: false)[Stile e Linguaggio]
  Il registro linguistico deve adattarsi al destinatario del documento secondo lo schema seguente:

  #table(
    columns: (auto, 1fr),
    align: (left, left),
    table.header([Destinatario], [Registro e Caratteristiche]),

    [*Interno* \ (Team)],
    [*Tecnico e Sintetico.* È ammesso l'uso di gergo tecnico condiviso e una struttura schematica per massimizzare la
      velocità di lettura. L'obiettivo è l'efficienza operativa.],

    [*Esterno - Tecnico* \ (Committente/Professori)],
    [*Formale e Professionale.* Uso rigoroso della terminologia standard. Le frasi devono essere complete, oggettive e
      non ambigue. In caso di ambiguità, porre i termini nel Glossario. Privilegiare la forma impersonale (es. "Si è
      scelto di...") o la prima persona plurale ("Abbiamo analizzato...").],

    [*Esterno - Utente* \ (Manuali utente)],
    [*Semplice e Accessibile.* Evitare tecnicismi. Spiegare i concetti complessi con esempi pratici. Il tono deve essere
      guidato e rassicurante.],
  )
]

#norm(title: "Versionamento dei riferimenti", label: <versionamento-riferimenti>)[
  Al fine di garantire la massima tracciabilità e la riproducibilità delle decisioni, ogni volta si inserisce un
  riferimento ad un documento interno o a una fonte esterna, è obbligatorio esplicitare la versione di quest'ultima. \
  In questo modo è possibile prevenire eventuali ambiguità derivanti dall'evoluzione dei contenuti nel tempo e assicura
  che qualsiasi lettore o verificatore possa consultare l'esatta versione del documento utilizzata dall'autore al
  momento della stesura.
]

#norm(title: "Nomenclatura Work Items di documentazione", label: <work-items-docs>)[
  I work items di documentazione presenti su Jira devono seguire la seguente nomenclatura:
  #align(center)[`{nome_dir_documento}-v{nuova_versione_documento} - {Breve descrizione}`]
  Per l'approvazione di un documento (ossia scatti di Major version), la descrizione è sostituita da \"Approvazione\".

  _Nota:_ Non esagerare con la lunghezza dei nomi dei work items, in quanto determinano il nome dei relativi branch.

  Esempi:
  - \"norme_progetto-v0.6.0 - Ristrutturazione e espansione processo documentazione\";
  - \"piano_qualifica-v0.4.0 - Sprint 4\";
  - \"piano_progetto-v1.0.0 - Approvazione\".
]


#norm(title: "Gestione Git: Branching e Commit", label: <branching-commit-docs>)[
  Il repository documentale segue una strategia di branching #link("https://trunkbaseddevelopment.com/")[Trunk-Based],
  dove l'unica fonte di verità persistente è il branch `main`. Ogni feature branch è effimero e deve essere collegato
  univocamente a un Work Item registrato su Jira.

  #heading(level: 5, numbering: none, outlined: false)[Nomenclatura Branch]
  È obbligatorio mantenere la nomenclatura generata automaticamente dal Work Item, rimuovendo la sezione
  ` - {Breve descrizione}` dallo schema definito in @work-items-docs. Esempio: `NT-67-norme_progetto-v0-6-0`.

  #heading(level: 5, numbering: none, outlined: false)[Messaggi di Commit]
  I messaggi devono seguire tassativamente lo standard #link(
    "https://www.conventionalcommits.org/en/v1.0.0/",
  )[Conventional Commits] per garantire la leggibilità della commit history.
  - *Struttura:* `tipo(ambito): descrizione imperativa minuscola`
  - *Tipi principali:* `docs` (cambiamento contenuti), `style` (formattazione dei file), `chore` (configurazioni/asset).
  - *Esempi:*
    - `docs(norme_progetto): aggiunta sezione git`
    - `style(norme_progetto): formattazione file con typstyle`
    - `chore: inserimento font Noto Sans`
]

#norm(title: "Co-authoring singole versioni di documento", label: <co-authoring-docs>)[
  Il co-authoring di un documento deve sempre essere guidato da un Work Item per ogni attività assegnata ad un
  componente.

  Il titolo dei work items differisce solo per la parte di `{Breve descrizione}` (vedi @work-items-docs). Esempio:
  - \"analisi_requisiti-v0.14.0 - aggiunta UC45-UC53\", assegnato alla persona A;
  - \"analisi_requisiti-v0.14.0 - aggiunta UC54-57\", assegnato alla persona B.

  #heading(level: 5, numbering: none, outlined: false)[Comunicazione]
  La comunicazione tra gli autori del documento deve essere *sincrona* per evitare sovrapposizioni.

  #heading(level: 5, numbering: none, outlined: false)[Subfiles]
  Le diverse parti di documento su cui ognuno lavora devono essere divise in subfiles Typst per evitare conflitti.

  #heading(level: 5, numbering: none, outlined: false)[Branching]
  Il caso del co-authoring è l'unico in cui viene meno la corrispondenza 1:1 tra branch e Work Item. Viene creato un
  branch per la versione (e.g. `NT-67-analisi_requisiti-v0-14-0`), slegato da qualunque work item, a partire da `main`.
  I feature branch relativi ai work item di Jira partono e vengono chiusi da e su quel branch di versione con delle Pull
  Request. Il nome di tali branch è quello generato da Jira comprensivo della parte di ` - {Breve descrizione}`
  illustrata in @work-items-docs. Una volta completata la stesura collaborativa, viene eseguito il merge del branch di
  versione in `main` ed eliminato, preservando la pulizia del trunk.

  #heading(level: 5, numbering: none, outlined: false)[Verifica]
  Una volta terminati tutti i work items relativi alla versione, _un_ (solo) verificatore può procedere a verificare
  tutte le PR, eseguire il merge sul branch di versione, ed eseguire un merge finale in `main`.
]

#norm(title: [Utilizzo del tool di automazione `notipdo`], label: <uso-notipdo>)[
  Il tool di automazione interno alla repository di documentazione si chiama `notipdo`.

  Esso permette di
  - _Validare_ la struttura della repository e la correttezza sintattica dei file;
  - _Compilare_ i documenti;
  - Compilare i documenti in modalità _hot reload_;
  - _Generare il sito_ web del team contenente tutti i documenti;
  - _Formattare i file Typst_ secondo le regole di formattazione del team;
  - _Verificare_ che un set di modifiche rispetti le norme del progetto. Ad esempio:
    - Verificare che non siano stati modificati documenti di vecchie baseline;
    - Verificare

  Il tool è accompagnato dalla sua documentazione d'uso e da messaggi di errore chiari. Per iniziare ad utilizzarlo,
  seguire le istruzioni presenti in `README.md` e digitare `notipdo --help` sulla propria shell. `notipdo` supporta
  Linux, MacOS e Windows.
]

#norm(title: "Template Typst", label: <template-typst>)[
  La redazione dei documenti deve partire esclusivamente dai template ufficiali presenti in
  `docs/{milestone}/00-templates/`:
  #table(
    columns: (auto, 1fr),
    inset: 10pt,
    table.header([Template], [Utilizzo]),
    [`base_document.typ`], [Documenti generici (Analisi, Piano di Progetto, Norme)],
    [`base_verbale.typ`], [Verbali interni ed esterni. Include sezioni per ordine del giorno e decisioni],
    [`base_slides.typ`], [Presentazioni generiche],
    [`base_ddb.typ`], [Diari di bordo con struttura fissa],
  )
]

#norm(title: "Matrice Documento - Ruolo autore", label: <matr-ruolo-documento>)[
  La seguente tabella rappresenta quale ruolo è responsabile della scrittura di ogni documento.
  #table(
    columns: (1fr, 1fr),
    inset: 10pt,
    table.header([Documento], [Ruolo autore]),
    [Norme di Progetto], [#ROLES.amm],
    [Piano di Qualifica], [#ROLES.amm],
    [Piano di Progetto], [#ROLES.amm],
    [Analisi dei Requisiti], [#ROLES.amm],
    [Verbali], [#ROLES.resp],
    [Diari di Bordo], [#ROLES.resp],
    [Analisi dei Requisiti], [#ROLES.anal],
    [Analisi dello Stato dell'Arte], [#ROLES.proge],
  )

  Ognuno, durante la scrittura dei documenti, è tenuto ad inserire nel glossario i termini che lo richiedono.
]

#norm(title: "Specifiche di contenuto per documenti periodici", label: <contenuto-docs>)[
  Sebbene la struttura sia guidata dai template, deve essere garantita la presenza dei seguenti contenuti minimi,
  mappati sui parametri delle funzioni Typst dedicate.

  #heading(level: 5, numbering: none, outlined: false)[Verbali (Interni ed Esterni)]
  I verbali devono essere redatti tramite il template `base_verbale.typ` e includere i seguenti elementi:
  - *Informazioni di base (`front-info`):* Elenco dettagliato di tutti i presenti;
  - *Dettagli logistici:* Indicazione esplicita della data, della piattaforma di comunicazione (es. Microsoft Teams,
    Discord) e della fascia oraria dell'incontro;
  - *Ordine del Giorno (`odg`):* Sintesi dei punti previsti per la trattazione durante la riunione;
  - *Svolgimento (`discussion`):* Il contenuto deve essere organizzato in blocchi tramite la funzione `report-point`,
    assicurando che ogni sezione contenga:
    - Un titolo chiaro per il punto di discussione (`discussion_point`);
    - La sintesi del dibattito intercorso (`discussion`);
    - Il riepilogo delle decisioni prese (`decisions`);
    - Eventuali azioni da intraprendere (`actions`), corredate da descrizione e URL diretto al relativo work item su
      Jira;
  - *Approvazione Aziendale:* Per i verbali esterni, è obbligatorio includere la sezione finale dedicata alla firma dei
    referenti per la validazione formale dei contenuti.

  #heading(level: 5, numbering: none, outlined: false)[Diari di Bordo (DdB)]
  Ogni Diario di Bordo deve essere redatto tramite la funzione `apply-base-ddb` , indicando il numero dello Sprint di
  riferimento. I contenuti devono seguire rigorosamente la suddivisione in tre blocchi posizionali:
  + *Risultati raggiunti:* Elenco puntato delle attività completate e dei traguardi raggiunti rispetto a quanto
    pianificato;
  + *Obiettivi per il periodo successivo:* Pianificazione dei task previsti per lo sprint seguente, inclusi avanzamenti
    documentali o tecnici;
  + *Criticità:* Esposizione di dubbi, difficoltà organizzative incontrate (es. durante le festività) o rischi occorsi
    durante lo svolgimento delle attività.

  Per garantire l'integrità dei dati, ogni documento deve caricare il proprio registro delle modifiche tramite il file
  di metadati `{nome_documento}.meta.yaml`.
]

=== Attività del processo

#activity(
  title: "Pianificazione del documento",
  roles: (ROLES.amm, ROLES.anal, ROLES.proge, ROLES.progr, ROLES.ver, ROLES.resp),
  norms: ("work-items-docs", "template-typst", "struttura-repo-docs"),
  input: [Necessità identificata di produrre o modificare documentazione],
  output: [Work Item Jira, documento pronto alla lavorazione],
  procedure: (
    (
      name: "Creazione Work Item",
      desc: [Chi individua la necessità del nuovo documento apre un work-item su Jira:
        - Il titolo deve seguire rigorosamente la nomenclatura definita nelle norme (es. `doc-v0.1.0 - Stesura`);
        - Nella descrizione vanno specificati gli obiettivi della nuova versione del documento.
        - Il Work Item deve contenere stime del tempo richiesto dai task di esecuzione e verifica.
      ],
    ),
    (
      name: "Setup (Solo nuovi documenti)",
      desc: [
        Se il documento non esiste:
        - Creare la cartella e i file iniziali utilizzando il *Template* corretto (vedi _Standard dei Template_);
        - Inizializzare il Changelog con la prima entry in versione `0.0.1` e descrizione \"Creazione documento\";
        - Aprire una PR verso `main`.
      ],
    ),
  ),
)

#activity(
  title: "Stesura del documento",
  label: <stesura-doc>,
  roles: (ROLES.aut,),
  norms: (
    "branching-commit-docs",
    "norme-tipog-stile",
    "versionamento-riferimenti",
    "struttura-repo-docs",
    "template-typst",
    "uso-notipdo",
    "co-authoring-docs",
  ),
  input: [Work Item Jira non assegnato],
  output: [Pull Request nuova versione documento aperta],
  procedure: (
    (
      name: "Presa in carico",
      desc: [Auto-assegnarsi al Work Item relativo alla nuova versione del documento.],
    ),
    (
      name: "Branching",
      desc: [
        Creare un branch locale a partire da `main` aggiornato.
        - Nome branch: deve rispettare rigorosamente la nomenclatura definita (es. `NT-67-norme_progetto-v0-6-0`);
        - È severamente vietato lavorare direttamente su main (azione tecnicamente inibita dalle policy del repository);
        - In caso di _co-authoring_, vedi #cite-norm("co-authoring-docs").
      ],
    ),
    (
      name: "Aggiornamento Changelog",
      desc: [
        Creare la nuova versione nel changelog del file `{nome_doc}.meta.yaml`, settando `TBD` (To Be Defined) come
        verificatore.
      ],
    ),
    (
      name: "Redazione",
      desc: [
        Scrivere i contenuti nel file `.typ` (o nei subfiles).
        - Consultare le _Norme tipografiche e stilistiche_ per formattazione e registro linguistico;
        - Utilizzare `notipdo watch doc {doc_dir}` per lavorare al documento in modalità hot-reload.
      ],
    ),
    (
      name: "Formattazione",
      desc: [
        Utilizzare `notipdo format doc {doc_dir}` per formattare correttamente i file sorgenti.
      ],
    ),
    (
      name: "Check delle modifiche",
      desc: [
        - Assicurarsi che il documento compili correttamente;
        - Utilizzare `notipdo check pr` e assicurarsi che le modifiche passino i controlli di formattazione e
          spellcheck.
      ],
    ),
    (
      name: "Commit e Push (loop)",
      desc: [
        - Eseguire commit atomici usando i _Conventional Commits_ (es. `docs(norme_progetto): stesura introduzione`);
        - Eseguire il push sul repository remoto.
      ],
    ),
    (
      name: "Apertura PR",
      desc: [Una volta completata la stesura, aprire una Pull Request verso `main`.],
    ),
    (
      name: "Submission Work Item",
      desc: [Spostare il Work Item in verifica dopo aver segnato il tempo speso effettivamente sul task.],
    ),
  ),
)

#activity(
  title: "Verifica del documento",
  roles: (ROLES.ver,),
  label: <verifica-doc>,
  norms: ("ciclo-vita-docs", "struttura-repo-docs", "norme-tipog-stile", "uso-notipdo", "co-authoring-docs"),
  input: [Pull Request aperta],
  output: [Documento verificato (su `main`) o richiesta modifiche],
  procedure: (
    (
      name: "Presa in Carico",
      desc: [
        Auto-assegnarsi al Work Item di verifica relativo alla nuova versione del documento.
        - In caso di versione realizzata in co-authoring, vedi #cite-norm("co-authoring-docs").
      ],
    ),
    (
      name: "Controlli Automatici",
      desc: [
        Attendere l'esito della pipeline di CI.
        - Se fallisce: La verifica è bloccata. L'autore deve risolvere gli errori tecnici.
      ],
    ),
    (
      name: "Revisione Umana",
      desc: [
        Scaricare il PDF di anteprima (artifact), controllare il codice e verificare:
        - Rispetto delle norme tipografiche e stilistiche;
        - Completezza e correttezza del contenuto rispetto al Work Item.
      ],
    ),
    (
      name: "Feedback (Loop)",
      desc: [
        - Se ci sono errori: Richiedere modifiche tramite commenti sulla PR. L'autore corregge e si riparte dal punto 1;
        - Se è tutto corretto: Procedere al punto successivo.
      ],
    ),
    (
      name: "Firma (Approvazione Tecnica)",
      desc: [
        Modificare il Changelog: sostituire il placeholder `TBD` (To Be Done) con il proprio Nome e Cognome. Questo
        sancisce la responsabilità della verifica.
      ],
    ),
    (
      name: "Controllo pre-merge",
      desc: [
        Assegnare la label `merge-ready` alla PR. Questo scatenerà un controllo automatico che si assicura dell'avvenuta
        firma al punto precedente.
      ],
    ),
    (
      name: "Merge",
      desc: [
        Approvare la PR su GitHub ed eseguire lo _Squash and Merge_ sul branch `main`.
      ],
    ),
    (
      name: "Chiusura Work Item",
      desc: [Spostare il Work Item in "Done" dopo aver segnato il tempo speso effettivamente sul task.],
    ),
  ),
)

#activity(
  title: "Approvazione del documento",
  roles: (ROLES.resp,),
  norms: ("ciclo-vita-docs", "work-items-docs", "branching-commit-docs"),
  input: [Documento in stato _Verificato_ (su `main`), Rilascio di Baseline imminente],
  output: [Nuova Major Version],
  rationale: [Questa attività sancisce il passaggio ufficiale da una versione di sviluppo a una versione stabile
    (Baseline).],
  procedure: (
    (
      name: "Presa in carico",
      desc: [Auto-assegnarsi al Work Item relativo all'approvazione del documento.],
    ),
    (
      name: "Branching",
      desc: [Aprire il branch relativo al Work Item, come nel caso di redazione del documento.],
    ),
    (
      name: "Valutazione",
      desc: [
        Valutare la maturità del documento per l'ingresso in Baseline.
        - I contenuti del documento rispecchiano gli scopi della baseline?
        - La forma del documento è corretta?
        Se la risposta è negativa, viene annullata l'attività di approvazione e creato il Work Item relativo alla
        soluzione dei problemi riscontrati.
      ],
    ),
    (
      name: "Version Bump",
      desc: [
        - Incrementare la versione da `X.Y.Z` a `X+1.0.0`;
        - Aggiornare la data del Changelog alla data di rilascio corrente.
        - Verificatore: TBD
      ],
    ),
    (
      name: "Submission, PR, Verifica, Chiusura",
      desc: [
        La chiusura del task avviene esattamente come ogni altra versione.\
        Unica differenza: il verificatore è tenuto solo a controllare la spunta verde dei check automatici, non a
        controllare manualmente il contenuto.
      ],
    ),
  ),
)

#activity(
  title: "Distribuzione della documentazione",
  roles: (ROLES.amm,),
  norms: ("struttura-repo-docs", "uso-notipdo"),
  input: [Documenti relativi alla Baseline approvati],
  output: [Baseline pubblicata sul #link("https://notipswe.github.io/RepoDocumentale/")[sito Web]],
  procedure: (
    (
      name: "Rilascio",
      desc: [Lanciare l'automazione di rilascio del sito su GitHub Pages dal branch `main`.],
    ),
    (
      name: [Modifica configurazione `notipdo`],
      desc: [Modificare le impostazioni di `notipdo` presenti nel file `notipdo/lib/configs.py`.],
    ),
  ),
)
