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
  In data *19 gennaio 2026*, alle ore *14:50*, si è svolta una riunione interna del gruppo NoTIP in modalità virtuale sul
  server *Discord* ufficiale del team. La riunione si è conclusa alle ore *16:20*.

  Ordine del giorno:
  - Analisi delle attività svolte e discussione criticità emerse nel precedente Sprint;
  - Pianificazione operativa del prossimo Sprint, ed in particolare suddivisione dei compiti per la realizzazione del PoC;
  - Discussione e previsione del periodo di consegna per RTB, anche in relazione agli esami universitari dei vari componenti del gruppo;

][
  #base-report.report-point(
    discussion_point: [Criticità emerse nello Sprint precedente.],
    discussion: [
      Durante la discussione riguardo le attività svolte nello Sprint precedente, sono emerse alcune criticità che hanno
      rallentato il lavoro del gruppo. In particolare, si è riscontrata una difficoltà nell'organizzazione del lavoro, dovuta principalmente alla presenza di esami universitari che hanno limitato la disponibilità dei vari componenti del gruppo.
    ],
    decisions: [
      Viene evidenziata la necessità di migliorare l’organizzazione del lavoro del gruppo, in particolare in vista dell’avvicinarsi del periodo di consegna della RTB. Si decide pertanto di adottare una pianificazione più strutturata delle attività, prevedendo una suddivisione dei compiti maggiormente aderente alle effettive disponibilità temporali di ciascun componente, così da ridurre rallentamenti e sovraccarichi di lavoro.
    ],
  )

  #base-report.report-point(
    discussion_point: [Rotazione dei ruoli.],
    discussion: [
      Si è discusso riguardo la rotazione dei ruoli, con l'obiettivo di permettere a tutti i membri del gruppo di acquisire esperienza in diverse aree e di evitare sovraccarichi di lavoro su singoli individui.
    ],
    decisions: [
      L’assegnazione e la rotazione dei ruoli vengono ufficializzate tenendo conto delle disponibilità emerse durante la discussione, con l’obiettivo di garantire un’equa distribuzione del carico di lavoro e favorire l’acquisizione di competenze trasversali da parte di tutti i membri del gruppo.
    ],
  )

  #base-report.report-point(
    discussion_point: [Redazione documentazione.],
    discussion: [
      La discussione si è focalizzata sulla redazione della documentazione, in particolare riguardo al proseguimento di tutti i documenti previsti e non ancora completati, non trascurando l'importanza di una buona organizzazione e pianificazione del lavoro per evitare ritardi e sovraccarichi di lavoro.
    ],
    decisions: [
      Si decide di proseguire con la redazione di tutta la documentazione prevista e non ancora completata, definendo una pianificazione delle attività più dettagliata e una chiara suddivisione dei compiti, al fine di garantire il rispetto delle scadenze e prevenire eventuali ritardi.
    ],
  )


][
  = Esiti e decisioni finali
  Lo Sprint Planning si conclude con esito positivo. Tutti i componenti del gruppo risultano allineati sia sulle attività svolte nello Sprint precedente sia su quelle pianificate per il prossimo periodo.
  Le attività non completate vengono riprogrammate, ponendo particolare attenzione al miglioramento dell’organizzazione del lavoro in vista della consegna della RTB.
  Viene ufficializzata l’assegnazione dei ruoli nel rispetto delle disponibilità emerse e confermata la prosecuzione della redazione di tutta la documentazione prevista, con una pianificazione più accurata delle attività.
  Viene infine ribadita l’importanza della definizione e realizzazione di un PoC da condividere al più presto anche con la proponente.
]
