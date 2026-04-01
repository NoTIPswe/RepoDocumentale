#import "../../00-templates/base_verbale.typ" as base-report
#import "../../00-templates/base_configs.typ" as base

#let metadata = yaml(sys.inputs.at("meta-path", default: "verbint_2026-03-31.meta.yaml"))

#base-report.apply-base-verbale(
  date: "2026-03-31",
  scope: base-report.INTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Valerio Solito \
        Leonardo Preo \
        Matteo Mantoan \
        Alessandro Contarini \
        Francesco Marcon \
      ],
    ),
  ),
  abstract: "Meeting interno dedicato alla riprogrammazione delle scadenze, all'allineamento sullo stato dello sviluppo, alla pianificazione dei test di sistema e all'aggiornamento della documentazione di progetto.",
  changelog: metadata.changelog,
)[

  In data *31 marzo 2026* alle ore 9:00 si è svolta una riunione interna del gruppo in modalità telematica.

  L'ordine del giorno prevede le seguenti questioni operative:
  - Riprogrammazione delle scadenze di progetto e assegnazione dei ruoli;
  - Allineamento sullo stato di avanzamento dello sviluppo software e dell'infrastruttura;
  - Pianificazione strutturata dei test e aggiornamento del Piano di Qualifica;
  - Aggiornamento e verifica della documentazione tecnica e di progetto.

][

  #base-report.report-point(
    discussion_point: [Riprogrammazione scadenze e ruoli],
    discussion: [
      Il gruppo ha discusso la necessità di ricalibrare le tempistiche di consegna del progetto alla luce delle attività
      ancora da completare.
    ],
    decisions: [
      Si è deciso di posticipare ufficialmente la data di scadenza prevista al 13 aprile 2026, mantenendo comunque
      l'obiettivo interno di concludere i lavori con anticipo rispetto a tale data.
    ],
  )

  #base-report.report-point(
    discussion_point: [Stato di avanzamento sviluppo e infrastruttura],
    discussion: [
      Il team ha fatto il punto sullo stato di avanzamento del software, concentrandosi sulle componenti core. È emersa
      l'urgenza di finalizzare l'SDK e il frontend per garantire la continuità del lavoro. Inoltre è sorta la necessità
      di configurare gli strumenti di monitoraggio (Prometheus e Grafana).
    ],
    decisions: [
      Si è stabilito di dare priorità assoluta al completamento del codice relativo al frontend e all'SDK.
      Contemporaneamente si procederà con il deployment degli strumenti di monitoraggio basandosi sul Proof of Concept
      già esistente.
    ],
  )

  #base-report.report-point(
    discussion_point: [Pianificazione dei test e qualità del software],
    discussion: [
      Una parte rilevante dell'incontro è stata dedicata all'organizzazione delle attività di collaudo. È stata
      sottolineata l'importanza di controllare in modo rigoroso i test già implementati. È anche emersa la necessità di
      pianificare in modo strutturato i futuri test di sistema, partendo dall'analisi dei requisiti di capitolato e dai
      flussi principali suddivisi per attori.
    ],
    decisions: [
      Si è deciso che tutti i test di unità e di integrazione realizzati per i singoli servizi dovranno essere
      confrontati con quelli presenti nel Piano di Qualifica. Inoltre dovrà essere stilata una lista preliminare dei
      test di sistema necessari, in modo da poter procedere con la loro esecuzione.
    ],
  )

  #base-report.report-point(
    discussion_point: [Aggiornamento della documentazione tecnica],
    discussion: [
      Il gruppo ha valutato lo stato di avanzamento della documentazione di progetto, individuando le specifiche sezioni
      che richiedono stesura, aggiornamento o verifica formale per garantire l'allineamento con l'attuale stato del
      codice sorgente.
    ],
    decisions: [
      Si è deciso di procedere con l'aggiornamento delle Norme di Progetto e con la redazione e verifica delle
      Specifiche Tecniche relative al Simulatore e alla Data-API. Parallelamente, continuerà la stesura dei vari Manuali
      Utente.
    ],
  )

][

  #pagebreak()

  = Esiti e decisioni finali
  La riunione si è conclusa fissando la consegna al 13 aprile 2026 e chiarendo le priorità operative. Lo sviluppo si
  concentrerà sulla chiusura di SDK e frontend e sulla risoluzione tempestiva dei blocchi infrastrutturali. È stata
  definita una rigorosa roadmap per la qualità come detto nei punti precedenti, così da controllare e implementare
  correttamente i test necessari. Tutte queste attività saranno costantemente affiancate dal progressivo aggiornamento
  dei manuali, delle norme e delle specifiche tecniche.
]
