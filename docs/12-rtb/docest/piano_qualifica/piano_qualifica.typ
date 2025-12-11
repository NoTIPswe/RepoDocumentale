#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)

#let metrics-table(metrics, caption: none) = {
  set text(hyphenate: false)
  figure(
    table(
      columns: (auto, auto, auto, auto),
      align: center + horizon,
      inset: 8pt,
      table.header(
        text(12pt)[*Codice*], text(12pt)[*Metrica*], text(12pt)[*Valore Accettabile*], text(12pt)[*Valore Ottimale*]
      ),
      ..metrics.map(m => (m.cod, m.name, m.acceptable, m.optimal)).flatten(),
    ),
    caption: caption,
    kind: table,
  )
}

#let metrics-description(
  cod,
  name,
  acceplable,
  optimal,
  note: none,
) = {
  block(
    breakable: false,
    [
      #heading(level: 4, numbering: none, outlined: false)[#cod]

      *Motivazione valore accettabile:*
      #acceplable

      *Motivazione valore ottimo:*
      #optimal

      #if note != none [
        *Note di utilizzo:*
        #note
      ]
    ],
  )
  v(0.5em)
}

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Il documento descrive le metodologie di controllo qualità applicate al progetto, includendo l'utilizzo di metriche di monitoraggio e pianificazione di test. L'obiettivo è assicurare la conformità del prodotto finale alle specifiche di sicurezza ed efficienza richieste per il sistema distribuito e l'architettura Cloud.",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione
  == Scopo del documento
  Il presente Piano di Qualifica definisce le strategie, le metodologie e le metriche adottate dal gruppo per garantire la qualità del prodotto software e l'efficienza dei processi di sviluppo. Esso costituisce il riferimento principale per le attività di:
  - Verifica: accertarsi che il prodotto stia venendo costruito a regola d'arte.
  - Validazione: accertarsi che si stia costruendo il prodotto giusto rispetto alle attese del proponente.

  Il documento nasce all'inizio del progetto, ma è concepito come uno strumento dinamico che accompagna l'intero ciclo di vita dello stesso, evolvendosi attraverso revisioni migliorative continue. La strategia di gestione della qualità si ispira al ciclo di PDCA (Plan, Do, Check, Act), articolandosi nelle seguenti fasi:
  - *Pianificazione (Plan)*: Definizione degli obiettivi qualitativi e quantitativi. Questa fase stabilisce le metriche di riferimento e le soglie di accettazione da applicare sia ai processi che al prodotto finale.
  - *Esecuzione (Do)*: Attuazione delle procedure pianificate. In questa fase vengono eseguiti i processi di sviluppo e di test secondo le metodologie stabilite, raccogliendo i dati necessari per le misurazioni successive.
  - *Controllo (Check)*: Applicazione di misurazioni oggettive durante lo svolgimento delle attività. L'obiettivo è rilevare scostamenti rispetto a quanto pianificato e verificare la conformità ai requisiti stabiliti.
  - *Miglioramento (Act)*: Analisi critica dei risultati ottenuti (consuntivo). Questa fase mira a identificare difficoltà organizzative o tecniche e ad attuare azioni correttive tempestive per ottimizzare i processi negli sprint successivi.

  L'obiettivo finale è assicurare che il rilascio soddisfi pienamente i requisiti del capitolato, minimizzando i difetti e garantendo alti livelli di manutenibilità e usabilità.

  == Scopo del prodotto
  Il progetto ha l'obiettivo di realizzare una piattaforma Cloud multi-tenant e scalabile, dedicata all'acquisizione e alla gestione sicura di dati provenienti da sensori Bluetooth Low Energy (BLE).

  L'architettura del sistema si fonda su due componenti principali:
  - Infrastruttura Cloud Centralizzata:
    - Costituisce il cuore del sistema per l'ingestione, segregazione ed esposizione dei dati.
    - Gestisce il provisioning sicuro dei gateway e il controllo degli accessi in un contesto multi-tenant.
    - Garantisce la persistenza dei dati e la loro accessibilità.
  - Simulatore Software di Gateway:
    - Replica il comportamento di un Gateway BLE-WiFi fisico in un contesto reale.
    - Genera flussi di dati verosimili per validare la robustezza del sistema.
    - Gestisce la comunicazione sicura verso il livello Cloud.

  L'obiettivo finale è quello di fornire uno strumento completo per l'amministrazione e la visualizzazione dei dati, garantendo requisiti non funzionali critici quali sicurezza, affidabilità e scalabilità.

  == Riferimenti
  === Riferimenti normativi

  - #link("https://notipswe.github.io/docs/12-rtb/docint/norme_progetto.pdf")[Norme di Progetto]
  - #link(
      "https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf",
    )[Capitolato d'appalto C7 - Sistema di acquisizione dati da sensori]

  === Riferimenti informativi

  - #link("https://www.math.unipd.it/~tullio/IS-1/2009/Approfondimenti/ISO_12207-1995.pdf")[Standard ISO/IEC 12207:1995] – Software Life Cycle Processes
  - #link("https://it.wikipedia.org/wiki/ISO/IEC_9126")[Standard ISO/IEC 9126] – Software Engineering - Product Quality
  - Materiale didattico:
    - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/T07.pdf")[Slide T7] - Qualità di prodotto
    - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/T08.pdf")[Slide T8] - Qualità di processo
    - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/T09.pdf")[Slide T9] - Verifica e Validazione

  Al fine di garantire un linguaggio univoco e prevenire possibili ambiguità, i termini tecnici, gli acronimi e i vocaboli con accezione specifica nel contesto del progetto sono stati definiti puntualmente nel documento #link("https://notipswe.github.io/docs/12-rtb/docest/glossario.pdf")[Glossario]. Si invita il lettore a fare riferimento a tale documento per chiarire qualsiasi dubbio.

  = Qualità di processo

  Garantire la qualità del processo significa assicurarsi che il nostro metodo di lavoro sia solido, e non solo che il codice funzioni. Un processo ben strutturato è l'unico modo per evitare sprechi di risorse, ridurre il rischio di errori a cascata e mantenere il controllo sulle tempistiche del progetto.

  Per ottenere questo risultato, non ci affidiamo al caso ma a una strategia basata su:

  - Riferimenti normativi: abbiamo preso come riferimento il modello CMMI e lo standard ISO/IEC 12207;

  - Approccio Quantitativo: per evitare valutazioni soggettive, utilizziamo metriche oggettive. Ogni metrica ha due soglie di riferimento: un valore accettabile e un valore ottimale;

  - Iterazione e Miglioramento: sfruttiamo le retrospettive di fine sprint per analizzare i dati raccolti e, se i numeri si discostano dagli obiettivi, allora applicando il ciclo PDCA, cerchiamo di correggere nel successivo sprint.

  = Qualità di processo

  == Processi primari

  === Fornitura

  #metrics-table(
    (
      (cod: [*MP01*], name: [Earned Value], acceptable: [≥ 0], optimal: [\= PV]),
      (cod: [*MP02*], name: [Planned Value], acceptable: [≥ 0], optimal: [≤ BAC]),
      (cod: [*MP03*], name: [Actual Cost], acceptable: [≥ 0], optimal: [≤ PV]),
      (cod: [*MP04*], name: [Cost Performance Index], acceptable: [≥ 0.6], optimal: [≥ 1.0]),
      (cod: [*MP05*], name: [Schedule Performance Index], acceptable: [≥ 0.6], optimal: [≥ 1.0]),
      (cod: [*MP06*], name: [Estimate At Completion], acceptable: [≥ 0], optimal: [≤ BAC]),
      (cod: [*MP07*], name: [Estimate To Complete], acceptable: [≥ 0], optimal: [≤ Budget residuo]),
      (cod: [*MP08*], name: [Time Estimate At Completion], acceptable: [≥ 0], optimal: [≤ Durata pianificata]),
      (cod: [*MP09*], name: [Budget Burn Rate], acceptable: [≤ BAC/Giorni totali], optimal: [Costante]),
    ),
    caption: [Soglie metriche processo di Fornitura],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MP01],
    [Earned Value],
    [Il valore accettabile minimo è zero poiché l'EV rappresenta il valore del lavoro completato. Non può essere negativo per definizione e valori molto bassi rispetto al pianificato indicano ritardi nell'esecuzione, tuttavia non invalidanti dal punto di vista metrico.],
    [Il valore ottimo corrisponde esattamente al Planned Value (EV = PV), indicando che il lavoro completato coincide o eccede addirittura con quello pianificato. Questo significa che il progetto procede esattamente nei tempi previsti, senza ritardi.],
    note: [L'EV deve essere calcolato a intervalli regolari (es. fine sprint) per tracciare l'andamento del progetto. Variazioni significative richiedono analisi delle cause e potenziali azioni correttive.],
  )

  #metrics-description(
    [MP02],
    [Planned Value],
    [Il PV non può essere negativo poiché rappresenta il budget allocato per il lavoro pianificato fino a un dato momento. Il valore minimo zero si verifica all'inizio del progetto quando nessun lavoro è ancora pianificato.],
    [Il valore ottimo è che il PV rimanga sempre minore o uguale al Budget At Completion (BAC), ovvero che la pianificazione non ecceda il budget totale disponibile. Un PV che cresce linearmente nel tempo indica una pianificazione equilibrata.],
    note: [Il PV funge da baseline per tutti i calcoli di performance. Deve essere definito accuratamente in fase di pianificazione basandosi su stime realistiche delle attività.],
  )

  #metrics-description(
    [MP03],
    [Actual Cost],
    [L'AC non può essere negativo in quanto rappresenta costi realmente sostenuti. Il valore minimo zero si ha all'inizio del progetto prima di iniziare qualsiasi attività.],
    [Il valore ottimo è che l'AC rimanga sempre minore o uguale al PV, indicando che il progetto sta spendendo meno o uguale a quanto pianificato rispetto al periodo corrente. Valori di AC eccedenti PV segnalano potenziali problemi di budget.],
    note: [L'AC deve includere tutti i costi diretti. La sua accuratezza è critica per calcolare correttamente CPI ed EAC.],
  )

  #metrics-description(
    [MP04],
    [Cost Performance Index],
    [A seguito di ricerche, solitamente CPI ≥ 0.85 è considerato accettabile secondo standard di project management. Per l'inesperienza dei membri del gruppo abbiamo deciso di abbassarlo a valori CPI ≥ 0.6, simboleggianti la sufficienza. Valori inferiori segnalano seri problemi di efficienza tecnico-economica che richiedono interventi immediati, in modo da iniziare a produrre in modo maggiormente efficiente.],
    [Un CPI = 1.0 è ottimale, indicando che si sta ottenendo esattamente quello che ci aspetta per la spesa fatta. CPI > 1 significa efficienza superiore alle previsioni, ottimale di definizione.],
  )

  #metrics-description(
    [MP05],
    [Schedule Performance Index],
    [Un SPI ≥ 0.6 è accettabile, per i motivi presentati nella metrica precedente indicando che il lavoro completato è almeno l'60% di quello pianificato. SPI < 0.6 implica, con tutta probabilità, ritardi significativi nel planning del progetto.],
    [Un SPI ≥ 1.0 è ottimale, indicando che il lavoro completato coincide o eccede quello pianificato. SPI > 1 significa che si è in anticipo sulla tabella di marcia. Il valore 1.0 rappresenta l'aderenza perfetta alla pianificazione.],
    note: [L'SPI è particolarmente importante nelle fasi iniziali per identificare problemi di stima. A differenza del CPI, l'SPI può essere recuperato in sprint successivi aumentando la velocity del team.],
  )

  #metrics-description(
    [MP06],
    [Estimate At Completion],
    [L'EAC non può essere negativo essendo una proiezione di costo ed il valore zero è puramente teorico, non si verifica in progetti reali.],
    [Il valore ottimo è EAC ≤ BAC, ovvero che la stima finale dei costi non superi il budget inizialmente allocato. Questo indica che il progetto si concluderà entro il budget previsto. Nel caso in cui EAC = BAC significa perfetta aderenza al budget.],
    note: [L'EAC dovrebbe essere ricalcolato ad ogni sprint utilizzando il CPI aggiornato, fornendo quindi una prospettiva concreta sul modo in cui il lavoro sta procedendo. Avere una tendenza crescente nell'EAC è considerabile un warning di potenziale sforamento budget.],
  )

  #metrics-description(
    [MP07],
    [Estimate To Complete],
    [L'ETC non può essere negativo poiché rappresenta il costo stimato per completare il lavoro rimanente. Risulta essere zero se e solo se il progetto è completato.],
    [Il valore ottimo è che l'ETC rimanga entro il budget residuo originariamente pianificato. ETC superiore al budget residuo indica necessità di fondi aggiuntivi.],
    note: [Se ETC supera significativamente il budget disponibile, potrebbe essere necessario intraprendere trattative a ribasso con la proponente riguardo il proseguimento del progetto.],
  )

  #metrics-description(
    [MP08],
    [Time Estimate At Completion],
    [Il TEAC non può essere negativo essendo una stima temporale sul futuro. Risulterà essere zero solamente al termine del progetto.],
    [Il valore ottimo è TEAC ≤ Durata pianificata, indicando che il progetto si concluderà entro le tempistiche previste, dove TEAC = Durata pianificata indica perfetta aderenza alla schedulazione.],
    note: [Il TEAC è critico per gestire aspettative degli stakeholder e per decisioni su milestone contrattuali. Un TEAC significativamente superiore alla durata pianificata può richiedere rinegoziazione delle scadenze o delle richieste.],
  )

  #metrics-description(
    [MP09],
    [Budget Burn Rate],
    [Il burn rate accettabile è che rimanga minore o uguale al burn rate pianificato. Questo assicura che il budget non si esaurisca prima del completamento del progetto. Un burn rate leggermente superiore è sostenibile solamente se temporaneo.],
    [Il valore ottimo è un burn rate costante e prevedibile nel tempo, idealmente coincidente con quello pianificato. Fluttuazioni minime sono assolutamente normali, ma avere un burn rate costante facilita la comprensione del modo in cui sta venendo speso il budget.],
    note: [Il burn rate dovrebbe essere visualizzato graficamente (burn-down chart) per identificare visivamente trend problematici.],
  )

  === Sviluppo

  #metrics-table(
    (
      (cod: [*MP10*], name: [Requirements Stability Index], acceptable: [≥ 70%], optimal: [100%]),
    ),
    caption: [Soglie metriche processo di Sviluppo],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MP10],
    [Requirements Stability Index],
    [Questo valore riconosce un margine di cambiamento accettabile, in quanto in progetti con gestione agile, sono inevitabili cambiamenti per rispondere a feedback o nuove esigenze. RSI < 70% segnala analisi iniziale inadeguata.],
    [Un RSI = 100% è ottimale. Questo livello di stabilità riflette un'eccellente analisi iniziale e requisiti ben compresi. Permette pianificazione affidabile e riduce drasticamente i costi di rework.],
    note: [L'RSI diventa significativo solo dopo aver stabilito una baseline dei requisiti.],
  )

  // - MP__: Code Coverage (durante sviluppo)
  // - MP__: Complessità Ciclomatica Media per Modulo

  == Processi di supporto
  === Documentazione
  
  #metrics-table(
    (
      (cod: [*MP13*], name: [Indice di Gulpease], acceptable: [≥ 60], optimal: [≥ 80]),
      (cod: [*MP14*], name: [Correttezza Ortografica], acceptable: [0 errori], optimal: [0 errori]),
    ),
    caption: [Soglie metriche processo di Documentazione]
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]
  
  #metrics-description(
    [MP13],
    [Indice di Gulpease],
    [Un indice ≥ 60 garantisce che la documentazione sia comprensibile per lettori con istruzione media, appropriato per documentazione tecnica rivolta a professionisti del settore. Questo livello bilancia precisione terminologica e chiarezza espositiva.],
    [Un indice ≥ 80 indica documentazione molto accessibile, comprensibile anche per lettori con istruzione base.],
    note: [L'indice di Gulpease non è sempre necessario massimizzarlo, ma va interpretato considerando il tipo di documento in esame: manuali utente dovrebbero cercare di raggiungere valori più alti (≥75), mentre documentazione più tecnica si appresterà ad avere valori più bassi (≥55) data la natura tecnica del contenuto.]
  )

  #metrics-description(
    [MP14],
    [Correttezza Ortografica],
    [Zero errori ortografici è l'unico valore accettabile per documentazione professionale.],
    [Il valore ottimo coincide con l'accettabile: zero errori, in quanto la documentazione formale destinata agli stakeholder deve essere priva errori di battitura o refusi da versioni precedenti, in modo da riflettere la professionalità del gruppo e dei processi dallo stesso impiegati.],
    note: [La presenza di errori indica processi di quality assurance inadeguati che devono essere rafforzati.]
  )

  === Verifica
  // Metriche di testing e copertura
  // - MP12: Code Coverage
  // - MP13: Test Success Rate
  //
  // NUOVE METRICHE AGGIUNTE:
  // - MP28: Test Automation Percentage
  //   Formula: (Test automatizzati) / (Test totali) × 100
  //   Accettabile: ≥ 70%
  //   Ottimale: ≥ 85%
  //   Utilità: Sostenibilità regressione continua

  === Gestione della Configurazione
  // NUOVA SEZIONE AGGIUNTA
  //
  // - MP29: Commit Message Quality Score
  //   Valutazione aderenza a convenzioni (0-10)
  //   Accettabile: ≥ 7/10
  //   Ottimale: ≥ 9/10
  //   Utilità: Tracciabilità storico modifiche
  //    Pensare a come valutare la qualità dei commit

  === Gestione della Qualità
  // - MP14: Quality Metrics Satisfied
  //
  // NUOVA METRICA AGGIUNTA:
  // - MP31: Quality Gate Pass Rate
  //   Formula: (Build che superano quality gate) / (Build totali) × 100
  //   Accettabile: ≥ 85%
  //   Ottimale: ≥ 95%
  //   Utilità: Monitoraggio automatico qualità pipeline CI/CD

  == Processi organizzativi
  === Gestione dei Processi
  // - MP15: Time Efficiency
  //
  // NUOVE METRICHE AGGIUNTE:
  //
  // - MP32: Sprint Velocity Stability
  //   Deviazione standard della velocity negli ultimi 3 sprint
  //   Accettabile: ≤ 20%
  //   Ottimale: ≤ 10%
  //   Utilità: Prevedibilità pianificazione
  //
  // - MP33: Meeting Efficiency Index
  //   Formula: (Decisioni prese) / (Ore di meeting) × 100
  //   Accettabile: ≥ 2 decisioni/ora
  //   Ottimale: ≥ 3 decisioni/ora
  //   Utilità: Evita meeting improduttivi
  //
  // - MP34: Issue Resolution Time
  //   Tempo medio tra apertura e chiusura issue (per priorità)
  //   Accettabile: Alta ≤ 3 giorni, Media ≤ 7 giorni, Bassa ≤ 14 giorni
  //   Ottimale: Alta ≤ 1 giorno, Media ≤ 3 giorni, Bassa ≤ 7 giorni
  //   Utilità: Responsività del team

  = Qualità di prodotto
  == Funzionalità
  // Copertura requisiti
  // - MQ01: Requisiti Obbligatori Soddisfatti
  // - MQ02: Requisiti Desiderabili Soddisfatti
  // - MQ03: Requisiti Opzionali Soddisfatti

  == Affidabilità
  // - MQ04: Branch Coverage
  // - MQ05: Statement Coverage
  // - MQ06: Failure Density

  == Usabilità
  // - MQ07: Time on Task
  // - MQ08: Error Rate
  //
  // Da gestire solamente quando avremo idea di come il prodotto finale verrà utilizzato

  == Efficienza
  // - MQ09: Response Time
  // Da gestire solamente quando avremo idea di come il prodotto finale verrà utilizzato

  == Manutenibilità
  // - MQ10: Code Smells
  // - MQ11: Coefficient of Coupling -> non so come farla
  // - MQ12: Cyclomatic Complexity
  //
  // NUOVE METRICHE AGGIUNTE:
  //
  // - MQ25: Code Duplication Percentage
  //   Formula: (Linee duplicate) / (Linee totali) × 100
  //   Accettabile: ≤ 5%
  //   Ottimale: ≤ 3%
  //   Utilità: Riduce debito tecnico

  == Portabilità
  // NUOVA SEZIONE AGGIUNTA (RILEVANTE PER CLOUD)
  //
  // - MQ27: Container Image Size
  //   Dimensione immagini Docker prodotte
  //   Accettabile: ≤ 500 MB
  //   Ottimale: ≤ 200 MB
  //   Utilità: Velocità deployment e costi storage
  //  -> ci pensiamo

  == Sicurezza
  // NUOVA SEZIONE AGGIUNTA (CRITICA PER IL PROGETTO)
  //  -> da vedere come fare
  //
  // - MQ30: Authentication Success Rate
  //   Formula: (Autenticazioni corrette) / (Tentativi totali) × 100
  //   Accettabile: ≥ 98% (considerando errori utente)
  //   Ottimale: ≥ 99.5%
  //   Utilità: Robustezza provisioning gateway
  //
  // - MQ31: Encryption Coverage
  //   Formula: (Dati sensibili crittografati) / (Dati sensibili totali) × 100
  //   Accettabile: 100%
  //   Ottimale: 100%
  //   Utilità: Compliance GDPR

  = Metodi di testing


  = Cruscotto di valutazione

]

// Aggiungere misurazioni di numero di bug tra sprint (sono aumentati? perché?)

