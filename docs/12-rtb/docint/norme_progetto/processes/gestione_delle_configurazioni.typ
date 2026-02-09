#import "lib.typ": ROLES, activity, cite-norm, norm

== Gestione delle Configurazioni

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
  title: "Elementi di Configurazione",
  label: <config-items>,
)[
  Vengono sottoposti a controllo di versione e configurazione i seguenti elementi:
  - *Documentazione*: Tutti i file sorgente `.typ` e gli asset contenuti nella directory `docs/`;
  - *Sito Web*: I template e gli script per la generazione del sito statico contenuti nella directory `site/`;
  - *Dizionari*: I file di dizionario personalizzati (es. `.hunspell/it_IT.dic`) utilizzati per il controllo
    ortografico;
  - *Schemi di validazione*: File contenuti all'interno della directory `.schemas/`;
  - *Automazione*: Il codice sorgente del tool `notipdo` e i workflow di GitHub (`.github/workflows/`) utilizzati nella
    chiusura delle PR e rilascio del sito web.
]

#norm(
  title: "Strategia dei Repository",
  label: <repo-strategy>,
)[
  Il gruppo adotta una strategia Multi-repo per garantire una netta separazione delle responsabilità e mantenere lineare
  la cronologia dei contributi. La struttura è così suddivisa:
  - *Repository Documentale*: Contiene la documentazione di progetto, il sito web e il tool `notipdo`;
  - *Repository PoC*: Contiene il codice sorgente per la Technology Baseline (Proof of Concept);
  - *Repository MVP*: Conterrà il codice sorgente del prodotto richiesto dall'azienda proponente (Minimum Viable
    Product).
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
  title: "Configurazione Task Jira",
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
  title: "Restrizioni e Check",
  label: <restriction-check>,
)[
  Per garantire che solo configurazioni verificate confluiscano nel ramo principale, vengono applicate le seguenti
  regole su GitHub):
  - *Merge Restriction*: Il merge è consentito solo tramite Pull Request approvata da almeno un membro del team che in
    quel momento sta ricoprendo il ruolo di *Verificatore*.
  - *Status Check*: Il merge è bloccato se i check automatici (`pr-check-n-build`) falliscono, indicando cosa correggere
    per allinearsi alle norme finora descritte.
]

=== Attività del processo

#activity(
  title: "Identificazione della Configurazione",
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
  title: "Controllo della Configurazione",
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
  title: "Registrazione dello Stato della Configurazione",
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
  title: "Valutazione della Configurazione",
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
