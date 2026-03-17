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
  title: "Pin delle Versioni delle Dipendenze",
  label: <pin-versioni>,
)[
  È vietato l'uso del tag `latest` o di versioni non specificate per dipendenze, immagini base e
  tool. Per garantire riproducibilità e stabilità degli ambienti, il gruppo adotta le seguenti
  regole:
  - *Sistema operativo*: Mantenere l'ultima versione stabile di Debian o Alpine come base delle
    immagini Docker;
  - *Tool e runtime* (es. Node.js, Go, Nginx): Pinnare ad una specifica versione *Minor*
    (es. `node:24.14-trixie-slim`). In questo modo si ricevono automaticamente gli aggiornamenti
    di sicurezza (patch) senza introdurre nuove feature non necessarie;
  - *Aggiornamento manuale*: Se una nuova feature del tool è necessaria, la versione Minor va
    aggiornata esplicitamente con una modifica deliberata al Dockerfile o al file di dipendenze.

  _Nota_: Il pin fino alla revisione Git specifica non viene adottato per semplicità, pur
  essendo la pratica raccomandata in ambienti di produzione ad alta criticità.
]

#norm(
  title: "Pre-commit Hooks",
  label: <pre-commit-hooks>,
)[
  Il gruppo utilizza `pre-commit`, un framework Python per la gestione degli hook Git locali,
  installato in ogni repository. Gli hook vengono eseguiti automaticamente prima di ogni commit,
  garantendo che il codice committato rispetti gli standard di qualità definiti senza dipendere
  dalla disciplina manuale del singolo sviluppatore.

  La configurazione degli hook attivi per ogni repository è definita nel file
  `.pre-commit-config.yaml` presente nella radice della repository stessa.

  Per il setup di `pre-commit` nell'ambiente locale si rimanda alla @setup-devcontainer.
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

#norm(
  title: "Branching e Conventional Commits nello Sviluppo",
  label: <branching-conventional-commits>,
)[
  Il Programmatore è tenuto a rispettare le seguenti norme durante lo sviluppo del codice.

  *Branching*: Per ogni Task Jira deve essere creato un feature branch dedicato a partire dal
  branch `main` aggiornato. È severamente vietato lavorare direttamente su `main`. La
  nomenclatura del branch deve includere l'identificativo del Task come definito nella
  @integrazione-git.

  *Peso dei Conventional Commits*: I prefissi dei commit determinano l'avanzamento automatico
  della versione da parte della CI/CD (vedi @versionamento-codice) secondo le seguenti regole:
  - `fix:` → avanzamento di versione Patch;
  - `docs:` → avanzamento di versione Patch (utilizzato per aggiungere documentazione di qualsiasi tipo al codice);
  - `feat:` → avanzamento di versione Minor;
  - `BREAKING CHANGE` (nel footer del commit) o `!` (dopo il tipo del commit) → avanzamento di
    versione Major. Da usare esclusivamente al rilascio in Product Baseline.

  In presenza di più commit in una singola Pull Request, vince il prefisso di peso maggiore.
  *Esempi:*
  - `main` v0.6.9 + merge con `fix:`, `fix:`, `feat:` → vince `feat:` → `main` passa a v0.7.0;
  - `main` v1.0.0 + merge con `fix:`, `fix:`, `docs:` → vince `fix:` → `main` passa a v1.0.1.

  Per la disciplina generale sui commit (amend/reset) si rimanda alla @disciplina-commit.
]

#norm(
  title: "Interfacce Condivise (API Contracts)",
  label: <api-contracts>,
)[
  La gestione dei contratti per le interfacce condivise varia a seconda del paradigma di comunicazione adottato (sincrono o asincrono).

  *API Sincrone (REST / OpenAPI)*
  L'approccio adottato per la condivisione delle interfacce tra servizi è *code-first*: i servizi
  che espongono API (tutti sviluppati in NestJS) definiscono le interfacce direttamente nel codice
  sorgente tramite decoratori Swagger/OpenAPI, senza file di specifica redatti manualmente.

  La directory `notip-infra/api-contracts/` funge da registro centrale per i contratti API
  pubblicati dai backend. I servizi consumatori (frontend Angular, data-consumer Go) non dipendono
  da un file mantenuto a mano, ma da uno snapshot generato e pubblicato automaticamente dalla CI
  del backend.

  Il file `openapi.json` scaricato e committato nella repository di ogni servizio consumatore
  costituisce un *lockfile dell'API*: esso traccia l'esatta versione dell'interfaccia contro cui
  il consumer è compilato ed è un elemento di configurazione soggetto a versionamento
  (vedi @config-items).

  I servizi consumatori utilizzano tool standard per la generazione automatica di DTO, interfacce
  e client HTTP a partire dal JSON locale:
  - `openapi-generator-cli` per i consumer TypeScript (Angular);
  - `oapi-codegen` per i consumer Go.

  Per il workflow operativo di aggiornamento del contratto API si rimanda alla
  @workflow-api-contracts.

  *API Asincrone (NATS / AsyncAPI)*
  Per le comunicazioni asincrone tramite message broker (NATS), il gruppo adotta lo standard AsyncAPI. A differenza delle API sincrone, la definizione degli endpoint (canali) avviene in modo manuale ed è centralizzata all'interno del file nats-contracts.yaml situato nella directory `notip-infra/api-contracts/async-api/`.

  Per garantire ordine e selettività nella generazione del codice, ogni entry del file deve dichiarare all'interno dell'attributo `tags` la lista dei servizi che andranno ad utilizzare quello specifico canale, specificandone esplicitamente il ruolo (`Publisher` o `Subscriber`). Questo approccio permette ai singoli servizi di filtrare il documento e autogenerare esclusivamente le interfacce di proprio interesse.

  *Esempio:*

  `channels:
  telemetry.data.{tenantId}.{gatewayId}:
    tags:
      - name: gateway-sim
        description: "Role: Publisher"
      - name: data-api
        description: "Role: Subscriber"`
  
  Affinché due o più componenti possano comunicare correttamente tramite NATS, è requisito stringente che utilizzino e siano compilati contro la medesima versione dei contratti AsyncAPI.
]

#norm(
  title: "Database e Migrazioni",
  label: <database-migrazioni>,
)[
  I database principali del sistema (MeasuresDB e ManagementDB) devono essere creati e migrati
  tramite gli strumenti di migrazione offerti da TypeORM in NestJS. È vietato applicare modifiche
  agli schemi dei database in modo manuale o tramite strumenti alternativi.

  Le migrazioni devono essere sempre generate, committate e versionate nella repository del
  servizio di riferimento. Esse costituiscono elementi di configurazione soggetti a versionamento
  obbligatorio (vedi @config-items).

  Il database del simulatore (SQLite), essendo un mock a scopo di testing e sviluppo, è escluso
  da questo requisito: non si producono né si versionano migrazioni per esso.
]

=== Attività del processo

#activity(
  title: "Analisi dei Requisiti di Sistema",
  roles: (ROLES.anal,),
  norms: ("nomenclatura-uc", "struttura-uc", "nomenclatura-requisiti"),
  input: [Capitolato C7, verbali degli incontri con il committente],
  output: [#link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/analisi_requisiti.pdf")[Analisi dei
      Requisiti v1.1.0] (casi d'uso e lista requisiti)],
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

#activity(
  title: "Workflow di Aggiornamento delle Interfacce Condivise",
  label: <workflow-api-contracts>,
  roles: (ROLES.progr,),
  norms: ("api-contracts", "config-items", "repo-strategy"),
  input: [Modifiche all'interfaccia API nel codice sorgente del servizio backend],
  output: [
    `openapi.json` aggiornato committato nella repository del servizio consumatore, client HTTP
    autogenerato aggiornato
  ],
  procedure: (
    (
      name: "Estrazione (Backend)",
      desc: [
        Durante la build, uno script NestJS genera offline il file `openapi.json` direttamente
        dai decoratori del codice. Il file non viene committato nella repository del backend.
      ],
    ),
    (
      name: "Pubblicazione (Push nel Registro)",
      desc: [
        La CI del backend pusha automaticamente il JSON generato nella cartella `api-contracts/`
        dentro `notip-infra`, che funge da registro centrale.
      ],
    ),
    (
      name: "Sincronizzazione (Pull del Consumatore)",
      desc: [
        Lo sviluppatore del servizio consumatore lancia uno script locale che scarica il file
        `openapi.json` da `notip-infra`, puntando a un commit SHA specifico (pinning),
        garantendo la riproducibilità.
      ],
    ),
    (
      name: "Lockfile",
      desc: [
        Il file JSON scaricato viene committato nella repository del consumatore. Esso funge da
        lockfile e traccia l'esatta versione dell'API contro cui il consumer è compilato.
      ],
    ),
    (
      name: "Generazione Codice",
      desc: [
        Il consumatore esegue il tool di generazione appropriato (`openapi-generator-cli` per
        TypeScript, `oapi-codegen` per Go) per autogenerare DTO, interfacce e client HTTP a
        partire dal JSON locale appena aggiornato.
      ],
    ),
  ),
)
