#import "../../00-templates/base_document.typ" as base-document
#import "test_lib.typ": *

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

  == Glossario
  Al fine di garantire un linguaggio univoco e prevenire possibili ambiguità, i termini tecnici, gli acronimi e i
  vocaboli con accezione specifica nel contesto del progetto sono stati definiti puntualmente nel documento #link(
    "https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/glossario.pdf",
  )[Glossario v3.0.0]. Si invita il lettore a fare riferimento a tale documento per chiarire qualsiasi dubbio. Le parole
  che possiedono un riferimento nel Glossario saranno indicate nel modo che segue:
  #align(center)[#emph([parola#sub[G]])]

  == Riferimenti
  === Riferimenti normativi

  - #link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docint/norme_progetto.pdf")[Norme di Progetto v2.0.0]
  - #link(
      "https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf",
    )[Capitolato d'appalto C7 - Sistema di acquisizione dati da sensori] \ _Ultimo accesso: 2026-03-09_

  === Riferimenti informativi

  - #link("https://www.math.unipd.it/~tullio/IS-1/2009/Approfondimenti/ISO_12207-1995.pdf")[Standard ISO/IEC 12207:1995]
    \ _Ultimo accesso: 2026-03-09_
  - #link("https://it.wikipedia.org/wiki/ISO/IEC_9126")[Standard ISO/IEC 9126] \ _Ultimo accesso: 2026-03-17_
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/T07.pdf")[T07 - Qualità di prodotto] \ _Ultimo accesso:
    2026-03-26_
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/T08.pdf")[T08 - Qualità di processo] \ _Ultimo accesso:
    2026-03-28_
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/T09.pdf")[T09 - Verifica e Validazione] \ _Ultimo
    accesso: 2026-04-03_
  - #link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/glossario.pdf")[Glossario v3.0.0]

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
    [Il valore accettabile minimo è zero poiché l’EV rappresenta il valore del lavoro completato. Non può essere
      negativo per definizione e valori molto bassi rispetto al pianificato indicano ritardi nell'esecuzione, tuttavia
      non sono invalidanti dal punto di vista metrico.],
    [Il valore ottimo corrisponde esattamente al Planned Value (EV = PV), indicando che il lavoro completato coincide o
      eccede addirittura quello pianificato. Questo significa che il progetto procede esattamente nei tempi previsti,
      senza ritardi.],
    note: [L’EV deve essere calcolato a intervalli regolari (es. fine sprint) per tracciare l'andamento del progetto.
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
    note: [Non è sempre necessario massimizzare tale indice, ma va interpretato considerando il tipo di documento in
      esame: manuali utente dovrebbero cercare di raggiungere valori più alti (≥75), mentre documentazione tecnica
      tenderà ad avere valori più bassi (≥55) data la natura tecnica del contenuto.],
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

  === Gestione della configurazione

  #metrics-table(
    (
      (cod: [*MP17*], name: [Commit Message Quality Score], acceptable: [7/10], optimal: [9/10]),
    ),
    caption: [Soglie metriche Gestione della configurazione di processo],
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

  === Gestione della qualità

  #metrics-table(
    (
      (cod: [*MP18*], name: [Quality Metrics Satisfied], acceptable: [≥ 80%], optimal: [≥ 100%]),
      (cod: [*MP19*], name: [Quality Gate Pass Rate], acceptable: [≥ 85%], optimal: [≥ 95%]),
    ),
    caption: [Soglie metriche Gestione della qualità],
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

  === Gestione dei processi

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
    [≥ 60% è accettabile in quanto testare tutti i branch possibili risulta complesso. Questo livello garantisce che un
      livello sufficiente delle decisioni logiche sia verificata.],
    [Un valore ≥ 80% è ottimale e rappresenta un'eccellente copertura, riducendo drasticamente i bug di logica
      condizionale e migliora la confidenza nel comportamento del codice in tutte le circostanze.],
    note: [Focus particolare dovrebbe essere dato a: business logic critica, gestione errori, e validazione input.],
  )

  #metrics-description(
    [MQ05],
    [Statement Coverage],
    [Un valore ≥ 70% garantisce che la maggioranza delle istruzioni sia stata eseguita almeno una volta durante i test,
      riducendo il rischio di bug nascosti in codice non verificato.],
    [≥ 90% è ottimale e dimostra una test suite molto completa. Il 10% non coperto può giustificarsi per: codice di
      gestione errori estremi, codice legacy non critico, o sezioni in attesa di rimozione.],
    note: [Deve essere affiancata da branch coverage e test di qualità che verifichino comportamenti attesi, non solo
      l'esecuzione di linee.],
  )

  #metrics-description(
    [MQ06],
    [Failure Density],
    [Un valore ≤ 0.5 failure/KLOC è accettabile per software in fase di stabilizzazione. Corrisponde mediamente a 1 bug
      ogni 2000 linee di codice.],
    [≤ 0.1 failure/KLOC è ottimale e rappresenta software di altissima qualità, tipico di software a seguito di
      estensive sessioni di testing e bug-fixing.],
    note: [È cruciale distinguere failure per severity: un bug critico (crash, data loss) ha impatto molto maggiore di
      uno cosmetico (typo in UI).],
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
    [Dal momento in cui l'utente impiega un tempo ≤ 60 secondi per eseguire task standard, viene considerato
      accettabile. Oltre questo tempo, l'utente può percepire il sistema come lento o inefficiente.
    ],
    [≤ 30 secondi è ottimale e indica un'interfaccia altamente efficiente e intuitiva.],
    note: [Misurare con utenti reali o rappresentativi del target. Definire task specifici e misurabili (es. "creare un
      nuovo gateway e associare 3 sensori"). Task complesse possono giustificare tempi maggiori. Questa metrica diventa
      rilevante solo quando l'interfaccia è sufficientemente sviluppata.],
  )

  #metrics-description(
    [MQ08],
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
      (cod: [*MQ09*], name: [Response Time], acceptable: [≤ 2 sec], optimal: [≤ 1 sec]),
    ),
    caption: [Soglie metriche Efficienza del prodotto],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MQ09],
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
      (cod: [*MQ10*], name: [Code Smells], acceptable: [≤ 10], optimal: [≤ 5]),
      (cod: [*MQ11*], name: [Cyclomatic Complexity], acceptable: [≤ 10], optimal: [≤ 5]),
      (cod: [*MQ12*], name: [Code Duplication Percentage], acceptable: [≤ 5%], optimal: [≤ 3%]),
    ),
    caption: [Soglie metriche Manutenibilità del prodotto],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MQ10],
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
    [MQ11],
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
    [MQ12],
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
      (cod: [*MQ13*], name: [Container Image Size], acceptable: [≤ 500 MB], optimal: [≤ 200 MB]),
    ),
    caption: [Soglie metriche Portabilità del prodotto],
  )

  #heading(level: 4, numbering: none, outlined: false)[Motivazioni delle soglie]

  #metrics-description(
    [MQ13],
    [Container Image Size],
    [Un valore ≤ 500 MB è accettabile, permettendo l'inclusione di runtime e librerie necessarie ma mantenendo
      deployment relativamente rapidi e storage gestibili.],
    [≤ 200 MB è ottimale e tipicamente raggiungibile con base images leggere, garantendo deployment veloci e cold start
      rapidi in ambiente cloud.],
  )

  #pagebreak()

  = Metodi di testing
  I seguenti metodi di testing verranno adottati per garantire la qualità minima del prodotto:
  - *Unit Testing*: test automatici per singole unità di codice, garantendo correttezza funzionale isolata.
  - *Integration Testing*: verifica delle interazioni tra unità, assicurando che collaborino correttamente.
  - *System Testing*: test end-to-end del Sistema completo in ambiente simulato.

  #include "generated/_yaml_test_index.typ"
  #include "generated/_yaml_traceability.typ"

  = Cruscotto di valutazione
  Di seguito vengono presentate le misurazioni raccolte nel periodo compreso tra l’aggiudicazione del capitolato e la
  definizione della Requirements and Technology Baseline (RTB).

  In ottica di Continuous Integration e nel rispetto delle Norme di Progetto, il tracciamento manuale delle metriche di
  processo riguardanti lo sviluppo tramite screenshot è stato sostituito dall’automazione. Si dichiara ufficialmente che
  la dashboard pubblica di SonarQube (#link("https://sonarcloud.io/organizations/notipswe/projects"), ultimo accesso
  2026-04-13) costituisce la Single Source of Truth (SSoT) per tutte le metriche di qualità riguardanti lo sviluppo del
  codice sorgente. Il rispetto di tali metriche è garantito dai Quality Gate bloccanti impostati sulle pipeline di
  CI/CD, che impediscono il merge di codice non conforme. Nelle sezioni seguenti sono riportati i valori di Baseline
  registrati al momento del rilascio di questo documento. Per la consultazione di SonarQube, si rimanda alla
  documentazione ufficiale (#link("https://docs.sonarsource.com/sonarqube-cloud"), ultimo accesso 2026-04-13).

  == MP01 e MP02: Earned Value e Planned Value

  #figure(
    image(height: 30%, "assets/EV.png"),
    caption: [Grafico per Sprint di MP01 e MP02],
  ) <MP01_MP02>

  === RTB

  Dal grafico non emergono scostamenti rilevanti tra andamento pianificato e andamento reale. Sia l’Earned Value (EV)
  sia la Planned Value (PV) mostrano un incremento progressivo lungo i sei sprint considerati. La quasi sovrapposizione
  delle due curve indica che il valore effettivamente maturato segue con buona precisione quanto previsto in fase di
  pianificazione. Gli scostamenti risultano minimi e non evidenziano ritardi o anticipi significativi rispetto al piano
  iniziale.

  === PB

  Nel periodo compreso tra gli sprint 8 e 12, l’andamento complessivo evidenzia una buona coerenza tra Earned Value (EV)
  e Planned Value (PV). Nei primi sprint considerati si registra un lieve scostamento, con l’EV leggermente inferiore al
  PV; tuttavia, a partire dallo sprint 10 le due curve tendono progressivamente a convergere. Nel dodicesimo sprint i
  valori coincidono, attestando un allineamento completo tra il valore pianificato e quello effettivamente maturato.


  == MP03 e MP07: Actual Cost e Estimate To Complete

  #figure(
    image(height: 30%, "assets/ETC.png"),
    caption: [Grafico per Sprint di MP03 e MP07],
  ) <MP03_MP07>

  === RTB

  Dal grafico non emergono particolari criticità nell’andamento dei costi. L’Actual Cost (AC) cresce progressivamente
  lungo i sei sprint, mostrando un incremento regolare e coerente con l’avanzamento delle attività. Questo andamento è
  spiegato dal naturale sviluppo del progetto: man mano che il lavoro viene completato, i costi effettivi aumentano.
  Parallelamente, l’Estimate To Complete (ETC) diminuisce in modo costante, indicando una progressiva riduzione del
  lavoro ancora da svolgere.

  === PB

  Nel periodo compreso tra gli sprint 8 e 12, l’Actual Cost (AC) registra una crescita graduale, mentre l’Estimate To
  Complete (ETC) prosegue la propria riduzione. L’andamento delle due curve si mantiene regolare anche nella fase
  conclusiva: l’AC cresce con incrementi contenuti fino allo sprint 12, mentre l’ETC si riduce progressivamente fino a
  raggiungere il valore minimo del periodo considerato. Il grafico evidenzia pertanto il progressivo completamento delle
  attività pianificate e la contestuale riduzione del lavoro residuo.


  == MP04 e MP05: Cost Performance Index e Schedule Performance Index


  #figure(
    image(height: 30%, "assets/CPI.png"),
    caption: [Grafico per Sprint di MP04 e MP05],
  ) <MP04_MP05>

  === RTB

  Dal grafico si osserva che nei primi sprint il Cost Performance Index (CPI) risulta superiore a 1 (indicando un
  utilizzo efficiente del budget) e lo Schedule Performance Index (SPI) è in linea con la pianificazione. Tuttavia, in
  seguito il diagramma mostra una lieve flessione; evidenzia infatti che nelle fasi conclusive del periodo analizzato,
  le attività hanno richiesto un impegno leggermente maggiore rispetto a quanto previsto. Nonostante questa diminuzione,
  la situazione rimane complessivamente sotto controllo: gli scostamenti sono contenuti e non evidenziano criticità
  rilevanti.

  === PB

  Nel periodo compreso tra gli sprint 8 e 12, lo Schedule Performance Index (SPI) si mantiene costantemente prossimo a
  1, confermando una buona aderenza alla pianificazione temporale. Nello stesso intervallo, il Cost Performance Index
  (CPI), dopo aver raggiunto il valore minimo attorno allo sprint 8, corrispondente a una fase di elevato carico di
  impegni esterni al progetto, mostra una progressiva risalita. Pur rimanendo leggermente inferiore a 1 tra gli sprint 8
  e 11, nel dodicesimo sprint il CPI torna ad allinearsi allo SPI, raggiungendo anch'esso il valore unitario.


  == MP06: Estimate At Completion

  #figure(
    image(height: 30%, "assets/EAC.png"),
    caption: [Grafico per Sprint di MP06],
  ) <MP06>

  === RTB

  Dal grafico si osserva che l’Estimate At Completion (EAC) tende progressivamente ad aumentare dallo Sprint 2 in poi,
  arrivando a superare il Budget At Completion (BAC) nella parte centrale e finale del periodo considerato. Tale
  incremento è riconducibile a una temporanea riduzione della produttività del gruppo, dovuta alla concomitanza con il
  periodo degli esami universitari. Il rallentamento delle attività ha comportato un maggiore impiego di risorse
  rispetto a quanto inizialmente pianificato, incidendo così sulla stima finale dei costi. Tuttavia, nell’ultimo sprint
  l’andamento dell’EAC mostra un’attenuazione della crescita e una tendenza alla stabilizzazione. Questo rappresenta un
  segnale positivo, in quanto indica una maggiore attenzione nella gestione delle risorse e un impegno concreto da parte
  del gruppo nel contenimento dei costi.

  === PB

  Nel periodo compreso tra gli sprint 8 e 12, l’Estimate At Completion (EAC) evidenzia una chiara tendenza decrescente.
  A partire dal valore massimo registrato attorno allo sprint 8, la curva scende progressivamente negli sprint
  successivi, convergendo verso la linea del Budget At Completion (BAC). Nel dodicesimo sprint l’EAC torna a coincidere
  con il BAC, attestando un riallineamento della stima finale al budget previsto.


  == MP08: Time Estimate At Completion

  #figure(
    image(height: 30%, "assets/TAC.png"),
    caption: [Grafico per Sprint di MP08],
  ) <MP08>

  === RTB

  Dal grafico si osserva che il Time At Completion si mantiene sostanzialmente allineato al valore ottimale per i primi
  quattro sprint. Solo a partire dallo sprint 5 si registra un lieve aumento rispetto alla durata prevista, seguito da
  una leggera riduzione nello sprint 6, pur rimanendo leggermente sopra il valore ottimale. Lo scostamento registrato
  nella parte centrale può essere ricondotto a un rallentamento temporaneo delle attività, che ha inciso sulla
  previsione complessiva della durata del progetto. Tuttavia, tale variazione risulta contenuta e non evidenzia un
  allungamento significativo dei tempi.

  === PB

  Nel periodo compreso tra gli sprint 8 e 12, il Time At Completion evidenzia una marcata tendenza al ribasso. A partire
  dal picco registrato attorno allo sprint 8, il valore decresce progressivamente negli sprint successivi, pur
  mantenendosi leggermente al di sopra della soglia ottimale. Nel dodicesimo sprint la curva si riallinea alla soglia
  ottimale, attestando un completo recupero dello scostamento registrato in precedenza.


  == MP09: Budget Burn Rate

  #figure(
    image(height: 30%, "assets/BBR.png"),
    caption: [Grafico per Sprint di MP09],
  ) <MP09>

  === RTB

  Dal grafico si osserva che il consumo medio di budget per sprint mostra un andamento inizialmente crescente. In
  particolare, dal primo al quarto sprint il valore aumenta progressivamente, passando da circa 50 giorni/uomo a un
  picco intorno ai 70 giorni/uomo. Nel quinto sprint il valore si mantiene su livelli simili al precedente, evidenziando
  una fase di stabilizzazione del ritmo di spesa. Nell’ultimo sprint, invece, si registra una lieve diminuzione del burn
  rate, che torna intorno ai 60 giorni/uomo. È comunque importante sottolineare che per l’intera durata del periodo
  considerato, il Budget Burn Rate rimane sempre al di sotto del valore soglia accettabile (pari a circa 100
  giorni/uomo), rappresentato dalla linea rossa nel grafico. Questo aspetto evidenzia che il progetto ha mantenuto un
  livello di consumo delle risorse coerente con quanto pianificato, senza superare i limiti stabiliti.

  === PB

  Nel periodo compreso tra gli sprint 8 e 12, il Budget Burn Rate presenta un andamento sostanzialmente stabile, con una
  lieve crescita progressiva riconducibile all’intensificarsi delle attività nella fase conclusiva del progetto. I
  valori aumentano in misura contenuta da uno sprint al successivo, passando da poco meno di 80 giorni/uomo a poco più
  di 80 giorni/uomo. Per l’intero intervallo considerato, il burn rate si mantiene al di sotto della soglia accettabile,
  evidenziando un consumo delle risorse costante e coerente con quanto pianificato.

  == MP10: Requirements Stability Index
  #figure(
    image(height: 30%, "assets/RSI.png"),
    caption: [Grafico per Sprint di MP10],
  ) <MP10>
  === PB

  Il Requirements Stability Index si mantiene complessivamente su valori elevati per l’intera durata del periodo
  considerato. Nello sprint 9 si registra una flessione, con l’indicatore che si porta in prossimità della soglia minima
  del 70%, risultando leggermente inferiore ad essa. A partire dallo sprint 10, tuttavia, il valore cresce in maniera
  marcata, riportandosi su livelli molto elevati e stabilizzandosi in prossimità del 100% negli sprint successivi. Tale
  andamento evidenzia una fase iniziale di lieve variabilità, seguita da una netta stabilizzazione dei requisiti nella
  parte conclusiva del periodo osservato.


  == MP11: Indice di Gulpease
  #figure(
    image(height: 30%, "assets/gulpease.png"),
    caption: [Grafico per Sprint di MP11],
  ) <MP11>
  === RTB
  Dal grafico emerge che tutti i documenti mantengono un livello di avanzamento superiore alla soglia minima del 60%
  definita internamente dal gruppo. Nel complesso, l’andamento conferma una gestione della documentazione stabile e
  coerente con quanto fissato, senza scostamenti al di sotto del livello minimo previsto.

  === PB

  Nel periodo compreso tra gli sprint 8 e 12, tutti i documenti rappresentati nel grafico si mantengono al di sopra
  della soglia minima del 60%. La fase conclusiva evidenzia una sostanziale stabilità complessiva, accompagnata da lievi
  oscillazioni positive per la maggior parte dei documenti. In particolare, la Specifica Tecnica si mantiene in
  prossimità della soglia minima con un lieve miglioramento finale, mentre Analisi dei Requisiti e Piano di Qualifica
  mostrano una crescita moderata in direzione dello sprint 12. Norme di Progetto, Glossario e Piano di Progetto si
  attestano invece su valori più elevati e sostanzialmente stabili.

  == MP12: Correttezza Ortografica

  #figure(
    image(height: 30%, "assets/ortografica.png"),
    caption: [Grafico per Sprint di MP12],
  ) <MP12>

  === RTB

  Dal grafico si osserva un andamento complessivamente decrescente del numero di errori ortografici rilevati nei
  documenti prodotti durante gli sprint. Nel primo sprint il valore iniziale risulta piuttosto elevato (circa 35
  errori), segno di una fase iniziale in cui la revisione formale non era ancora pienamente strutturata. Nel secondo
  sprint si registra una lieve diminuzione, seguita però da un piccolo incremento nel terzo sprint. A partire dal quarto
  sprint, tuttavia, il numero di errori cala in modo significativo, passando da circa 20 nel quarto sprint a 12 nel
  quinto, fino ad azzerarsi completamente nel sesto sprint. Il progressivo avvicinamento e infine il raggiungimento del
  valore ottimo (e accettabile) dimostrano un miglioramento continuo nella qualità redazionale e una maggiore attenzione
  ai processi di revisione.

  === PB

  Nel periodo compreso tra gli sprint 8 e 12, il numero di errori ortografici rilevati si mantiene costantemente pari a
  zero. La curva coincide con il valore ottimo e con la soglia accettabile per tutti gli sprint considerati nella fase
  PB, confermando la piena stabilità del risultato conseguito già negli sprint precedenti. Tale risultato è da
  attribuirsi, in parte, all'adozione sistematica di strumenti automatici di controllo ortografico integrati nel
  processo redazionale.



  == MP13: Code Coverage

  #figure(
    table(
      columns: (1fr, auto, auto),
      stroke: 0.5pt,
      inset: 6pt,
      table.header([*Repository*], [*Valore registrato*], [*Quality Gate*]),
      [notip-crypto-sdk], [91,7%], [Passed],
      [notip-data-api], [97,1%], [Passed],
      [notip-data-consumer], [97,3%], [Passed],
      [notip-frontend], [94,9%], [Passed],
      [notip-management-api], [87,1%], [Passed],
      [notip-provisioning-service], [94,4%], [Passed],
      [notip-simulator-backend], [94,6%], [Passed],
      [notip-simulator-cli], [95,2%], [Passed],
    ),
    caption: [Valori di Baseline: code coverage per servizio. Fonte: SonarQube],
    kind: table,
  ) <MP13>

  === PB

  I valori di Baseline della metrica di Code Coverage nella fase PB sono riportati nella tabella precedente, ottenuti
  tramite SonarQube. Dai dati raccolti emerge un valore medio di copertura superiore al 90%, con differenze contenute
  tra i vari servizi. Tale risultato soddisfa il valore accettabile definito per la metrica e si allinea sostanzialmente
  al valore ottimale fissato al 90%, attestando un livello di copertura complessivamente molto elevato. Il gruppo ha
  adottato opportune misure per garantire che tutti i componenti critici siano adeguatamente coperti dai test,
  assicurando la correttezza del prodotto.


  == MP14: Test Success Rate

  === PB
  In merito a questa metrica, durante la fase di sviluppo è stato adottato un controllo bloccante applicato in fase di
  code review, attivato a ogni Pull Request. Tale meccanismo impediva l'avanzamento di qualsiasi commit finché i test
  non risultassero integralmente superati, obbligando alla risoluzione immediata di eventuali errori. Grazie a questa
  politica di verifica sistematica, il Test Success Rate si è mantenuto al *100%* per ogni servizio sviluppato.

  == MP15: Test Automation Percentage

  === PB
  Nel periodo compreso tra gli sprint 8 e 12, la metrica Test Automation Percentage si è mantenuta stabilmente al valore
  ottimo del *100%* per i test di unità e d'integrazione. Ogni suite di test è stata sviluppata sfruttando i framework
  nativi dei rispettivi linguaggi ed è stata integrata direttamente nelle pipeline di Continuous Integration (CI).
  Grazie a tale approccio, strumenti di analisi statica come SonarQube vengono alimentati in modo continuo dai report
  generati automaticamente dai runner della CI a ogni Pull Request. Di conseguenza, l'intero insieme di test viene
  eseguito e validato per ogni servizio senza alcun intervento manuale, eliminando il rischio di errore umano nella fase
  di verifica e confermando il pieno conseguimento dell'obiettivo prefissato.

  Per quanto riguarda i test di sistema, è stata adottata una strategia di verifica manuale basata sull'esecuzione di
  test end-to-end, finalizzata ad accertare il corretto funzionamento dell'intero sistema in condizioni operative
  realistiche. Nonostante la natura manuale di tali test, è stata predisposta una rigorosa pianificazione e
  documentazione dei casi di test, al fine di garantire una copertura esaustiva e una tracciabilità accurata dei
  risultati. Tale approccio ha consentito di bilanciare efficacemente l'automazione a livello di test unitari e
  d'integrazione con una strategia manuale mirata per i test di sistema, assicurando un elevato standard qualitativo
  complessivo.

  == MP16: Defect Discovery Rate

  === PB
  In merito alla metrica MP16, l'integrazione di SonarQube e dei relativi meccanismi di automazione ha consentito il
  monitoraggio sistematico dell'andamento dei difetti del codice, permettendone la correzione tempestiva all'esecuzione
  dei workflow definiti nel repository. Il numero di difetti rilevati ha seguito un andamento costantemente decrescente
  nel corso dell'attività di codifica, fino ad *azzerarsi* completamente nella fase conclusiva del progetto.

  == MP18: Quality Metrics Satisfied

  #figure(
    image(height: 30%, "assets/QMS.png"),
    caption: [Grafico per Sprint di MP18],
  ) <MP18>

  === RTB

  Il grafico evidenzia come la percentuale di Quality Metrics Satisfied si sia mantenuta costantemente al di sopra della
  soglia di minimo accettabile (80%) per tutti gli sprint considerati. Sebbene non sia stato raggiunto il target
  ottimale (100%), le lievi oscillazioni registrate non hanno compromesso gli standard qualitativi prefissati. Tali
  risultati riflettono una gestione efficace della qualità e una pronta capacità di reazione del Team nel monitorare e
  mantenere il controllo sulle metriche prestabilite.

  === PB

  Nel periodo compreso tra gli sprint 8 e 12, la percentuale di Quality Metrics Satisfied si mantiene costantemente al
  di sopra della soglia di accettabilità. Dopo una lieve flessione registrata attorno allo sprint 8, il valore torna a
  crescere negli sprint successivi, attestandosi stabilmente intorno al 95% nella parte finale del periodo considerato.
  Pur non raggiungendo il valore ottimo del 100%, il grafico evidenzia un andamento complessivamente positivo e stabile.

  == MP19: Quality Gate Pass Rate

  #figure(
    table(
      columns: (1fr, auto),
      stroke: 0.5pt,
      inset: 6pt,
      table.header([*Repository*], [*Quality Gate*]),
      [notip-crypto-sdk], [Passed],
      [notip-data-api], [Passed],
      [notip-data-consumer], [Passed],
      [notip-frontend], [Passed],
      [notip-management-api], [Passed],
      [notip-provisioning-service], [Passed],
      [notip-simulator-backend], [Passed],
      [notip-simulator-cli], [Passed],
    ),
    caption: [Stato Quality Gate per servizio (Baseline al rilascio di questo documento). Fonte: SonarQube],
    kind: table,
  ) <MP19>

  === PB
  In merito alla metrica MP19, l'integrazione di SonarQube nel processo di code review ha consentito il rilevamento
  automatico di eventuali difetti nel codice, bloccando il flusso di Pull Request in presenza di violazioni. Tale
  meccanismo ha garantito un controllo sistematico e continuo sulla qualità del codice, imponendo la risoluzione
  immediata di qualsiasi anomalia rilevata. Come riportato nella tabella precedente, tutti i servizi hanno superato il
  Quality Gate al momento del rilascio di questo documento. Questa politica ha condotto al raggiungimento di *0*
  vulnerabilità (i security hotspot rilevati dallo strumento), confermando il pieno conseguimento del valore ottimo
  prefissato per la metrica.

  == MP20: Time Efficiency
  #figure(
    image(height: 30%, "assets/TE.png"),
    caption: [Grafico per Sprint di MP20],
  ) <MP20>

  === RTB

  Dal grafico si osserva un progressivo incremento della Time Efficiency (TE) dallo sprint 1 allo sprint 6. Tuttavia,
  l’indicatore rimane costantemente al di sotto del valore ottimale, evidenziando un livello di efficienza temporale
  ancora migliorabile. Questo andamento è legato alla significativa incidenza delle “ore di palestra”, indispensabili al
  team per lo svolgimento dei task in analisi. Nonostante ciò, la crescita costante dell’indicatore dimostra un
  miglioramento graduale nella gestione del tempo. Inoltre, si prevede che, dopo la RTB, le ore di palestra tenderanno a
  diminuire, poiché il gruppo avrà ormai consolidato competenze e modalità operative. Questo comporterà un aumento delle
  ore effettivamente produttive e, di conseguenza, un incremento della Time Efficiency nei prossimi sprint.

  === PB

  Nel periodo compreso tra gli sprint 8 e 12, la Time Efficiency registra una crescita costante e regolare. I valori si
  mantengono sempre al di sopra della soglia accettabile, mostrando un incremento progressivo dal 50% circa fino a circa
  il 65% nello sprint 12. Il grafico attesta pertanto un miglioramento continuativo dell’indicatore nella fase PB;
  tuttavia, la distanza dal valore ottimo indica che permane margine di miglioramento nella gestione efficiente del
  tempo.


  == MP21: Sprint Velocity Stability
  #figure(
    image(height: 30%, "assets/SVS.png"),
    caption: [Grafico per Sprint di MP21],
  ) <MP21>

  === RTB

  Dal grafico si osserva un andamento progressivamente migliorativo nel corso degli sprint. Poiché la metrica misura lo
  scostamento percentuale tra velocity pianificata e velocity effettiva, valori più elevati indicano una maggiore
  instabilità, mentre valori più bassi rappresentano una migliore capacità di previsione e quindi una maggiore
  stabilità. Nel primo sprint il valore si attesta intorno al 100%, evidenziando uno scostamento molto elevato e quindi
  una situazione iniziale critica. Nel secondo sprint si registra una lieve riduzione, ma il miglioramento più
  significativo si osserva nel terzo sprint, dove lo scostamento scende intorno al 65%. Negli sprint successivi il
  valore continua a ridursi gradualmente e tende a stabilizzarsi attorno al 70%, mostrando comunque una distanza dalla
  soglia di accettabilità (linea rossa). Sebbene il team non abbia ancora raggiunto il valore accettabile, il valore
  decrescente rappresenta un segnale positivo: lo scostamento si sta progressivamente riducendo e la prevedibilità della
  velocity sta migliorando.

  === PB

  Nel periodo compreso tra gli sprint 8 e 12, la Sprint Velocity Stability mostra un progressivo miglioramento, con
  valori in costante diminuzione. Dopo aver superato ancora la soglia accettabile nello sprint 8, l’indicatore scende al
  di sotto di essa a partire dallo sprint 9, mantenendosi inferiore per tutti gli sprint successivi fino al termine del
  periodo considerato. Il valore minimo si registra attorno allo sprint 11, seguito da un lieve incremento finale che
  non compromette il rispetto della soglia accettabile definita.

  == MP22: Meeting Efficiency Index

  #figure(
    image(height: 30%, "assets/MEI.png"),
    caption: [Grafico per Sprint di MP22],
  ) <MP22>

  === RTB

  Dal grafico si osserva un andamento variabile nel corso degli sprint, con valori che oscillano attorno al valore
  ottimo fissato a 5 decisioni/ora (linea gialla). Poiché la metrica misura il numero medio di decisioni prese per ora
  di riunione, valori più elevati indicano una maggiore efficienza, mentre valori più bassi riflettono un minor
  rendimento degli incontri. Nel primo sprint l’indice si attesta intorno a 9 decisioni/ora, valore significativamente
  superiore a quello ottimo. Negli sprint successivi si osserva una progressiva riduzione: nel secondo sprint il valore
  scende a circa 6, mentre nel terzo si allinea al valore ottimo di 5 decisioni/ora, evidenziando un buon equilibrio tra
  produttività e qualità delle decisioni. Nel quarto sprint si registra un lieve incremento, seguito però da un calo più
  marcato nel quinto sprint (circa 3–4 decisioni/ora), valore che si avvicina alla soglia di accettabilità (linea
  rossa), indice di riunioni meno focalizzate e di fasi in cui le decisioni effettive risultano meno numerose.
  Nell’ultimo sprint si osserva una ripresa, con un ritorno a circa 6 decisioni/ora, riportando l’indicatore sopra il
  valore ottimo.

  === PB

  Nel periodo compreso tra gli sprint 8 e 12, il Meeting Efficiency Index si mantiene costantemente al di sopra della
  soglia accettabile, collocandosi per quasi tutto l’intervallo in prossimità o leggermente al di sopra del valore
  ottimo. Dopo l’allineamento al valore ottimo nello sprint 8, il grafico evidenzia un picco positivo nello sprint 9,
  seguito da una lieve diminuzione e da una successiva stabilizzazione negli sprint conclusivi su valori di poco
  superiori a 5 decisioni/ora.

  == MP23: PR Resolution Time

  #figure(
    image(height: 30%, "assets/PRRT.png"),
    caption: [Grafico per Sprint di MP23],
  ) <MP23>

  === RTB

  Dal grafico si osserva un andamento complessivamente variabile nel tempo, con un picco significativo nella parte
  centrale del periodo considerato. La metrica misura il numero medio di giorni necessari per la risoluzione delle Pull
  Request: trattandosi di un indicatore temporale, valori più bassi sono preferibili, poiché indicano maggiore
  reattività e fluidità nel processo di revisione. Nel primo sprint il tempo medio di risoluzione si attesta intorno ai
  3 giorni, valore in prossimità della soglia di accettabilità (linea rossa). Nel secondo sprint si registra un
  miglioramento significativo, con una riduzione a circa 1 giorno, in linea con il valore ottimo (linea gialla). Anche
  il terzo sprint mantiene un tempo contenuto, sebbene leggermente superiore rispetto al precedente. Nel quarto sprint
  si verifica un marcato peggioramento, con un picco di circa 11–12 giorni, ampiamente superiore alla soglia
  accettabile. A partire dal quinto sprint si osserva un recupero significativo: il tempo medio scende nuovamente sotto
  la soglia accettabile (circa 2 giorni) e nell’ultimo sprint si riporta in prossimità del valore ottimo. Questo
  andamento evidenzia la capacità del team di reagire a una criticità temporanea e di ristabilire un processo di
  revisione più efficiente.

  === PB

  Nel periodo compreso tra gli sprint 8 e 12, il PR Resolution Time si mantiene stabilmente al di sotto della soglia
  accettabile e in prossimità del valore ottimo. A partire dallo sprint 8, i valori oscillano in misura contenuta
  attorno a circa 1 giorno, con un lieve incremento negli ultimi sprint che rimane comunque entro limiti trascurabili.
  Il grafico evidenzia pertanto una fase conclusiva caratterizzata da continuità e stabilità nel tempo medio di
  risoluzione delle Pull Request.


  == MQ01/MQ02/MQ03: Requisiti Obbligatori/Desiderabili/Opzionali Soddisfatti

  === PB
  A seguito della negoziazione con l'azienda proponente, in cui un requisito originariamente classificato come
  obbligatorio, quello relativo alla funzionalità End-to-End, è stato ridefinito come desiderabile/opzionale, il gruppo
  ha conseguito il soddisfacimento del *100%* dei requisiti obbligatori.

  == MQ04: Branch Coverage
  === PB
  Nel periodo di PB, la copertura delle decisioni logiche del codice si è attestata su livelli eccellenti. La media di
  progetto ha superato costantemente il valore ottimo dell'80%, con alcuni microservizi che hanno raggiunto una
  copertura del 100%. Il valore minimo rilevato su un singolo servizio è stato del 75%, risultato comunque ampiamente al
  di sopra della soglia accettabile del 60%.

  #figure(
    table(
      columns: (1fr, auto, auto),
      stroke: 0.5pt,
      inset: 6pt,
      table.header([*Repository*], [*Branch coverage*], [*Quality Gate*]),
      [notip-crypto-sdk], [79,2%], [Passed],
      [notip-data-api], [92,8%], [Passed],
      [notip-data-consumer], [N/D], [Passed],
      [notip-frontend], [91,3%], [Passed],
      [notip-management-api], [77,5%], [Passed],
      [notip-provisioning-service], [85,6%], [Passed],
      [notip-simulator-backend], [N/D], [Passed],
      [notip-simulator-cli], [N/D], [Passed],
    ),
    caption: [Valori di Baseline: branch coverage per servizio. Fonte: SonarQube (N/D: metrica non esposta dallo
      strumento per il linguaggio del servizio)],
    kind: table,
  )

  == MQ05: Statement Coverage
  === PB
  L'andamento della metrica durante la PB ha confermato l'alta affidabilità della test suite. La copertura delle
  istruzioni non è mai scesa sotto l'87% globale (ampiamente sopra il 70% accettabile) ed è rientrata nel range ottimale
  (>= 90%) per la quasi totalità dell'architettura. Sui moduli principali del backend, gli strumenti di analisi statica
  hanno certificato picchi di copertura fino al 97,3%.

  #figure(
    table(
      columns: (1fr, auto, auto),
      stroke: 0.5pt,
      inset: 6pt,
      table.header([*Repository*], [*Statement coverage*], [*Quality Gate*]),
      [notip-crypto-sdk], [95,3%], [Passed],
      [notip-data-api], [99,4%], [Passed],
      [notip-data-consumer], [97,3%], [Passed],
      [notip-frontend], [96,8%], [Passed],
      [notip-management-api], [92,8%], [Passed],
      [notip-provisioning-service], [97,5%], [Passed],
      [notip-simulator-backend], [94,6%], [Passed],
      [notip-simulator-cli], [95,2%], [Passed],
    ),
    caption: [Valori di Baseline: statement coverage per servizio. Fonte: SonarQube],
    kind: table,
  )

  == MQ06: Failure Density
  === PB
  La metrica ha fatto registrare risultati ottimali per l'intero periodo. Grazie all'applicazione sistematica di
  controlli automatizzati e a rigorose procedure di code review, le analisi non hanno rilevato alcun bug o vulnerabilità
  nel codice rilasciato. Il valore della Failure Density si è attestato a 0,0 failure/KLOC, centrando il valore ottimo
  definito (≤ 0,1).

  #figure(
    table(
      columns: (1fr, auto, auto, auto),
      stroke: 0.5pt,
      inset: 6pt,
      table.header([*Repository*], [*Bug*], [*Vulnerabilità*], [*Quality Gate*]),
      [notip-crypto-sdk], [0], [0], [Passed],
      [notip-data-api], [0], [0], [Passed],
      [notip-data-consumer], [0], [0], [Passed],
      [notip-frontend], [0], [0], [Passed],
      [notip-management-api], [0], [0], [Passed],
      [notip-provisioning-service], [0], [0], [Passed],
      [notip-simulator-backend], [0], [0], [Passed],
      [notip-simulator-cli], [0], [0], [Passed],
    ),
    caption: [Valori di Baseline: bug e vulnerabilità per servizio. Fonte: SonarQube],
    kind: table,
  )

  == MQ10: Code Smells
  === PB
  Durante la fase di PB, il codice prodotto ha evidenziato un elevato livello di manutenibilità, certificato dal rating
  massimo ("A") nella categoria Maintainability su SonarQube per l'intero ecosistema di repository. Il numero di code
  smell è risultato pressoché nullo, mantenendosi costantemente al di sotto della soglia ottimale (≤ 5 code smell/KLOC).

  #figure(
    table(
      columns: (1fr, auto, auto),
      stroke: 0.5pt,
      inset: 6pt,
      table.header([*Repository*], [*Code smells*], [*Quality Gate*]),
      [notip-crypto-sdk], [0], [Passed],
      [notip-data-api], [1], [Passed],
      [notip-data-consumer], [0], [Passed],
      [notip-frontend], [0], [Passed],
      [notip-management-api], [1], [Passed],
      [notip-provisioning-service], [8], [Passed],
      [notip-simulator-backend], [0], [Passed],
      [notip-simulator-cli], [1], [Passed],
    ),
    caption: [Valori di Baseline: code smells per servizio. Fonte: SonarQube],
    kind: table,
  )

  == MQ11: Cyclomatic Complexity
  === PB
  Nonostante l'elevata complessità architetturale complessiva (a titolo esemplificativo, il frontend presenta una
  complessità cumulativa di circa 1.396 distribuita su oltre 140 file), la complessità ciclomatica media per singolo
  metodo o funzione si è mantenuta stabilmente all'interno del range ottimale (≤ 5). Il gruppo ha applicato con rigore
  principi di refactoring, scomponendo la logica in funzioni lineari, concise e facilmente verificabili.

  #figure(
    table(
      columns: (1fr, auto, auto, auto),
      stroke: 0.5pt,
      inset: 6pt,
      table.header([*Repository*], [*Complessità totale*], [*Funzioni*], [*Media per funzione*]),
      [notip-crypto-sdk], [80], [48], [1,67],
      [notip-data-api], [309], [137], [2,26],
      [notip-data-consumer], [194], [82], [2,37],
      [notip-frontend], [1497], [788], [1,90],
      [notip-management-api], [1105], [513], [2,15],
      [notip-provisioning-service], [163], [82], [1,99],
      [notip-simulator-backend], [558], [192], [2,91],
      [notip-simulator-cli], [146], [43], [3,40],
    ),
    caption: [Valori di Baseline: complessità ciclomatica per servizio. Fonte: SonarQube],
    kind: table,
  )

  == MQ12: Code Duplication Percentage
  === PB
  I report finali di analisi statica confermano un'eccellente fattorizzazione del codice, nel pieno rispetto del
  principio DRY. Per la quasi totalità dei servizi sviluppati è stata registrata una percentuale di duplicazione
  estremamente contenuta. Il picco massimo rilevato è stato del 2,2% nel servizio di management, valore comunque
  inferiore alla soglia ottimale del 3%.

  #figure(
    table(
      columns: (1fr, auto, auto),
      stroke: 0.5pt,
      inset: 6pt,
      table.header([*Repository*], [*Duplicazione*], [*Quality Gate*]),
      [notip-crypto-sdk], [0,0%], [Passed],
      [notip-data-api], [1,7%], [Passed],
      [notip-data-consumer], [0,0%], [Passed],
      [notip-frontend], [1,5%], [Passed],
      [notip-management-api], [2,2%], [Passed],
      [notip-provisioning-service], [0,0%], [Passed],
      [notip-simulator-backend], [0,0%], [Passed],
      [notip-simulator-cli], [0,0%], [Passed],
    ),
    caption: [Valori di Baseline: percentuale di duplicazione per servizio. Fonte: SonarQube],
    kind: table,
  )

  == MQ13: Container Image Size
  === PB
  Durante la fase di PB, il gruppo ha riservato particolare attenzione all'ottimizzazione delle immagini Docker al fine
  di garantire deployment rapidi ed efficienti. Nella configurazione iniziale, il container di dimensioni maggiori si
  attestava intorno ai 400 MB, valore comunque ampiamente entro la soglia accettabile di 500 MB. A seguito di interventi
  mirati di ottimizzazione, le dimensioni delle immagini sono state ulteriormente ridotte, raggiungendo in alcuni casi
  valori al di sotto della soglia ottimale.

  #pagebreak()

  = Valutazioni per l'automiglioramento
  Al fine di perseguire un miglioramento continuo durante lo svolgimento del progetto, è opportuno effettuare
  valutazioni periodiche. Tali valutazioni hanno l’obiettivo di individuare le criticità emerse e le relative soluzioni
  adottate per affrontarle, consentendo al gruppo di acquisire una maggiore consapevolezza e di ridurre il rischio di
  ripetere gli stessi errori in futuro. Le analisi effettuate si basano sulle tre categorie di rischio definite nel
  _Piano di Progetto_ v1.0.0, ovvero:
  - Rischi connessi alle tecnologie adottate (*RT1*);
  - Rischi connessi all'organizzazione del team (*RO1*);
  - Rischi connessi ai singoli componenti del gruppo (*RP1*).

  == Valutazione sulle tecnologie adottate
  #table(
    columns: (1fr, 1fr, 0.4fr),
    stroke: 0.5pt,
    inset: 6pt,

    table.header([*Problema*], [*Soluzione adottata*], [*Tecnologia coinvolta*]),
    [La gestione del codice condiviso può generare conflitti e perdita di tracciabilità.],
    [Utilizzo di repository GitHub con branch protection, pull request e Sistema di issue tracking.],
    [GitHub],

    [La pianificazione e il monitoraggio delle attività possono risultare disorganizzati senza uno strumento dedicato.],
    [Utilizzo di Jira per la gestione del backlog, la pianificazione degli sprint e il monitoraggio dello stato delle
      attività.],
    [Jira],

    [Alcuni membri del gruppo non avevano familiarità con il linguaggio Go, causando una curva di apprendimento
      iniziale.],
    [Ogni membro ha intrapreso un percorso di autoapprendimento mirato, supportato da documentazione ufficiale ed esempi
      pratici.],
    [Linguaggio Go],

    [La maggior parte del team non aveva esperienza con tecnologie di messagging come NATS.],
    [Studio della documentazione ufficiale e realizzazione di prototipi incrementali per validarne l'utilizzo nel PoC.],
    [NATS JetStream],

    [L’utilizzo di un database time-series basato su estensione PostgreSQL non era noto a tutti i membri.],
    [Approfondimento delle funzionalità principali (Hypertables, partizionamento) e utilizzo guidato nelle prime fasi di
      sviluppo.],
    [PostgreSQL + TimescaleDB],

    [La struttura modulare di NestJS può risultare inizialmente complessa.],
    [Adozione delle convenzioni ufficiali del framework e suddivisione chiara dei moduli per facilitare la
      comprensione.],
    [TypeScript / NestJS],

    [Il framework Angular richiede una buona organizzazione dei componenti e dei servizi.],
    [Suddivisione dell’interfaccia in componenti con responsabilità ben definite e organizzazione della struttura del
      progetto seguendo le linee guida della documentazione.],
    [Angular],

    [La gestione della decifratura lato client introduce complessità applicativa.],
    [Implementazione semplificata con chiavi statiche per dimostrare la fattibilità dell’approccio nel PoC.],
    [Cifratura end-to-end (Zero Knowledge).],
  )

  == Valutazione sull'organizzazione del team

  #table(
    columns: (1fr, 1fr),
    stroke: 0.5pt,
    inset: 6pt,

    table.header([*Problema*], [*Soluzione adottata*]),
    [La difficoltà nel coordinamento del lavoro asincrono tra i membri del team ha rallentato il progresso del
      progetto.],
    [Pianificazione di riunioni regolari per allineare gli obiettivi e le attività del team, oltre all'adozione di
      strumenti di gestione del progetto per migliorare la comunicazione.],

    [La comunicazione della rendicontazione delle ore lavorative durante la retrospettiva di sprint ha inizialmente
      causato un rallentamento del flusso organizzativo.],
    [Utilizzo di Jira per tracciare le ore lavorative in modo più efficiente e trasparente, riducendo il tempo dedicato
      alla rendicontazione manuale.],

    [La gestione non strutturata delle priorità delle attività ha portato a ritardi nell'implementazione di funzionalità
      chiave.],
    [Definizione delle priorità a inizio sprint e loro revisione durante la pianificazione.],

    [Rallentamento delle attività di progetto nel periodo della sessione d'esami invernale.],
    [Pianificazione delle attività in modo da recuperare il ritardo una volta terminati gli esami.],
  )

  == Valutazione sui singoli componenti del gruppo

  #table(
    columns: (1fr, 1fr),
    stroke: 0.5pt,
    inset: 6pt,

    table.header([*Problema*], [*Soluzione adottata*]),
    [Impegni esterni di alcuni componenti del gruppo hanno causato temporanee indisponibilità.],
    [Comunicazione immediata al team e riorganizzazione delle attività per garantire la continuità del lavoro.],

    [Differenti livelli di esperienza tra i membri del gruppo.],
    [Collaborazione attiva e supporto reciproco per garantire un avanzamento uniforme delle attività.],
  )

]
