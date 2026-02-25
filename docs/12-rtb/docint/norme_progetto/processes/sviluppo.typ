#import "lib.typ": ROLES, activity, cite-norm, norm

=== Norme e strumenti del processo di sviluppo

#norm(
  title: "Nomenclatura dei Casi d'Uso",
  label: <nomenclatura-uc>,
)[
  Per garantire univocità e tracciabilità, i casi d'uso adottano la seguente nomenclatura:
  #align(center, text(1.2em)[*`UC[Codice].[Sottocaso] - [Titolo]`*])
  dove:
  - *UC*: acronimo di Use Case;
  - *[Codice]*: numero identificativo univoco del caso d'uso principale;
  - *[Sottocaso]*: numero identificativo progressivo gerarchico per identificare scenari derivati o specifici (ci
    possono essere sottocasi derivanti da altri sottocasi);
  - *[Titolo]*: titolo sintetico ed esplicativo dell'azione.

  Per la parte B (Simulatore), la nomenclatura viene estesa in *UCS (Use Case Simulatore)*.
]

#norm(
  title: "Struttura dei Casi d'Uso",
  label: <struttura-uc>,
)[
  Ogni caso d'uso viene dettagliato secondo la seguente struttura:
  - *Attori Primari*: utenti e attori che avviano l'interazione;
  - *Attori Secondari*: destinatari di notifiche o sistemi esterni coinvolti passivamente;
  - *Precondizioni*: stato del sistema o condizioni necessarie per l'attivazione del caso d'uso;
  - *Postcondizioni*: stato garantito del sistema a seguito del completamento con successo;
  - *Scenario Principale*: sequenza di azioni atomiche in linguaggio naturale, inclusi eventuali:
    - Punti di Inclusione (`Include: UC[ID] - Titolo`);
    - Punti di Estensione (`Descrizione passo. [EP: NOME]`).
  - *Estensioni*: gestione di scenari alternativi o eccezioni, definiti da una condizione di guardia e dal relativo caso
    d'uso esteso.
]

#norm(
  title: "Nomenclatura dei Requisiti",
  label: <nomenclatura-requisiti>,
)[
  Ogni requisito è identificato dalla seguente nomenclatura:
  #align(center, text(1.2em)[*`R-[Numero]-[Tipologia] [Priorità]`*])
  dove:
  - *R*: abbreviazione di Requisito;
  - *Numero*: valore univoco che identifica il requisito;
  - *Tipologia*: indica la natura del requisito:
    - *F* per *Funzionale*;
    - *Q* per *Qualità*;
    - *V* per *Vincolo*;
    - *S* per *Sicurezza*.
  - *Priorità*: indica l'importanza strategica del requisito:
    - *Obbligatorio*: indispensabile per la validità del progetto;
    - *Desiderabile*: non indispensabile, ma con valore aggiunto;
    - *Opzionale*: funzionalità aggiuntive a bassa priorità.

  Per la parte B (Simulatore), la nomenclatura viene estesa in *RS (Requisito Simulatore)*.
]

#norm(
  title: "Stack Tecnologico",
  label: <stack-tecnologico>,
)[
  Le tecnologie adottate per lo sviluppo del progetto sono:
  - *Backend*: Linguaggio *Go* (Golang);
  - *Frontend*: Framework *Angular* con linguaggio *TypeScript*;
  - *Automazione/Scripting*: Linguaggio *Python* per la gestione della documentazione.
]

#norm(
  title: "Strumenti di Qualità del Codice",
  label: <strumenti-qualita-codice>,
)[
  È richiesta la configurazione dell'editor per l'applicazione automatica al salvataggio ("format on save") e i seguenti
  strumenti per formattare il codice:
  #table(
    columns: (auto, auto, 1fr),
    align: (center, center, left),
    table.header([Ambito], [Tool], [Descrizione]),
    [*Go*], [`gofmt`], [Standard per la formattazione.],
    [*TypeScript*],
    [`ESLint` \ `Prettier`],
    [Analisi per prevenire errori comuni e best-practices (ESLint) e formattazione stilistica (Prettier).],
  )
]

#norm(
  title: "Convenzioni di Scrittura e Nomenclatura",
  label: <convenzioni-scrittura>,
)[
  Tutti i membri del gruppo sono tenuti a rispettare le seguenti convenzioni stilistiche:
  - *Lingua*: Il codice, inclusi i nomi di variabili, funzioni e i commenti, deve essere scritto interamente in
    *Inglese*;
  - *File*: Mantenere i file snelli con responsabilità singola. Se un file cresce eccessivamente, deve essere
    rifattorizzato;
  - *Nomenclatura*:
    - *Variabili*: Utilizzare la notazione `PascalCase` (es. `MyVariable`);
    - *Funzioni/Metodi*: Utilizzare la notazione `camelCase` (es. `myFunction`);
    - *Costanti*: Evitare costanti globali; prediligere configurazioni o variabili contestualizzate.
]

=== Attività del processo di sviluppo

#activity(
  title: "Analisi dei Requisiti di Sistema",
  roles: (ROLES.anal,),
  norms: ("nomenclatura-uc", "struttura-uc", "nomenclatura-requisiti"),
  input: [Capitolato C7, verbali degli incontri con il committente],
  output: [#link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/analisi_requisiti.pdf")[Analisi dei
      Requisiti] (casi d'uso e lista requisiti)],
  procedure: (
    (
      name: "Modellazione dei Casi d'Uso",
      desc: [
        Individuazione degli attori e delle interazioni con il sistema. Ogni caso d'uso viene redatto rispettando la
        struttura e la nomenclatura definite nelle norme.
      ],
    ),
    (
      name: "Individuazione dei Requisiti",
      desc: [
        Derivazione dei requisiti dal capitolato e dagli incontri con il committente. Ogni requisito viene classificato
        per tipologia e priorità secondo la nomenclatura definita nelle norme.
      ],
    ),
  ),
)

#activity(
  title: "Workflow di Sviluppo del Codice",
  roles: (ROLES.progr,),
  norms: ("stack-tecnologico", "strumenti-qualita-codice", "convenzioni-scrittura"),
  input: [Specifica architetturale, Task Jira assegnato],
  output: [Codice sorgente committato, Unit Tests],
  procedure: (
    (
      name: "Setup e Branching",
      desc: [
        Creazione del feature branch dedicato al task corrente a partire dal ramo di sviluppo aggiornato.
      ],
    ),
    (
      name: "Codifica",
      desc: [
        Scrittura del codice sorgente rispettando le convenzioni di nomenclatura definite. Il codice deve essere
        auto-esplicativo; eventuali commenti in inglese devono chiarire una sezione complessa.
      ],
    ),
    (
      name: "Commit",
      desc: [
        Salvataggio delle modifiche sul repository remoto seguendo le convenzioni dei messaggi di commit.
      ],
    ),
  ),
)
