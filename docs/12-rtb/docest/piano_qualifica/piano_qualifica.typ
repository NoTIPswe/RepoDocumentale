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
  Il presente Piano di Qualifica definisce le strategie, le metodologie e le metriche adottate dal gruppo per garantire la qualità del prodotto software e l'efficienza dei processi del progetto. Esso costituisce il riferimento principale per le attività di:
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
    [Il valore accettabile minimo è zero poiché l'EV rappresenta il valore del lavoro completato. Non può essere negativo per definizione e valori molto bassi rispetto al pianificato indicano ritardi nell'esecuzione, tuttavia non sono invalidanti dal punto di vista metrico.],
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
    caption: [Soglie metriche Sviluppo di processo],
  )

  #heading(level: 4, outlined: false)[Motivazioni delle soglie]

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
    caption: [Soglie metriche Documentazione di processo],
  )

  #heading(level: 4, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MP13],
    [Indice di Gulpease],
    [Un indice ≥ 60 garantisce che la documentazione sia comprensibile per lettori con istruzione media, appropriato per documentazione tecnica rivolta a professionisti del settore. Questo livello bilancia precisione terminologica e chiarezza espositiva.],
    [Un indice ≥ 80 indica documentazione molto accessibile, comprensibile anche per lettori con istruzione base.],
    note: [L'indice di Gulpease non è sempre necessario massimizzarlo, ma va interpretato considerando il tipo di documento in esame: manuali utente dovrebbero cercare di raggiungere valori più alti (≥75), mentre documentazione più tecnica si appresterà ad avere valori più bassi (≥55) data la natura tecnica del contenuto.],
  )

  #metrics-description(
    [MP14],
    [Correttezza Ortografica],
    [Zero errori ortografici è l'unico valore accettabile per documentazione professionale.],
    [Il valore ottimo coincide con l'accettabile: zero errori, in quanto la documentazione formale destinata agli stakeholder deve essere priva errori di battitura o refusi da versioni precedenti, in modo da riflettere la professionalità del gruppo e dei processi dallo stesso impiegati.],
    note: [La presenza di errori indica processi di quality assurance inadeguati che devono essere rafforzati.],
  )

  === Verifica
  #metrics-table(
    (
      (cod: [*MP15*], name: [Code Coverage], acceptable: [≥ 80%], optimal: [≥ 90%]),
      (cod: [*MP16*], name: [Test Success Rate], acceptable: [100%], optimal: [100%]),
      (cod: [*MP17*], name: [Test Automation Percentage], acceptable: [≥70%], optimal: [≥85%]),
      (cod: [*MP18*], name: [Bugs Trend], acceptable: [Costante], optimal: [Decrescente]),
    ),
    caption: [Soglie metriche Verifica di processo],
  )

  #heading(level: 4, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MP15],
    [Code Coverage],
    [In ogni progetto è importante mantenere una percentuale di code coverage alta, ≥ 80% è una convenzione spesso usata, affinchè si possa garantire che il codice scritto sia stato effettivamente testato per la sua maggioranza.],
    [L'ottimo non è stato posto al 100% sia per avere una stima più realistica e sia per evitare che il team sia troppo influenzato a raggiungere il 100% di code coverage, creando così test che non controllano il codice nella maniera corretta.],
    note: [L'obiettivo è avere un code coverage quanto più vicino al 100% nelle sezioni critiche del codice e dell'80% per quanto riguarda il restante codice.],
  )

  #metrics-description(
    [MP16],
    [Test Success Rate],
    [Trattandosi di un sistema che gestisce dati sensibili ci si prefissa di avere una percentuale del 100%, perchè ogni bug potrebbe essere pericoloso in un sistema di questo tipo.],
    [Il valore ottimo coincide con l'accettabile, in quanto non sono tollerati test falliti in branch principali.],
    note: [Qualsiasi test fallito indica regressioni o bug che devono essere risolti immediatamente prima di procedere con ulteriore sviluppo],
  )

  #metrics-description(
    [MP17],
    [Test Automation Percentage],
    [È importante che una parte considerevole dei test da eseguire sul sistema siano automatizzati, così da garantire automaticamente che la parte più importante di tutto il codice sia stata testata in maniera veloce ed efficace.],
    [L'85% è un valore ottimo ragionevole, permettendo esecuzioni frequenti senza costi significativi. Il restante 15% per test di usabilità per l'eventuale interfaccia grafica e per altre verifiche che potrebbero essere necessarie.],
    note: [Il 100% di automazione non è considerato un obiettivo perchè potrebbe anche introdurre dei test instabili o avere una fase di test eccessivamente lunga.],
  )

  #metrics-description(
    [MP18],
    [Bugs Trend],
    [Un trend costante è accettabile durante le fasi centrali di sviluppo. Indica che il team riesce a risolvere i difetti con la stessa velocità con cui ne vengono scoperti di nuovi, mantenendo il debito tecnico sotto controllo.],
    [Un trend decrescente è ottimo, in quanto significa che il numero totale di bug aperti diminuisce progressivamente, indicando che il prodotto sta diventando maggiormente stabile.],
    note: [Metrica introdotta su suggerimento dell'azienda proponente. È necessario indagare le cause dell'andamento di questa metrica durante la retrospettiva e attuare azioni correttive nello sprint successivo.],
  )

  === Gestione della Configurazione

  #metrics-table(
    (
      (cod: [*MP19*], name: [Commit Message Quality Score], acceptable: [7/10], optimal: [9/10]),
    ),
    caption: [Soglie metriche Gestione della Configurazione di processo],
  )
  #metrics-description(
    [MP19],
    [Commit Message Quality Score],
    [Abbiamo optato per un valore accettabile 7/10, perché la qualità del commit deve essere almeno sopra la sufficienza per garantire chiarezza del messaggio, oltre per permettere in alcuni casi di risalire ad errori introdotti con recenti commit.],
    [Un punteggio ≥ 9/10 è ottimale, indicando commit messages esemplari che documentano completamente sia il "cosa" che il "perché" delle modifiche. Questo facilita enormemente debugging futuro, code review, e onboarding di nuovi sviluppatori.],
    note: [Template di commit messages e linee guida chiare nelle Norme di Progetto sono essenziali per raggiungere punteggi alti.],
  )

  === Gestione della Qualità

  #metrics-table(
    (
      (cod: [*MP20*], name: [Quality Metrics Satisfied], acceptable: [≥ 80%], optimal: [≥ 100%]),
      (cod: [*MP21*], name: [Quality Gate Pass Rate], acceptable: [≥ 85%], optimal: [≥ 95%]),
    ),
    caption: [Soglie metriche Gestione della Qualità],
  )

  #heading(level: 4, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MP20],
    [Quality Metrics Satisfied],
    [Un valore ≥ 80% di metriche soddisfatte rappresenta un buon livello qualitativo generale, permettendo un margine del 20% per metriche particolarmente difficili da soddisfare completamente. Sotto questa soglia il progetto ha problemi di qualità.],
    [Avere soddisfazione del 100% significa che tutte le metriche definite sono soddisfatte. Questo livello dimostra eccellenza complessiva nella gestione della qualità.],
    note: [Questa metrica dovrebbe essere calcolata pesando correttamente le varie metriche, dove quelle critiche dovrebbero avere peso maggiore di metriche meno critiche.],
  )

  #metrics-description(
    [MP21],
    [Quality Gate Pass Rate],
    [Indica che la maggior parte del codice proposto rispetta gli standard minimi di sicurezza e manutenibilità. Un 15% di fallimenti è concesso per permettere iterazioni veloci e feedback loop rapidi dalla CI senza imporre un perfezionismo prematuro.],
    [Un tasso ≥ 95% testimonia un'elevata maturità del team nell'eseguire verifiche locali prima del push sul repository. Indica un processo di integrazione fluido, dove la CI fallisce solamente raramente.],
    note: [Il valore va interpretato con attenzione: un pass rate costantemente al 100% potrebbe indicare controlli troppo laschi, mentre un valore troppo basso suggerisce la necessità di rivedere la configurazione dei gate o di migliorare la formazione del team sui test locali.],
  )

  == Processi organizzativi

  === Gestione dei Processi

  #metrics-table(
    (
      (cod: [*MP22*], name: [Time Efficiency], acceptable: [≥ 60%], optimal: [100%]),
      (cod: [*MP23*], name: [Sprint Velocity Stability], acceptable: [≤ 30%], optimal: [≤ 10%]),
      (cod: [*MP24*], name: [Meeting Efficiency Index], acceptable: [≥ 2 dec./ora], optimal: [≥ 5 dec./ora]),
      (
        cod: [*MP25*],
        name: [PR Resolution Time],
        acceptable: [≤ 3gg],
        optimal: [≤ 1gg],
      ),
    ),
    caption: [Soglie metriche Gestione dei Processi],
  )

  #heading(level: 4, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MP22],
    [Time Efficiency],
    [Il minimo accettabile per garantire un avanzamento accettabile del progetto. Scendere sotto questa soglia indica una dispersione eccessiva di risorse in attività non produttive.],
    [Indica uno scenario di efficienza assoluta in cui sono stati eliminati tutti i tempi morti, le riunioni superflue e le attività a non-valore aggiunto.],
    note: [Per calcolare la metrica, è necessario distinguere nel tracciamento le ore "produttive" da quelle "organizzative/di palestra".],
  )

  #metrics-description(
    [MP23],
    [Sprint Velocity Stability],
    [Una deviazione standard ≤ 30% della media è accettabile, permettendo una certa variabilità naturale tra sprint dovuta alla complessità variabile delle task, impegni dei membri del gruppo o eventi imprevisti.],
    [≤ 10% di deviazione è ottimale, indicando velocity altamente prevedibile. Questo livello si raggiunge con: stime accurate, team stabile, scope ben definito, e impedimenti gestiti efficacemente. Facilita enormemente commitment e pianificazione di release.],
    note: [Variabilità > 20% rende la pianificazione inaffidabile. Dovrebbe però migliorare naturalmente con il passare del tempo, stabilizzandosi su valori tendenti all'ottimo.],
  )

  #metrics-description(
    [MP24],
    [Meeting Efficiency Index],
    [≥ 2 decisioni/ora è accettabile per meeting produttivi. Riconosce che alcune discussioni richiedono tempo per esplorare alternative prima di decidere. Meeting sotto questa soglia tendono ad essere troppo poco produttivi.],
    [≥ 5 decisioni/ora è ottimale, indicando meeting altamente focalizzati con agenda chiara e partecipanti preparati. Questo livello massimizza il valore del tempo speso.],
    note: [Preparazione dell'agenda con decisioni da prendere, condividere materiale pre-lettura e documentare decisioni prese.],
  )

  #metrics-description(
    [MP25],
    [PR Resolution Time],
    [Un tempo di merge ≤ 3 giorni è accettabile. Garantisce che il codice o un documento non rimanga bloccato troppo a lungo, riducendo il rischio di conflitti di merge complessi.],
    [Un tempo ≤ 1 giorno è ottimale. Indica un processo di Code Review estremamente efficiente e una cultura di team che prioritizza il processo di revisione rispetto all'inizio di nuove task, favorendo il Continuous Integration.],
    note: [Un tempo di risoluzione breve garantisce che la correzione o l'aggiunta avvenga mentre la memoria dell'autore è ancora fresca. Inoltre è raccomandata l'apertura di PR più piccole e focalizzate per migliorare l'efficacia e la velocità della verifica],
  )

  #pagebreak()

  = Qualità di prodotto

  La qualità del prodotto costituisce il traguardo fondamentale del progetto. Questa la possiamo intendere come la capacità del software rilasciato di rispondere puntualmente alle necessità degli stakeholder e di operare con robustezza in ambiente di produzione. Un livello qualitativo elevato non si raggiunge in maniera casuale, ma è la diretta conseguenza del rigore metodologico applicato ai processi.

  Per garantire una valutazione oggettiva e strutturata, il gruppo ha adottato come framework di riferimento lo standard ISO/IEC 9126. Secondo tale modello, l'eccellenza del software si misura attraverso il soddisfacimento delle seguenti caratteristiche:

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
    ),
    caption: [Soglie metriche Funzionalità del prodotto],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MQ01],
    [Requisiti Obbligatori Soddisfatti],
    [L'unico valore accettabile è 100%. I requisiti obbligatori rappresentano funzionalità contrattualmente vincolanti e essenziali per l'utilizzo base del sistema, richieste esplicitamente dallo stakeholder. Non implementare anche un solo requisito obbligatorio rende il prodotto non conforme e non accettabile dal committente.],
    [Il valore ottimo coincide con l'accettabile.],
    note: [Problemi nell'implementazione di requisiti obbligatori dovranno avere priorità massima e potranno richiedere riallocazione urgente di ore e ruoli.],
  )

  #metrics-description(
    [MQ02],
    [Requisiti Desiderabili Soddisfatti],
    [0% è tecnicamente accettabile poiché questi requisiti non sono essenziali per l'accettazione del prodotto. Tuttavia, anche a seguito degli incontri tenuti con la proponente, l'implementazione di una parte di essi è altamente consigliata e aggiunge valore al prodotto.],
    [100% rappresenta un prodotto completo e ricco di funzionalità che supera le aspettative minime. Questo livello dovrebbe essere perseguito se il progetto ha risorse e tempo sufficienti dopo aver completato tutti i requisiti obbligatori.],
    note: [La prioritizzazione dei requisiti desiderabili dovrebbe basarsi su: feedback del committente, rapporto valore/costo di implementazione e dipendenze con altri requisiti.],
  )

  #metrics-description(
    [MQ03],
    [Requisiti Opzionali Soddisfatti],
    [0% risulta essere accettabile, in quanto i requisiti opzionali rappresentano dei "nice-to-have" da considerare solamente dopo aver completato obbligatori e desiderabili. Non implementarli non rende il prodotto incompleto rispetto alle richieste.],
    [100% rappresenta un prodotto estremamente completo, ma questo livello difficilmente raggiungibile senza un notevole sforzo economicamente.],
    note: [La loro implementazione non dovrebbe mai sottrarre risorse a requisiti di priorità superiore durante lo sviluppo della versione corrente.],
  )

  == Affidabilità

  #metrics-table(
    (
      (cod: [*MQ04*], name: [Branch Coverage], acceptable: [≥ 60%], optimal: [≥ 80%]),
      (cod: [*MQ05*], name: [Statement Coverage], acceptable: [≥ 70%], optimal: [≥ 90%]),
      (cod: [*MQ06*], name: [Failure Density], acceptable: [≤ 0.5], optimal: [≤ 0.1]),
    ),
    caption: [Soglie metriche Affidabilità del prodotto],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MQ04],
    [Branch Coverage],
    [≥ 60% è accettabile in quanto testare tutti i branch possibili risulta complesso. Questo livello garantisce che un livello sufficiente delle decisioni logiche sia verificata.],
    [Un valore ≥ 80% è ottimale e rappresenta un'eccellente copertura, riducendo drasticamente i bug di logica condizionale e migliora la confidenza nel comportamento del codice in tutte le circostanze.],
    note: [Focus particolare dovrebbe essere dato a: business logic critica, gestione errori, e validazione input.],
  )

  #metrics-description(
    [MQ05],
    [Statement Coverage],
    [Un valore ≥ 70% garantisce che la maggioranza delle istruzioni sia stata eseguita almeno una volta durante i test, riducendo il rischio di bug nascosti in codice non verificato.],
    [≥ 90% è ottimale e dimostra una test suite molto completa. Il 10% non coperto può giustificarsi per: codice di gestione errori estremi, codice legacy non critico, o sezioni in attesa di rimozione.],
    note: [Deve essere affiancata da branch coverage e test di qualità che verifichino comportamenti attesi, non solo l'esecuzione di linee.],
  )

  #metrics-description(
    [MQ06],
    [Failure Density],
    [Un valore ≤ 0.5 failure/KLOC è accettabile per software in fase di stabilizzazione. Corrisponde mediamente a 1 bug ogni 2000 linee di codice.],
    [≤ 0.1 failure/KLOC è ottimale e rappresenta software di altissima qualità, tipico di software a seguito di estensive sessioni di testing e bug-fixing.],
    note: [È cruciale distinguere failure per severity: un bug critico (crash, data loss) ha impatto molto maggiore di uno cosmetico (typo in UI).],
  )

  == Usabilità
  #metrics-table(
    (
      (cod: [*MQ07*], name: [Time on Task], acceptable: [≤ 60 sec], optimal: [≤ 30 sec]),
      (cod: [*MQ08*], name: [Error Rate], acceptable: [≤ 5%], optimal: [≤ 2%]),
    ),
    caption: [Soglie metriche Usabilità del prodotto],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MQ07],
    [Time on Task],
    [Dal momento in cui l'utente impiega un tempo ≤ 60 secondi per eseguire task standard, viene considerato accettabile. Oltre questo tempo, l'utente può percepire il sistema come lento o inefficiente. ],
    [≤ 30 secondi è ottimale e indica un'interfaccia altamente efficiente e intuitiva.],
    note: [Misurare con utenti reali o rappresentativi del target. Definire task specifici e misurabili (es. "creare un nuovo gateway e associare 3 sensori"). Task complesse possono giustificare tempi maggiori. Questa metrica diventa rilevante solo quando l'interfaccia è sufficientemente sviluppata.],
  )

  #metrics-description(
    [MQ08],
    [Error Rate],
    [≤ 5% è accettabile, riconoscendo che alcuni errori utente sono inevitabili. Questo margine tollera una certa curva di apprendimento e situazioni ambigue nell'interfaccia.],
    [≤ 2% è ottimale e indica un'interfaccia estremamente intuitiva dove gli errori sono rari. Si raggiunge con: design patterns consolidati, validazione input efficace, feedback chiari e prevenzione degli errori.],
    note: [Errori frequenti in task specifici indicano problemi di design localizzati. È quindi utile andare ad analizzare quali task generano più errori e perché.],
  )

  == Efficienza

  #metrics-table(
    (
      (cod: [*MQ09*], name: [Response Time], acceptable: [≤ 2 sec], optimal: [≤ 1 sec]),
    ),
    caption: [Soglie metriche Efficienza del prodotto],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MQ09],
    [Response Time],
    [≤ 2 secondi è il limite accettabile secondo standard di usabilità (Nielsen). Oltre questo tempo, l'utente percepisce attesa significativa.],
    [Un valore ≤ 1 secondo è ottimale e fornisce un'esperienza fluida senza attese percepite. Mantiene il flusso di lavoro dell'utente ininterrotto.],
    note: [Operazioni complesse possono giustificare tempi > 2s. Potrebbe aiutare aggiungere degli indicatori di progresso, per dare un feedback diretto all'utilizzatore.],
  )

  == Manutenibilità

  #metrics-table(
    (
      (cod: [*MQ10*], name: [Code Smells], acceptable: [≤ 10], optimal: [≤ 5]),
      (cod: [*MQ11*], name: [Coefficient of Coupling], acceptable: [≤ 0.4], optimal: [≤ 0.2]),
      (cod: [*MQ12*], name: [Cyclomatic Complexity], acceptable: [≤ 20], optimal: [≤ 10]),
      (cod: [*MQ13*], name: [Code Duplication Percentage], acceptable: [≤ 5%], optimal: [≤ 3%]),
    ),
    caption: [Soglie metriche Manutenibilità del prodotto],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MQ10],
    [Code Smells],
    [≤ 10 code smell/KLOC consente la presenza di alcuni problemi di design non critici, senza compromettere significativamente la manutenibilità complessiva.],
    [≤ 5 code smell/KLOC indica codice ben strutturato e facilmente manutenibile; richiede revisione costante e refactoring Mirato per mantenere livelli elevati di qualità.],
    note: [Strumenti come SonarQube individuano automaticamente code smell. Prioritizzare la correzione nelle aree critiche o soggette a frequenti modifiche. Gli smell temporanei devono essere documentati e risolti nei successivamente.],
  )

  #metrics-description(
    [MQ11],
    [Coefficient of Coupling],
    [≤ 0.4 indica accoppiamento moderato e gestibile. Permette interdipendenze necessarie per funzionalità del sistema mantenendo architettura sufficientemente modulare per modifiche localizzate senza effetti a cascata eccessivi.],
    [Un valore ≤ 0.2 rappresenta sistema disaccoppiato, coeso internamente e con poche dipendenze esterne. Ideale per manutenibilità, in quanto modifiche a un componente hanno impatto minimo su altri.],
    note: [Accoppiamento alto rende il sistema fragile. ],
  )

  #metrics-description(
    [MQ12],
    [Cyclomatic Complexity],
    [≤ 20 per metodo/funzione indica codice complesso ma ancora comprensibile e testabile. Oltre questa soglia, codice diventa difficile da capire e richiede numero eccessivo di test per coprire tutti i percorsi logici.],
    [≤ 10 indica codice semplice, lineare, facile da leggere, testare e manutenere. Questo dovrebbe essere l'obiettivo per la maggior parte delle funzioni. Metodi più complessi dovrebbero essere refactored in funzioni più piccole e coese.],
    note: [Complessità > 20 richiede refactoring urgente: estrarre metodi, usare polimorfismo invece di condizionali (Strategy/State patterns), semplificare logica booleana. La complessità correla fortemente con probabilità di bug e effort di manutenzione.],
  )

  #metrics-description(
    [MQ13],
    [Code Duplication Percentage],
    [≤ 5% è accettabile, riconoscendo che piccole duplicazioni possono essere tollerabili se ben giustificate (es. performance critiche, isolamento di contesti). Duplicazioni limitate non compromettono gravemente la manutenibilità.],
    [≤ 3% è ottimale e indica codice ben fattorizzato seguendo principio DRY. Questo livello minimizza effort di manutenzione e rischio di inconsistenze quando si correggono bug in codice duplicato.],
    note: [Tool come SonarQube rilevano duplicazioni automaticamente. Soluzione: estrarre codice comune in funzioni riutilizzabili, usare Template Method o Strategy pattern per gestire variazioni. Duplicazioni legittime (es. test fixtures) dovrebbero essere escluse dal calcolo.],
  )

  == Portabilità

  #metrics-table(
    (
      (cod: [*MQ14*], name: [Container Image Size], acceptable: [≤ 500 MB], optimal: [≤ 200 MB]),
    ),
    caption: [Soglie metriche Portabilità del prodotto],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MQ14],
    [Container Image Size],
    [Un valore ≤ 500 MB è accettabile, permettendo l'inclusione di runtime e librerie necessarie ma mantenendo deployment relativamente rapidi e storage gestibili.],
    [≤ 200 MB è ottimale e tipicamente raggiungibile con base images leggere, garantendo deployment veloci e cold start rapidi in ambiente cloud.],
  )

  == Sicurezza

  #metrics-table(
    (
      (cod: [*MQ15*], name: [Authentication Success Rate], acceptable: [≥ 98%], optimal: [≥ 99.5%]),
      (cod: [*MQ16*], name: [Encryption Coverage], acceptable: [100%], optimal: [100%]),
    ),
    caption: [Soglie metriche Sicurezza del prodotto],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MQ15],
    [Authentication Success Rate],
    [≥ 98% è accettabile per il sistema di provisioning gateway, considerando che 2% di failure può derivare da errori utente legittimi. Success rate inferiore può indicare problemi nel meccanismo di autenticazione.],
    [≥ 99.5% è ottimale e indica sistema robusto e affidabile dove quasi tutti i tentativi legittimi hanno successo. Failure residui coprono edge case.],
    note: [Fondamentale distinguere tra failure legittimi (credenziali errate) e tecnici (servizio down, timeout).],
  )

  #metrics-description(
    [MQ16],
    [Encryption Coverage],
    [Tutti i dati sensibili devono essere crittografati sia in storage che durante le comunicazioni, quindi 100% è l'unico valore accettabile.],
    [Il valore ottimo coincide con l'accettabile. Trattando potenziali dati sensibili, la mancata crittografia espone a rischi non solo legali ma anche di reputazione.],
  )

  #pagebreak()

  = Metodi di testing
  // Da completare successivamente

  = Cruscotto di valutazione
  // Da completare successivamente

]
