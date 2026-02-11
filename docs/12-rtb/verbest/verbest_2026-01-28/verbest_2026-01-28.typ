#import "../../00-templates/base_verbale.typ" as base-report

#let metadata = yaml(sys.inputs.meta-path)
#base-report.apply-base-verbale(
  date: "2026-01-28",
  scope: base-report.EXTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Francesco Marcon \
        Matteo Mantoan \
        Mario De Pasquale \
        Alessandro Contarini \
        Alessandro Mazzariol \
      ],
    ),
  ),
  abstract: "Il presente documento riporta il resoconto dell'incontro esterno tenutosi in remoto. L'incontro ha avuto
  come oggetto la discussione tecnica sul Proof of Concept con le tecnologie adottate e la complessità del MVP.",
  changelog: metadata.changelog,
)[
  Il presente documento attesta formalmente che, in data *28 Gennaio 2026*, si è tenuto un incontro in remoto tramite
  Microsoft Teams con la proponente _M31_, con una durata compresa tra le *14:30* e le *15:30*.

  A rappresentare l’Azienda erano presenti Cristian Pirlog e Moones Mobaraki.
][
  L'incontro è stato dedicato alla discussione di aspetti tecnici per lo sviluppo del Proof of Concept; tra cui scelte
  architetturali relative alla sicurezza dei dati e le tecnologie da adottare per il backend. Il confronto ha permesso
  di chiarire dubbi tecnici e di ricevere conferme dalla proponente.

  Durante la riunione sono state inoltre discusse le preoccupazioni del gruppo riguardo la complessità del MVP.
][

  #base-report.report-point(
    discussion_point: [Sicurezza dei dati e crittografia nel POC.],
    discussion: [
      Il gruppo ha posto il quesito se sia necessario fornire un sistema di gestione della decrittazione end-to-end. La
      proponente ha risposto ad ogni dubbio: i messaggi non devono essere inviati in chiaro e deve essere implementato
      un metodo di decrittazione lato client. L'aspettativa è che l'utente e l'altra parte siano in grado di mandare
      messaggi crittografati e di decifrarli correttamente.

      È stato chiarito che si deve dare per scontata la presenza di un API che ritorna una chiave utilizzabile per la
      decrittazione. La sfida di trovare la soluzione implementativa di come mandare i messaggi e, soprattutto, di come
      decifrarli è lasciata al gruppo.
    ],
    decisions: [
      L'obiettivo finale è riuscire ad avere un meccanismo funzionante di crittografia end-to-end. Il gruppo procederà
      con l'implementazione di tale sistema nel POC, con la libertà di scegliere l'approccio tecnico più adeguato.
    ],
  )

  #base-report.report-point(
    discussion_point: [Scelta tecnologica: NATS invece di MQTT.],
    discussion: [
      Il gruppo ha comunicato la decisione di utilizzare NATS al posto di MQTT per il POC. Tale scelta è motivata dal
      fatto che dalla documentazione ufficiale, i dispositivi che consentono l'utilizzo di NATS sono più adatti alle
      esigenze del progetto.
    ],
    decisions: [
      La proponente ha condiviso la scelta del gruppo, confermando che NATS è una soluzione appropriata per il contesto
      applicativo.
    ],
  )

  #base-report.report-point(
    discussion_point: [Scelta tecnologica per il backend: Go e framework correlati.],
    discussion: [
      Il gruppo ha comunicato l'intenzione di utilizzare Go come tecnologia per il backend e si è interessato a capire
      se fosse una scelta appropriata, chiedendo alla proponente eventuali consigli.
    ],
    decisions: [
      La proponente ha chiarito che non sono presenti vincoli sulle tecnologie da utilizzare e che il gruppo è libero di
      scegliere gli strumenti che ritiene più adatti. Ha inoltre fornito alcuni suggerimenti tecnici:
      - *Gin* e *Fiber* sono framework basati su Go, semplici da utilizzare ma potenti quanto Go stesso;
      - *gRPC* è un'altra tecnologia consigliata per la comunicazione tra servizi;
    ],
  )

  #base-report.report-point(
    discussion_point: [Complessità del MVP e mediazione del carico di lavoro.],
    discussion: [
      Il gruppo ha espresso preoccupazioni riguardo alla complessità del MVP. Considerando il carico di lavoro
      richiesto, è stata proposta alla proponente l'apertura di un dialogo per mediare e possibilmente alleggerire la
      complessità del MVP.
    ],
    decisions: [
      La proponente si è mostrata estremamente disponibile a creare un dialogo per mediare la complessità del MVP. Ha
      sottolineato che per loro è essenziale principalmente il corretto funzionamento del core del sistema, mentre le
      altre funzionalità possono essere discusse insieme per trovare un equilibrio sostenibile.
    ],
  )

  #base-report.report-point(
    discussion_point: [Stato documentazione: Analisi dei Requisiti.],
    discussion: [
      Il gruppo ha informato la proponente di aver completato il documento dell'Analisi dei Requisiti e ha manifestato
      l'intenzione di inviarlo per una revisione e per l'eventuale approvazione e successiva firma di esso.
    ],
    decisions: [
      La proponente ha accolto positivamente la notizia e si è dichiarata disponibile a visionare il documento, ed in
      caso di esito positivo, fornirci la propria approvazione formale.
    ],
  )

  #base-report.report-point(
    discussion_point: [Pianificazione completamento POC e prossimo incontro.],
    discussion: [
      Il gruppo ha comunicato l'intenzione di completare entro la fine della settimana successiva dall'incontro sia il
      POC sia l'Analisi dello Stato dell'Arte. È stata quindi discussa la data del prossimo incontro per poter mostrare
      i risultati e discuterne con la proponente.

      Dopo un breve momento dove sono stati discussi i possibili giorni sono emersi mercoledì e venerdì come migliori
      candidati.
    ],
    decisions: [
      Viene concordato un approccio flessibile: si tenterà di organizzare la riunione per mercoledì (in modalità
      online), con la possibilità di posticipare a venerdì se necessario, in base allo stato di avanzamento del POC. Per
      questo motivo seguiranno altre comunicazioni via telematica tra le due parti per aggiornarsi sullo stato dei
      lavori.
    ],
  )

  = Epilogo della riunione
  L'incontro si è concluso con esito estremamente positivo. Il confronto ha permesso di:
  - Ottenere conferme tecniche fondamentali sulle scelte architetturali relative alla sicurezza;
  - Ricevere suggerimenti preziosi sulle tecnologie da adottare per il backend;
  - Stabilire un approccio collaborativo per gestire la complessità del MVP;
  - Pianificare con chiarezza le prossime attività e gli incontri futuri.

  Il gruppo _NoTIP_ ringrazia l'Azienda per la disponibilità, la flessibilità e il supporto tecnico fornito. La
  proponente si è dimostrata particolarmente aperta al dialogo e orientata a facilitare il lavoro del gruppo, mantenendo
  comunque l'attenzione sugli obiettivi fondamentali del progetto.

  Il prossimo appuntamento è fissato per mercoledì della settimana successiva, quando verrà presentato il POC
  completato. Solo nel caso in cui il gruppo avesse bisogno di più tempo per terminare lo sviluppo del POC allora la
  riunione verrà spostata a venerdì.

  #pagebreak()

  = Approvazione Aziendale
  La presente sezione certifica che il verbale è stato esaminato e approvato dai rappresentanti di _M31_. L’avvenuta
  approvazione è formalmente confermata dalle firme riportate di seguito dei referenti Aziendali.

  #v(2em)

  #align(right)[
    #image("assets/sign.png")
  ]
]
