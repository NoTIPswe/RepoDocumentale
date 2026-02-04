#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)

#let metrics-table(metrics, caption: none) = {
  set text(hyphenate: false)
  figure(
    table(
      columns: (auto, auto, auto, auto),
      align: center + horizon,
      inset: 6pt,
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
  acceptable,
  optimal,
  note: none,
) = {
  v(0.5em)
  heading(level: 4, numbering: none, outlined: false)[#cod - #name]
  v(0.5em)

  block(
    breakable: false,
    [
      *Motivazione valore accettabile:*
      #acceptable
    ],
  )

  block(
    breakable: false,
    [
      *Motivazione valore ottimo:*
      #optimal
    ],
  )

  if note != none [
    #block(
      breakable: false,
      [
        *Note di utilizzo:*
        #note
      ],
    )
  ]
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
  Il presente Piano di Qualifica definisce le strategie, le metodologie e le metriche adottate dal gruppo per garantire
  la qualità del prodotto software e l'efficienza dei processi del progetto. Esso costituisce il riferimento principale
  per le attività di:
  - Verifica: accertarsi che il prodotto stia venendo costruito a regola d'arte.
  - Validazione: accertarsi che si stia costruendo il prodotto giusto rispetto alle attese del proponente.

  Il documento nasce all'inizio del progetto, ma è concepito come uno strumento dinamico che accompagna l'intero ciclo
  di vita dello stesso, evolvendosi attraverso revisioni migliorative continue. La strategia di gestione della qualità
  si ispira al ciclo di PDCA (Plan, Do, Check, Act), articolandosi nelle seguenti fasi:
  - *Pianificazione (Plan)*: Definizione degli obiettivi qualitativi e quantitativi. Questa fase stabilisce le metriche
    di riferimento e le soglie di accettazione da applicare sia ai processi che al prodotto finale.
  - *Esecuzione (Do)*: Attuazione delle procedure pianificate. In questa fase vengono eseguiti i processi di sviluppo e
    di test secondo le metodologie stabilite, raccogliendo i dati necessari per le misurazioni successive.
  - *Controllo (Check)*: Applicazione di misurazioni oggettive durante lo svolgimento delle attività. L'obiettivo è
    rilevare scostamenti rispetto a quanto pianificato e verificare la conformità ai requisiti stabiliti.
  - *Miglioramento (Act)*: Analisi critica dei risultati ottenuti (consuntivo). Questa fase mira a identificare
    difficoltà organizzative o tecniche e ad attuare azioni correttive tempestive per ottimizzare i processi negli
    sprint successivi.

  L'obiettivo finale è assicurare che il rilascio soddisfi pienamente i requisiti del capitolato, minimizzando i difetti
  e garantendo alti livelli di manutenibilità e usabilità.

  == Scopo del prodotto
  Il progetto ha l'obiettivo di realizzare una piattaforma Cloud multi-tenant e scalabile, dedicata all'acquisizione e
  alla gestione sicura di dati provenienti da sensori Bluetooth Low Energy (BLE).

  L'architettura del sistema si fonda su due componenti principali:
  - Infrastruttura Cloud Centralizzata:
    - Costituisce il cuore del sistema per l'ingestione, segregazione ed esposizione dei dati.
    - Gestisce il provisioning sicuro dei gateway e il controllo degli accessi in un contesto multi-tenant.
    - Garantisce la persistenza dei dati e la loro accessibilità.
  - Simulatore Software di Gateway:
    - Replica il comportamento di un Gateway BLE-WiFi fisico in un contesto reale.
    - Genera flussi di dati verosimili per validare la robustezza del sistema.
    - Gestisce la comunicazione sicura verso il livello Cloud.

  L'obiettivo finale è quello di fornire uno strumento completo per l'amministrazione e la visualizzazione dei dati,
  garantendo requisiti non funzionali critici quali sicurezza, affidabilità e scalabilità.

  == Riferimenti
  === Riferimenti normativi

  - #link("https://notipswe.github.io/docs/12-rtb/docint/norme_progetto.pdf")[Norme di Progetto]
  - #link(
      "https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf",
    )[Capitolato d'appalto C7 - Sistema di acquisizione dati da sensori]

  === Riferimenti informativi

  - #link("https://www.math.unipd.it/~tullio/IS-1/2009/Approfondimenti/ISO_12207-1995.pdf")[Standard ISO/IEC 12207:1995]
    – Software Life Cycle Processes
  - #link("https://it.wikipedia.org/wiki/ISO/IEC_9126")[Standard ISO/IEC 9126] – Software Engineering - Product Quality
  - Materiale didattico:
    - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/T07.pdf")[Slide T7] - Qualità di prodotto
    - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/T08.pdf")[Slide T8] - Qualità di processo
    - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/T09.pdf")[Slide T9] - Verifica e Validazione

  Al fine di garantire un linguaggio univoco e prevenire possibili ambiguità, i termini tecnici, gli acronimi e i
  vocaboli con accezione specifica nel contesto del progetto sono stati definiti puntualmente nel documento #link(
    "https://notipswe.github.io/docs/12-rtb/docest/glossario.pdf",
  )[Glossario]. Si invita il lettore a fare riferimento a tale documento per chiarire qualsiasi dubbio.

  = Qualità di processo

  Garantire la qualità del processo significa assicurarsi che il nostro metodo di lavoro sia solido, e non solo che il
  codice funzioni. Un processo ben strutturato è l'unico modo per evitare sprechi di risorse, ridurre il rischio di
  errori a cascata e mantenere il controllo sulle tempistiche del progetto.

  Per ottenere questo risultato, non ci affidiamo al caso ma a una strategia basata su:

  - Riferimenti normativi: abbiamo preso come riferimento il modello CMMI e lo standard ISO/IEC 12207;

  - Approccio Quantitativo: per evitare valutazioni soggettive, utilizziamo metriche oggettive. Ogni metrica ha due
    soglie di riferimento: un valore accettabile e un valore ottimale;

  - Iterazione e Miglioramento: sfruttiamo le retrospettive di fine sprint per analizzare i dati raccolti e, se i numeri
    si discostano dagli obiettivi, allora applicando il ciclo PDCA, cerchiamo di correggere nel successivo sprint.

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
    caption: [Soglie metriche Fornitura di processo],
  )

  #heading(level: 4, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MP01],
    [Earned Value],
    [Il valore accettabile minimo è zero poiché l'EV rappresenta il valore del lavoro completato. Non può essere
      negativo per definizione e valori molto bassi rispetto al pianificato indicano ritardi nell'esecuzione, tuttavia
      non sono invalidanti dal punto di vista metrico.],
    [Il valore ottimo corrisponde esattamente al Planned Value (EV = PV), indicando che il lavoro completato coincide o
      eccede addirittura quello pianificato. Questo significa che il progetto procede esattamente nei tempi previsti,
      senza ritardi.],
    note: [L'EV deve essere calcolato a intervalli regolari (es. fine sprint) per tracciare l'andamento del progetto.
      Variazioni significative richiedono analisi delle cause e potenziali azioni correttive.],
  )

  #metrics-description(
    [MP02],
    [Planned Value],
    [Il PV non può essere negativo poiché rappresenta il budget allocato per il lavoro pianificato fino a un dato
      momento. Il valore minimo zero si verifica all'inizio del progetto quando nessun lavoro è ancora pianificato.],
    [Il valore ottimo è che il PV rimanga sempre minore o uguale al Budget At Completion (BAC), ovvero che la
      pianificazione non ecceda il budget totale disponibile. Un PV che cresce linearmente nel tempo indica una
      pianificazione equilibrata.],
    note: [Il PV funge da baseline per tutti i calcoli di performance. Deve essere definito accuratamente in fase di
      pianificazione basandosi su stime realistiche delle attività.],
  )

  #metrics-description(
    [MP03],
    [Actual Cost],
    [L'AC non può essere negativo in quanto rappresenta costi realmente sostenuti. Il valore minimo zero si ha
      all'inizio del progetto prima di iniziare qualsiasi attività.],
    [Il valore ottimo è che l'AC rimanga sempre minore o uguale al PV, indicando che il progetto sta spendendo meno o
      uguale a quanto pianificato rispetto al periodo corrente. Valori di AC eccedenti PV segnalano potenziali problemi
      di budget.],
    note: [L'AC deve includere tutti i costi diretti. La sua accuratezza è critica per calcolare correttamente CPI ed
      EAC.],
  )

  #metrics-description(
    [MP04],
    [Cost Performance Index],
    [A seguito di ricerche, solitamente CPI ≥ 0.85 è considerato accettabile secondo standard di project management. Per
      l'inesperienza dei membri del gruppo abbiamo deciso di abbassarlo a valori CPI ≥ 0.6, simboleggianti la
      sufficienza. Valori inferiori segnalano seri problemi di efficienza tecnico-economica che richiedono interventi
      immediati, in modo da iniziare a produrre in modo maggiormente efficiente.],
    [Un CPI = 1.0 è ottimale, indicando che si sta ottenendo esattamente quello che ci aspetta per la spesa fatta. CPI >
      1 significa efficienza superiore alle previsioni, ottimale di definizione.],
  )

  #metrics-description(
    [MP05],
    [Schedule Performance Index],
    [Un SPI ≥ 0.6 è accettabile, per i motivi presentati nella metrica precedente indicando che il lavoro completato è
      almeno l'60% di quello pianificato. SPI < 0.6 implica, con tutta probabilità, ritardi significativi nel planning
      del progetto.],
    [Un SPI ≥ 1.0 è ottimale, indicando che il lavoro completato coincide o eccede quello pianificato. SPI > 1 significa
      che si è in anticipo sulla tabella di marcia. Il valore 1.0 rappresenta l'aderenza perfetta alla pianificazione.],
    note: [L'SPI è particolarmente importante nelle fasi iniziali per identificare problemi di stima. A differenza del
      CPI, l'SPI può essere recuperato in sprint successivi aumentando la velocity del team.],
  )

  #metrics-description(
    [MP06],
    [Estimate At Completion],
    [L'EAC non può essere negativo essendo una proiezione di costo ed il valore zero è puramente teorico, non si
      verifica in progetti reali.],
    [Il valore ottimo è EAC ≤ BAC, ovvero che la stima finale dei costi non superi il budget inizialmente allocato.
      Questo indica che il progetto si concluderà entro il budget previsto. Nel caso in cui EAC = BAC significa perfetta
      aderenza al budget.],
    note: [L'EAC dovrebbe essere ricalcolato ad ogni sprint utilizzando il CPI aggiornato, fornendo quindi una
      prospettiva concreta sul modo in cui il lavoro sta procedendo. Avere una tendenza crescente nell'EAC è
      considerabile un warning di potenziale sforamento budget.],
  )

  #metrics-description(
    [MP07],
    [Estimate To Complete],
    [L'ETC non può essere negativo poiché rappresenta il costo stimato per completare il lavoro rimanente. Risulta
      essere zero se e solo se il progetto è completato.],
    [Il valore ottimo è che l'ETC rimanga entro il budget residuo originariamente pianificato. ETC superiore al budget
      residuo indica necessità di fondi aggiuntivi.],
    note: [Se ETC supera significativamente il budget disponibile, potrebbe essere necessario intraprendere trattative a
      ribasso con la proponente riguardo il proseguimento del progetto.],
  )

  #metrics-description(
    [MP08],
    [Time Estimate At Completion],
    [Il TEAC non può essere negativo essendo una stima temporale sul futuro. Risulterà essere zero solamente al termine
      del progetto.],
    [Il valore ottimo è TEAC ≤ Durata pianificata, indicando che il progetto si concluderà entro le tempistiche
      previste, dove TEAC = Durata pianificata indica perfetta aderenza alla schedulazione.],
    note: [Il TEAC è critico per gestire aspettative degli stakeholder e per decisioni su milestone contrattuali. Un
      TEAC significativamente superiore alla durata pianificata può richiedere rinegoziazione delle scadenze o delle
      richieste.],
  )

  #metrics-description(
    [MP09],
    [Budget Burn Rate],
    [Il burn rate accettabile è che rimanga minore o uguale al burn rate pianificato. Questo assicura che il budget non
      si esaurisca prima del completamento del progetto. Un burn rate leggermente superiore è sostenibile solamente se
      temporaneo.],
    [Il valore ottimo è un burn rate costante e prevedibile nel tempo, idealmente coincidente con quello pianificato.
      Fluttuazioni minime sono assolutamente normali, ma avere un burn rate costante facilita la comprensione del modo
      in cui sta venendo speso il budget.],
    note: [Il burn rate dovrebbe essere visualizzato graficamente (burn-down chart) per identificare visivamente trend
      problematici.],
  )

  === Sviluppo

  #metrics-table(
    (
      (cod: [*MP10*], name: [Requirements Stability Index], acceptable: [≥ 70%], optimal: [100%]),
    ),
    caption: [Soglie metriche Sviluppo di processo],
  )

  #heading(level: 4, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MP10],
    [Requirements Stability Index],
    [Questo valore riconosce un margine di cambiamento accettabile, in quanto in progetti con gestione agile, sono
      inevitabili cambiamenti per rispondere a feedback o nuove esigenze. RSI < 70% segnala analisi iniziale
      inadeguata.],
    [Un RSI = 100% è ottimale. Questo livello di stabilità riflette un'eccellente analisi iniziale e requisiti ben
      compresi. Permette pianificazione affidabile e riduce drasticamente i costi di rework.],
    note: [L'RSI diventa significativo solo dopo aver stabilito una baseline dei requisiti.],
  )

  // - MP__: Code Coverage (durante sviluppo)
  // - MP__: Complessità Ciclomatica Media per Modulo

  == Processi di supporto
  === Documentazione

  #metrics-table(
    (
      (cod: [*MP11*], name: [Indice di Gulpease], acceptable: [≥ 60], optimal: [≥ 80]),
      (cod: [*MP12*], name: [Correttezza Ortografica], acceptable: [0 errori], optimal: [0 errori]),
    ),
    caption: [Soglie metriche Documentazione di processo],
  )

  #heading(level: 4, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MP11],
    [Indice di Gulpease],
    [Un indice ≥ 60 garantisce che la documentazione sia comprensibile per lettori con istruzione media, appropriato per
      documentazione tecnica rivolta a professionisti del settore. Questo livello bilancia precisione terminologica e
      chiarezza espositiva.],
    [Un indice ≥ 80 indica documentazione molto accessibile, comprensibile anche per lettori con istruzione base.],
    note: [L'indice di Gulpease non è sempre necessario massimizzarlo, ma va interpretato considerando il tipo di
      documento in esame: manuali utente dovrebbero cercare di raggiungere valori più alti (≥75), mentre documentazione
      tecnica tenderà ad avere valori più bassi (≥55) data la natura tecnica del contenuto.],
  )

  #metrics-description(
    [MP12],
    [Correttezza Ortografica],
    [Zero errori ortografici è l'unico valore accettabile per documentazione professionale.],
    [Il valore ottimo coincide con l'accettabile: zero errori, in quanto la documentazione formale destinata agli
      stakeholder deve essere priva errori di battitura o refusi da versioni precedenti, in modo da riflettere la
      professionalità del gruppo e dei processi dallo stesso impiegati.],
    note: [La presenza di errori indica processi di quality assurance inadeguati che devono essere rafforzati.],
  )

  === Verifica
  #metrics-table(
    (
      (cod: [*MP13*], name: [Code Coverage], acceptable: [≥ 80%], optimal: [≥ 90%]),
      (cod: [*MP14*], name: [Test Success Rate], acceptable: [100%], optimal: [100%]),
      (cod: [*MP15*], name: [Test Automation Percentage], acceptable: [≥70%], optimal: [≥85%]),
      (
        cod: [*MP16*],
        name: [Defect Discovery Rate],
        acceptable: [Crescente→Decrescente],
        optimal: [Picco in System Test,\ 0 rilascio],
      ),
    ),
    caption: [Soglie metriche Verifica di processo],
  )

  #heading(level: 4, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MP13],
    [Code Coverage],
    [In ogni progetto è importante mantenere una percentuale di code coverage alta, ≥ 80% è una convenzione spesso
      usata, affinché si possa garantire che il codice scritto sia stato effettivamente testato per la sua
      maggioranza.],
    [L'ottimo non è stato posto al 100% sia per avere una stima più realistica e sia per evitare che il team sia troppo
      focalizzato sul raggiungere il 100% di code coverage, creando così test che non controllano il codice nella
      maniera corretta.],
    note: [L'obiettivo è avere un code coverage quanto più vicino al 100% nelle sezioni critiche del codice e dell'80%
      per quanto riguarda il restante codice.],
  )

  #metrics-description(
    [MP14],
    [Test Success Rate],
    [Trattandosi di un sistema che gestisce dati sensibili ci si prefissa di avere una percentuale del 100%, perché ogni
      bug potrebbe essere pericoloso in un sistema di questo tipo.],
    [Il valore ottimo coincide con l'accettabile, in quanto non sono tollerati test falliti in branch principali.],
    note: [Qualsiasi test fallito indica regressioni o bug che devono essere risolti immediatamente prima di procedere
      con ulteriore sviluppo],
  )

  #metrics-description(
    [MP15],
    [Test Automation Percentage],
    [È importante che una parte considerevole dei test da eseguire sul sistema siano automatizzati, così da garantire
      automaticamente che la parte più importante di tutto il codice sia stata testata in maniera veloce ed efficace.],
    [L'85% è un valore ottimo ragionevole, permettendo esecuzioni frequenti senza costi significativi. Il restante 15%
      per test di usabilità per l'eventuale interfaccia grafica e per altre verifiche che potrebbero essere
      necessarie.],
    note: [Il 100% di automazione non è considerato un obiettivo perché potrebbe anche introdurre dei test instabili o
      avere una fase di test eccessivamente lunga.],
  )

  #metrics-description(
    [MP16],
    [Defect Discovery Rate],
    [Nelle fasi iniziali e centrali dello sviluppo (Unit e Integration Test), il trend deve essere crescente: un numero
      basso di bug trovati in questa fase indicherebbe test inefficaci o poco aggressivi. Il trend deve diventare
      decrescente solo nella fase di stabilizzazione finale.],
    [Il valore ottimo prevede che il picco massimo di bug trovati coincida con la fase di Testing di Sistema e
      Integrazione, per poi crollare drasticamente verso lo zero nell'imminenza del rilascio.],
    note: [Se la curva rimane piatta (pochi bug trovati) durante lo sviluppo intenso, è necessario rivedere la strategia
      di test.],
  )

  === Gestione della Configurazione

  #metrics-table(
    (
      (cod: [*MP17*], name: [Commit Message Quality Score], acceptable: [7/10], optimal: [9/10]),
    ),
    caption: [Soglie metriche Gestione della Configurazione di processo],
  )
  #metrics-description(
    [MP17],
    [Commit Message Quality Score],
    [Abbiamo optato per un valore accettabile 7/10, perché la qualità del commit deve essere almeno sopra la sufficienza
      per garantire chiarezza del messaggio, oltre a permettere in alcuni casi di risalire ad errori introdotti con
      recenti commit.],
    [Un punteggio ≥ 9/10 è ottimale, indicando commit messages esemplari che documentano completamente sia il "cosa" che
      il "perché" delle modifiche. Questo facilita enormemente debugging futuro, code review, e inserimento di nuovi
      sviluppatori.],
    note: [Template di commit messages e linee guida chiare nelle Norme di Progetto sono essenziali per raggiungere
      punteggi alti.],
  )

  === Gestione della Qualità

  #metrics-table(
    (
      (cod: [*MP18*], name: [Quality Metrics Satisfied], acceptable: [≥ 80%], optimal: [≥ 100%]),
      (cod: [*MP19*], name: [Quality Gate Pass Rate], acceptable: [≥ 85%], optimal: [≥ 95%]),
    ),
    caption: [Soglie metriche Gestione della Qualità],
  )

  #heading(level: 4, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MP18],
    [Quality Metrics Satisfied],
    [Un valore ≥ 80% di metriche soddisfatte rappresenta un buon livello qualitativo generale, permettendo un margine
      del 20% per metriche particolarmente difficili da soddisfare completamente. Sotto questa soglia il progetto ha
      problemi di qualità.],
    [Avere soddisfazione del 100% significa che tutte le metriche definite sono soddisfatte. Questo livello dimostra
      eccellenza complessiva nella gestione della qualità.],
    note: [Questa metrica dovrebbe essere calcolata pesando correttamente le varie metriche, dove quelle critiche
      dovrebbero avere peso maggiore di metriche meno critiche.],
  )

  #metrics-description(
    [MP19],
    [Quality Gate Pass Rate],
    [Indica che la maggior parte del codice proposto rispetta gli standard minimi di sicurezza e manutenibilità. Un 15%
      di fallimenti è concesso per permettere iterazioni veloci e feedback loop rapidi dalla CI senza imporre un
      perfezionismo prematuro.],
    [Un tasso ≥ 95% testimonia un'elevata maturità del team nell'eseguire verifiche locali prima del push sul
      repository. Indica un processo di integrazione fluido, dove la CI fallisce solamente raramente.],
    note: [Il valore va interpretato con attenzione: un pass rate costantemente al 100% potrebbe indicare controlli
      troppo laschi, mentre un valore troppo basso suggerisce la necessità di rivedere la configurazione dei gate o di
      migliorare la formazione del team sui test locali.],
  )

  == Processi organizzativi

  === Gestione dei Processi

  #metrics-table(
    (
      (cod: [*MP20*], name: [Time Efficiency], acceptable: [≥ 60%], optimal: [100%]),
      (cod: [*MP21*], name: [Sprint Velocity Stability], acceptable: [≤ 30%], optimal: [≤ 10%]),
      (cod: [*MP22*], name: [Meeting Efficiency Index], acceptable: [≥ 2 decisioni/ora], optimal: [≥ 5 decisioni/ora]),
      (
        cod: [*MP23*],
        name: [PR Resolution Time],
        acceptable: [≤ 3 giorni],
        optimal: [≤ 1 giorni],
      ),
    ),
    caption: [Soglie metriche Gestione dei Processi],
  )

  #heading(level: 4, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MP20],
    [Time Efficiency],
    [Il minimo accettabile per garantire un avanzamento accettabile del progetto. Scendere sotto questa soglia indica
      una dispersione eccessiva di risorse in attività non produttive.],
    [Indica uno scenario di efficienza assoluta in cui sono stati eliminati tutti i tempi morti, le riunioni superflue e
      le attività a non-valore aggiunto.],
    note: [Per calcolare la metrica, è necessario distinguere nel tracciamento le ore "produttive" da quelle
      "organizzative/di palestra".],
  )

  #metrics-description(
    [MP21],
    [Sprint Velocity Stability],
    [Una deviazione standard ≤ 30% della media è accettabile, permettendo una certa variabilità naturale tra sprint
      dovuta alla complessità variabile delle task, impegni dei membri del gruppo o eventi imprevisti.],
    [≤ 10% di deviazione è ottimale, indicando velocity altamente prevedibile. Questo livello si raggiunge con: stime
      accurate, team stabile, scope ben definito, e impedimenti gestiti efficacemente. Facilita enormemente commitment e
      pianificazione di release.],
    note: [Variabilità > 20% rende la pianificazione inaffidabile. Dovrebbe però migliorare naturalmente con il passare
      del tempo, stabilizzandosi su valori tendenti all'ottimo.],
  )

  #metrics-description(
    [MP22],
    [Meeting Efficiency Index],
    [≥ 2 decisioni/ora è accettabile per meeting produttivi. Riconosce che alcune discussioni richiedono tempo per
      esplorare alternative prima di decidere. Meeting sotto questa soglia tendono ad essere troppo poco produttivi.],
    [≥ 5 decisioni/ora è ottimale, indicando meeting altamente focalizzati con agenda chiara e partecipanti preparati.
      Questo livello massimizza il valore del tempo speso.],
    note: [Preparazione dell'agenda con decisioni da prendere, condividere materiale da discutere in precedenza e
      documentare decisioni prese.],
  )

  #metrics-description(
    [MP23],
    [PR Resolution Time],
    [Un tempo di merge ≤ 3 giorni è accettabile. Garantisce che il codice o un documento non rimanga bloccato troppo a
      lungo, riducendo il rischio di conflitti di merge complessi.],
    [Un tempo ≤ 1 giorno è ottimale. Indica un processo di Code Review estremamente efficiente e una cultura di team che
      dà priorità al processo di revisione rispetto all'inizio di nuove task, favorendo il Continuous Integration.],
    note: [Un tempo di risoluzione breve garantisce che la correzione o l'aggiunta avvenga mentre la memoria dell'autore
      è ancora fresca. Inoltre è raccomandata l'apertura di PR più piccole e focalizzate per migliorare l'efficacia e la
      velocità della verifica],
  )

  #pagebreak()

  = Qualità di prodotto

  La qualità del prodotto costituisce il traguardo fondamentale del progetto. Questa la possiamo intendere come la
  capacità del software rilasciato di rispondere puntualmente alle necessità degli stakeholder e di operare con
  robustezza in ambiente di produzione. Un livello qualitativo elevato non si raggiunge in maniera casuale, ma è la
  diretta conseguenza del rigore metodologico applicato ai processi.

  Per garantire una valutazione oggettiva e strutturata, il gruppo ha adottato come framework di riferimento lo standard
  ISO/IEC 9126. Secondo tale modello, l'eccellenza del software si misura attraverso il soddisfacimento delle seguenti
  caratteristiche:

  - *Funzionalità*, per coprire integralmente i requisiti espressi;
  - *Affidabilità*, per assicurare continuità di servizio senza malfunzionamenti;
  - *Usabilità*, per garantire un'interazione intuitiva;
  - *Efficienza*, per ottimizzare l'uso delle risorse;
  - *Manutenibilità*, per facilitare l'evoluzione futura del codice;
  - *Portabilità*, per permettere l'esecuzione in ambienti diversi

  == Funzionalità

  #metrics-table(
    (
      (cod: [*MQ01*], name: [Requisiti Obbligatori Soddisfatti], acceptable: [100%], optimal: [100%]),
      (cod: [*MQ02*], name: [Requisiti Desiderabili Soddisfatti], acceptable: [0%], optimal: [100%]),
      (cod: [*MQ03*], name: [Requisiti Opzionali Soddisfatti], acceptable: [0%], optimal: [100%]),
      (
        cod: [*MQ04*],
        name: [Requirements Test Coverage],
        acceptable: [100% (R. Obbligatori)],
        optimal: [100% (R. Obbligatori + Accettabili)],
      ),
    ),
    caption: [Soglie metriche Funzionalità del prodotto],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MQ01],
    [Requisiti Obbligatori Soddisfatti],
    [L'unico valore accettabile è 100%. I requisiti obbligatori rappresentano funzionalità contrattualmente vincolanti e
      essenziali per l'utilizzo base del sistema, richieste esplicitamente dallo stakeholder. Non implementare anche un
      solo requisito obbligatorio rende il prodotto non conforme e non accettabile dal committente.],
    [Il valore ottimo coincide con l'accettabile.],
    note: [Problemi nell'implementazione di requisiti obbligatori dovranno avere priorità massima e potranno richiedere
      riallocazione urgente di ore e ruoli.],
  )

  #metrics-description(
    [MQ02],
    [Requisiti Desiderabili Soddisfatti],
    [0% è tecnicamente accettabile poiché questi requisiti non sono essenziali per l'accettazione del prodotto.
      Tuttavia, anche a seguito degli incontri tenuti con la proponente, l'implementazione di una parte di essi è
      altamente consigliata e aggiunge valore al prodotto.],
    [100% rappresenta un prodotto completo e ricco di funzionalità che supera le aspettative minime. Questo livello
      dovrebbe essere perseguito se il progetto ha risorse e tempo sufficienti dopo aver completato tutti i requisiti
      obbligatori.],
    note: [La priorità esecutiva assegnata ai requisiti desiderabili dovrebbe basarsi su: feedback del committente,
      rapporto valore/costo di implementazione e dipendenze con altri requisiti.],
  )

  #metrics-description(
    [MQ03],
    [Requisiti Opzionali Soddisfatti],
    [0% risulta essere accettabile, in quanto i requisiti opzionali rappresentano dei "nice-to-have" da considerare
      solamente dopo aver completato obbligatori e desiderabili. Non implementarli non rende il prodotto incompleto
      rispetto alle richieste.],
    [100% rappresenta un prodotto estremamente completo, ma questo livello difficilmente raggiungibile senza un notevole
      sforzo economicamente.],
    note: [La loro implementazione non dovrebbe mai sottrarre risorse a requisiti di priorità superiore durante lo
      sviluppo della versione corrente.],
  )

  #metrics-description(
    [MQ04],
    [Requirements Test Coverage],
    [Non è sufficiente che un requisito sia implementato; deve essere verificato. Il 100% dei requisiti obbligatori deve
      essere tracciato da almeno un caso di test che termini con successo.],
    [Estendere la copertura dei test automatizzati anche ai requisiti desiderabili e opzionali garantisce che l'intero
      valore del prodotto sia testato.],
  )

  == Affidabilità

  #metrics-table(
    (
      (cod: [*MQ05*], name: [Branch Coverage], acceptable: [≥ 60%], optimal: [≥ 80%]),
      (cod: [*MQ06*], name: [Statement Coverage], acceptable: [≥ 70%], optimal: [≥ 90%]),
      (cod: [*MQ07*], name: [Failure Density], acceptable: [≤ 0.5], optimal: [≤ 0.1]),
      (
        cod: [*MQ08*],
        name: [Modified Condition/Decision Coverage (MC/DC)],
        acceptable: [100% (Critical Only)],
        optimal: [100%],
      ),
    ),
    caption: [Soglie metriche Affidabilità del prodotto],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MQ05],
    [Branch Coverage],
    [≥ 60% è accettabile in quanto testare tutti i branch possibili risulta complesso. Questo livello garantisce che un
      livello sufficiente delle decisioni logiche sia verificata.],
    [Un valore ≥ 80% è ottimale e rappresenta un'eccellente copertura, riducendo drasticamente i bug di logica
      condizionale e migliora la confidenza nel comportamento del codice in tutte le circostanze.],
    note: [Focus particolare dovrebbe essere dato a: business logic critica, gestione errori, e validazione input.],
  )

  #metrics-description(
    [MQ06],
    [Statement Coverage],
    [Un valore ≥ 70% garantisce che la maggioranza delle istruzioni sia stata eseguita almeno una volta durante i test,
      riducendo il rischio di bug nascosti in codice non verificato.],
    [≥ 90% è ottimale e dimostra una test suite molto completa. Il 10% non coperto può giustificarsi per: codice di
      gestione errori estremi, codice legacy non critico, o sezioni in attesa di rimozione.],
    note: [Deve essere affiancata da branch coverage e test di qualità che verifichino comportamenti attesi, non solo
      l'esecuzione di linee.],
  )

  #metrics-description(
    [MQ07],
    [Failure Density],
    [Un valore ≤ 0.5 failure/KLOC è accettabile per software in fase di stabilizzazione. Corrisponde mediamente a 1 bug
      ogni 2000 linee di codice.],
    [≤ 0.1 failure/KLOC è ottimale e rappresenta software di altissima qualità, tipico di software a seguito di
      estensive sessioni di testing e bug-fixing.],
    note: [È cruciale distinguere failure per severity: un bug critico (crash, data loss) ha impatto molto maggiore di
      uno cosmetico (typo in UI).],
  )

  #metrics-description(
    [MQ08],
    [Modified Condition/Decision Coverage (MC/DC)],
    [Dato l'alto costo di questa metrica, è accettabile applicarla rigorosamente (100%) solo ai moduli identificati come
      "Safety-Critical" o "Business-Critical". Garantisce che ogni singola condizione in una decisione complessa
      influenzi indipendentemente il risultato.],
    [L'ottimo prevede il 100% di copertura sui moduli critici senza eccezioni e l'estensione ai moduli ad alta
      complessità ciclomatica. Questo livello offre la certezza matematica che non esistano condizioni superflue o
      logiche errate (mascheramento) nelle decisioni complesse.],
    note: [L'adozione della metrica MC/DC è limitata ai soli componenti critici (Core Domain) a causa dell'elevato
      overhead di implementazione e della necessità di strumentazione di testing avanzata. Per i moduli standard (UI,
      DTO, Controller) la Branch Coverage è ritenuta sufficiente per garantire la qualità senza impattare eccessivamente
      sulla velocity del team.],
  )

  == Usabilità
  #metrics-table(
    (
      (cod: [*MQ09*], name: [Time on Task], acceptable: [≤ 60 sec], optimal: [≤ 30 sec]),
      (cod: [*MQ10*], name: [Error Rate], acceptable: [≤ 5%], optimal: [≤ 2%]),
    ),
    caption: [Soglie metriche Usabilità del prodotto],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MQ09],
    [Time on Task],
    [Dal momento in cui l'utente impiega un tempo ≤ 60 secondi per eseguire task standard, viene considerato
      accettabile. Oltre questo tempo, l'utente può percepire il sistema come lento o inefficiente.
    ],
    [≤ 30 secondi è ottimale e indica un'interfaccia altamente efficiente e intuitiva.],
    note: [Misurare con utenti reali o rappresentativi del target. Definire task specifici e misurabili (es. "creare un
      nuovo gateway e associare 3 sensori"). Task complesse possono giustificare tempi maggiori. Questa metrica diventa
      rilevante solo quando l'interfaccia è sufficientemente sviluppata.],
  )

  #metrics-description(
    [MQ10],
    [Error Rate],
    [≤ 5% è accettabile, riconoscendo che alcuni errori utente sono inevitabili. Questo margine tollera una certa curva
      di apprendimento e situazioni ambigue nell'interfaccia.],
    [≤ 2% è ottimale e indica un'interfaccia estremamente intuitiva dove gli errori sono rari. Si raggiunge con: design
      patterns consolidati, validazione input efficace, feedback chiari e prevenzione degli errori.],
    note: [Errori frequenti in task specifici indicano problemi di design localizzati. È quindi utile andare ad
      analizzare quali task generano più errori e perché.],
  )

  == Efficienza

  #metrics-table(
    (
      (cod: [*MQ11*], name: [Response Time], acceptable: [≤ 2 sec], optimal: [≤ 1 sec]),
    ),
    caption: [Soglie metriche Efficienza del prodotto],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MQ11],
    [Response Time],
    [≤ 2 secondi è il limite accettabile secondo standard di usabilità (Nielsen). Oltre questo tempo, l'utente
      percepisce attesa significativa.],
    [Un valore ≤ 1 secondo è ottimale e fornisce un'esperienza fluida senza attese percepite. Mantiene il flusso di
      lavoro dell'utente ininterrotto.],
    note: [Operazioni complesse possono giustificare tempi > 2s. Potrebbe aiutare aggiungere degli indicatori di
      progresso, per dare un feedback diretto all'utilizzatore.],
  )

  == Manutenibilità

  #metrics-table(
    (
      (cod: [*MQ12*], name: [Code Smells], acceptable: [≤ 10], optimal: [≤ 5]),
      (cod: [*MQ13*], name: [Coefficient of Coupling], acceptable: [≤ 0.4], optimal: [≤ 0.2]),
      (cod: [*MQ14*], name: [Cyclomatic Complexity], acceptable: [≤ 10], optimal: [≤ 5]),
      (cod: [*MQ15*], name: [Code Duplication Percentage], acceptable: [≤ 5%], optimal: [≤ 3%]),
    ),
    caption: [Soglie metriche Manutenibilità del prodotto],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MQ12],
    [Code Smells],
    [≤ 10 code smell/KLOC consente la presenza di alcuni problemi di design non critici, senza compromettere
      significativamente la manutenibilità complessiva.],
    [≤ 5 code smell/KLOC indica codice ben strutturato e facilmente manutenibile; richiede revisione costante e
      refactoring mirato per mantenere livelli elevati di qualità.],
    note: [Strumenti come SonarQube individuano automaticamente code smell. Prioritizzare la correzione nelle aree
      critiche o soggette a frequenti modifiche. Gli smell temporanei devono essere documentati e risolti nelle
      iterazioni successive.],
  )

  #metrics-description(
    [MQ13],
    [Coefficient of Coupling],
    [≤ 0.4 indica accoppiamento moderato e gestibile. Permette interdipendenze necessarie per funzionalità del sistema
      mantenendo architettura sufficientemente modulare per modifiche localizzate senza effetti a cascata eccessivi.],
    [Un valore ≤ 0.2 rappresenta sistema disaccoppiato, coeso internamente e con poche dipendenze esterne. Ideale per
      manutenibilità, in quanto modifiche a un componente hanno impatto minimo su altri.],
    note: [Accoppiamento alto rende il sistema fragile e difficile da testare.],
  )

  #metrics-description(
    [MQ14],
    [Cyclomatic Complexity],
    [≤ 10 per metodo/funzione indica codice complesso ma ancora comprensibile e testabile. Oltre questa soglia, codice
      diventa difficile da capire e richiede numero eccessivo di test per coprire tutti i percorsi logici.],
    [≤ 5 indica codice semplice, lineare, facile da leggere, testare e manutenere. Questo dovrebbe essere l'obiettivo
      per la maggior parte delle funzioni. Metodi più complessi dovrebbero essere refactored in funzioni più piccole e
      coese.],
    note: [Complessità > 10 richiede refactoring urgente: estrarre metodi, usare polimorfismo invece di condizionali,
      semplificare logica booleana. La complessità correla fortemente con probabilità di bug e effort di manutenzione.],
  )

  #metrics-description(
    [MQ15],
    [Code Duplication Percentage],
    [≤ 5% è accettabile, riconoscendo che piccole duplicazioni possono essere tollerabili se ben giustificate (es.
      performance critiche, isolamento di contesti). Duplicazioni limitate non compromettono gravemente la
      manutenibilità.],
    [≤ 3% è ottimale e indica codice ben fattorizzato seguendo principio DRY. Questo livello minimizza effort di
      manutenzione e rischio di inconsistenze quando si correggono bug in codice duplicato.],
    note: [Tool come SonarQube rilevano duplicazioni automaticamente. Soluzione: estrarre codice comune in funzioni
      riutilizzabili, usare Template Method o Strategy pattern per gestire variazioni. Duplicazioni legittime (es. test
      fixtures) dovrebbero essere escluse dal calcolo.],
  )

  == Portabilità

  #metrics-table(
    (
      (cod: [*MQ16*], name: [Container Image Size], acceptable: [≤ 500 MB], optimal: [≤ 200 MB]),
    ),
    caption: [Soglie metriche Portabilità del prodotto],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MQ16],
    [Container Image Size],
    [Un valore ≤ 500 MB è accettabile, permettendo l'inclusione di runtime e librerie necessarie ma mantenendo
      deployment relativamente rapidi e storage gestibili.],
    [≤ 200 MB è ottimale e tipicamente raggiungibile con base images leggere, garantendo deployment veloci e cold start
      rapidi in ambiente cloud.],
  )

  == Sicurezza

  #metrics-table(
    (
      (cod: [*MQ17*], name: [Authentication Success Rate], acceptable: [≥ 98%], optimal: [≥ 99.5%]),
      (cod: [*MQ18*], name: [Encryption Coverage], acceptable: [100%], optimal: [100%]),
    ),
    caption: [Soglie metriche Sicurezza del prodotto],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MQ17],
    [Authentication Success Rate],
    [≥ 98% è accettabile per il sistema di provisioning gateway, considerando che 2% di failure può derivare da errori
      utente legittimi. Success rate inferiore può indicare problemi nel meccanismo di autenticazione.],
    [≥ 99.5% è ottimale e indica sistema robusto e affidabile dove quasi tutti i tentativi legittimi hanno successo.
      Failure residui coprono edge case.],
    note: [Fondamentale distinguere tra failure legittimi (credenziali errate) e tecnici (servizio down, timeout).],
  )

  #metrics-description(
    [MQ18],
    [Encryption Coverage],
    [Tutti i dati sensibili devono essere crittografati sia in storage che durante le comunicazioni, quindi 100% è
      l'unico valore accettabile.],
    [Il valore ottimo coincide con l'accettabile. Trattando potenziali dati sensibili, la mancata crittografia espone a
      rischi non solo legali ma anche di reputazione.],
  )

  #pagebreak()

  = Metodi di testing
  I seguenti metodi di testing verranno adottati per garantire la qualità minima del prodotto:
  - *Unit Testing*: test automatici per singole unità di codice, garantendo correttezza funzionale isolata.
  - *Integration Testing*: verifica delle interazioni tra unità, assicurando che collaborino correttamente.
  - *System Testing*: test end-to-end del sistema completo in ambiente simulato.

  == Test di Unità

  #table(
  columns: (1fr, 3.5fr, 1.2fr, 0.8fr),
  stroke: 0.5pt,
  inset: 6pt,

  table.header(
    [*Codice*],
    [*Descrizione (unitaria)*],
    [*Requisiti di riferimento*],
    [*Stato*],
  ),
  [T-U-1], [Verificare la validazione del campo email nella richiesta di login (presenza e formato)], [R-2-F], [NI],
  [T-U-2], [Verificare la validazione del campo password nella richiesta di login], [R-3-F], [NI],
  [T-U-3], [Verificare il mapping dell’errore “credenziali errate”], [R-4-F], [NI],
  [T-U-4], [Verificare la generazione del segreto TOTP (formato e lunghezza)], [R-5-F], [NI],
  [T-U-5], [Verificare la serializzazione del segreto TOTP], [R-5-F], [NI],
  [T-U-6], [Verificare la valutazione della condizione “2FA richiesto”], [R-6-F], [NI],
  [T-U-7], [Verificare la validazione dell’input OTP (solo cifre, lunghezza)], [R-7-F], [NI],
  [T-U-8], [Verificare il mapping dell’errore “OTP errato”], [R-8-F], [NI],
  [T-U-9], [Verificare la validazione della richiesta di recupero password], [R-9-F], [NI],
  [T-U-10], [Verificare il mapping dell’errore “account non esistente”], [R-11-F], [NI],
  [T-U-11], [Verificare la validazione della nuova password], [R-12-F], [NI],
  [T-U-12], [Verificare il mapping dell’errore “password non corrispondenti”], [R-13-F], [NI],
  [T-U-13], [Verificare il rispetto della policy di complessità password], [R-14-F], [NI],

  [T-U-14], [Verificare il mapping dello stato gateway verso label testuale], [R-24-F], [NI],
  [T-U-15], [Verificare la formattazione del timestamp ultimo invio gateway], [R-26-F], [NI],
  [T-U-16], [Verificare la formattazione del timestamp ultimo invio sensore], [R-29-F], [NI],
  [T-U-17], [Verificare la normalizzazione e serializzazione dello stream dati], [R-31-F], [NI],
  [T-U-18], [Verificare la trasformazione dello stream in struttura tabellare], [R-32-F], [NI],
  [T-U-19], [Verificare la trasformazione dello stream in serie per grafico], [R-33-F], [NI],
  [T-U-20], [Verificare la validazione dell’intervallo temporale (start ≤ end)], [R-36-F], [NI],
  [T-U-21], [Verificare il mapping dello stato “dati non disponibili”], [R-37-F], [NI],
  [T-U-22], [Verificare la serializzazione dei dati per export], [R-38-F], [NI],
  [T-U-23], [Verificare la formattazione del valore fuori range], [R-41-F], [NI],
  [T-U-24], [Verificare la formattazione del range accettato], [R-42-F], [NI],
  [T-U-25], [Verificare la formattazione del timestamp di un dato irregolare], [R-43-F], [NI],

  [T-U-26], [Verificare il mapping del tipo di alert verso descrizione testuale], [R-46-F], [NI],
  [T-U-27], [Verificare il mapping dell’hardware interessato da un alert], [R-47-F], [NI],
  [T-U-28], [Verificare la formattazione del timestamp di emissione alert], [R-48-F], [NI],
  [T-U-29], [Verificare la validazione delle impostazioni di notifica], [R-52-F], [NI],

  [T-U-30], [Verificare la validazione del nome utente tenant], [R-71-F], [NI],
  [T-U-31], [Verificare la validazione dei ruoli assegnabili], [R-73-F], [NI],
  [T-U-32], [Verificare l’assenza di duplicati nella selezione utenti], [R-77-F], [NI],
  [T-U-33], [Verificare la generazione del Client ID], [R-79-F], [NI],
  [T-U-34], [Verificare la generazione del Client Secret], [R-80-F], [NI],

  [T-U-35], [Verificare la costruzione di una entry di audit (campi obbligatori)], [R-90-F], [NI],
  [T-U-36], [Verificare il mapping dell’operazione di audit verso testo], [R-92-F], [NI],
  [T-U-37], [Verificare la validazione di un token JWT (scadenza e formato)], [R-102-F], [NI],
  [T-U-38], [Verificare la validazione dei permessi secondo policy], [R-105-F], [NI],

  [T-U-39], [Verificare il mapping della lista gateway simulati], [R-S-1-F], [NI],
  [T-U-40], [Verificare il mapping del gateway simulato], [R-S-2-F], [NI],
  [T-U-41], [Verificare la validazione della configurazione gateway simulato], [R-S-11-F], [NI],
  [T-U-42], [Verificare il mapping dell’errore di deploy gateway simulato], [R-S-12-F], [NI],
  [T-U-43], [Verificare la validazione della configurazione sensore simulato], [R-S-14-F], [NI],
  [T-U-44], [Verificare il mapping dell’errore range invalido sensore], [R-S-15-F], [NI],
  )

  == Test di Integrazione

  #table(
  columns: (1fr, 3.5fr, 1.2fr, 0.8fr),
  stroke: 0.5pt,
  inset: 6pt,

  table.header(
    [*Codice*],
    [*Descrizione (unitaria)*],
    [*Requisiti di riferimento*],
    [*Stato*],
  ),
  [T-I-1], [Verificare la corretta ricezione e validazione dei pacchetti JSON inviati dal Simulatore al Cloud Ingestion Service], [R-S-1-F, R-S-4-F], [NI],
  [T-I-2], [Verificare il flusso di controllo bidirezionale: invio e corretta applicazione dei comandi di configurazione dal Cloud al Simulatore], [R-S-7-F, R-S-10-F], [NI],
  [T-I-3], [Verificare la gestione del buffer locale del Simulatore e della successiva integrazione con il Cloud dopo un ripristino di rete], [R-S-8-F], [NI],
  [T-I-4], [Verificare la persistenza dei dati nel database (MongoDB) e dell'isolamento dei dati per ciascun Tenant], [R-S-17-F, R-S-22-F], [NI],
  [T-I-5], [Verificare la comunicazione tra il servizio di Ingestion e il sistema di Streaming (NATS) per la distribuzione dei dati], [R-S-21-F], [NI],
  [T-I-6], [Verificare l'attivazione dei trigger di allerta tra il modulo di analisi dati e il servizio notifiche al superamento delle soglie], [R-S-19-F, R-S-20-F], [NI],
  [T-I-7], [Verificare l'integrazione del sistema di autenticazione (JWT) tra l'API Gateway e i microservizi interni], [R-S-23-F, R-S-24-F], [NI],
  [T-I-8], [Verificare la gestione degli errori di configurazione del Gateway simulato in caso di payload invalido o frequenza fuori range], [R-S-23-F, R-S-24-F], [NI],
  [T-I-9], [Verificare la propagazione e gestione di misure anomale (outlier) dal Simulatore al Cloud], [R-S-21-F], [NI],
  [T-I-10], [Verificare l’integrazione del sistema con più Gateway simulati attivi in parallelo], [R-S-17-F], [NI],
  [T-I-11], [Verificare la corretta trasmissione del flusso di dati tra sensore e relativo gateway], [R-Q-2], [NI],
  [T-I-12], [Verificare che i dati scambiati tra le diverse componenti del sistema distribuito siano cifrati e trasmessi tramite protocollo TLS.], [R-1-S], [NI],
  [T-I-13], [Verificare l’isolamento dei dati tra Tenant tramite API e persistenza su database], [R-2-S], [NI],
  

  )

  == Test di Sistema

  #table(
  columns: (1fr, 3.3fr, 1.4fr, 0.7fr),
  stroke: 0.5pt,
  inset: 6pt,

  table.header(
    [*Codice*],
    [*Descrizione (unitaria)*],
    [*Requisiti di riferimento*],
    [*Stato*],
  ),
  //Autenticazione e Autorizzazione
  [T-S-001], [Verificare che un utente non autenticato possa accedere al sistema inserendo credenziali valide tramite interfaccia UI], [R-1-F, R-2-F, R-3-F], [NI],
  [T-S-002], [Verificare che il sistema neghi l’accesso e mostri un messaggio di errore in caso di credenziali errate], [R-4-F], [NI],
  [T-S-003], [Verificare che un utente possa configurare correttamente il meccanismo 2FA durante il primo accesso], [R-5-F], [NI],
  [T-S-004], [Verificare che un utente possa effettuare il login tramite codice OTP valido], [R-6-F, R-7-F], [NI],
  [T-S-005], [Verificare che il sistema notifichi un errore in caso di inserimento di codice OTP errato], [R-8-F], [NI],
  [T-S-006], [Verificare che tutti gli endpoint UI e API rifiutino richieste provenienti da utenti non autenticati], [R-6-S], [NI],

  //Recupero Credenziali
  [T-S-007], [Verificare che un utente non autenticato possa avviare la procedura di recupero password inserendo una mail valida], [R-9-F], [NI],
  [T-S-008], [Verificare che il sistema permetta la modifica della password tramite procedura di recupero], [R-10-F, R-12-F], [NI],
  [T-S-009], [Verificare che il sistema notifichi un errore in caso di email non associata ad alcun account], [R-11-F], [NI],
  [T-S-010], [Verificare che il sistema notifichi un errore in caso di password inserite non corrispondenti o non valide], [R-13-F, R-14-F], [NI],

  //Gateway e Sensori
  [T-S-011], [Verificare che un utente autenticato possa visualizzare la lista dei Gateway associati al proprio Tenant], [R-21-F], [NI],
  [T-S-012], [Verificare che il sistema mostri correttamente i dettagli di un Gateway selezionato], [R-22-F, R-23-F, R-24-F, R-25-F], [NI],
  [T-S-013], [Verificare che il sistema mostri la lista dei sensori associati a un Gateway], [R-26-F, R-27-F], [NI],
  [T-S-014], [Verificare che il sistema mostri correttamente i dettagli e l’ultimo timestamp di ciascun sensore], [R-28-F, R-29-F, R-30-F], [NI],

  //Dati, Filtri e Esportazione
  [T-S-015], [Verificare che il sistema visualizzi i dati di stream in formato tabellare], [R-31-F, R-32-F], [NI],
  [T-S-016], [Verificare che il sistema visualizzi i dati di stream in formato grafico], [R-33-F], [NI],
  [T-S-017], [Verificare che l’utente possa filtrare i dati per Gateway, sensore e intervallo temporale], [R-34-F, R-35-F, R-36-F], [NI],
  [T-S-018], [Verificare che il sistema notifichi l’utente quando non sono disponibili dati per i filtri selezionati], [R-37-F], [NI],
  [T-S-019], [Verificare che l’utente possa esportare i dati visualizzati in formato supportato], [R-38-F], [NI],

  //Alert e Notifiche
  [T-S-020], [Verificare che il sistema generi un alert in caso di Gateway non raggiungibile], [R-39-F], [NI],
  [T-S-021], [Verificare che il sistema generi un alert in caso di valore sensore fuori range], [R-40-F, R-41-F, R-42-F, R-43-F], [NI],
  [T-S-022], [Verificare che l’utente possa visualizzare lo storico degli alert generati], [R-44-F, R-45-F], [NI],
  [T-S-023], [Verificare che il sistema mostri i dettagli completi di un alert selezionato], [R-46-F, R-47-F, R-48-F], [NI],
  [T-S-024], [Verificare che l’utente possa configurare le notifiche di alert via email e dashboard], [R-52-F, R-53-F], [NI],

  //Configurazione Gateway
  [T-S-025], [Verificare che l’utente possa modificare il nome di un Gateway e ricevere errore in caso di duplicato], [R-54-F, R-55-F], [NI],
  [T-S-026], [Verificare che l’utente possa modificare lo stato operativo di un Gateway], [R-56-F, R-57-F], [NI],
  [T-S-027], [Verificare che l’utente possa modificare i range di allarme di un sensore specifico], [R-58-F, R-59-F], [NI],

  //Utenti e Tenant
  [T-S-028], [Verificare che il Tenant Admin possa creare, modificare ed eliminare utenti del Tenant], [R-50-F, R-51-F, R-52-F, R-53-F, R-54-F, R-55-F, R-56-F, R-57-F, R-58-F], [NI],
  [T-S-029], [Verificare che l'Amministratore di Sistema possa creare, sospendere, riattivare ed eliminare un Tenant], [R-79-F, R-80-F, R-81-F, R-82-F, R-83-F, R-84-F, R-85-F, R-86-F, R-87-F, R-89-F, R-90-F, R-91-F], [NI],
  [T-S-030], [Verificare che l'Amministratore di Sistema possa impersonificare un utente Tenant e operare con i suoi permessi], [R-92-F], [NI],

  //API, audit e monitoraggio
  [T-S-031], [Verificare che il Tenant Admin possa creare e revocare credenziali API], [R-59-F, R-60-F, R-61-F, R-62-F], [NI],
  [T-S-032], [Verificare che il sistema registri tutte le operazioni rilevanti nei log di Audit], [R-64-F, R-4-S], [NI],
  [T-S-033], [Verificare che un utente autorizzato possa consultare ed esportare i log di Audit], [R-65-F, R-95-F, R-96-F], [NI],
  [T-S-034], [Verificare che il sistema mostri metriche di latenza, traffico e utilizzo storage], [R-97-F, R-97.1-F, R-97.2-F, R-97.3-F], [NI],

  //Provisioning e sicurezza comunicazioni
  [T-S-035], [Verificare che un Gateway non provisioned possa completare correttamente il processo di onboarding], [R-93-F, R-94-F, R-98-F], [NI],
  [T-S-036], [Verificare che il sistema notifichi errori di autenticazione per Gateway non validi], [R-99-F, R-101-F], [NI],
  [T-S-037], [Verificare che il Gateway invii dati al Cloud tramite canale cifrato e che il Cloud li accetti], [R-100-F, R-100.1-F, R-1-S], [NI],

  //Simulatore Gateway
  [T-S-038], [Verificare che l’utente del simulatore possa visualizzare e gestire Gateway simulati], [R-S-1-F, R-S-2-F, R-S-3-F, R-S-4-F], [NI],
  [T-S-039], [Verificare che l’utente possa configurare e simulare sensori associati a un Gateway simulato], [R-S-5-F, R-S-6-F, R-S-7-F, R-S-8-F, R-S-9-F, R-S-10-F, R-S-11-F, R-S-12-F, R-S-13-F, R-S-14-F, R-S-15-F, R-S-16-F], [NI],
  [T-S-040], [Verificare che il simulatore permetta di iniettare anomalie di rete e valori sensore anomali], [R-S-17-F, R-S-18-F, R-S-19-F, R-S-20-F, R-S-21-F], [NI],
  [T-S-041], [Verificare che il Cloud possa inviare configurazioni al Gateway simulato e ricevere notifiche di errore], [R-S-22-F, R-S-23-F, R-S-24-F], [NI],
  )

  = Cruscotto di valutazione
  Di seguito vengono presentate le misurazioni raccolte nel periodo compreso tra l’aggiudicazione del capitolato e la definizione della Requirements and Technology Baseline (RTB).
  EVENTUALI ALTRE CONSIDERAZIONI DERIVATE DALLE MISURAZIONI POTRANNO ESSERE RICAVATE SOLO NEL MOMENTO IN CUI VERRANNO EFFETTUATE LE MISURAZIONI IMMEDIATAMENTE PRIMA DELLA REVISIONE RTB

  == Burndown / Burnup Chart
  IMMAGINE DA METTERE PRIMA DELLA RTB

  Il grafico Burndown/Burnup mostra l’andamento delle ore di lavoro completate rispetto alla pianificazione ideale nel periodo compreso in analisi. La linea di riferimento ideale rappresenta l’avanzamento atteso del lavoro in modo lineare, mentre la curva delle ore effettivamente completate evidenzia l’andamento reale del progetto.

  Dall’osservazione del grafico si nota che il lavoro effettivamente completato cresce nel tempo, ma con un andamento non perfettamente allineato alla pianificazione ideale. In particolare, sono presenti periodi di crescita ridotta alternati a incrementi più marcati, indice di una distribuzione del lavoro non uniforme tra le varie iterazioni. La distanza tra la curva reale e quella ideale indica un avanzamento inferiore rispetto a quanto pianificato, suggerendo un rallentamento temporaneo nello sviluppo.

  == Velocity Chart
  IMMAGINE DA METTERE PRIMA DELLA RTB
  Il grafico di Velocity rappresenta il numero di ore di lavoro completate in ciascun intervallo temporale, mettendolo a confronto con la velocità media calcolata sulle iterazioni precedenti. Le barre mostrano il lavoro effettivamente completato in ogni sprint, mentre la linea di velocità media fornisce un’indicazione del ritmo di sviluppo complessivo del team.

  == Altre misurazioni da aggiungere !

  = Valutazioni per l'automiglioramento 
  Al fine di perseguire un miglioramento continuo durante lo svolgimento del progetto, è opportuno effettuare valutazioni periodiche. Tali valutazioni hanno l’obiettivo di individuare le criticità emerse e le relative soluzioni adottate per affrontarle, consentendo al gruppo di acquisire una maggiore consapevolezza e di ridurre il rischio di ripetere gli stessi errori in futuro. Le analisi effettuate si basano sulle tre categorie di rischio definite nel _Piano di Progetto_ v1.0.0, ovvero:
  - Rischi connessi alle tecnologie adottate (*RT1*);
  - Rischi connessi all'organizzazione del team (*RO1*);
  - Rischi connessi ai singoli componenti del gruppo (*RP1*).

  == Valutazione sulle tecnologie adottate



  == Valutazione sull'organizzazione del team



  == Validazione sui singoli componenti del gruppo

]

