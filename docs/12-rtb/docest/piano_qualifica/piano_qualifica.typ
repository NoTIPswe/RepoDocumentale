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
  acceplable,
  optimal,
  note: none,
) = {
  block(
    breakable: false,
    [
      #v(0.5em)
      #heading(level: 4, numbering: none, outlined: false)[#cod - #name]
      #v(0.5em)

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
    caption: [Soglie metriche processo di Documentazione],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

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
    ),
    caption: [Soglie metriche processo di Verifica],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

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

  === Gestione della Configurazione

  #metrics-table(
    (
      (cod: [*MP18*], name: [Commit Message Quality Score], acceptable: [7/10], optimal: [9/10]),
    ),
    caption: [Soglie metriche processo di Gestione della Configurazione],
  )
  #metrics-description(
    [MP18],
    [Commit Message Quality Score],
    [Abbiamo optato per un valore accettabile 7/10, perché la qualità del commit deve essere almeno sopra la sufficienza per garantire chiarezza del messaggio, oltre per permettere in alcuni casi di risalire ad errori introdotti con recenti commit.],
    [Un punteggio ≥ 9/10 è ottimale, indicando commit messages esemplari che documentano completamente sia il "cosa" che il "perché" delle modifiche. Questo facilita enormemente debugging futuro, code review, e onboarding di nuovi sviluppatori.],
    note: [Template di commit messages e linee guida chiare nelle Norme di Progetto sono essenziali per raggiungere punteggi alti.],
  )

  === Gestione della Qualità

  #metrics-table(
    (
      (cod: [*MP19*], name: [Quality Metrics Satisfied], acceptable: [≥ 80%], optimal: [≥ 100%]),
      (cod: [*MP20*], name: [Quality Gate Pass Rate], acceptable: [≥ 85%], optimal: [≥ 95%]),
    ),
    caption: [Soglie metriche Gestione della Qualità],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MP19],
    [Quality Metrics Satisfied],
    [Un valore ≥ 80% di metriche soddisfatte rappresenta un buon livello qualitativo generale, permettendo un margine del 20% per metriche particolarmente difficili da soddisfare completamente. Sotto questa soglia il progetto ha problemi di qualità.],
    [Avere soddisfazione del 100% significa che tutte le metriche definite sono soddisfatte. Questo livello dimostra eccellenza complessiva nella gestione della qualità.],
    note: [Questa metrica dovrebbe essere calcolata pesando correttamente le varie metriche, dove quelle critiche dovrebbero avere peso maggiore di metriche meno critiche.],
  )

  #metrics-description(
    [MP20],
    [Quality Gate Pass Rate],
    [Indica che la maggior parte del codice proposto rispetta gli standard minimi di sicurezza e manutenibilità. Un 15% di fallimenti è concesso per permettere iterazioni veloci e feedback loop rapidi dalla CI senza imporre un perfezionismo prematuro.],
    [Un tasso ≥ 95% testimonia un'elevata maturità del team nell'eseguire verifiche locali prima del push sul repository. Indica un processo di integrazione fluido, dove la CI fallisce solamente raramente.],
    note: [Il valore va interpretato con attenzione: un pass rate costantemente al 100% potrebbe indicare controlli troppo lassi, mentre un valore troppo basso suggerisce la necessità di rivedere la configurazione dei gate o di migliorare la formazione del team sui test locali.],
  )

  == Processi organizzativi

  === Gestione dei Processi

  #metrics-table(
    (
      (cod: [*MP21*], name: [Time Efficiency], acceptable: [≥ 60%], optimal: [100%]),
      (cod: [*MP22*], name: [Sprint Velocity Stability], acceptable: [≤ 30%], optimal: [≤ 10%]),
      (cod: [*MP23*], name: [Meeting Efficiency Index], acceptable: [≥ 2 dec./ora], optimal: [≥ 5 dec./ora]),
      (
        cod: [*MP24*],
        name: [PR Resolution Time],
        acceptable: [≤ 3gg],
        optimal: [≤ 1gg],
      ),
    ),
    caption: [Soglie metriche Gestione dei Processi],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MP21],
    [Time Efficiency],
    [Il minimo accettabile per garantire un avanzamento accettabile del progetto. Scendere sotto questa soglia indica una dispersione eccessiva di risorse in attività non produttive.],
    [Indica uno scenario di efficienza assoluta in cui sono stati eliminati tutti i tempi morti, le riunioni superflue e le attività a non-valore aggiunto.],
    note: [Per calcolare la metrica, è necessario distinguere nel tracciamento le ore "produttive" da quelle "organizzative/di palestra".],
  )

  #metrics-description(
    [MP22],
    [Sprint Velocity Stability],
    [Una deviazione standard ≤ 30% della media è accettabile, permettendo una certa variabilità naturale tra sprint dovuta alla complessità variabile delle task, impegni dei membri del gruppo o eventi imprevisti.],
    [≤ 10% di deviazione è ottimale, indicando velocity altamente prevedibile. Questo livello si raggiunge con: stime accurate, team stabile, scope ben definito, e impedimenti gestiti efficacemente. Facilita enormemente commitment e pianificazione di release.],
    note: [Variabilità > 20% rende la pianificazione inaffidabile. Dovrebbe però migliorare naturalmente con il passare del tempo, stabilizzandosi su valori tendenti all'ottimo.],
  )

  #metrics-description(
    [MP23],
    [Meeting Efficiency Index],
    [≥ 2 decisioni/ora è accettabile per meeting produttivi. Riconosce che alcune discussioni richiedono tempo per esplorare alternative prima di decidere. Meeting sotto questa soglia tendono ad essere troppo poco produttivi.],
    [≥ 5 decisioni/ora è ottimale, indicando meeting altamente focalizzati con agenda chiara e partecipanti preparati. Questo livello massimizza il valore del tempo speso.],
    note: [Preparazione dell'agenda con decisioni da prendere, condividere materiale pre-lettura e documentare decisioni prese.],
  )

  #metrics-description(
    [MP24],
    [PR Resolution Time],
    [Un tempo di merge ≤ 3 giorni è accettabile. Garantisce che il codice o un documento non rimanga bloccato troppo a lungo, riducendo il rischio di conflitti di merge complessi.],
    [Un tempo ≤ 1 giorno è ottimale. Indica un processo di Code Review estremamente efficiente e una cultura di team che prioritizza il processo di revisione rispetto all'inizio di nuove task, favorendo il Continuous Integration.],
    note: [Un tempo di risoluzione breve garantisce che la correzione o l'aggiunta avvenga mentre la memoria dell'autore è ancora fresca. Inoltre è raccomandata l'apertura di PR più piccole e focalizzate per migliorare l'efficacia e la velocità della verifica],
  )

  #pagebreak()

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

