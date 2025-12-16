#import "../../00-templates/base_verbale.typ" as base-report
#import "../../00-templates/base_configs.typ" as base

#let metadata = yaml(sys.inputs.meta-path)

#base-report.apply-base-verbale(
  date: "2025-12-15",
  scope: base-report.INTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Francesco Marcon \
        Valerio Solito \
        Leonardo Preo \
        Alessandro Mazzariol \
        Matteo Mantoan \
        Alessandro Contarini \
        Mario De Pasquale
      ],
    ),
  ),
  abstract: "Verbale della riunione interna di Sprint Review dello Sprint 2. La sessione ha vertito sull'analisi critica dei blocchi emersi durante la stesura dell'Analisi dei Requisiti, determinando una ri-pianificazione delle attività e la definizione puntuale degli obiettivi per il prossimo ciclo di lavoro.",
  changelog: metadata.changelog,
)[

  In data *15 dicembre 2025*, alle ore *16:45*, si è svolta una riunione interna del gruppo NoTIP in modalità telematica
  sul server *Discord* ufficiale del team. L'incontro è terminato alle ore *18:05*.

  L'ordine del giorno, in occasione della Sprint Review, prevede:
  - Analisi delle attività svolte e gestione delle criticità bloccanti nel precedente Sprint;
  - Revisione e approvazione degli strumenti di automatizzazione;
  - Aggiornamento delle Norme di Progetto e formalizzazione delle milestone interne;
  - Discussione approfondita sulle problematiche dell'Analisi dei Requisiti;
  - Pianificazione operativa del prossimo Sprint.

][

  #base-report.report-point(
    discussion_point: [Sprint Review: criticità Analisi dei Requisiti e rinvio rilascio.],
    discussion: [
      L'obiettivo primario dello Sprint era il consolidamento dell'#link(
        "https://notipswe.github.io/docs/12-rtb/docest/analisi_requisiti.pdf",
      )[Analisi dei Requisiti] in una versione stabile (v0.4.0).

      In fase di stesura, è emerso che diversi Casi d'Uso (UC), inizialmente ritenuti maturi e stabili, mancavano del
      necessario livello di dettaglio. Questa mancanza ha impedito la corretta derivazione dei requisiti, causando uno
      ritardo nelle tempistiche di redazione previste. Il gruppo ha deciso di dedicare, durante la riunione, una piccola
      sessione di confronto per definire univocamente il livello di granularità richiesto per la descrizione degli UC.
    ],
    decisions: [
      Si deciso di rinviare i rilasci di v0.3.0 e v0.4.0, riallocando i relativi task nel prossimo Sprint con priorità
      maggiore. È stato inoltre stabilito di richiedere un confronto mirato con il prof. Cardin al termine della
      prossima lezione, al fine di validare l'adeguatezza della profondità di analisi ora ipotizzata.
    ],
    actions: (
      (
        desc: "Spostamento task: Analisi dei Requisiti v0.3.0 - aggiustamenti UC",
        url: "https://notipswe.atlassian.net/browse/NT-101",
      ),
      (
        desc: "Spostamento task: Analisi dei Requisiti v0.4.0 - inserimento requisiti funzionali",
        url: "https://notipswe.atlassian.net/browse/NT-89",
      ),
      (
        desc: "Spostamento task: Analisi dei Requisiti v0.4.0 - inserimento requisiti qualitativi e di vincolo",
        url: "https://notipswe.atlassian.net/browse/NT-92",
      ),
      (
        desc: "Spostamento task: Analisi dei Requisiti v0.4.0 - inserimento requisiti di prestazione e sicurezza",
        url: "https://notipswe.atlassian.net/browse/NT-98",
      ),
      (
        desc: "Spostamento task: Analisi dei Requisiti v0.4.0 - inserimento tracciamento requisito-fonte",
        url: "https://notipswe.atlassian.net/browse/NT-104",
      ),
      (
        desc: "Spostamento task: Analisi dei Requisiti v0.4.0 - inserimento tracciamento fonte-requisiti",
        url: "https://notipswe.atlassian.net/browse/NT-107",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Revisione tool di automatizzazione.],
    discussion: [
      È stato presentato dall'Amministratore il lavoro svolto sui nuovi strumenti per l'automazione di processi di
      verifica.
    ],
    decisions: [
      Il gruppo approva l'integrazione dei nuovi strumenti nel workflow operativo, al fine di efficientare quanto più
      possibile le attività di verifica.
    ],
  )

  #base-report.report-point(
    discussion_point: [Aggiornamento Piano di Progetto.],
    discussion: [
      Le difficoltà riscontrate nell'Analisi dei Requisiti hanno evidenziato l'esigenza di formalizzare con maggior
      rigore la gestione dei rischi e la specifica dei requisiti. Si rende necessario un aggiornamento del Piano di
      Progetto per mitigare il rischio di futuri blocchi operativi.

      Contestualmente, si è discusso l'approccio operativo per la prosecuzione del documento.
    ],
    decisions: [
      A seguito del confronto, si decide di:
      - Finalizzare il consuntivo dello Sprint 2;
      - Istituire lo Sprint 3 con una pianificazione dettagliata delle attività.
    ],
    actions: (
      (
        desc: "Piano di Progetto v0.3.0 - Aggiornamento Sprint 2 e Aggiunta Sprint 3",
        url: "https://notipswe.atlassian.net/browse/NT-195",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Aggiornamento Piano di Qualifica.],
    discussion: [
      Dall'analisi dello stato attuale del Piano di Qualifica è emersa la necessità di una revisione critica delle
      metriche finora adottate. Il gruppo intende verificare che le metriche selezionate offrano un reale valore
      informativo (es. efficacia durante le Review) e presentino un trade-off favorevole tra costo di gestione e
      utilità, eliminando quelle che costituiscono un mero onere burocratico, favorendo metriche efficaci ed efficienti
      nel contesto del progetto.
    ],
    decisions: [
      I responsabili dell'aggiornamento del Piano di Qualifica procederanno secondo i seguenti step:
      - Validazione delle metriche in base al valore aggiunto apportato al processo;
      - Progettazione della struttura del Cruscotto di Valutazione (organizzazione e contenuti);
      - Analisi preliminare e stesura dei metodi di testing (attività opzionale).
    ],
    actions: (
      // da inserire nuovo task
      (
        desc: "Piano di Qualifica v0.3.0 - Palestra per sezione Testing",
        url: "https://notipswe.atlassian.net/browse/NT-146",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Aggiornamento Norme di Progetto.],
    discussion: [
      L'esperienza maturata nell'ultimo periodo ha portato alla luce lacune normative che richiedono un aggiornamento
      del documento Norme di Progetto nel prossimo Sprint.
    ],
    decisions: [
      Nello Sprint 3 verranno integrate le seguenti sezioni:
      - Formalizzazione dei Processi Primari: definizione puntuale dei processi di Fornitura, Sviluppo (compatibilmente
        con lo stato avanzamento lavori) e Gestione della Configurazione;
      - Inserimento e definizione delle Metriche, subordinata alla loro approvazione nel Piano di Qualifica.
    ],
    actions: (
      (
        desc: "Norme di Progetto - v0.6.0",
        url: "https://notipswe.atlassian.net/browse/NT-67",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Rotazione dei ruoli.],
    discussion: [
      Si è proceduto alla definizione dei ruoli per il prossimo periodo, bilanciando il carico di lavoro in funzione
      della disponibilità oraria dichiarata dai singoli membri.
    ],
    decisions: [
      L'assegnazione dei ruoli è stata ufficializzata nel rispetto dei vincoli di disponibilità emersi.
    ],
  )

  #base-report.report-point(
    discussion_point: [Definizione di Milestone intermedie.],
    discussion: [
      Per gestire meglio il lavoro verso la RTB, è emersa la necessità di fissare delle scadenze interne intermedie.
      Questo approccio permette di controllare meglio i progressi e di accorgersi subito di eventuali blocchi (come
      quello avvenuto sui casi d'uso), evitando di accumulare ritardi.
    ],
    decisions: [
      Si decide di stabilire delle milestone interne che scandiscano il lavoro fino alla RTB. Queste scadenze dovranno
      avere obiettivi chiari e verificabili nel breve periodo, per avere un riscontro frequente sulla qualità del lavoro
      svolto.
    ],
    actions: (
      // da definire
    ),
  )

][

  = Esiti e decisioni finali
  La Sprint Review è da considerarsi conclusa con successo, in quanto il gruppo è stato in grado di evidenziare vari
  punti su cui concentrarsi, in particolare la necessità di una revisione qualitativa dell'approccio all'analisi dei
  requisiti. Le attività rimaste in sospeso sono state ripianificate nel prossimo Sprint, ponendo come priorità assoluta
  la validazione della profondità dei casi d'uso e l'aggiornamento della documentazione.

]
