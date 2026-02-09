#import "lib.typ": ROLES, activity, cite-norm, norm

=== Attività previste
Le attività previste dal processo di sviluppo in base allo standard ISO/IEC 12207:1995 sono le seguenti:
- *Istanziazione del processo*: definizione del modello di ciclo di vita e stesura dei piani legati al progetto;
- *Analisi dei requisiti di sistema*: identificazione e definizione delle necessità dell'utente finale in relazione alle
  funzionalità che il Software deve offrire;
- *Progettazione dell'architettura di sistema*: identificazione dell'hardware e del software del prodotto finale,
  affinché tutti i requisiti individuati siano soddisfatti;
- *Progettazione architetturale software*: definizione della struttura generale, delle diverse componenti del sistema e
  il loro funzionamento;
- *Codifica e test software*: produzione delle unità di tutte le componenti individuate precedentemente, assicurando che
  ciascuna di queste venga adeguatamente testata;
- *Integrazione software*: assemblaggio delle varie unità software e test per assicurare il corretto funzionamento;
- *Test di qualità software*: realizzazione di appositi test per assicurare la conformità del software agli obiettivi di
  qualità attesi;
- *Integrazione di sistema*: assemblaggio del software con l'hardware e altri sistemi;
- *Test di qualifica del sistema*: test dell'intero sistema per assicurare il corretto funzionamento;
- *Installazione software*: fornitura di quanto realizzato al cliente finale nell'ambiente concordato;
- *Supporto all'accettazione software*: assistenza al committente durante le verifiche finali per l'accettazione.

Le attività scritte in dettaglio sono quelle che il gruppo riteneva importanti per la *Requirements and Technology
Baseline (RTB)*, le restanti attività verranno descritte per la prossima baseline ovvero la *Product Baseline (PB)*.

=== Analisi dei Requisiti <analisi-requisiti>

L'#link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/analisi_requisiti.pdf")[Analisi dei Requisiti] è
una delle attività cardine della milestone Requirements and Technology Baseline (RTB). Il suo obiettivo è individuare
l'insieme completo dei requisiti che il sistema dovrà soddisfare, fungendo da riferimento oggettivo per le successive
attività di verifica. Il documento, redatto dagli analisti, è strutturato nelle seguenti sezioni:
- *Introduzione*: definisce lo scopo e il campo di applicazione del documento;
- *Descrizione*: illustra le finalità generali e gli obiettivi del prodotto;
- *Attori*: identifica gli utilizzatori del sistema e i soggetti che interagiscono con esso;
- *Casi d'Uso*: modella le interazioni tra attori e sistema;
- *Requisiti*: elenca le caratteristiche funzionali, qualitative, di vincolo e di sicurezza da rispettare.

==== Casi d'uso

Per garantire univocità e tracciabilità, i casi d'uso adottano la seguente nomenclatura:
#align(center, text(1.2em)[*`UC[Codice].[Sottocaso] - [Titolo]`*])
dove:
- *UC*: acronimo di Use Case;
- *[Codice]*: numero identificativo univoco del caso d'uso principale.
- *[Sottocaso]*: numero identificativo progressivo gerarchico per identificare scenari derivati o specifici (ci possono
  essere sottocasi derivanti da altri sottocasi).
- *[Titolo]*: titolo sintetico ed esplicativo dell'azione.
Per la parte B (Simulatore), la nomenclatura viene estesa in *UCS (Use Case Simulatore)*.

Ogni caso d'uso viene dettagliato secondo la seguente struttura:
- *Attori Primari*: utenti e attori che avviano l'interazione.
- *Attori Secondari*: destinatari di notifiche o sistemi esterni coinvolti passivamente.
- *Precondizioni*: stato del sistema o condizioni necessarie per l'attivazione del caso d'uso.
- *Postcondizioni*: stato garantito del sistema a seguito del completamento con successo.
- *Scenario Principale*: sequenza di azioni atomiche in linguaggio naturale, inclusi eventuali:
  - Punti di Inclusione (Include: UC[ID] - Titolo).
  - Punti di Estensione (Descrizione passo. [EP: NOME]).
- *Estensioni*: gestione di scenari alternativi o eccezioni, definiti da una condizioni di guardia e dal relativo caso
  d'uso esteso.

==== Requisiti

Una volta definiti i casi d'uso, il documento procede all'individuazione dei requisiti, derivati dal capitolato e dagli
incontri effettuati con il committente. Per garantire una catalogazione rigorosa, ogni requisito è identificato dalla
seguente nomenclatura:
#align(center, text(1.2em)[*`R-[Numero]-[Tipologia] [Priorità]`*])
dove:
- *R* abbreviazione di *Requisito*;
- *Numero* è un valore univoco che identifica il requisito;
- *Tipologia* indica la natura del requisito, classificata in:
  - *F* per *Funzionale*;
  - *Q* per *Qualità*;
  - *V* per *Vincolo*;
  - *S* per *Sicurezza*;
- *Priorità* indica l'importanza strategica del requisito:
  - *Obbligatorio*: indispensabile per la validità del progetto;
  - *Desiderabile*: non indispensabile, ma con valore aggiunto;
  - *Opzionale*: funzionalità aggiuntive a bassa priorità.
Per la parte B (Simulatore), la nomenclatura viene estesa in RS (Requisito Simulatore).

=== Codifica

L'attività di codifica rappresenta la fase di realizzazione del ciclo di vita del software, dove le specifiche
progettuali vengono tradotte in codice sorgente eseguibile. L'obiettivo è produrre software non solo funzionante, ma
anche leggibile e manutenibile.

==== Norme e strumenti per la codifica

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
  Tutti i membri del gruppo sono tenuti a rispettare le seguenti convenzioni stilistiche per garantire la leggibilità:

  - *Lingua*: Il codice, inclusi i nomi di variabili, funzioni e i commenti, deve essere scritto interamente in
    *Inglese*;
  - *File*: Mantenere i file snelli con responsabilità singola. Se un file cresce eccessivamente, deve essere
    rifattorizzato;
  - *Nomenclatura*:
    - *Variabili*: Utilizzare la notazione `PascalCase` (es. `MyVariable`);
    - *Funzioni/Metodi*: Utilizzare la notazione `camelCase` (es. `myFunction`);
    - *Costanti*: Evitare costanti globali; prediligere configurazioni o variabili contestualizzate.
]

==== Attività del processo

#activity(
  title: "Workflow di Sviluppo del Codice",
  roles: (ROLES.progr,),
  norms: ("stack-tecnologico", "strumenti-qualita-codice", "convenzioni-scrittura"),
  input: [Specifica architetturale, Task Jira assegnato],
  output: [Codice sorgente committato, Unit Tests],
  procedure: (
    (
      name: "Setup e Branching",
      desc: [Creazione del feature branch dedicato al task corrente a partire dal ramo di sviluppo aggiornato.],
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
