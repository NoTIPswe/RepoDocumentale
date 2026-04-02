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
  - *Backend*: Linguaggio *Go* (Golang) e framework *NestJS* (TypeScript);
  - *Frontend*: Framework *Angular* con linguaggio *TypeScript*;
  - *Identity and Access Management (IAM)*: *Keycloak* per la gestione centralizzata di autenticazione, autorizzazione
    (RBAC) e multi-tenancy;
  - *Reverse Proxy / API Gateway*: *Nginx*, unico punto di ingresso del traffico di rete verso i microservizi. È
    responsabile del routing delle richieste in entrata, della terminazione TLS e dell'iniezione degli header di
    sicurezza globali (configurati in `security-headers.conf`). La configurazione è versionata in
    `notip-infra/infra/nginx/`;
  - *Osservabilità*: *Prometheus* per la raccolta delle metriche applicative a runtime, *Grafana* per la loro
    visualizzazione tramite dashboard versionata in `notip-infra/infra/monitoring/`;
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
    [*Go*], [`gofmt`], [Standard per la formattazione del codice.],
    [*Go*],
    [`golangci-lint`],
    [Linter aggregato, configurato tramite il file `.golangci.yml`. Esegue controlli di qualità avanzati in parallelo,
      rilevando errori, anti-pattern e violazioni stilistiche non coperte da `gofmt`.],

    [*Go*],
    [`air`],
    [Tool di live-reloading per applicazioni Go durante lo sviluppo locale nel DevContainer. Configurato tramite
      `.air.toml`, ricompila e riavvia il servizio automaticamente ad ogni modifica ai file sorgente.],

    [*TypeScript*],
    [`ESLint` \ `Prettier`],
    [Analisi per prevenire errori comuni e best-practices (ESLint, configurato tramite `eslint.config.mjs`) e
      formattazione stilistica (Prettier).],
  )
]

#norm(
  title: "Pin delle Versioni delle Dipendenze",
  label: <pin-versioni>,
)[
  È vietato l'uso del tag `latest` o di versioni non specificate per dipendenze, immagini base e tool. Per garantire
  riproducibilità e stabilità degli ambienti, il gruppo adotta le seguenti regole:
  - *Sistema operativo*: Mantenere l'ultima versione stabile di Debian o Alpine come base delle immagini Docker;
  - *Tool e runtime* (es. Node.js, Go, Nginx): Pinnare ad una specifica versione *Minor* (es. `node:24.14-trixie-slim`).
    In questo modo si ricevono automaticamente gli aggiornamenti di sicurezza (patch) senza introdurre nuove feature non
    necessarie;
  - *Aggiornamento manuale*: Se una nuova feature del tool è necessaria, la versione Minor va aggiornata esplicitamente
    con una modifica deliberata al Dockerfile o al file di dipendenze.

  _Nota_: Il pin fino alla revisione Git specifica non viene adottato per semplicità, pur essendo la pratica
  raccomandata in ambienti di produzione ad alta criticità.
]

#norm(
  title: "Pre-commit Hooks",
  label: <pre-commit-hooks>,
)[
  Il gruppo utilizza `pre-commit`, un framework Python per la gestione degli hook Git locali, installato in ogni
  repository. Gli hook vengono eseguiti automaticamente prima di ogni commit, garantendo che il codice committato
  rispetti gli standard di qualità definiti senza dipendere dalla disciplina manuale del singolo sviluppatore.

  La configurazione degli hook attivi per ogni repository è definita nel file `.pre-commit-config.yaml` presente nella
  radice della repository stessa.

  Per il setup di `pre-commit` nell'ambiente locale si rimanda alla @setup-devcontainer.
]

#norm(
  title: "Interfaccia di Automazione Locale",
  label: <automazione-locale>,
)[
  Per garantire coerenza nella Developer Experience, le operazioni comuni (build, test, lint, avvio) devono essere
  esposte tramite un'interfaccia standard che varia in base allo stack del servizio:

  - *Servizi Go* e repository `notip-infra`: Adottano un `Makefile` nella root del progetto come unico punto di accesso,
    in quanto non dispongono di un package manager con script integrati. Ogni nuovo servizio Go deve includere un
    `Makefile` conforme a questi target.

  - *Servizi NestJS e Angular*: Espongono le stesse operazioni tramite script nel `package.json`, sfruttando il package
    manager come interfaccia nativa dello stack.
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

  *Branching*: Per ogni Task Jira deve essere creato un feature branch dedicato a partire dal branch `main` aggiornato.
  È severamente vietato lavorare direttamente su `main`. La nomenclatura del branch deve includere l'identificativo del
  Task come definito nella @integrazione-git.

  *Peso dei Conventional Commits*: I prefissi dei commit determinano l'avanzamento automatico della versione da parte
  della CI/CD (vedi @versionamento-codice) secondo le seguenti regole:
  - `fix:` → avanzamento di versione Patch;
  - `docs:` → avanzamento di versione Patch (utilizzato per aggiungere documentazione di qualsiasi tipo al codice);
  - `feat:` → avanzamento di versione Minor;
  - `BREAKING CHANGE` (nel footer del commit) o `!` (dopo il tipo del commit) → avanzamento di versione Major. Da usare
    esclusivamente al rilascio in Product Baseline.

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
  La gestione dei contratti per le interfacce condivise varia a seconda del paradigma di comunicazione adottato
  (sincrono o asincrono).

  *API Sincrone (REST / OpenAPI)*
  L'approccio adottato è *code-first*: i servizi che espongono API (tutti sviluppati in NestJS) definiscono le
  interfacce direttamente nel codice sorgente tramite decoratori Swagger/OpenAPI.

  A differenza dei contratti NATS (centralizzati in `notip-infra`), ogni servizio backend è *unica sorgente di verità
  del proprio contratto OpenAPI*: il file `openapi.yaml` generato dai decoratori viene committato direttamente nella
  repository del servizio produttore (es. `api-contracts/openapi/openapi.yaml` in `notip-management-api`).

  I servizi consumatori che necessitano dell'interfaccia di un backend scaricano il file `openapi.yaml` dalla repository
  del servizio produttore tramite uno script dedicato. Il file scaricato viene rinominato (manualmente) con il prefisso
  del servizio di provenienza (es. `management-api-openapi.yaml`, `data-api-openapi.yaml`) e committato nella repository
  del consumatore, dove funge da *lockfile dell'API*: traccia l'esatta versione dell'interfaccia contro cui il consumer
  è compilato ed è un elemento di configurazione soggetto a versionamento (vedi @config-items).

  I servizi consumatori utilizzano tool standard per la generazione automatica di DTO, interfacce e client HTTP a
  partire dal file scaricato:
  - `openapi-generator-cli` per i consumer TypeScript (Angular);
  - `oapi-codegen` per i consumer Go.

  Per il workflow operativo di aggiornamento del contratto API si rimanda alla @workflow-api-contracts.

  *API Asincrone (NATS / AsyncAPI)*
  Per le comunicazioni asincrone tramite message broker (NATS), il gruppo adotta lo standard AsyncAPI. A differenza
  delle API sincrone, la definizione degli endpoint (canali) avviene in modo manuale ed è centralizzata all'interno del
  file nats-contracts.yaml situato nella directory `notip-infra/api-contracts/async-api/`.

  Per garantire ordine e selettività nella generazione del codice, ogni entry del file deve dichiarare all'interno
  dell'attributo `tags` la lista dei servizi che andranno ad utilizzare quello specifico canale, specificandone
  esplicitamente il ruolo (`Publisher` o `Subscriber`). Ogni servizio estrae la propria porzione del contratto tramite
  uno script di filtering locale: `scripts/filter-asyncapi.mjs` (che filtra i canali di pertinenza in base ai tag)
  invocato da `scripts/generate-asyncapi.sh`. Questi script leggono il file centralizzato
  `notip-infra/api-contracts/async-api/nats-contracts.yaml` e producono i soli canali e le relative interfacce
  necessarie al microservizio.

  *Esempio:*

  `channels:
  telemetry.data.{tenantId}.{gatewayId}:
    tags:
      - name: gateway-sim
        description: "Role: Publisher"
      - name: data-api
        description: "Role: Subscriber"`

  Affinché due o più componenti possano comunicare correttamente tramite NATS, è requisito stringente che utilizzino e
  siano compilati contro la medesima versione dei contratti AsyncAPI.
]

#norm(
  title: "Database e Migrazioni",
  label: <database-migrazioni>,
)[
  La strategia di migrazione dipende dallo stack tecnologico del servizio:

  - *Servizi NestJS*: Le migrazioni devono essere create e applicate esclusivamente tramite gli strumenti offerti da
    *TypeORM*. È vietato applicare modifiche agli schemi in modo manuale o tramite strumenti alternativi. Le migrazioni
    vengono generate, committate e versionate nella repository del servizio.

  - *Servizi Go*: Le migrazioni utilizzano *file SQL puri* con numerazione progressiva (es.
    `001_create_telemetry_hypertable.sql`). La loro applicazione è gestita tramite tool idiomatici Go (es.
    `golang-migrate`) o script interni al servizio. Anche questi file sono committati e versionati nella repository del
    servizio.

  In entrambi i casi le migrazioni costituiscono elementi di configurazione soggetti a versionamento obbligatorio (vedi
  @config-items).
]

#norm(
  title: "Sicurezza e Crittografia (Crypto Contract)",
  label: <crypto-contract>,
)[
  Qualsiasi dato sensibile (es. credenziali di Gateway, materiale crittografico) non deve mai essere trasmesso né
  persistito in chiaro. Il documento `notip-infra/api-contracts/crypto-contract.md` costituisce la *Single Source of
  Truth* per gli algoritmi, i parametri (es. IV, salt) e i formati di scambio adottati.

  Ogni componente che gestisce cifratura o decifratura (es. `key-material-encryption.ts` in NestJS, `encryptor.go` nei
  servizi Go) deve conformarsi a quanto specificato in quel documento. L'introduzione di schemi crittografici
  alternativi non documentati in `crypto-contract.md` è vietata.
]

#norm(
  title: "Tracciabilità delle Operazioni (Audit Logging)",
  label: <audit-logging>,
)[
  Ogni operazione di mutazione critica (creazione, modifica, eliminazione di risorse) esposta dalle API NestJS deve
  essere tracciata nel flusso NATS `AUDIT_LOG`.

  Omettere la tracciatura su un endpoint critico costituisce un difetto architetturale bloccante in fase di verifica.
]

#norm(
  title: "Protezione degli Endpoint (Multi-Tenancy e RBAC)",
  label: <endpoint-security>,
)[
  Il sistema è *Multi-Tenant*: ogni richiesta HTTP in entrata deve essere associata a un tenant specifico e non può
  accedere a risorse appartenenti ad altri tenant.

  Il controllo degli accessi basato sui ruoli è implementato tramite le guard NestJS:
  - `roles.guard.ts`: verifica che il ruolo dell'utente (estratto dal token Keycloak) sia tra quelli ammessi;
  - `access-policy.guard.ts`: verifica le policy di accesso a livello di risorsa;
  - `block-impersonation.guard.ts`: impedisce l'impersonificazione di altri utenti o tenant.

  Ogni nuovo endpoint deve dichiarare esplicitamente i decoratori `@Tenants()` e `@Roles()` appropriati. L'assenza di
  protezione esplicita su un endpoint esposto non è permessa.
]

#norm(
  title: "Osservabilità del Sistema (Prometheus e Grafana)",
  label: <osservabilita>,
)[
  Ogni microservizio deve esporre un endpoint `/metrics` compatibile con il formato di scraping di *Prometheus*. Le
  metriche esposte consentono il monitoraggio della salute applicativa a runtime (es. latenza, throughput, stato delle
  connessioni NATS).

  La configurazione dei target di scraping e le regole di alerting sono versionate in
  `notip-infra/infra/monitoring/prometheus/`. Le dashboard *Grafana* che visualizzano tali metriche sono versionate in
  `notip-infra/infra/monitoring/grafana/` e devono essere aggiornate contestualmente a ogni modifica architetturale
  rilevante (es. aggiunta di un nuovo servizio o stream NATS). È vietato creare o modificare dashboard esclusivamente
  dall'interfaccia grafica di Grafana senza prima eseguire il commit del corrispondente file JSON.
]

#norm(
  title: "Pattern Architetturale (Microservizi Go)",
  label: <architettura-go>,
)[
  I microservizi sviluppati in Go adottano l'*Architettura Esagonale (Ports and Adapters)*. Il codice sorgente è
  organizzato all'interno della cartella `internal/` secondo la seguente separazione delle responsabilità:

  - `internal/domain/`: Logica di business pura. Non contiene dipendenze verso infrastruttura esterna (database, rete,
    framework). Qualsiasi dipendenza esterna che porti alla violazione di questo principio costituisce un difetto
    architetturale bloccante;
  - `internal/ports/`: Interfacce (contratti Go) che definiscono i comportamenti richiesti o offerti dal dominio.
    Separano il dominio dagli adapter senza accoppiare le implementazioni;
  - `internal/adapters/driving/` (*primary adapters*): Adapter che ricevono input esterno e invocano il dominio (es.
    NATS Consumer, HTTP Handler). Dipendono dai `ports`, non dal `domain` direttamente;
  - `internal/adapters/driven/` (*secondary adapters*): Adapter che implementano i port outbound per comunicare con
    sistemi esterni (es. PostgreSQL Writer, NATS Publisher, encryptor).

  È vietato inserire query SQL, chiamate di rete o logica di framework direttamente nei tipi o nelle funzioni del
  `domain/`.
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
    `openapi.yaml` aggiornato committato nel backend produttore; lockfile `{service}-openapi.yaml` aggiornato e client
    HTTP rigenerato nel servizio consumatore.
  ],
  procedure: (
    (
      name: "Generazione e Commit (Backend Produttore)",
      desc: [
        Uno script NestJS genera offline il file `openapi.yaml` direttamente dai decoratori del codice. Il file viene
        committato nella repository del backend produttore (es. `api-contracts/openapi/openapi.yaml`), rendendolo la
        sorgente di verità del contratto.
      ],
    ),
    (
      name: "Download (Servizio Consumatore)",
      desc: [
        Lo sviluppatore del servizio consumatore lancia lo script dedicato che scarica il file `openapi.yaml` dalla
        repository del backend produttore, puntando a un commit SHA specifico per garantire la riproducibilità. Il file
        scaricato viene rinominato con il prefisso del servizio di provenienza (es. `management-api-openapi.yaml`,
        `data-api-openapi.yaml`).
      ],
    ),
    (
      name: "Lockfile",
      desc: [
        Il file rinominato viene committato nella repository del consumatore. Esso funge da lockfile e traccia l'esatta
        versione dell'API contro cui il consumer è compilato (vedi @config-items).
      ],
    ),
    (
      name: "Generazione Codice",
      desc: [
        Il consumatore esegue il tool di generazione appropriato per autogenerare DTO, interfacce e client HTTP a
        partire dal lockfile aggiornato.
      ],
    ),
  ),
)
