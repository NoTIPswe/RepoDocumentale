#import "lib.typ": ROLES, activity, cite-norm, norm

== Accertamento della Qualità

Il processo di *Accertamento della Qualità* (QA) ha lo scopo di garantire che i processi di lavoro e i prodotti
realizzati siano conformi agli standard stabiliti e soddisfino gli obiettivi di qualità. In particolare, l'Accertamento
della Qualità si concentra sul monitoraggio continuo e sul miglioramento dei processi per prevenire l'introduzione di
difetti, ponendo maggiore attenzione nei confronti del processo rispetto al prodotto.

=== Norme e strumenti per l'accertamento della qualità

#norm(
  title: "Modello PDCA",
  label: <modello-pdca>,
  rationale: [
    *Perché PDCA?* In un contesto Agile con sprint brevi, è fondamentale iterare non solo sul prodotto ma anche sul
    metodo di lavoro. Il ciclo PDCA formalizza questo approccio.
  ],
)[
  Il gruppo adotta il modello iterativo *Plan-Do-Check-Act* per la gestione della qualità:
  - *Plan*: Pianificare gli obiettivi di qualità e i processi per raggiungerli (es. definizione delle metriche nel Piano
    di Qualifica);
  - *Do*: Eseguire i processi secondo le norme stabilite;
  - *Check*: Monitorare e misurare i processi e i prodotti rispetto agli obiettivi tramite l'ausilio di Dashboard;
  - *Act*: Adottare azioni correttive per colmare i gap rilevati e migliorare le prestazioni future.
]

#norm(
  title: "Gestione delle Metriche",
  label: <gestione-metriche>,
)[
  La qualità viene valutata quantitativamente tramite metriche definite nel *Piano di Qualifica*. Le metriche si
  dividono in:
  - *Metriche di Processo*: Misurano l'efficienza del metodo di lavoro in utilizzo in un dato momento (es. Earned
    Value). La fonte dati principale risulta essere *Jira*;
  - *Metriche di Prodotto*: Misurano la qualità intrinseca degli artefatti (es. Indice Gulpease). Le metriche vengono
    raccolte e storicizzate al termine di ogni Sprint.
]

#norm(
  title: "Strumenti di Monitoraggio",
  label: <strumenti-monitoraggio>,
)[
  Il monitoraggio della qualità è supportato dai seguenti strumenti:
  - *Jira Dashboard*: Per la visualizzazione in tempo reale delle metriche di processo che permettono di avere un'idea
    precisa di come il gruppo stia procedendo. In particolare tramite l'utilizzo di: Burndown Chart, Velocity Chart,
    distribuzione del carico di lavoro;
  - *GitHub Actions & `notipdo`*: Per la raccolta automatica delle metriche di prodotto. I log delle pipeline
    costituiscono la prova oggettiva del superamento dei controlli implementati fino a quel momento.
]

=== Attività del processo

#activity(
  title: "Definizione e Evoluzione del Sistema di Qualità",
  roles: (ROLES.amm, ROLES.resp),
  norms: ("modello-pdca", "gestione-metriche"),
  input: [Avvio progetto, esiti delle Retrospective, non conformità rilevate],
  output: [Norme di Progetto revisionate, pipeline di verifica aggiornate],
  procedure: (
    (
      name: "Formalizzazione degli Standard",
      desc: [Definire e documentare le convenzioni per la codifica, la stesura dei documenti e le modalità operative del
        gruppo, aggiornando le presenti Norme di Progetto.],
    ),
    (
      name: "Automazione dei Controlli",
      desc: [Predisporre verifiche automatiche cercando di prevenire gli errori alla fonte, rendendo quindi impossibile
        il mancato rispetto delle norme.],
    ),
  ),
)

#activity(
  title: "Misurazione e Raccolta Dati",
  roles: (ROLES.ver, ROLES.amm),
  norms: ("gestione-metriche", "strumenti-monitoraggio"),
  input: [Attività di sviluppo in corso, Chiusura Sprint],
  output: [Dati grezzi delle metriche],
  procedure: (
    (
      name: "Raccolta Automatica",
      desc: [I sistemi di CI/CD raccolgono automaticamente le metriche di prodotto (es. coverage) ad ogni push/PR.
        `notipdo` verifica la conformità dei documenti.],
    ),
    (
      name: "Raccolta Manuale",
      desc: [Il Responsabile verifica su Jira la correttezza del tracciamento temporale e l'aggiornamento degli stati
        dei task, demandata comunque al singolo.],
    ),
  ),
)

#activity(
  title: "Valutazione e Miglioramento",
  roles: (ROLES.resp, "Tutti i membri"),
  norms: ("modello-pdca",),
  input: [Dati delle metriche, fine dello Sprint],
  output: [Azioni correttive (Task Jira), Aggiornamento Norme],
  procedure: (
    (
      name: "Analisi degli Scostamenti",
      desc: [Confrontare i valori misurati con le soglie di accettazione definite nel Piano di Qualifica.],
    ),
    (
      name: "Identificazione Cause",
      desc: [Se una metrica è fuori soglia, analizzare le cause (es. stime errate).],
    ),
    (
      name: "Pianificazione Azioni Correttive",
      desc: [
        Definire azioni concrete per risolvere il problema nello sprint successivo:
        - Se il problema è di natura procedurale è necessario andare ad aggiornare le Norme di Progetto;
        - Se il problema è di natura tecnica è necessario creare task correttivi.
      ],
    ),
  ),
)
