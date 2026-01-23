#import "../../00-templates/base_verbale.typ" as base-report
#import "../../00-templates/base_configs.typ" as base

#let metadata = yaml(sys.inputs.meta-path)

#base-report.apply-base-verbale(
  date: "2026-01-06",
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
  abstract: "Il presente documento riporta il resoconto dell'incontro interno svolto con l'obiettivo di discutere l'organizzazione e la pianificazione delle attività in previsione dell'RTB",
  changelog: metadata.changelog,
)[
  In data *1 gennaio 2026*, alle ore *15:00*, si è svolta una riunione interna del gruppo NoTIP in modalità virtuale sul
  server *Discord* ufficiale del team. La riunione si è conclusa alle ore *16:12*.

  Ordine del giorno:
  - Analisi delle attività svolte e discussione criticità emerse nel precedente Sprint;
  - Pianificazione operativa del prossimo Sprint;
  - Discussione e previsione del periodo di consegna per RTB;
  - Discussione riguardante cosa richiede come PoC l'azienda proponente.

][
  #base-report.report-point(
    discussion_point: [Criticità emerse nello Sprint precedente.],
    discussion: [
      Il gruppo si è confrontato sul difficile lavoro svoltosi durante le vacanze invernali, evidenziando come la
      mancanza di tempo e gli impegni personali di ognuno dei componenti del gruppo non abbiano permesso la
      realizzazione di tutto ciò programmato ad inizio Sprint. Si è discusso inoltre riguardo le difficoltà emerse
      durante la ristesura dell'Analisi dei requisiti, evidenziando comunque come questa fosse oramai quasi ultimata e
      necessitasse solo di alcuni aggiustamenti finali. Si è proceduto con la stesura di una serie di domande da porre
      al Prof. Cardin, in maniera tale da ultimare il documento entro la prima metà dello Sprint corrente.
    ],
    decisions: [
      Viene ufficializzata la necessità di contattare il Prof. Cardin e esporre le domande preparate dal gruppo.
    ],
  )

  #base-report.report-point(
    discussion_point: [Rotazione dei ruoli.],
    discussion: [
      Si è proceduto alla definizione dei ruoli per lo Sprint corrente, seguendo la disponibilità dei vari elementi del
      gruppo, ma garantendo che il PoC venga iniziato entro il termine del periodo.
    ],
    decisions: [
      L'assegnazione dei ruoli è stata ufficializzata nel rispetto dei vincoli di disponibilità emersi.
    ],
  )

  #base-report.report-point(
    discussion_point: [Previsione consegna RTB.],
    discussion: [
      Per organizzare al meglio il lavoro del gruppo e per garantire la consegna della RTB nei tempi previsti, si è
      discusso riguardo al fissaggio di una data entro la quale sporgere richiesta di consegna della Milestone.
    ],
    decisions: [
      Si è deciso, di comune accordo, di fissare la data limite per la richiesta al *1 febbraio 2026*, permettendo così
      a tutti i componenti del gruppo di prepararsi agli esami e di arrivare pronti alla consegna.
    ],
  )

  #base-report.report-point(
    discussion_point: [Analisi dello Stato dell'Arte.],
    discussion: [
      Affinchè ogni componente del gruppo sapesse cosa l'azienda richiede oltre al PoC, si è discusso riguardo la
      stesura dell'Analisi dello Stato dell'Arte. Da ciò sono emersi vari dubbi, soprattutto riguardo la forma e la
      profondità che deve presentare il suddetto documento.
    ],
    decisions: [
      Si è deciso di esporre i dubbi al Prof. Vardanega durante l'incontro per il Diario di Bordo, inoltre si è optato
      per una esplicita richiesta di chiarimenti riguardo il documento da parte dell'azienda proponente.
    ],
  )

  #base-report.report-point(
    discussion_point: [Fissaggio PoC.],
    discussion: [
      La discussione si è spostata sul PoC, in maniera particolare su cosa l'azienda si aspetti da questo e su come il
      gruppo debba organizzarsi per la sua realizzazione. Si è discusso riguardo le funzionalità principali che il PoC
      debba presentare, arrivando alla conclusione che debba essere un prototipo funzionante ma non completo, in maniera
      tale da dimostrare le capacità tecniche del gruppo senza dover realizzare un prodotto finito.
    ],
    decisions: [
      Eventuali delucidazioni verranno richieste all'azienda proponente durante il prossimo incontro. Al primo posto
      viene lo studio delle tecnologie che possono essere utilizzate per la realizzazione del PoC.
    ],
  )

][
  = Esiti e decisioni finali
  Lo Sprint Planning si è concluso con successo, in quanto ogni componente del gruppo è stato aggiornato riguardo le
  attività da svolgere nel prossimo periodo e ciò fatto nello Sprint precedente. Vengono quindi riprogrammate tutte le
  attività non completate, ponendo come priorità assoluta la finalizzazione dell'Analisi dei Requisiti e l'inizio dello
  studio per la realizzazione del PoC.
]
