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
  - *Metriche di Prodotto*: Misurano la qualità degli artefatti (es. Indice Gulpease). Le metriche vengono raccolte e
    storicizzate al termine di ogni Sprint.
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
  roles: (ROLES.amm,),
  norms: ("modello-pdca", "gestione-metriche"),
  input: [Avvio progetto, esiti delle Retrospective, non conformità rilevate],
  output: [Norme di Progetto revisionate, pipeline di verifica aggiornate],
  procedure: (
    (
      name: "Formalizzazione degli Standard",
      desc: [Definire e documentare le convenzioni per la codifica, la stesura dei documenti e le modalità operative del
        gruppo, aggiornando il presente documento.],
    ),
    (
      name: "Automazione dei Controlli",
      desc: [Predisporre verifiche automatiche cercando di prevenire gli errori alla fonte, riducendo quindi le
        possibilità di un mancato rispetto delle norme.],
    ),
  ),
)

#activity(
  title: "Accertamento della Qualità del Prodotto",
  roles: (ROLES.ver,),
  norms: ("gestione-metriche", "strumenti-monitoraggio"),
  input: [Prodotti in rilascio (Codice, Documenti), Report di Verifica],
  output: [Report di Qualità del Prodotto, Non conformità rilevate],
  procedure: (
    (
      name: "Verifica delle Metriche",
      desc: [
        Confrontare le metriche di prodotto raccolte automaticamente (es. Code Coverage, Indice Gulpease) con le soglie
        di accettabilità definite nel Piano di Qualifica.
      ],
    ),
    (
      name: "Controllo di Conformità",
      desc: [
        Accertarsi che tutti gli artefatti siano stati sottoposti alle attività di Verifica obbligatorie e che non vi
        siano difetti bloccanti aperti.
      ],
    ),
  ),
)

#activity(
  title: "Accertamento della Qualità del Processo",
  roles: (ROLES.resp, ROLES.amm),
  norms: ("modello-pdca", "gestione-metriche"),
  input: [Dati di processo (Jira, Git logs), Svolgimento delle attività],
  output: [Report di Qualità del Processo, Azioni correttive],
  rationale: [
    Attività prevista dallo standard. Si assicura che il team stia lavorando secondo le regole definite nelle Norme di
    Progetto.
  ],
  procedure: (
    (
      name: "Audit dei Processi",
      desc: [
        Verificare periodicamente che gli strumenti siano usati correttamente.
      ],
    ),
    (
      name: "Analisi delle Performance",
      desc: [
        Valutare le metriche di processo (es. Earned Value, Velocity) per identificare inefficienze nel metodo di
        lavoro.
      ],
    ),
    (
      name: "Miglioramento Continuo",
      desc: [
        Attuare le azioni correttive (Act) emerse dalle retrospettive per aggiornare i processi e prevenire il ripetersi
        delle eventuali non conformità rilevate.
      ],
    ),
  ),
)
