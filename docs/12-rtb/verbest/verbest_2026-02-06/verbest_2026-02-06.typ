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
        Mario De Pasquale \
        Alessandro Contarini \
        Alessandro Mazzariol \
        Valerio Solito \
        Leonardo Preo \
      ],
    ),
  ),
  abstract: "Il presente documento riporta il resoconto dell'incontro esterno tenutosi in remoto. L'incontro ha avuto
  come oggetto la discussione sul PoC recentemente ultimato e delle eventuali modifiche da apportare ad esso.",
  changelog: metadata.changelog,
)[
  Il presente documento attesta formalmente che, in data *06 Febbraio 2026*, si è tenuto un incontro in remoto tramite
  Microsoft Teams con la proponente _M31_, con una durata compresa tra le *11:00* e le *11:50*.

  A rappresentare l’Azienda erano presenti Cristian Pirlog e Moones Mobaraki.
][
  L'incontro è stato dedicato alla presentazione del PoC, recentemente ultimato. Il Team ha inoltre chiesto domande di
  natura tecnica riguardo eventuali punti del PoC, per confermare di aver correttamente trasposto le intenzioni della
  proponente nel lavoro svolto. Il confronto ha permesso di chiarire alcuni dubbi e di ricevere conferme dalla
  proponente.

  Durante la riunione si è anche discusso dell'Analisi dello Stato dell'Arte. Entrambi i punti discussi hanno ricevuto
  conferma dalla proponente, ma comunque riceveranno un'ulteriore analisi approfondita nei giorni a seguire da parte
  dell'Azienda via Mail.
][
  #base-report.report-point(
    discussion_point: [Presentazione e validazione Proof of Concept (PoC)],

    discussion: [
      Il Team ha presentato il PoC ultimato, evidenziandone le seguenti caratteristiche:
      - *Isolamento dei Tenant:* I dati sono segregati per tenant.
      - *Limite visualizzazione record:* Sono visibili solo gli ultimi 500 record, gli altri vengono eliminati dalla
        dashboard.
      - *Sicurezza:* Al momento i dati vengono crittografati con una chiave statica, anche se per il MVP si prevede di
        implementarne una dinamica. I dati vengono impacchettati insieme e inviati in maniera crittografata, vengono
        decifrati soltanto dalla WebApp.
      - *Tecnologie:* Si è utilizzato _NestJS_ per le Data API e _Go_ per il simulatore di dati. Si è deciso di non
        inserire un Ingestion Service per ottimizzare la scalabilità. In questa maniera abbiamo il Database che effettua
        le query e la WebApp si interfaccia con le API per recuperare i dati.
      Inoltre è stato usato _TimescaleDB_ come database per gestire i dati dei clienti e lo storico delle misurazioni,
      invece _Angular_ e _TypeScript_ sono stati utilizzati per realizzare la WebApp.
    ],

    decisions: [
      Durante la discussione l'azienda ha approvato il PoC in maniera provvisoria. Nella settimana attuale e nella
      successiva seguirà una revisione approfondita in cui daranno un altro feedback definitivo.
    ],
  )

  #base-report.report-point(
    discussion_point: [Analisi dello Stato dell'Arte],

    discussion: [
      Si è discusso delle tecnologie selezionate per l'architettura a microservizi realizzata dal Team:
      - *Nats JetStream o Kafka:* Il Team aveva selezionato _Nats JetStream_ e _Go_ per il backend, ritenendo _Kafka_
        sovradimensionato e troppo complesso per la portata del progetto.
      - *Gestione Pacchetti Dati:* I sensori generano dati e il Gateway riceve tutti i dati generati (anche multipli
        nello stesso intervallo) e non solo l'ultimo rilevamento di quel tipo di sensore.
    ],

    decisions: [
      L'Azienda ha confermato l'uso di Nats JetStream per le stesse ragioni discusse dal team. Per il MVP è stato
      consigliato di inserire un'ulteriore strato logico fra dashboard e Gateway per permettere anche di applicare
      funzioni e filtri ai dati che verranno visualizzati dall'utente. È stato anche consigliata come alternativa _Gin_
      con _Go_ al posto di _NestJS_, ma in ogni caso anche la scelta di _NestJS_ è stata ritenuta valida.
    ],
  )

  #base-report.report-point(
    discussion_point: [Definizione Chiave Primaria],

    discussion: [
      Il team ha deciso di porre come chiave primaria al momento una chiave composta dal tempo di arrivo nel database,
      gateway che ha creato i dati, tenant associato e Nonce. A tal proposito ha chiesto quali alternative sarebbero
      disponibili per la chiave primaria.
    ],

    decisions: [
      L'Azienda ha proposto di approfondire l'utilizzo del Nonce, e nel caso in cui fosse sufficiente di utilizzarlo
      come identificativo. Altrimenti è anche stato proposto di approfondire _UUID_ (in particolare la versione 7, che
      include timestamp ordinabile) che potrebbe essere un altra valida alternativa.
    ],
  )

  #base-report.report-point(
    discussion_point: [Standard per MVP],

    discussion: [
      L'azienda ha fornito alcune linee guida per il passaggio dal PoC al MVP:
      - *Documentazione del Codice:* È stato consigliato di aggiungere ulteriori commenti al Codice nelle sezioni più
        complesse o di avere separatamente una documentazione per il codice scritto.
      - *Test:* Nel PoC non sono stati fatti test, cosa che invece ci si aspetta avvenga in maniera molto approfondita e
        documentata per quanto riguarda il MVP
    ],

    decisions: [
      Il Team seguirà le indicazioni fornite dall'Azienda e deciderà se riutilizzare alcune parti del PoC come base per
      il MVP.
    ],
  )

  #base-report.report-point(
    discussion_point: [Incontri Successivi],

    discussion: [
      Il Team e il gruppo hanno discusso se ritornare alla cadenza settimanale precedente alle vacanze natalizie e alla
      sessione invernali.
    ],

    decisions: [
      Con molta probabilità si ritornerà a questo tipo di organizzazione con incontri settimanali ogni mercoledì. In
      ogni caso il Team aggiornerà la proponente riguardo questo punto al più presto possibile e al massimo entro il 9
      Febbraio.
    ],
  )

  = Epilogo della Riunione
  L'incontro si è concluso con esito positivo. La presentazione del PoC ha soddisfatto le aspettative della proponente,
  confermando la validità della direzione intrapresa dal gruppo. Il confronto ha permesso di:
  - Validare le scelte architetturali fatte dal gruppo nell'Analisi dello stato dell'Arte.
  - Ricevere feedback tecnico per la risoluzione dei dubbi sorti nel Team durante lo sviluppo del PoC.
  - Fissare degli standard di qualità per quello che il gruppo dovrà svolgere nella fase dedicata al MVP.

  Il gruppo _NoTIP_ ringrazia l'Azienda per la disponibilità, la flessibilità e il supporto tecnico fornito. La
  proponente si è dimostrata particolarmente aperta al dialogo e orientata a facilitare il lavoro del gruppo, mantenendo
  comunque l'attenzione sugli obiettivi fondamentali del progetto.

  Il prossimo appuntamento è fissato a mercoledì prossimo. Solo nel caso in cui il gruppo dovesse incorrere in
  rallentamenti o problemi dovrà avvisare la proponente entro lunedì.

  = Approvazione Aziendale
  La presente sezione certifica che il verbale è stato esaminato e approvato dai rappresentanti di _M31_. L’avvenuta
  approvazione è formalmente confermata dalle firme riportate di seguito dei referenti Aziendali.

]
