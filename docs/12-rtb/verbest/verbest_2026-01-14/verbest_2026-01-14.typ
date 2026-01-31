#import "../../00-templates/base_verbale.typ" as base-report

#let metadata = yaml("verbest_2026-01-14.meta.yaml")
#base-report.apply-base-verbale(
  date: "2026-01-14",
  scope: base-report.EXTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Francesco Marcon \
        Leonardo Preo \
        Mario De Pasquale \
        Valerio Solito \
        Alessandro Contarini \
        Alessandro Mazzariol \
      ],
    ),
  ),
  abstract: "Il presente documento riporta il resoconto dell'incontro di Sprint Review esterna tenutosi in remoto. L'incontro si è incentrato sulla definizione dei requisiti minimi del PoC e sulla revisione dell'Analisi dei Requisiti.",
  changelog: metadata.changelog,
)[
  Il presente documento attesta formalmente che, in data *14 Gennaio 2026*, si è tenuto un incontro in modalità remota
  tramite la piattaforma Microsoft Teams con la proponente _M31_, con una durata compresa tra le *14:30* e le *15:30*.

  A rappresentare l’Azienda erano presenti Cristian Pirlog e Moones Mobaraki.
][
  L'incontro si è focalizzato sulla definizione dei requisiti minimi attesi per il PoC, con consigli da parte della
  proponente volti a guidare il gruppo durante la scelta delle tecnologie e delle architetture da adottare. Inoltre, si
  è proceduto a richiedere all'azienda alcuni chiarimenti e specificazioni riguardo parametri dei Tenant e dei gateway.
  Si sono, infine, richieste informazioni riguardo le aspettative dell'azienda riguardo al documento Analidi dello Stato
  dell'Arte.
][

  #base-report.report-point(
    discussion_point: [Analisi dello Stato dell'Arte],
    discussion: [
      L'azienda ribadisce di non dedicarci troppo tempo, ma di usarlo per capire se esistono soluzioni riutilizzabili.
      Gli studenti chiedono se possono presentare all'azienda la stessa presentazione preparata per i professori
      (Cardin/Vardanega) in cui giustificano le scelte tecnologiche.
    ],
    decisions: [
      Approvato il riutilizzo della presentazione per i docenti come documento di Analisi dello Stato dell'Arte per
      l'azienda.
    ],
  )

  #base-report.report-point(
    discussion_point: [Suggerimenti Stack Tecnologico],
    discussion: [
      L'azienda consiglia fortemente Go (con framework Gin e ORM Gorm) per i servizi e la simulazione, NATS per la
      comunicazione e Angular per il frontend. Questo anche in quanto sono le tecnologie che tutt'ora l'azienda
      utilizza, e nelle quali potrebbe seguirci maggiormente. Tuttavia, gli studenti chiedono se possono usare NestJS
      (con Prisma come ORM), alternativa che avevano trovato online durante lo studio per la scelta delle tecnologie.
    ],
    decisions: [
      L'azienda approva l'uso di NestJS e Prisma come valida alternativa se il team preferisce rimanere su stack
      Node/TypeScript. Confermata la libertà di scelta tecnologica, pur mantenendo i consigli originali.
    ],
  )

  #base-report.report-point(
    discussion_point: [Aspettative Proof of Concept],
    discussion: [
      Viene ribadito che per il PoC l'interfaccia grafica è superflua; il focus è puramente architetturale. L'obiettivo
      è dimostrare il flusso "minimo indispensabile": un gateway simulato che invia un messaggio, il quale viaggia
      cifrato e arriva al cloud. È stato specificato che la sincronizzazione con il DB serve principalmente a dimostrare
      la "segregazione dei dati" (ovvero che un gateway è associato a uno specifico tenant). Se il codice prodotto
      risulterà ben strutturato, potrà essere usato come base per l'MVP, altrimenti potrà essere scartato ("buttato
      via") trattandosi di una demo esplorativa.
    ],
    decisions: [
      La dimostrazione avverrà tramite visualizzazione di Log, terminale o chiamate API (Postman). Non è necessario
      implementare cache complesse in questa fase.
    ],
  )

  #base-report.report-point(
    discussion_point: [Analisi Requisiti - Parametri simulazione Sensore e Gateway],
    discussion: [
      - *Sensore:* I campi proposti (ID, tipo, range, algoritmo) sono sufficienti per il contesto "stream-in-site" della
        simulazione.

      - *Gateway:* L'azienda ha spiegato che, in un'ottica di prodotto reale e futuro MVP, saranno necessari gli
        aggiornamenti OTA (Over-The-Air). Per questo motivo, limitarsi a ID e chiave di fabbrica è riduttivo. È
        necessario tracciare le versioni per sapere, ad esempio, se un dispositivo con uno specifico seriale ha bisogno
        di un aggiornamento software.
      L'azienda consiglia anche al gruppo di controllare le soluzioni adottate in altri sistemi di questo tipo. È stato
      citato come "desiderata" opzionale la visualizzazione su mappa (coordinate GPS) con indicatori di stato colorati,
      ma non è prioritario ora.
    ],
    decisions: [
      Aggiunta dei parametri "Versione Software", "Versione Firmware" e altri eventuali campi come "Modello" e
      "Coordinate".
    ],
  )

  #base-report.report-point(
    discussion_point: [Analisi Requisiti - Audit Log],
    discussion: [
      Si è discusso di come rendere i log utili per un amministratore. Una semplice descrizione testuale non basta
      perché rende difficile la ricerca automatizzata. L'azienda suggerisce di ispirarsi alle best practices inserendo
      un codice univoco che permetta di filtrare rapidamente le azioni nella dashboard.
    ],
    decisions: [
      Aggiungere il campo Codice Operazione per facilitare il filtraggio, il raggruppamento e il tracciamento delle
      attività.
    ],
  )

  #base-report.report-point(
    discussion_point: [Analisi Requisiti - Dati Tenant],
    discussion: [
      Gli analisti erano incerti su quali dati raccogliere, non essendoci pagamenti diretti in piattaforma. L'azienda ha
      chiarito che il Tenant va considerato come un cliente B2B ("Azienda"). Poiché la fatturazione avviene esternamente
      (tramite contratti), non servono dati di carte di credito, ma solo le informazioni necessarie per il contatto
      commerciale e l'identificazione fiscale dell'entità giuridica.
    ],
    decisions: [
      Inserire i dati classici aziendali: Nome azienda, Partita IVA, Email di contatto, Numero di telefono, Indirizzo
      della sede legale.
    ],
  )

  #base-report.report-point(
    discussion_point: [Strategia di Autenticazione (Client API)],
    discussion: [
      Alla richiesta se integrare provider esterni (es. Auth0) da parte del gruppo, l'azienda ha risposto che sarebbe
      una scelta "borderline" per questo tipo di progetto. Non trattandosi di un e-commerce o di un'app pubblica per
      milioni di utenti (come Amazon), ma di un sistema per clienti specifici, una gestione interna è più appropriata e
      coerente con i sistemi attuali dell'azienda (che usa già generatori di certificati interni). Inoltre,
      implementarlo internamente ha un valore didattico maggiore per il team.
    ],
    decisions: [
      Scegliere una soluzione interna. Scartata l'ipotesi di server di autenticazione esterni per mantenere il controllo
      e la coerenza con l'infrastruttura aziendale.
    ],
  )

  #base-report.report-point(
    discussion_point: [Definizione requisiti e aspettative per il POC.],
    discussion: [
      Il gruppo ha espresso delle incertezze riguardo il funzionamento di API token e il loro rapporto con i consumi e
      relativi pagamenti all'azienda _M31_. L'azienda ha fatto l'esempio delle API di OpenAI o GitHub: il cliente genera
      un token e il sistema traccia quanto quel token viene usato (volume dati o numero chiamate). Questo meccanismo
      serve per bloccare l'accesso (invalidando il token) se il cliente non paga il canone o supera i limiti
      contrattuali. Sebbene utile, l'azienda invita a non complicare troppo l'analisi attuale: il calcolo dei volumi
      potrà essere delegato in futuro a strumenti come Prometheus/Grafana.
    ],
    decisions: [
      Questa funzionalità è classificata come "desiderata", opzionale. Utile da prevedere a livello architetturale
      (associare consumo a token), ma non bloccante per l'MVP attuale.
    ],
  )

  = Epilogo della riunione
  L'incontro si è concluso positivamente: i dubbi del gruppo sono stati sanati, permettendo la continuazione dei lavori.
  A causa della sessione d'esami imminente si è chiesto all'azienda di rimandare l'incontro della settimana successiva.
  Le eventuali comunicazioni avverrano tramite email, programmando il prossimo incontro tra il *26* ed il *28 Gennaio*,
  nel quale verrà presentato il PoC prodotto. \
  NoTIP ringrazia nuovamente _M31_ per la professionalità e la disponibilità dimostrate durante l’incontro.

  = Approvazione Aziendale
  La presente sezione certifica che il verbale è stato esaminato e approvato dai rappresentanti di _M31_. L’avvenuta
  approvazione è formalmente confermata dalle firme riportate di seguito dei referenti Aziendali.

  #align(right)[
    #image("assets/sign.png")
  ]
]
