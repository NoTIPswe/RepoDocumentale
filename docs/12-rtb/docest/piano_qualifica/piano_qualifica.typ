#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)

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
    - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato d'appalto C7 - Sistema di acquisizione dati da sensori]

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
    // Metriche economico-temporali standard
    // - MP01: Earned Value (EV)
    // - MP02: Planned Value (PV)
    // - MP03: Actual Cost (AC)
    // - MP04: Cost Performance Index (CPI)
    // - MP05: Schedule Performance Index (SPI)
    // - MP06: Estimate At Completion (EAC)
    // - MP07: Estimate To Complete (ETC)
    // - MP08: Time Estimate At Completion (TEAC)
    // 
    // NUOVA METRICA AGGIUNTA:
    // - MP16: Budget Burn Rate
    //   Formula: (Budget speso fino ad oggi) / (Giorni trascorsi)
    //   Indica la velocità di consumo del budget
    //   Accettabile: ≤ Budget totale / Giorni totali pianificati
    //   Ottimale: Costante nel tempo
    //   Utilità: Prevedere esaurimento budget in anticipo

  === Sviluppo
    // Metriche di stabilità requisiti e qualità codifica
    // - MP09: Requirements Stability Index (RSI)
    // - MP17: Code Coverage (durante sviluppo)
    // - MP18: Complessità Ciclomatica Media per Modulo
    // 
    // NUOVE METRICHE AGGIUNTE:
    // 
    // - MP19: Technical Debt Ratio
    //   Formula: (Tempo stimato per risolvere code smells) / (Tempo di sviluppo totale)
    //   Misura il "debito tecnico" accumulato
    //   Accettabile: ≤ 5%
    //   Ottimale: ≤ 3%
    //   Utilità: Evita degrado qualità

  == Processi di supporto
  === Documentazione
    // Metriche di leggibilità e correttezza
    // - MP10: Indice di Gulpease
    // - MP11: Correttezza Ortografica
  
  === Verifica
    // Metriche di testing e copertura
    // - MP12: Code Coverage
    // - MP13: Test Success Rate
    // - MP24: Branch Coverage
    // - MP25: Statement Coverage
    // 
    // NUOVE METRICHE AGGIUNTE:
    // 
    // - MP26: Defect Detection Percentage (DDP)
    //   Formula: (Difetti trovati in verifica) / (Difetti totali trovati) × 100
    //   Accettabile: ≥ 80%
    //   Ottimale: ≥ 90%
    //   Utilità: Valuta efficacia del processo di verifica
    // 
    // - MP27: Mean Time To Detect (MTTD) Bug
    //   Tempo medio tra introduzione e rilevamento di un bug
    //   Accettabile: ≤ 7 giorni
    //   Ottimale: ≤ 3 giorni
    //   Utilità: Velocità feedback loop
    // 
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
    // 
    // - MP30: Branch Lifetime
    //   Tempo medio di vita di un feature branch
    //   Accettabile: ≤ 5 giorni
    //   Ottimale: ≤ 3 giorni
    //   Utilità: Riduce conflitti merge, favorisce integrazione continua

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
    // 
    // NUOVA METRICA AGGIUNTA:
    // - MQ14: Feature Completeness per Milestone
    //   Formula: (Funzionalità complete previste) / (Funzionalità pianificate) × 100
    //   Accettabile: ≥ 90% a RTB, 100% a PB
    //   Ottimale: 100% sempre
    //   Utilità: Verifica aderenza roadmap

  == Affidabilità
    // - MQ04: Branch Coverage
    // - MQ05: Statement Coverage
    // - MQ06: Failure Density
    // 
    // NUOVE METRICHE AGGIUNTE (CRUCIALI PER IL TUO PROGETTO):
    // 
    // - MQ15: Data Integrity Rate
    //   Formula: (Pacchetti dati corretti) / (Pacchetti totali ricevuti) × 100
    //   Accettabile: ≥ 99.5%
    //   Ottimale: ≥ 99.9%
    //   Utilità: Fondamentale per ingestione dati da gateway BLE

  == Usabilità
    // - MQ07: Time on Task
    // - MQ08: Error Rate

  == Efficienza
    // - MQ09: Response Time

  == Manutenibilità
    // - MQ10: Code Smells
    // - MQ11: Coefficient of Coupling
    // - MQ12: Cyclomatic Complexity
    // 
    // NUOVE METRICHE AGGIUNTE:
    // 
    // - MQ25: Code Duplication Percentage
    //   Formula: (Linee duplicate) / (Linee totali) × 100
    //   Accettabile: ≤ 5%
    //   Ottimale: ≤ 3%
    //   Utilità: Riduce debito tecnico
    // 
    // - MQ26: Dependency Freshness
    //   Numero di dipendenze outdated/vulnerabili
    //   Accettabile: 0 critiche, ≤ 5 moderate
    //   Ottimale: 0 totali
    //   Utilità: Sicurezza e aggiornabilità

  == Portabilità
    // NUOVA SEZIONE AGGIUNTA (RILEVANTE PER CLOUD)
    // 
    // - MQ27: Container Image Size
    //   Dimensione immagini Docker prodotte
    //   Accettabile: ≤ 500 MB
    //   Ottimale: ≤ 200 MB
    //   Utilità: Velocità deployment e costi storage
    // 
    // - MQ28: Multi-tenancy Isolation Score
    //   Test di penetrazione tra tenant (% superati)
    //   Accettabile: 100%
    //   Ottimale: 100%
    //   Utilità: Sicurezza architettura multi-tenant

  == Sicurezza
    // NUOVA SEZIONE AGGIUNTA (CRITICA PER IL PROGETTO)
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