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
  abstract: "Verbale della riunione interna di Sprint Review dello Sprint 2. L'incontro si è concentrato principalmente sull'analisi delle criticità emerse nella stesura dell'Analisi dei Requisiti, sulla conseguente ri-pianificazione delle attività e sulla definizione degli obiettivi per il prossimo Sprint.",
  changelog: metadata.changelog,
)[
  In data *15 dicembre 2025*, alle ore *16:45*, si è svolta una riunione interna del gruppo NoTIP in modalità virtuale
  sul server *Discord* ufficiale del team. La riunione si è conclusa alle ore *18:05*.

  L'ordine del giorno, essendo la cerimonia di Sprint Review, prevede di discutere circa:
  - Analisi attività previste e criticità bloccanti nel precedente sprint;
  - Revisione strumenti di automatizzazione;
  - Aggiornamento Norme di Progetto e definizione milestone interne;
  - Criticità nell'Analisi dei Requisiti;
  - Pianificazione del prossimo Sprint.
][

  #base-report.report-point(
    discussion_point: [Sprint Review: criticità Analisi dei Requisiti e rinvio rilascio.],
    discussion: [
      L'obiettivo dello sprint era raggiungere una versione semi-definitiva (secondo programma v0.4.0) dell'#link(
        "https://notipswe.github.io/docs/12-rtb/docest/analisi_requisiti.pdf",
      )[Analisi dei Requisiti].

      Durante la lavorazione, è emerso che alcuni Casi d'Uso (UC), considerati in precedenza stabili e sul punto di
      essere formalizzati, non possedevano il livello di profondità e dettaglio necessario. Questa mancanza ha impedito
      la corretta definizione dei requisiti collegati, ritardando il proseguimento del documento. Durante la
      discussione, il gruppo ha discusso, usando tempo di palestra, riguardo il livello di dettaglio richiesto,
      raggiungendo un accordo finale.
    ],
    decisions: [
      Si decide di non rilasciare la v0.3.0 e la v0.4.0 programmate per questo sprint, rinviando i task al prossimo
      ciclo, dandone priorità maggiore. È stato stabilito di chiedere un rapido chiarimento al docente Cardin, a seguito
      della lezione di domani, per confermare la correttezza della nuova profondità di analisi ipotizzata.
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
      È stato presentato dall'Amministratore il lavoro svolto sui nuovi strumenti per automatizzare i processi di
      verifica.
    ],
    decisions: [
      Il gruppo approva l'integrazione dei nuovi tool nel flusso di lavoro per supportare le attività di verifica
      continua.
    ],
  )

  #base-report.report-point(
    discussion_point: [Aggiornamento Piano di Progetto.],
    discussion: [
      Il blocco riscontrato sull'Analisi dei Requisiti evidenzia la necessità di normare meglio la gestione degli
      imprevisti e la definizione delle specifiche. È necessario aggiornare il Piano di Progetto per evitare il
      ripetersi di simili situazioni di stallo.

      Oltre a ciò è stato discusso di come proseguire la stesura del documento.
    ],
    decisions: [
      A seguito della discussione, il gruppo ha deciso di procedere come segue:
      - Aggiornare il consuntivo dello Sprint 2;
      - Creazione dello Sprint 3 definendo una pianificazione dettagliata;
    ],
    actions: (
      // da inserire nuovo task
    ),
  )

  #base-report.report-point(
    discussion_point: [Aggiornamento Piano di Qualifica.],
    discussion: [
      Il gruppo ha discusso di quanto trattato fino a quel momento all'interno del Piano di Qualifica. In particolare è
      stata evidenziata la necessità di andare a rivedere le metriche formalizzate finora, andando a valutare in modo
      critico l'effettiva possibilità di utilizzo. In particolare il gruppo vuole quindi assicurarsi che le metriche
      finora individuate rispondano ad esigenze concrete (es. utilità effettiva nelle Review) ed abbiamo un buon
      rapporto Complessità di gestione/Valore aggiunto, evitando quindi rallentamenti inutili.
    ],
    decisions: [
      Il/I membro/i del gruppo che nel successivo periodo aggiorneranno il Piano di Qualifica procederanno nel seguente
      ordine:
      - Assicurarsi che le metriche siano valore aggiunto e non un fardello;
      - Definire una possibile struttura del Cruscotto di Valutazione (Come strutturarlo nel documento? Che contenuti
        inserire?);
      - Approfondire i metodi di testing, iniziandone la stesura (opzionale).
    ],
    actions: (
      // da inserire nuovo task
    ),
  )

  #base-report.report-point(
    discussion_point: [Aggiornamento Norme di Progetto.],
    discussion: [
      Nel prossimo sprint sarà necessario andare ad aggiornare le Norme di Progetto in quanto, nello sprint appena
      concluso, sono state evidenziate varie contenuti che non erano stati effettivamente normati.
    ],
    decisions: [
      Il prossimo sprint si prevede di andare ad inserire le seguenti sezioni previste dalle Norme di Progetto:
      - Definizione dei Processi Primari, andando a definire Fornitura e Sviluppo in modo completo (per quanto possibile
        allo stato attuale) e Gestione di Configurazione
      - Aggiunta della definizione delle Metriche, una volta confermate nel Piano di Qualifica.
    ],
    actions: (
      // da inserire nuovo task
    ),
  )

  #base-report.report-point(
    discussion_point: [Rotazione dei ruoli.],
    discussion: [
      Il gruppo si è poi dedicato discutere l'assegnazione dei ruoli da assegnare ai membri del gruppo, cercando di
      bilanciare il carico di lavoro a seconda degli impegni di ognuno nel prossimo periodo.
    ],
    decisions: [
      I ruoli sono stati assegnati rispettando i vincoli di disponibilità dati dal gruppo.
    ],
    actions: (
      // Da definire
    ),
  )

  #base-report.report-point(
    discussion_point: [Definizione di Milestone intermedie],
    discussion: [
      È emersa la necessità di suddividere il periodo lavorativo che precede la RTB in milestone interne aggiuntive.
      Rispetto alle uniche due scadenze imposte esternamente dal progetto, si è discusso di introdurre obiettivi a grana
      più fine e con scadenze ravvicinate. Questo approccio mira a monitorare il progresso con maggiore precisione,
      evitando che blocchi operativi (come quelli riscontrati sui casi d'uso).
    ],
    decisions: [
      Si decide di formalizzare l'uso di milestone interne per scandire il progetto fino al raggiungimento della RTB.
      Tali milestone dovranno avere obiettivi relativamente contenuti e verificabili nel breve periodo per garantire un
      feedback rapido sulla qualità del lavoro.
    ],
    actions: (
      // da definire
    ),
  )
][
  = Esiti e decisioni finali
  La Sprint Review è da considerarsi essersi eseguita con successo, in quanto il gruppo è stato in grado di evidenziare
  vari punti su cui concentrarsi all'interno della la necessità di una revisione qualitativa dell'approccio all'analisi
  dei requisiti. Il gruppo ha ripianificato le attività bloccate spostandole nel prossimo Sprint, con l'obiettivo
  prioritario di validare la profondità dei casi d'uso con il proponente/docente e consolidare la documentazione
  normativa e di pianificazione.
]
