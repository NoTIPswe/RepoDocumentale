#import "lib.typ": ROLES, activity, cite-norm, norm

== Gestione delle configurazioni

Il processo di *Gestione delle Configurazioni* ha lo scopo di identificare, definire e tracciare gli elementi che
compongono il prodotto software e la documentazione, controllandone le modifiche e registrandone lo stato nel corso del
progetto.

=== Norme e strumenti della gestione di configurazione

#norm(
  title: "Strumenti a supporto",
  label: <strumenti-config>,
)[
  Il gruppo utilizza i seguenti strumenti per garantire l'integrità e la tracciabilità dei prodotti:

  #table(
    columns: (auto, 1fr),
    align: (center, left),
    table.header([Strumento], [Descrizione e Utilizzo]),
    [Git],
    [Sistema di controllo di versione, utilizzato per tracciare la storia delle modifiche di documenti, codice sorgente
      e script di automazione.],

    [GitHub], [Gestisce le Pull Request e le pipeline di verifica create tramite GitHub Actions.],
    [Jira],
    [Ogni modifica alla configurazione viene tracciata da un Task su Jira Board, contenente stime temporali, consuntivi
      e ruoli coinvolti.],

    [`notipdo`],
    [Automatizza la validazione, la compilazione dei documenti Typst e la generazione del sito statico, garantendo build
      coerenti.],
  )
]

#norm(
  title: "Elementi di configurazione",
  label: <config-items>,
)[
  Vengono sottoposti a controllo di versione e configurazione i seguenti elementi:
  - *Documentazione*: Tutti i file sorgente `.typ` e gli asset contenuti nella directory `docs/`;
  - *Sito Web*: I template e gli script per la generazione del sito statico contenuti nella directory `site/`;
  - *Dizionari*: I file di dizionario personalizzati (es. `.hunspell/it_IT.dic`) utilizzati per il controllo
    ortografico;
  - *Schemi di validazione*: File contenuti all'interno della directory `.schemas/`;
  - *Automazione*: Il codice sorgente del tool `notipdo` e i workflow di GitHub (`.github/workflows/`) utilizzati nella
    chiusura delle PR e rilascio del sito web;
  - *File di configurazione degli ambienti* (`.env.example`): Ogni repository deve contenere il file `.env.example`
    committato, che documenta tutte le variabili d'ambiente necessarie all'esecuzione del servizio senza esporre valori
    reali. Per la politica di gestione dei segreti si rimanda alla @gestione-segreti;
  - *Migrazioni del database*: I file di migrazione (generati da TypeORM per i servizi NestJS, o file SQL puri per i
    servizi Go) sono elementi di configurazione soggetti a versionamento obbligatorio. Per le norme di utilizzo si
    rimanda alla @database-migrazioni;
  - *Contratti OpenAPI (produttore)*: Il file `openapi.yaml` generato dai decoratori NestJS è committato nella
    repository del servizio backend produttore (es. `api-contracts/openapi/openapi.yaml`) ed è un elemento di
    configurazione soggetto a versionamento;
  - *Lockfile delle API (consumatore)*: Il file `{service}-openapi.yaml` scaricato dalla repository del servizio
    produttore e committato nella repository del consumatore costituisce un lockfile. Esso rappresenta la fotografia
    dell'esatta versione dell'API contro cui il consumer è compilato (es. `management-api-openapi.yaml`). Per il
    workflow di aggiornamento si rimanda alla @workflow-api-contracts;
  - *Definizioni degli ambienti di sviluppo* (DevContainers): I Dockerfile base contenuti in
    `notip-infra/devcontainers/` e i file `.devcontainer/devcontainer.json` presenti in ogni repository sono elementi di
    configurazione soggetti a versionamento. Essi garantiscono la riproducibilità degli ambienti di sviluppo. Per la
    struttura e l'architettura si rimanda alla @devcontainers.
  - *Immagini Docker di build e rilascio* (`notip-infra/containers/`): I Dockerfile base per la build e il rilascio in
    produzione dei servizi applicativi sono elementi di configurazione soggetti a versionamento. Per la policy di
    utilizzo si rimanda alla @build-release-process;
  - *Topologia Event-Driven (NATS JetStream Streams)*: I file JSON che definiscono i flussi JetStream, le loro policy di
    retention e le configurazioni dei consumer (es. `TELEMETRY.json`, `AUDIT_LOG.json`, `COMMANDS.json`) devono essere
    versionati in `notip-infra/infra/nats/streams/`. È vietato creare o modificare stream direttamente sull'istanza NATS
    senza prima di eseguire il commit della definizione corrispondente; ogni modifica alla topologia del message broker
    passa obbligatoriamente per Pull Request.
]

#norm(
  title: "Approccio GitOps per l'infrastruttura",
  label: <gitops-infra>,
)[
  Il repository Git è l'unica fonte di verità per lo stato dell'infrastruttura. È vietata qualsiasi modifica manuale
  tramite interfaccia grafica o CLI che non sia preceduta dal corrispondente commit nel repository:

  - *Grafana*: Le dashboard non possono essere create o modificate esclusivamente dall'interfaccia grafica. Ogni
    modifica deve essere esportata come file JSON e committata in `notip-infra/infra/monitoring/grafana/` tramite Pull
    Request (vedi @osservabilita);
  - *NATS JetStream*: Stream, consumer e policy di retention non possono essere modificati tramite CLI NATS. Ogni
    modifica deve essere riflessa nei file JSON in `notip-infra/infra/nats/streams/` tramite Pull Request (vedi
    @config-items);
  - *Keycloak*: Le configurazioni di realm, client, ruoli e policy non possono essere modificate esclusivamente
    dall'interfaccia di amministrazione. Il realm export aggiornato deve essere committato nella directory di
    configurazione dedicata in `notip-infra/` tramite Pull Request;
  - *Nginx*: Le regole di routing, la configurazione TLS e gli header di sicurezza non possono essere modificati
    direttamente sui server. Ogni modifica deve essere applicata ai file in `notip-infra/infra/nginx/` tramite Pull
    Request (vedi @nginx-gateway).

  Ogni stato dell'infrastruttura non tracciato nel repository è considerato configurazione non autorizzata.
]

#norm(
  title: "Strategia dei repository",
  label: <repo-strategy>,
)[
  Il gruppo adotta una strategia Multi-repo per garantire una netta separazione delle responsabilità e mantenere lineare
  la cronologia dei contributi. La struttura è così suddivisa:
  - *Repository Documentale*: Contiene la documentazione di progetto, il sito web e il tool `notipdo`;
  - *Repository PoC*: Contiene il codice sorgente per la Technology Baseline (Proof of Concept);
  - *Repository di Prodotto*: Il prodotto è sviluppato attraverso le seguenti repository distinte, una per servizio,
    secondo un'architettura a microservizi:
    - `notip-infra`: infrastruttura, configurazione di monitoring (Prometheus+Grafana), NATS, Nginx, devcontainer base,
      api-contracts e test di sistema e integrazione multi-servizio. È un monorepo;
    - `notip-data-api`: backend NestJS e MeasuresDB (PostgreSQL + TimescaleDB);
    - `notip-frontend`: web app Angular;
    - `notip-simulator-backend`: contiene il backend in Go e il database SQLite del simulatore;
    - `notip-simulator-frontend`: contiene la web app Angular del simulatore;
    - `notip-data-consumer`: data-consumer in Go;
    - `notip-provisioning-service`: provisioning service in NestJS;
    - `notip-management-api`: management API in NestJS.

  *Gestione dei Monorepo*

  Il repository `notip-infra`è strutturato come monorepo, contenendo più componenti con cicli di vita distinti.

  *Versionamento*: Per `notip-infra` non si traccia una versione globale, in quanto funge da contenitore di
  infrastruttura condivisa. Per la politica di versionamento automatico tramite CI/CD si rimanda alla
  @versionamento-codice.

  *Struttura delle directory di test in `notip-infra`*

  La repository `notip-infra` ospita i test che coinvolgono più servizi, secondo la seguente struttura:
  - `notip-infra/tests/integration/`: test di integrazione multi-servizio;
  - `notip-infra/tests/system/`: test di sistema (e2e), se automatizzati.

  Per la classificazione completa dei test e la norma sulla loro collocazione si rimanda alla @analisi-dinamica.
]

#norm(
  title: "Baseline",
  label: <baseline-def>,
)[
  Una Baseline rappresenta una versione stabile e approvata della configurazione. Nella repository documentale, le
  baseline sono definite a livello strutturale tramite le directory di primo livello in `docs/`:
  - `11-candidatura`: Baseline di Candidatura;
  - `12-rtb`: Requirements and Technology Baseline.

  Ogni modifica a una baseline passata (conclusa) è vietata se non previa autorizzazione esplicita del Responsabile e
  bloccata dalle automazioni di verifica.
]

#norm(
  title: "Configurazione work items Jira",
  label: <jira-config>,
)[
  Ogni modifica alla configurazione deve essere associata a un Task su Jira. È obbligatorio compilare i seguenti campi
  per garantire un tracciamento delle risorse corretto:
  - *Autore*: Chi esegue la modifica;
  - *Ruolo*: Il ruolo ricoperto durante l'attività (es. Analista, Verificatore, ...);
  - *Time Tracking*:
    - _Original Estimate_: Tempo stimato prima di iniziare l'attività;
    - _Time Spent_: Tempo effettivamente impiegato (da aggiornare a fine attività).
]

#norm(
  title: "Restrizioni e check",
  label: <restriction-check>,
)[
  Per garantire che solo configurazioni verificate confluiscano nel ramo principale, vengono applicate le seguenti
  regole su GitHub):
  - *Merge Restriction*: Il merge è consentito solo tramite Pull Request approvata da almeno un membro del team che in
    quel momento sta ricoprendo il ruolo di *Verificatore*.
  - *Status Check*: Il merge è bloccato se i check automatici della pipeline CI/CD falliscono, indicando cosa correggere
    per allinearsi alle norme finora descritte. La struttura dei workflow varia per tipologia di repository:
    - *Repository Documentale*: Il workflow `pr-check-n-build` esegue `notipdo check pr` (validazione sintattica,
      controllo ortografico e schemi) e `notipdo build changes` (compilazione di anteprima degli artefatti modificati);
    - *Repository di Prodotto*: La pipeline è articolata in tre workflow distinti:
      - `pr-check.yml`: Validazioni rapide (linting, build, test di unità) eseguite ad ogni aggiornamento di PR;
      - `quality-checks.yml`: Analisi approfondita tramite SonarQube/SonarCloud (Code Coverage, Code Smells,
        Vulnerabilità);
      - `release.yml`: Calcolo automatico della versione semantica tramite *Semantic Release* e pubblicazione
        dell'immagine Docker sul GitHub Container Registry (GHCR), eseguito al merge su `main`.
]

#norm(
  title: "Versionamento del codice sorgente",
  label: <versionamento-codice>,
  rationale: [
    La logica di avanzamento automatico si applica allo stato del branch `main` al momento del merge. In presenza di più
    commit in una singola Pull Request, vince il prefisso di peso maggiore. Questo approccio elimina la necessità di
    aggiornare manualmente i numeri di versione, riducendo il rischio di errori e disallineamenti tra repository.
  ],
)[
  Il versionamento del codice sorgente segue una strategia *Trunk-Based Development*: lo sviluppo avviene sul branch
  `main` tramite Pull Request piccole e frequenti, senza overhead derivante da strategie come GitFlow.

  Le versioni (Major, Minor, Patch) e i relativi tag Git vengono calcolati e generati automaticamente dalla CI/CD
  tramite il tool *Semantic Release* (configurato tramite il file `.releaserc.json` presente in ogni repository di
  prodotto), che legge i prefissi dei commit secondo lo standard Conventional Commits. Ogni repository di prodotto
  avanza di versione in modo indipendente.

  Per i prefissi dei commit e il loro peso nella determinazione della versione si rimanda alla
  @branching-conventional-commits. Per le norme sulla strategia dei repository e la gestione dei monorepo si rimanda
  alla @repo-strategy.
]

#norm(
  title: "Gestione dei segreti e configurazioni",
  label: <gestione-segreti>,
)[
  Le configurazioni e i segreti di progetto sono gestiti tramite file `.env`. In fase di CI/deploy i valori vengono
  iniettati tramite GitHub Secrets.

  I file `.env` reali non vengono mai committati nel repository, in quanto esclusi tramite `.gitignore` come definito
  nella @git-ignore-policy. Ogni repository deve invece contenere un file `.env.example` committato, che documenta tutte
  le variabili necessarie all'esecuzione senza esporre valori reali (vedi @config-items).

  I file `.env` locali rappresentano sempre la configurazione di sviluppo (dev), mentre la configurazione generata da
  GitHub Secrets è quella di produzione (prod).

  Per il setup del file `.env` locale da parte di ogni sviluppatore si rimanda alla @setup-devcontainer.
]

#norm(
  title: "Disciplina dei commit",
  label: <disciplina-commit>,
)[
  Per correzioni minori o aggiustamenti all'ultimo commit, è vietato produrre una sequenza di micro-commit correttivi
  consecutivi (es. tre commit successivi con messaggio "fix typo"). Si deve invece ricorrere a:
  - `git commit --amend`: per modificare l'ultimo commit non ancora pushato sul repository remoto;
  - `git reset`: per ricomporre più commit locali in uno solo prima del push.

  Questa norma vale sia per il codice sorgente sia per la documentazione. Per la documentazione il rimando operativo è
  alla @branching-commit-docs.
]

=== Attività del processo

#activity(
  title: "Identificazione della configurazione",
  roles: (ROLES.amm, ROLES.resp),
  norms: ("config-items", "struttura-repo-docs", "uso-notipdo"),
  input: [Nuovi artefatti da produrre],
  output: [Struttura di directory conforme],
  procedure: (
    (
      name: "Collocazione",
      desc: [Ogni nuovo documento o script deve essere collocato nella directory corretta secondo la struttura definita
        dal processo precedente.],
    ),
    (
      name: "Metadati",
      desc: [I documenti devono essere accompagnati dal relativo file `.meta.yaml` conforme allo schema
        `.schemas/meta.schema.json` per garantire la validazione automatica.],
    ),
    (
      name: "Verifica Strutturale",
      desc: [Eseguire `notipdo check` per verificare che la nuova struttura sia conforme alle regole del progetto.],
    ),
  ),
)

#activity(
  title: "Controllo della configurazione",
  roles: (ROLES.aut, ROLES.ver),
  norms: ("jira-config", "branching-commit-docs", "uso-notipdo"),
  input: [Necessità di modifica (Task o Bug)],
  output: [Configurazione aggiornata su `main`],
  procedure: (
    (
      name: "Creazione Task",
      desc: [Apertura di un ticket su Jira Board specificando la stima temporale e il ruolo.],
    ),
    (
      name: "Branching e Implementazione",
      desc: [
        Creazione del branch secondo nomenclatura (es. `NT-10-descrizione`) e implementazione della modifica.
      ],
    ),
    (
      name: "Verifica Automatica",
      desc: [
        All'apertura della Pull Request, il workflow `pr-check-n-build` esegue automaticamente:
        - `notipdo check pr`: Validazione sintattica, controllo ortografico (Hunspell) e validazione schemi;
        - `notipdo build changes`: Compilazione di anteprima dei soli artefatti modificati.
      ],
    ),
    (
      name: "Review",
      desc: [Un Verificatore controlla le modifiche e richiede eventuali correzioni.],
    ),
    (
      name: "Approvazione Tecnica",
      desc: [
        Se la verifica è superata, viene applicata la label `merge-ready`. Questo innesca il workflow `pr-merge-ready`
        che conferma la mergeability della PR.
      ],
    ),
    (
      name: "Consuntivazione",
      desc: [Registrazione delle ore effettive su Jira (_Time Spent_) e chiusura del Task.],
    ),
  ),
)

#activity(
  title: "Registrazione dello stato della configurazione",
  roles: (ROLES.amm,),
  norms: ("uso-notipdo", "baseline-def"),
  input: [Decisione di pubblicazione],
  output: [Sito Web aggiornato, Changelog],
  rationale: [
    Questa attività garantisce la visibilità immediata e pubblica dello stato corrente del progetto a tutti gli
    stakeholder tramite automazione.
  ],
  procedure: (
    (
      name: "Automazione e Snapshot",
      desc: [
        L'Amministratore avvia manualmente il workflow `deploy.yml` (dispatch). L'operazione è volutamente manuale in
        quanto la registrazione dello stato deve essere una operazione voluta e non eseguibile accidentalmente. Il
        sistema esegue `notipdo generate site`, generando la documentazione statica pubblicandoli su GitHub Pages come
        snapshot ufficiale e immutabile della configurazione in quel preciso momento.
      ],
    ),
  ),
)

#activity(
  title: "Valutazione della configurazione",
  roles: (ROLES.resp, ROLES.anal),
  norms: ("baseline-def", "jira-config"),
  input: [Rilascio di Baseline imminente],
  output: [Matrice di Tracciamento, Report di Audit],
  procedure: (
    (
      name: "Audit dei Configuration Item",
      desc: [
        Verifica l'integrità e la presenza fisica di tutti i componenti previsti per il rilascio, assicurandosi che ogni
        elemento sia correttamente versionato e coerente con lo stato descritto.
      ],
    ),
  ),
)
