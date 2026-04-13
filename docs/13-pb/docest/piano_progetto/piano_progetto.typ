#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)
#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Documento relativo al Piano di Progetto realizzato dal Gruppo NoTIP per la realizzazione del progetto Sistema di Acquisizione Dati da Sensori BLE",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione
  == Scopo del documento
  Il presente documento ha lo scopo di definire, descrivere e tracciare le attività svolte e da svolgere nell'ambito
  della realizzazione del progetto "Sistema di Acquisizione Dati da Sensori BLE" proposto da M31 S.r.l (capitolato C7).
  Il documento fornisce un'analisi complessiva delle attività coprendo, in particolare, la stima del tempo previsto ed
  effettivo, oltre ai potenziali rischi che il gruppo potrebbe affrontare.

  == Glossario
  Il #link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/glossario.pdf")[Glossario v2.0.0] è un
  documento soggetto a continuo aggiornamento per l'intera durata del progetto; il suo scopo è definire la terminologia
  tecnica per garantire una comprensione chiara e univoca dei contenuti. I termini presenti nel Glossario sono
  contrassegnati nel testo da una lettera "G" posta a pedice (es. parola#sub[G]).
  == Riferimenti
  === Riferimenti normativi
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato d'appalto C7 - Sistema di
      acquisizione dati da sensori]\ _Ultimo accesso: 2026-04-13_
  - #link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/piano_qualifica.pdf")[Piano di Qualifica
      v1.1.0]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/analisi_requisiti.pdf")[Analisi dei Requisiti
      v2.0.0]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docint/norme_progetto.pdf")[Norme di Progetto v2.0.0]
  === Riferimenti informativi
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/T03.pdf")[T03 - Ciclo di vita del Software] \ _Ultimo
    accesso: 2026-04-13_
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/T04.pdf")[T04 - Gestione di Progetto] \ _Ultimo accesso:
    2026-04-13_

  = Analisi e gestione dei rischi
  == Introduzione
  Questa sezione analizza i possibili rischi che il gruppo potrebbe incontrare durante lo svolgimento delle attività.
  Un'analisi accurata permette di prevenire difficoltà nella pianificazione delle attività, ritardi nelle scadenze
  stabilite e un eventuale aumento dei costi di produzione, oltre a garantire la realizzazione di un prodotto che
  soddisfi le attese del Cliente.

  L'analisi e gestione dei rischi si suddivide in 4 fasi:
  - *Identificazione*: individuare i possibili rischi legati ad un'attività nel contesto a cui ci si sta riferendo, che
    potrebbe essere incluso anche nella sfera personale.
  - *Analisi*: valutazione della probabilità di occorrenza e delle potenziali conseguenze dei rischi individuati sulle
    tempistiche e sullo sviluppo.
  - *Pianificazione*: pianificazione di azioni da intraprendere per mitigare o prevenire gli eventuali rischi
    analizzati.
  - *Controllo*: monitoraggio continuo delle attività fissate per poter rilevare il prima possibile la presenza di un
    rischio e applicare le procedure di mitigazione definite precedentemente.\
  Nell'analisi, ogni rischio è identificato tramite acronimo della tipologia di appartenenza e numero incrementale. Dato
  che una ridotta esperienza potrebbe rendere inefficaci le mitigazioni inizialmente pianificate, è necessario prevedere
  un'ulteriore analisi anche degli errori di mitigazione al fine di apportare miglioramenti alle strategie adottate.

  == Rischi tecnologici
  === Rischio legato all'apprendimento delle tecnologie richieste
  #figure(
    numbering: "1",
    table(
      columns: (1fr, 2fr),
      [Tipologia Dato], [Valore],
      [Codice], [RT1],
      [Nome], [Apprendimento delle tecnologie richieste],
      [Descrizione],
      [A causa della poca conoscenza o dell'inesperienza, il gruppo potrebbe incontrare difficoltà nella comprensione e
        nell'utilizzo delle tecnologie richieste nel progetto, causando un progressivo rallentamento nello sviluppo.],

      [Mitigazione],
      [Una volta individuate le tecnologie da adottare, è opportuno prevedere un periodo di “palestra” per approfondirle
        e consolidare le competenze, considerando che situazioni simili potrebbero ripresentarsi anche in futuro. Se la
        criticità dovesse coinvolgere l’intero gruppo, il Team potrà organizzare un incontro con M31 per richiedere
        chiarimenti sulla tecnologia oggetto di analisi. Tuttavia, poiché il livello di conoscenza tra i membri potrebbe
        non essere omogeneo, è verosimile che molte problematiche vengano risolte internamente al Team.],

      [Probabilità], [Alta],
      [Impatto prestazionale], [Alto],
    ),
    caption: [Rischio sull'apprendimento delle tecnologie richieste],
  )<tab:RT1>

  === Rischio legato ad errori di programmazione
  #figure(
    numbering: "1",
    table(
      columns: (1fr, 2fr),
      [Tipologia Dato], [Valore],
      [Codice], [RT2],
      [Nome], [Errori di programmazione],
      [Descrizione],
      [Risulta altamente improbabile che il codice scritto dal gruppo possa essere privo di errori alla prima
        esecuzione],

      [Mitigazione],
      [Il Team farà ampio ricorso ai test durante le fasi di sviluppo, così da assicurare il corretto funzionamento del
        prodotto. Nel caso in cui dovessero emergere difficoltà tali da impedire l’avanzamento delle attività, verrà
        richiesto il supporto dell’Azienda proponente.],

      [Probabilità], [Alta],
      [Impatto prestazionale], [Medio],
    ),
    caption: [Rischio sugli errori di programmazione],
  )<tab:RT2>
  == Rischi organizzativi
  === Rischio legato al mancato rispetto delle scadenze stabilite
  #figure(
    numbering: "1",
    table(
      columns: (1fr, 2fr),
      [Tipologia Dato], [Valore],
      [Codice], [RO1],
      [Nome], [Mancato rispetto delle scadenze stabilite],
      [Descrizione],
      [Durante lo sviluppo del prodotto possono verificarsi ritardi rispetto al conseguimento delle task fissate,
        comportando un prolungamento dei tempi di consegna e un eventuale blocco delle attività successive.],

      [Mitigazione],
      [Il Gruppo si impegna a rispettare le tempistiche, pur nella consapevolezza che possano verificarsi imprevisti.
        Eventuali ritardi dovranno essere comunicati tempestivamente e motivati, cercando di mitigare l'impatto sulle
        attività degli altri membri. Qualora il ritardo mettesse a rischio la data di consegna finale, verrà convocata
        con urgenza una riunione con _M31_ per rivedere la pianificazione o rinegoziare i requisiti.],

      [Probabilità], [Media - Bassa],
      [Impatto prestazionale], [Alto],
    ),
    caption: [Mancato rispetto delle scadenze stabilite],
  )<tab:RO1>
  == Rischi personali
  === Rischio legato a problematiche personali o attività universitarie
  #figure(
    numbering: "1",
    table(
      columns: (1fr, 2fr),
      [Tipologia Dato], [Valore],
      [Codice], [RP1],
      [Nome], [Problematiche personali o attività universitarie],
      [Descrizione],
      [Considerando la partecipazione dei membri del Gruppo ad altri corsi universitari concomitanti a Ingegneria del
        Software, si prevedono possibili indisponibilità temporanee dovute al relativo carico di lavoro. Non si
        escludono, inoltre, impegni di natura extra-accademica.],

      [Mitigazione],
      [Il membro interessato dovrà notificare tempestivamente al gruppo l'impedimento, fornendo una stima della sua
        durata. Qualora necessario, il carico di lavoro assegnatogli verrà redistribuito agli altri componenti. Al
        termine dell'indisponibilità, sarà cura del membro recuperare le ore perse.],

      [Probabilità], [Media],
      [Impatto prestazionale], [Medio],
    ),
    caption: [Problematiche personali o attività universitarie],
  )<tab:RP1>

  = Pianificazione nel lungo termine <pianificazione_lungo_termine>

  Come anticipato nella #link(
    "https://notipswe.github.io/RepoDocumentale/docs/11-candidatura/docest/dichiarazione_impegni.pdf",
  )[Dichiarazione degli impegni v1.0.0], e alla luce del ritardo accumulato durante la fase di RTB, il gruppo ha
  aggiornato la pianificazione e prevede di terminare il progetto entro il giorno *13 Aprile 2026*, mantenendo un budget
  di spesa fissato a *12.940 Euro*.\
  Al momento della candidatura si è teorizzato la seguente previsione dei costi: #figure(
    numbering: "1",
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [61], [1830],
      [Amministratore], [60], [1200],
      [Analista], [80], [2000],
      [Progettista], [137], [3425],
      [Programmatore], [165], [2475],
      [Verificatore], [134], [2010],
      [*Totale*], [*637*], [*12940*],
    ),
    caption: [Ore e costo per ciascun ruolo, e preventivo finale alla candidatura],
  )<tab:costi>

  La revisione per la Requirements and Technology Baseline (RTB) è avvenuta il 2 Marzo
  2026.
  Superata la Requirements and Technology Baseline (RTB), all’avvio della Product Baseline (PB), il gruppo ha deciso di
  ridistribuire le ore disponibili per ottimizzare l’allocazione delle risorse in vista delle attività previste. La
  nuova ripartizione è riportata nella tabella seguente:

  #figure(
    numbering: "1",
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [51], [1530],
      [Amministratore], [64], [1280],
      [Analista], [80], [2000],
      [Progettista], [141], [3525],
      [Programmatore], [167], [2505],
      [Verificatore], [140], [2100],
      [*Totale*], [*643*], [*12940*],
    ),
    caption: [Ore e costo per ciascun ruolo, e preventivo finale post ridistribuzione per la PB],
  )<tab:costi-ridistribuzione>

  == Attività fissate per la Requirements and Technology Baseline (RTB)

  === Redazione analisi dei requisiti (AdR)
  #table(
    columns: (0.25fr, 0.25fr),
    table.header(
      table.cell(align: center)[*Attività*],
      table.cell(align: center)[*Periodo*],
    ),
    [
      - Parte introduttiva
      - Casi d'Uso relativi a requisiti funzionali
      - Casi d'Uso relativi a requisiti non funzionali
      - Tracciamento requisiti - fonte
    ],
    [
      - Sprint 1
      - Sprint 2
      - Sprint 3
      - Sprint 4
      - Sprint 5
    ],
    table.cell(colspan: 2, align: center)[*Completato per RTB*],
  )
  === Redazione norme di progetto (NdP)
  #table(
    columns: (0.25fr, 0.25fr),
    table.header(
      table.cell(align: center)[*Attività*],
      table.cell(align: center)[*Periodo*],
    ),
    [
      - Parte introduttiva
      - Processi primari, di supporto e organizzativi
      - Metriche di qualità utilizzate
    ],
    [
      - Sprint 1
      - Sprint 2
      - Sprint 3
      - Sprint 4
      - Sprint 5
      - Sprint 6
    ],
    table.cell(colspan: 2, align: center)[*Completato per RTB*],
  )


  === Redazione piano di progetto (PdP)
  #table(
    columns: (0.25fr, 0.25fr),
    table.header(
      table.cell(align: center)[*Attività*],
      table.cell(align: center)[*Periodo*],
    ),
    [
      - Parte introduttiva
      - Analisi e gestione dei Rischi
      - Pianificazione a lungo termine
      - Pianificazione a breve termine
      - Descrizione degli Sprint
    ],
    [

      - Sprint 2
      - Sprint 3
      - Sprint 4
      - Sprint 5
      - Sprint 6
    ],
    table.cell(colspan: 2, align: center)[*Completato per RTB*],
  )


  === Redazione piano di qualifica (PdQ)
  #table(
    columns: (0.25fr, 0.25fr),
    table.header(
      table.cell(align: center)[*Attività*],
      table.cell(align: center)[*Periodo*],
    ),
    [
      - Parte introduttiva
      - Processi primari, di supporto e organizzativi
      - Metriche di qualità di processo
      - Metriche di qualità di prodotto
      - Metodi di testing
      - Cruscotto di valutazione
    ],
    [
      - Sprint 2
      - Sprint 3
      - Sprint 4
      - Sprint 5
      - Sprint 6
    ],
    table.cell(colspan: 2, align: center)[*Completato per RTB*],
  )


  === Redazione glossario
  #table(
    columns: (0.25fr, 0.25fr),
    table.header(
      table.cell(align: center)[*Attività*],
      table.cell(align: center)[*Periodo*],
    ),
    [
      - Termini
    ],
    [
      - Tutti gli sprint
    ],
    table.cell(colspan: 2, align: center)[*Completato per RTB*],
  )

  === Realizzazione del proof of concept
  #table(
    columns: (0.25fr, 0.25fr),
    table.header(
      table.cell(align: center)[*Attività*],
      table.cell(align: center)[*Periodo*],
    ),
    [
      - Test delle tecnologie:
        - Golang;
        - NATS;
        - Docker;
      - Test di sincronizzazione.
    ],
    [
      - Sprint 4
      - Sprint 5
      - Sprint 6
      - Sprint 7

    ],
    table.cell(colspan: 2, align: center)[*Completato per RTB*],
  )


  == Attività fissate per la Product Baseline (PB)
  Al termine della fase di RTB, preso atto del ritardo accumulato, il gruppo ha rivisto la pianificazione a lungo
  termine della seconda parte, estendendola fino al dodicesimo sprint con l’obiettivo di portare a termine il progetto.
  Di seguito sono riportate le attività previste per la fase di PB, suddivise per argomento.
  === Correzione errori nei documenti segnalati
  #figure(
    align(left)[
      #table(
        columns: (0.25fr, 0.25fr),
        align: (left, left),
        table.header(
          table.cell(align: center)[*Attività*],
          table.cell(align: center)[*Periodo*],
        ),
        [
          - Correzione posizione lettera di presentazione.
          - Eliminazione changelog dai verbali nella versione ufficiale.
          - Correzione AdR:
            - Correzione documenti normativi e informativi;
            - Correzione Use-case;
            - Correzione Piano di Progetto;
            - Correzione requisiti.
        ],
        [
          - Sprint 8
        ],
        table.cell(colspan: 2, align: center)[*Completato per PB*],
      )
    ],
  )<tab:Correzione-RTB>

  === Redazione TestBook
  #table(
    columns: (0.25fr, 0.25fr),
    table.header(
      table.cell(align: center)[*Attività*],
      table.cell(align: center)[*Periodo*],
    ),
    [
      - Definizione struttura del documento
      - Descrizione ambiente di esecuzione dei test
      - Elenco e descrizione dei test di integrazione e sistema
      - Procedura di esecuzione e verifica dei risultati
    ],
    [
      - Sprint 12
    ],
    table.cell(colspan: 2, align: center)[*Completato per PB*],
  )

  === Redazione manuali
  #table(
    columns: (0.25fr, 0.25fr),
    table.header(
      table.cell(align: center)[*Attività*],
      table.cell(align: center)[*Periodo*],
    ),
    [
      - Redazione manuale utente
        - Descrizione funzionalità del sistema
      - Redazione manuale admin
        - Descrizione funzionalità del sistema
      - Redazione manuale client api
        - Descrizione API esposte dal sistema
        - Descrizione procedura di implementazione libreria dedicata a decrittazione dati
      - Redazione manuale infrastruttura
        - Descrizione procedura di deploy del sistema
        - Inserimento sezione di monitoring tramite Grafana
    ],
    [
      - Sprint 10
      - Sprint 11
      - Sprint 12
    ],
    table.cell(colspan: 2, align: center)[*Completato per PB*],
  )

  === Redazione specifiche tecniche
  #table(
    columns: (0.25fr, 0.25fr),
    table.header(
      table.cell(align: center)[*Attività*],
      table.cell(align: center)[*Periodo*],
    ),
    [
      - Redazione specifica tecnica data-api
      - Redazione specifica tecnica management-api
      - Redazione specifica tecnica data-consumer
      - Redazione specifica tecnica simulator-backend e sim-cli
      - Redazione specifica tecnica \@notip/cryptp-sdk
      - Redazione specifica tecnica WebApp Frontend
      - Redazione specifica tecnica provisioning-service
      - Redazione specifica tecnica generale

    ],
    [
      - Sprint 10
      - Sprint 11
      - Sprint 12
    ],
    table.cell(colspan: 2, align: center)[*Completato per PB*],
  )

  === Aggiornamento analisi dei requisiti (AdR)
  #table(
    columns: (0.25fr, 0.25fr),
    table.header(
      table.cell(align: center)[*Attività*],
      table.cell(align: center)[*Periodo*],
    ),
    [
      - Aggiornamento Casi d'Uso effettivamente realizzati
      - Aggiornamento requisiti funzionali e non funzionali
      - Automatizzazione tracciamento requisiti, creazione e numerazione Casi d'Uso
    ],
    [
      - Sprint 10
      - Sprint 12
    ],
    table.cell(colspan: 2, align: center)[*Completato per PB*],
  )
  === Redazione norme di progetto (NdP)
  #table(
    columns: (0.25fr, 0.25fr),
    table.header(
      table.cell(align: center)[*Attività*],
      table.cell(align: center)[*Periodo*],
    ),
    [
      - Parte introduttiva
      - Processi primari, di supporto e organizzativi
      - Metriche di qualità utilizzate
    ],
    [
      - Sprint 7
      - Sprint 8
      - Sprint 10
      - Sprint 11
      - Sprint 12
    ],
    table.cell(colspan: 2, align: center)[*Completato per PB*],
  )


  === Redazione piano di progetto (PdP)
  #table(
    columns: (0.25fr, 0.25fr),
    table.header(
      table.cell(align: center)[*Attività*],
      table.cell(align: center)[*Periodo*],
    ),
    [
      - Descrizione degli Sprint
    ],
    [

      -Tutti gli sprint
    ],
    table.cell(colspan: 2, align: center)[*Completato per PB*],
  )


  === Redazione piano di qualifica (PdQ)
  #table(
    columns: (0.25fr, 0.25fr),
    table.header(
      table.cell(align: center)[*Attività*],
      table.cell(align: center)[*Periodo*],
    ),
    [
      - Inserimento metriche di qualità di processo e di prodotto
      - Inserimento test di unità, integrazione e sistema
    ],
    [
      - Sprint 10
      - Sprint 11
      - Sprint 12
    ],
    table.cell(colspan: 2, align: center)[*Completato per PB*],
  )

  === Redazione glossario
  #table(
    columns: (0.25fr, 0.25fr),
    table.header(
      table.cell(align: center)[*Attività*],
      table.cell(align: center)[*Periodo*],
    ),
    [
      - Termini
    ],
    [
      - Tutti gli sprint
    ],
    table.cell(colspan: 2, align: center)[*Completato per PB*],
  )

  === Realizzazione Minimum Viable Product (MVP)
  #table(
    columns: (0.25fr, 0.25fr),
    table.header(
      table.cell(align: center)[*Attività*],
      table.cell(align: center)[*Periodo*],
    ),
    [
      - Definizione e consolidamento dell'architettura
      - Implementazione dei componenti principali del sistema
      - Integrazione tra i componenti
      - Validazione del MVP
    ],
    [
      - Sprint 7
      - Sprint 8
      - Sprint 9
      - Sprint 10
      - Sprint 11
      - Sprint 12
    ],
    table.cell(colspan: 2, align: center)[*Completato per PB*],
  )

  = Pianificazione nel breve termine
  == Introduzione
  Il gruppo NoTIP ha deciso di adottare un approccio Agile per tutta la durata del progetto, suddividendo inizialmente
  lo sviluppo in sprint di due settimane. A partire dallo Sprint 9, la durata degli sprint è stata ridotta a una
  settimana, al fine di aumentare la frequenza di pianificazione e monitoraggio delle attività. Il gruppo si impegna a
  definire, all'inizio di ogni periodo, la pianificazione delle settimane successive e una rotazione dei ruoli coerente,
  mantenendo la flessibilità necessaria per eventuali cambiamenti organizzativi.

  Il gruppo si impegna, inoltre, a concordare incontri settimanali con la proponente (M31) per ricevere feedback su
  quanto realizzato e favorire momenti di brainstorming collettivo, garantendo scelte di sviluppo ottimali.
  Complessivamente, il metodo Agile è stato considerato efficace per completare il progetto nei tempi stabiliti,
  assicurando che il prodotto finale sia conforme alle aspettative della proponente.

  La descrizione dei vari periodi è divisa nel seguente modo:
  - Informazioni generali e attività pianificate;
  - Prospetto del consumo di tempo e dei costi;
  - Rischi attesi;
  - Consumo di tempo e costi effettivo;
  - Rischi incontrati e misure correttive attuate;
  - Retrospettiva;
  - Aggiornamento risorse rimanenti.

  == Requirements and Technology Baseline (RTB)
  === Sprint 1
  Inizio: *2025-11-16* \
  Fine prevista: *2025-11-29* \
  Fine reale: *2025-11-29* \
  Giorni di ritardo: *0* \

  ==== Informazioni generali e attività pianificate
  In questo periodo il Gruppo ha lavorato in modo sparso, ma comunque organizzato, con l'obiettivo di risolvere i
  problemi sorti durante il periodo di candidatura.

  In particolare, le attività fissate in questo periodo sono:
  - Aggiornamento sito del gruppo.
  - Modifica e finalizzazione sistema di versionamento dei documenti.
  - Sistemazione template dei documenti Typst.
  - Prima stesura del Glossario.
  - Prima stesura delle Norme di Progetto.
  - Stabilire programma incontri con l'azienda proponente M31.
  - Inizio stesura Analisi dei requisiti.
  - Trasferimento del workflow da GitHub Projects a Jira di Atlassian

  ==== Ore previste
  A seguito di una mancanza di organizzazione delle ore previste, il gruppo non ha lavorato nella maniera corretta, per
  questo si potrebbe vedere uno squilibrio nelle ore effettive. Il gruppo nel prossimo Sprint si impegnerà ad
  organizzarsi e rispettare le ore previste.

  ==== Possibili rischi
  Il gruppo pensa sia possibile che possano presentarsi i seguenti rischi:
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.
  - RT1: Rischio legato all'apprendimento delle tecnologie richieste.


  ==== Ore effettive
  #figure(
    numbering: "1",
    caption: [Sprint 1 - Ore effettive per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [4], [-], [-], [-], [-], [2], [*6*],
        [Francesco \ Marcon], [-], [4,5], [-], [-], [-], [2,25], [*6,75*],
        [Alessandro \ Mazzariol], [-], [2], [-], [-], [-], [3], [*5*],
        [Leonardo \ Preo], [-], [-], [2], [-], [-], [0,5], [*2,5*],
        [Valerio \ Solito], [-], [-], [-], [-], [-], [-], [*0*],
        [Matteo \ Mantoan], [-], [4], [-], [-], [-], [1,25], [*5,25*],
        [Mario De\ Pasquale], [-], [-], [1,5], [-], [-], [1], [*2,5*],
      )
    ],
  )<tab:Sprint1-ore-effettive>

  ==== Consuntivo del periodo
  Durante questo sprint il gruppo ha avuto difficoltà nel capire come organizzare il lavoro tra i vari componenti e,
  come si può evincere dalla @tab:Sprint1-ore-effettive, ci sono componenti che non hanno impiegato più di un'ora nel
  fare le mansioni, questo sia a causa del rischio *RP1*, sia per l'inesperienza generale.

  ==== Retrospettiva
  Questo Sprint è stato dedicato nel risolvere questioni importanti come il trasferimento del workflow su Jira, e la
  prima stesura dei documenti più importanti. Tutte le attività previste sono state comunque eseguite senza ritardi.

  ==== Misure correttive e aggiornamento dei rischi
  Per mitigare gli squilibri emersi nella distribuzione del lavoro, il Team ha deciso di definire con maggiore
  precisione la suddivisione delle task e il monte ore individuale del successivo sprint. I rischi RP1 e RT1 rimangono
  attivi e monitorati, poiché l'esperienza limitata del gruppo e gli impegni personali possono continuare a incidere
  sull'andamento delle attività.

  ==== Aggiornamento pianificazione futura
  Nel prossimo sprint il gruppo prevede di consolidare il workflow adottato, migliorare la pianificazione delle ore e
  proseguire con la stesura dei documenti avviati, così da rendere più regolare l'avanzamento complessivo del progetto.

  ==== Preventivo a finire
  #figure(
    numbering: "1",
    caption: [Sprint 1 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [57], [1710],
      [Amministratore], [49,5], [990],
      [Analista], [76,5], [1912,5],
      [Progettista], [137], [3425],
      [Programmatore], [165], [2475],
      [Verificatore], [124], [1860],
      [*Totale*], [*609*], [*12372,5*],
    ),
  )<tab:Sprint1-costi>



  === Sprint 2
  Inizio: *2025-12-02* \
  Fine prevista: *2025-12-14* \
  Fine reale: *2025-12-15* \
  Giorni di ritardo: *1*\

  ==== Informazioni generali e attività pianificate
  In questo sprint il gruppo, rispetto al periodo precedente, si è suddiviso equamente le task.

  In particolare, le attività fissate in questo periodo sono:
  - Prima stesura Piano di Progetto (PdP).
  - Continuazione delle Norme di Progetto (NdP).
  - Continuazione Analisi dei Requisiti (AdR).
  - Prima stesura Piano di Qualifica (PdQ)

  ==== Ore previste
  #figure(
    numbering: "1",
    caption: [Sprint 2 - Ore previste per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [-], [4], [4], [-], [-], [-], [*8*],
        [Francesco \ Marcon], [-], [3], [1], [-], [-], [2], [*6*],
        [Alessandro \ Mazzariol], [6], [-], [-], [-], [-], [1], [*7*],
        [Leonardo \ Preo], [-], [-], [5], [-], [-], [3], [*8*],
        [Valerio \ Solito], [-], [-], [3], [-], [-], [4], [*7*],
        [Matteo \ Mantoan], [-], [5], [-], [-], [-], [3], [*8*],
        [Mario De\ Pasquale], [-], [3], [1], [-], [-], [-], [*4*],
      )
    ],
  )<tab:Sprint2-ore-previste>

  ==== Possibili rischi
  Il gruppo pensa sia possibile che possano presentarsi i seguenti rischi:
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.
  - RT1: Rischio legato all'apprendimento delle tecnologie richieste.
  - RO1: Mancato rispetto delle scadenze stabilite.

  ==== Ore effettive
  #figure(
    numbering: "1",
    caption: [Sprint 2 - Ore effettive per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [-], [4], [3,5], [-], [-], [-], [*7,5*],
        [Francesco \ Marcon], [-], [3,25], [1], [-], [-], [2,5], [*6,75*],
        [Alessandro \ Mazzariol], [6], [-], [-], [-], [-], [1], [*7*],
        [Leonardo \ Preo], [-], [-], [4,5], [-], [-], [3], [*7,5*],
        [Valerio \ Solito], [-], [-], [3], [-], [-], [4], [*7*],
        [Matteo \ Mantoan], [-], [5], [-], [-], [-], [2,5], [*7,5*],
        [Mario De\ Pasquale], [-], [3,5], [1,5], [-], [-], [-], [*5*],
      )
    ],
  )<tab:Sprint2-ore-effettive>
  ==== Consuntivo del periodo
  Rallentamento nello sviluppo dell'Analisi dei Requisiti (RT1).

  ==== Retrospettiva
  Questo Sprint è servito al gruppo per attuare in maniera concreta il workflow idealizzato. Il Gruppo tuttavia ha
  dovuto affrontare modifiche importanti per quanto riguarda l'#link(
    "https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/analisi_requisiti.pdf",
  )[Analisi dei Requisiti v1.1.0] che hanno causato un rinvio al prossimo Sprint del raggiungimento della versione
  *0.3.0* e *0.4.0*.

  ==== Misure correttive e aggiornamento dei rischi
  Per contenere gli effetti del rallentamento sull'Analisi dei Requisiti, il Team ha deciso di riallocare parte del
  lavoro documentale sullo sprint successivo e di monitorare più da vicino le attività soggette a maggiore incertezza. I
  rischi RP1, RT1 e RO1 rimangono quindi aperti, con particolare attenzione alle attività di analisi e al rispetto delle
  scadenze interne.

  ==== Aggiornamento pianificazione futura
  La pianificazione futura prevede il completamento delle sezioni dell'Analisi dei Requisiti rinviate e il
  consolidamento del workflow documentale introdotto in questo periodo, in modo da recuperare lo scostamento emerso.

  ==== Preventivo a finire
  #figure(
    numbering: "1",
    caption: [Sprint 2 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [51], [1530],
      [Amministratore], [33,75], [675],
      [Analista], [63], [1575],
      [Progettista], [137], [3425],
      [Programmatore], [165], [2475],
      [Verificatore], [111], [1665],
      [*Totale*], [*560,75*], [*11345*],
    ),
  )<tab:Sprint2-costi>
  === Sprint 3
  Inizio: *2025-12-16* \
  Fine prevista: *2025-12-28* \
  Fine reale: *2026-01-04*\
  Giorni di ritardo: 0\

  ==== Informazioni generali e attività pianificate
  Le attività fissate per questo Sprint sono:
  - Analisi dei requisiti: casi d'uso da finire, iniziare la stesura dei requisiti.
  - Norme di Progetto: set di cambiamenti di NT-67; realizzare le seguenti sezioni: processo di fornitura, processo di
    sviluppo, processo di gestione della configurazione, metriche (citate nel _PdQ_).
  - Piano di Qualifica: metriche da rivedere e confermare, cruscotto di valutazione, metodi di testing da iniziare
    (qualora avanzasse tempo).
  - Piano di Progetto: Sprint 2 da aggiornare, stesura della sezione dello Sprint 3 , rischi da aggiornare.
  ==== Ore previste
  #figure(
    numbering: "1",
    caption: [Sprint 3 - Ore previste per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [-], [-], [4], [-], [-], [4], [*8*],
        [Francesco \ Marcon], [4], [-], [4], [-], [-], [-], [*8*],
        [Alessandro \ Mazzariol], [-], [4,5], [-], [-], [-], [2], [*6,5*],
        [Leonardo \ Preo], [-], [3], [5,5], [-], [-], [], [*8,5*],
        [Valerio \ Solito], [-], [-], [7], [-], [-], [1,5], [*8,5*],
        [Matteo \ Mantoan], [-], [3], [7], [-], [-], [-], [*10*],
        [Mario De\ Pasquale], [-], [-], [5], [-], [-], [3,5], [*8,5*],
      )
    ],
  )<tab:Sprint3-ore-previste>
  ==== Possibili rischi
  Il gruppo pensa sia possibile che possano presentarsi i seguenti rischi:
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.
  - RT1: Rischio legato all'apprendimento delle tecnologie richieste.
  - RO1: Mancato rispetto delle scadenze stabilite.
  ==== Ore effettive
  #figure(
    numbering: "1",
    caption: [Sprint 3 - Ore effettive per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [-], [-], [3,75], [-], [-], [4], [*7,75*],
        [Francesco \ Marcon], [4], [-], [3,5], [-], [-], [-], [*7,5*],
        [Alessandro \ Mazzariol], [-], [4,5], [-], [-], [-], [2], [*6,5*],
        [Leonardo \ Preo], [-], [3], [5,5], [-], [-], [-], [*8,5*],
        [Valerio \ Solito], [-], [-], [7], [-], [-], [2], [*9*],
        [Matteo \ Mantoan], [-], [3], [7,25], [-], [-], [-], [*10,25*],
        [Mario De\ Pasquale], [-], [-], [5], [-], [-], [4], [*9*],
      )
    ],
  )<tab:Sprint3-ore-effettive>
  ==== Consuntivo del periodo
  A causa delle festività natalizie, si è deciso di estendere la durata dello sprint a tre settimane. Per questo motivo
  risultano 0 giorni di ritardo, nonostante la data di fine prevista differisca da quella effettiva (RO1). (RP1)
  L’Analisi dei Requisiti si è rivelata più complessa del previsto; di conseguenza, sono state dedicate numerose ore di
  “palestra” a questa attività. (RT1)
  ==== Retrospettiva
  In questo sprint il lavoro del gruppo si è focalizzato sull'Analisi dei Requisiti, portando alla definizione di una
  grande quantità di Use Case e di parte dei requisiti. Per quanto riguarda gli altri documenti, in particolare il Piano
  di Progetto, le attività sono proseguite regolarmente; sono state inoltre sviluppate alcune sezioni delle Norme di
  Progetto e riviste le metriche del Piano di Qualifica. Non tutti gli obiettivi prefissati sono stati raggiunti, ma si
  prevede di completarli nei prossimi sprint.
  ==== Misure correttive e aggiornamento dei rischi
  In risposta alle difficoltà emerse, il Team ha accettato una rimodulazione temporale dello sprint dovuta alle
  festività e ha mantenuto alta l'attenzione sui rischi RP1, RT1 e RO1. Per il periodo successivo si è deciso di
  concentrare l'impegno sul completamento dell'Analisi dei Requisiti, riducendo la dispersione su attività secondarie.

  ==== Aggiornamento pianificazione futura
  Lo sprint successivo sarà dedicato in via prioritaria alla chiusura delle parti ancora aperte dell'Analisi dei
  Requisiti e all'avvio più strutturato delle attività progettuali, con aggiornamento continuo del Piano di Progetto.

  ==== Preventivo a finire
  #figure(
    numbering: "1",
    caption: [Sprint 3 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [47], [1410],
      [Amministratore], [23,25], [465],
      [Analista], [31], [775],
      [Progettista], [137], [3425],
      [Programmatore], [165], [2475],
      [Verificatore], [99], [1485],
      [*Totale*], [*502,25*], [*10035*],
    ),
  )<tab:Sprint3-costi>


  === Sprint 4
  Inizio: *2026-01-05* \
  Fine prevista: *2026-01-18* \
  Fine reale: *2026-01-18*\
  Giorni di ritardo: 0\

  ==== Informazioni generali e attività pianificate
  In questo Sprint il Gruppo si concentrerà sull'Analisi dello Stato dell'Arte e sulla fase progettuale del PoC (che non
  risulterà nelle ore effettive o previste, essendo ore di palestra), e sull'ultimare l'Analisi dei Requisiti. Inoltre,
  si prevede l'aggiornamento e l'aggiunta delle sezioni dedicate allo sprint 3 e 4 del _Piano di Progetto_.

  ==== Ore previste
  #figure(
    numbering: "1",
    caption: [Sprint 4 - Ore previste per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [-], [-], [3], [-], [-], [3], [*6*],
        [Francesco \ Marcon], [-], [-], [4], [-], [-], [1], [*5*],
        [Alessandro \ Mazzariol], [-], [9], [-], [-], [-], [-], [*9*],
        [Leonardo \ Preo], [3], [-], [-], [-], [-], [], [*3*],
        [Valerio \ Solito], [-], [3], [4], [-], [-], [], [*7*],
        [Matteo \ Mantoan], [-], [-], [-], [-], [-], [-], [*0*],
        [Mario De\ Pasquale], [-], [-], [3,5], [-], [-], [6,5], [*10*],
      )
    ],
  )<tab:Sprint4-ore-previste>

  ==== Possibili rischi
  Il gruppo pensa sia possibile che possano presentarsi i seguenti rischi:
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.
  - RT1: Rischio legato all'apprendimento delle tecnologie richieste.
  - RO1: Mancato rispetto delle scadenze stabilite.

  ==== Ore effettive
  #figure(
    numbering: "1",
    caption: [Sprint 4 - Ore effettive per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [-], [-], [3], [-], [-], [3,5], [*6,5*],
        [Francesco \ Marcon], [-], [-], [4], [-], [-], [1], [*5*],
        [Alessandro \ Mazzariol], [-], [-], [9], [-], [-], [-], [*9*],
        [Leonardo \ Preo], [4], [-], [-], [-], [-], [-], [*4*],
        [Valerio \ Solito], [-], [3], [4], [-], [-], [-], [*7*],
        [Matteo \ Mantoan], [-], [-], [-], [-], [-], [-], [*0*],
        [Mario De\ Pasquale], [-], [-], [3], [-], [-], [6,5], [*9,5*],
      )
    ],
  )<tab:Sprint4-ore-effettive>



  ==== Consuntivo del periodo
  In seguito ad un incontro con il Prof. Cardin e, successivamente con l'azienda, sono stati rivisti molti Use Case,
  sicuramente frutto dell'inesperienza del gruppo nell'analizzare correttamente il capitolato (RT1). Inoltre, dato
  l'inizio della sessione d'esami invernale, il lavoro ha subito alcuni rallentamenti (RP1).
  ==== Retrospettiva
  Nel corso di questo Sprint il Team si è concentrato sugli obiettivi stabiliti. Sebbene diversi membri abbiano
  registrato un numero inferiore di ore, a causa dell’attenzione dedicata all’analisi dello stato dell’arte e al Proof
  of Concept (POC), gli obiettivi prefissati sono stati comunque raggiunti senza ritardi significativi.
  ==== Misure correttive e aggiornamento dei rischi
  A fronte delle revisioni apportate ai casi d'uso e dell'avvio della sessione d'esami, il Team ha deciso di mantenere
  sotto osservazione i rischi RT1, RP1 e RO1, prevedendo maggiore confronto interno e momenti di riallineamento con i
  riferimenti esterni quando necessario. Le attività di palestra continueranno a supportare la comprensione del dominio
  e della soluzione progettuale.

  ==== Aggiornamento pianificazione futura
  Per lo sprint successivo è previsto il completamento dell'Analisi dei Requisiti e l'avanzamento del PoC, così da
  arrivare con una base più solida alle attività preparatorie per la RTB.

  ==== Preventivo a finire
  #figure(
    numbering: "1",
    caption: [Sprint 4 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [43], [1290],
      [Amministratore], [20,25], [405],
      [Analista], [8], [200],
      [Progettista], [137], [3425],
      [Programmatore], [165], [2475],
      [Verificatore], [88], [1320],
      [*Totale*], [*461,25*], [*9115*],
    ),
  )<tab:Sprint4-costi>

  === Sprint 5
  Inizio: *2026-01-19* \
  Fine prevista: *2026-02-01* \
  Fine reale: *2026-02-03*\
  Giorni di ritardo: 2\

  ==== Informazioni generali e attività pianificate
  In questo Sprint, il Team si concentrerà sulla fase di programmazione del PoC e sulla verifica/approvazione
  dell'Analisi dei Requisiti al fine di assicurarsi la piena completezza del documento per la revisione RTB. Inoltre, si
  porterà avanti il Piano di Qualifica, aggiungendo una sezione dedicata ai test, le Norme di Progetto e il Piano di
  Progetto, completando e aggiungendo la sezione dedicata allo Sprint 4 e 5.
  ==== Ore previste
  #figure(
    numbering: "1",
    caption: [Sprint 5 - Ore previste per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [-], [2], [-], [-], [6], [-], [*8*],
        [Francesco \ Marcon], [-], [-], [-], [-], [8], [-], [*8*],
        [Alessandro \ Mazzariol], [-], [-], [-], [-], [5], [3], [*8*],
        [Leonardo \ Preo], [-], [2], [-], [-], [3], [6], [*11*],
        [Valerio \ Solito], [-], [5], [-], [-], [1], [2], [*8*],
        [Matteo \ Mantoan], [-], [-], [-], [-], [6], [2], [*8*],
        [Mario De\ Pasquale], [7], [3], [-], [-], [2], [-], [*12*],
      )
    ],
  )<tab:Sprint5-ore-previste>
  ==== Possibili rischi
  Il gruppo pensa sia possibile che possano presentarsi i seguenti rischi:
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.
  - RT1: Rischio legato all'apprendimento delle tecnologie richieste.
  - RT2: Rischio tecnologico legato ad errori di programmazione.
  - RO1: Mancato rispetto delle scadenze stabilite.

  ==== Ore effettive
  #figure(
    numbering: "1",
    caption: [Sprint 5 - Ore effettive per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [-], [2], [-], [-], [6], [-], [*8*],
        [Francesco \ Marcon], [-], [-], [-], [-], [8], [-], [*8*],
        [Alessandro \ Mazzariol], [-], [-], [-], [-], [5], [3], [*8*],
        [Leonardo \ Preo], [-], [2], [-], [-], [3], [6], [*11*],
        [Valerio \ Solito], [-], [4], [-], [-], [1], [2], [*7*],
        [Matteo \ Mantoan], [-], [-], [-], [-], [6], [2], [*8*],
        [Mario De\ Pasquale], [7], [3], [-], [-], [2], [-], [*12*],
      )
    ],
  )<tab:Sprint5-ore-effettive>



  ==== Consuntivo del periodo
  Il Team ha speso ore di palestra nel comprendere come svolgere al meglio la fase di Progettazione e Programmazione del
  PoC (RT1 e RT2). Inoltre, dati gli esami universitari svolti in questo periodo, ci sono stati lievi rallentamenti nel
  lavoro da svolgere (RP1).
  ==== Retrospettiva
  Nello Sprint 5 anche se il gruppo ha incontrato alcuni rallentamenti, i compiti assegnati sono stati svolti. Anche in
  questo caso alcuni membri hanno meno ore registrate, perché hanno ultimato la progettazione del PoC.
  ==== Misure correttive e aggiornamento dei rischi
  Per ridurre l'impatto dei rallentamenti incontrati, il Team ha deciso di proseguire con attività di approfondimento
  tecnico sul PoC e di rafforzare la verifica interna delle attività di programmazione. I rischi RP1, RT1, RT2 e RO1
  restano monitorati, in quanto sia la fase tecnica sia il periodo universitario continuano a influenzare l'avanzamento.

  ==== Aggiornamento pianificazione futura
  Nel prossimo sprint il gruppo prevede di ultimare il PoC e di completare la documentazione necessaria alla RTB,
  sfruttando l'esperienza accumulata in questa fase di progettazione e sviluppo iniziale.

  ==== Preventivo a finire
  #figure(
    numbering: "1",
    caption: [Sprint 5 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [36], [1080],
      [Amministratore], [9,25], [185],
      [Analista], [8], [200],
      [Progettista], [137], [3425],
      [Programmatore], [134], [2010],
      [Verificatore], [75], [1125],
      [*Totale*], [*399,25*], [*8025*],
    ),
  )<tab:Sprint5-costi>

  === Sprint 6
  Inizio: *2026-02-04* \
  Fine prevista: *2026-02-17* \
  Fine reale: *2026-02-17*\
  Giorni di ritardo: 0 \

  ==== Informazioni generali e attività pianificate
  Per lo Sprint 6 il Team si è prefissato di ultimare il PoC, e di portare in avanti le norme di progetto e il piano di
  qualifica, affinché siano pronti per la RTB. Una volta che i documenti saranno stati ultimati verrà anche aggiornato
  il Glossario, aggiungendo così tutti i nuovi termini utilizzati. L'obiettivo è quello di ultimare e validare tutti i
  documenti (verbali, NdP, AdR, PdQ, PdP) finora stilati in vista della RTB.

  A causa dei vari impegni dei componenti del gruppo, causati principalmente dallo studio per alcuni esami, le ore a
  disposizione da dedicare al progetto sono sotto la media, ma comunque sufficienti per completare tutte le attività
  sopra citate.

  ==== Ore previste
  #figure(
    numbering: "1",
    caption: [Sprint 6 - Ore previste per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [2], [-], [-], [-], [-], [2], [*4*],
        [Francesco \ Marcon], [-], [-], [-], [-], [1], [5], [*6*],
        [Alessandro \ Mazzariol], [1], [1], [-], [-], [-], [3], [*5*],
        [Leonardo \ Preo], [-], [2], [-], [-], [3], [-], [*5*],
        [Valerio \ Solito], [5], [-], [-], [-], [-], [-], [*5*],
        [Matteo \ Mantoan], [-], [-], [-], [-], [-], [6], [*6*],
        [Mario De\ Pasquale], [2], [1], [-], [-], [-], [2], [*5*],
      )
    ],
  )<tab:Sprint6-ore-previste>
  ==== Possibili rischi
  Il gruppo pensa sia possibile che possano presentarsi i seguenti rischi:
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.
  - RT1: Rischio legato all'apprendimento delle tecnologie richieste.
  - RT2: Rischio tecnologico legato ad errori di programmazione.

  ==== Ore effettive
  #figure(
    numbering: "1",
    caption: [Sprint 6 - Ore effettive per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [2], [-], [-], [-], [-], [2], [*4*],
        [Francesco \ Marcon], [-], [-], [-], [-], [1], [5], [*6*],
        [Alessandro \ Mazzariol], [1], [1], [-], [-], [-], [3], [*5*],
        [Leonardo \ Preo], [-], [2], [-], [-], [3], [-], [*5*],
        [Valerio \ Solito], [5], [-], [-], [-], [-], [-], [*5*],
        [Matteo \ Mantoan], [-], [-], [-], [-], [-], [6], [*6*],
        [Mario De\ Pasquale], [2], [1], [-], [-], [-], [2], [*5*],
      )
    ],
  )<tab:Sprint6-ore-effettive>



  ==== Consuntivo del periodo
  Come preventivato, a causa degli impegni universitari dei componenti del Team, è stato difficile incastrare le ore di
  lavoro (RP1); tuttavia, tutti gli obiettivi prefissati sono stati raggiunti con successo.
  ==== Retrospettiva
  Nello Sprint 6, il Team si è concentrato principalmente sull'ultimare il PoC e sull'aggiornare i documenti in vista
  della RTB. Nonostante le ore dedicate siano state inferiori alla media, sono stati raggiunti tutti gli obiettivi
  prefissati.
  ==== Misure correttive e aggiornamento dei rischi
  Considerata la ridotta disponibilità oraria del periodo, il Team ha adottato una pianificazione più essenziale e
  focalizzata sugli obiettivi indispensabili per la RTB. Il rischio RP1 rimane quello maggiormente rilevante, mentre i
  rischi RT1 e RT2 risultano sotto controllo grazie al completamento delle attività previste e al consolidamento dei
  documenti prodotti.

  ==== Aggiornamento pianificazione futura
  La pianificazione successiva si concentrerà sulla revisione finale, verifica e approvazione dei documenti, oltre
  all'aggiornamento del Glossario, così da presentarsi alla RTB con una baseline documentale completa.

  ==== Preventivo a finire
  #figure(
    numbering: "1",
    caption: [Sprint 6 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [26], [780],
      [Amministratore], [5,25], [105],
      [Analista], [8], [200],
      [Progettista], [137], [3425],
      [Programmatore], [130], [1950],
      [Verificatore], [57], [855],
      [*Totale*], [*363,25*], [*7315*],
    ),
  )<tab:Sprint6-costi>

  === Sprint 7
  Inizio: *2026-02-18* \
  Fine prevista: *2026-03-04* \
  Fine reale: *2026-03-04*\
  Giorni di ritardo: 0 \

  ==== Informazioni generali e attività pianificate
  Nello Sprint 7, il Team si è focalizzato prioritariamente sulla revisione e approvazione dei documenti necessari alla
  RTB. Di conseguenza, il carico orario individuale risulta inferiore alla media generale delle fasi precedenti, essendo
  l'obiettivo principale il consolidamento del materiale già prodotto piuttosto che l'avanzamento tecnico su nuovi
  fronti.

  ==== Ore previste
  #figure(
    numbering: "1",
    caption: [Sprint 7 - Ore previste per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [-], [2], [0,75], [-], [-], [-], [*2,75*],
        [Francesco \ Marcon], [5], [0,25], [2,5], [-], [-], [-], [*7,75*],
        [Alessandro \ Mazzariol], [-], [1,5], [-], [-], [-], [3], [*4,5*],
        [Leonardo \ Preo], [-], [1], [-], [-], [-], [4,5], [*5,5*],
        [Valerio \ Solito], [-], [-], [-], [-], [5], [6], [*11*],
        [Matteo \ Mantoan], [-], [-], [4,25], [-], [-], [0,25], [*4,5*],
        [Mario De\ Pasquale], [-], [0,5], [-], [-], [4], [1,5], [*6*],
      )
    ],
  )<tab:Sprint7-ore-previste>
  ==== Possibili rischi
  Il gruppo pensa sia possibile che possano presentarsi i seguenti rischi:
  - RO1: Rischio organizzativo legato al mancato rispetto delle scadenze stabilite;
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.

  ==== Ore effettive
  #figure(
    numbering: "1",
    caption: [Sprint 7 - Ore effettive per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [-], [2], [0,75], [-], [-], [-], [*2,75*],
        [Francesco \ Marcon], [4], [0,25], [2,5], [-], [-], [-], [*6,75*],
        [Alessandro \ Mazzariol], [-], [1,5], [-], [-], [-], [3], [*4,5*],
        [Leonardo \ Preo], [-], [1], [-], [-], [-], [4,5], [*5,5*],
        [Valerio \ Solito], [-], [-], [-], [-], [5], [6], [*11*],
        [Matteo \ Mantoan], [-], [-], [4,25], [-], [-], [0,25], [*4,5*],
        [Mario De\ Pasquale], [-], [0,5], [-], [-], [4], [1,5], [*6*],
      )
    ],
  )<tab:Sprint7-ore-effettive>

  ==== Consuntivo del periodo
  Durante lo sprint corrente, il Team ha riscontrato delle criticità nel rispettare le tempistiche previste per la
  revisione RTB. Tali ritardi sono stati causati da difficoltà operative nel completamento e nella successiva
  approvazione della documentazione necessaria, determinando il verificarsi del rischio RO1 (Ritardo Operativo). La
  situazione è stata ulteriormente influenzata dalla concomitanza di sessioni d’esame per diversi membri del gruppo; la
  ridotta disponibilità oraria ha quindi portato all'insorgere del rischio RP1 (Indisponibilità dei Componenti),
  rendendo necessaria una ricalibrazione del carico di lavoro.
  ==== Retrospettiva
  Durante lo Sprint 7, l'attività si è concentrata sulla finalizzazione della documentazione per la RTB. Questa
  focalizzazione ha comportato l'esaurimento del monte ore allocato per il ruolo di Amministratore. Per sopperire alle
  necessità residue nelle fasi successive, il Team ha deliberato di attingere progressivamente alle ore ancora
  disponibili nei ruoli con maggiore margine residuo, a partire da quelle del Responsabile. La medesima logica verrà
  applicata anche alle limitate attività di analisi ancora aperte, così da assorbirle già nello Sprint successivo e
  garantire la copertura delle attività burocratiche, di coordinamento e di affinamento documentale senza intaccare il
  budget totale previsto per il progetto.

  ==== Misure correttive e aggiornamento dei rischi
  Per fronteggiare il verificarsi di RO1 e RP1, il Team ha riorganizzato il carico di lavoro e ha deliberato il
  riutilizzo delle ore residue del ruolo di Responsabile per coprire le esigenze amministrative ancora aperte. In
  continuità con questa decisione, dallo Sprint 8 le residue attività riconducibili al ruolo di Analista verranno
  considerate assorbite tramite riallocazione puntuale di ore provenienti dai ruoli in avanzo, mantenendo esplicita la
  tracciabilità del trasferimento da uno Sprint al successivo. I rischi legati alle scadenze e alla disponibilità dei
  componenti restano pertanto monitorati fino alla chiusura delle attività collegate alla RTB.

  ==== Aggiornamento pianificazione futura
  Conclusa la fase di preparazione alla RTB, il gruppo prevede di spostare progressivamente il focus verso la correzione
  delle osservazioni ricevute e l'avvio della progettazione tecnica del prodotto.

  ==== Preventivo a finire
  #figure(
    numbering: "1",
    caption: [Sprint 7 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [22], [660],
      [Amministratore], [0], [0],
      [Analista], [0,5], [12,5],
      [Progettista], [137], [3425],
      [Programmatore], [121], [1815],
      [Verificatore], [41,75], [626,25],
      [*Totale*], [*322,25*], [*6538,75*],
    ),
  )<tab:Sprint7-costi>
  #pagebreak()

  == Product Baseline (PB)
  Con la scelta di ridistribuire alcune ore residue del ruolo di Responsabile per aumentare il tempo dedicato alle
  attività di Amministrazione, Progettazione, Programmazione e Verifica, si è arrivati alla seguente distribuzione delle
  risorse rimanenti:

  #figure(
    numbering: "1",
    caption: [Sprint 7 - Variazione risorse monetarie rimanenti post ridistribuzione],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [12], [360],
      [Amministratore], [4], [80],
      [Analista], [0,5], [12,50],
      [Progettista], [141], [3525],
      [Programmatore], [123], [1845],
      [Verificatore], [47,75], [716,25],
      [*Totale*], [*328,25*], [*6538,75*],
    ),
  )<tab:Sprint7-costi-post-ridistribuzione>

  === Sprint 8
  Inizio: *2026-03-04* \
  Fine prevista: *2026-03-15* \
  Fine reale: *2026-03-15*\
  Giorni di ritardo: 0 \

  ==== Informazioni generali e attività pianificate
  In questo Sprint, il Team ha pianificato la correzione degli errori segnalati durante la revisione RTB; per l'elenco
  dettagliato dei documenti aggiornati, si faccia riferimento alla @tab:Correzione-RTB. Successivamente, l'attenzione si
  concentrerà sulla progettazione del prodotto mediante la stesura iniziale delle Specifiche Tecniche.

  ==== Ore previste
  #figure(
    numbering: "1",
    caption: [Sprint 8 - Ore previste per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [-], [-], [-], [4], [1], [1], [*6*],
        [Francesco \ Marcon], [-], [-], [-], [4], [1], [1], [*6*],
        [Alessandro \ Mazzariol], [-], [-], [-], [5], [1], [1], [*7*],
        [Leonardo \ Preo], [-], [-], [-], [4,5], [1], [1], [*6,5*],
        [Valerio \ Solito], [-], [-], [-], [2], [-], [1], [*3*],
        [Matteo \ Mantoan], [5], [-], [-], [2], [1,5], [1], [*9,5*],
        [Mario De\ Pasquale], [-], [-], [-], [6], [-], [-], [*6*],
      )
    ],
  )<tab:Sprint8-ore-previste>
  ==== Possibili rischi
  Il gruppo pensa sia possibile che possano presentarsi i seguenti rischi:
  - RO1: Rischio organizzativo legato al mancato rispetto delle scadenze stabilite;
  - RT1: Rischio legato all'apprendimento delle tecnologie richieste.

  ==== Ore effettive
  #figure(
    numbering: "1",
    caption: [Sprint 8 - Ore effettive per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [-], [-], [-], [4], [1], [1], [*6*],
        [Francesco \ Marcon], [-], [-], [-], [4], [1], [1], [*6*],
        [Alessandro \ Mazzariol], [-], [-], [-], [6], [1], [1], [*8*],
        [Leonardo \ Preo], [-], [-], [-], [5], [1], [1], [*7*],
        [Valerio \ Solito], [-], [-], [-], [3], [-], [1], [*4*],
        [Matteo \ Mantoan], [4], [-], [-], [2], [2], [1], [*9*],
        [Mario De\ Pasquale], [-], [-], [-], [7], [-], [-], [*7*],
      )
    ],
  )<tab:Sprint8-ore-effettive>

  ==== Consuntivo del periodo
  Durante lo sprint corrente, il Team si è ritrovato ad affrontare difficoltà nella progettazione del sistema, in
  particolare nella definizione dell'architettura dei singoli microservizi e nella stesura di un piano completo per la
  fase di implementazione. Queste sfide insieme ai ritardi accumulati nelle fasi precedenti hanno portato ad un mancato
  rispetto delle scadenze stabilite internamente, proiettando così il verificarsi del rischio RO1 (Ritardo Operativo).

  ==== Retrospettiva
  Al netto dei problemi descritti nella sezione precedente, lo Sprint 8 ha visto il Team immerso positivamente nella
  progettazione, portando ad avere anche grazie alle ore di palestra una visione del Sistema uniforme per tutti i
  membri. Tuttavia, è emersa la necessità di migliorare le ore produttive, al fine di rispettare le scadenze e
  recuperare il ritardo accumulato.

  ==== Misure correttive e aggiornamento dei rischi
  Per mitigare il rischio RO1 emerso durante la progettazione, il Team ha deciso di rafforzare il coordinamento interno
  e di mantenere attive le attività di palestra, così da uniformare la comprensione architetturale tra tutti i membri.
  Il rischio RT1 resta anch'esso monitorato, poiché la complessità progettuale del sistema richiede ulteriore
  consolidamento tecnico. Alla luce dell'assorbimento delle ultime attività amministrative e analitiche residue, il Team
  ha inoltre stabilito che, a partire dalla pianificazione dello Sprint 9, il carico di lavoro venga concentrato quasi
  esclusivamente sui ruoli tecnici ancora capienti. In questo modo il residuo dei ruoli di Amministratore e Analista
  potrà essere progressivamente assorbito negli sprint conclusivi, mantenendo la pianificazione complessiva coerente con
  le ore ancora disponibili.

  ==== Aggiornamento pianificazione futura
  Nei prossimi sprint la pianificazione verrà orientata verso una transizione più rapida dalla progettazione
  all'implementazione, includendo il recupero del ritardo accumulato e la definizione più precisa delle attività di
  sviluppo del MVP.

  ==== Preventivo a finire
  #figure(
    numbering: "1",
    caption: [Sprint 8 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [8], [240],
      [Amministratore], [4], [80],
      [Analista], [0,5], [12,50],
      [Progettista], [110], [2750],
      [Programmatore], [117], [1755],
      [Verificatore], [41,75], [626,25],
      [*Totale*], [*281,25*], [*5463,75*],
    ),
  )<tab:Sprint8-costi>

  === Sprint 9
  Inizio: *2026-03-16* \
  Fine prevista: *2026-03-22* \
  Fine reale: *2026-03-22*\
  Giorni di ritardo: 0 \

  ==== Informazioni generali e attività pianificate
  Da questo sprint in poi, il Team ha deciso di passare da periodi di 2 settimane a periodi di 1 settimana, al fine di
  aumentare il monte ore di lavoro svolto per periodo, permettendo il raggiungimento della quota ore nel tempo previsto.
  Alcune parti del Team in questo periodo sono passati dal progettare, alla codifica, iniziando con un periodo intenso
  di palestra.

  ==== Ore previste
  #figure(
    numbering: "1",
    caption: [Sprint 9 - Ore previste per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [1], [-], [-], [5], [3], [2], [*11*],
        [Francesco \ Marcon], [-], [-], [-], [6], [4], [1,25], [*11,25*],
        [Alessandro \ Mazzariol], [-], [-], [-], [6], [5], [-], [*11*],
        [Leonardo \ Preo], [-], [-], [-], [5], [4], [1], [*10*],
        [Valerio \ Solito], [-], [-], [-], [4], [5], [1], [*10*],
        [Matteo \ Mantoan], [-], [-], [-], [4], [5], [1], [*10*],
        [Mario De\ Pasquale], [-], [-], [-], [4], [4], [1], [*9*],
      )
    ],
  )<tab:Sprint9-ore-previste>
  ==== Possibili rischi
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.
  - RT1: Rischio legato all'apprendimento delle tecnologie richieste.
  - RT2: Rischio tecnologico legato ad errori di programmazione.

  ==== Ore effettive
  #figure(
    numbering: "1",
    caption: [Sprint 9 - Ore effettive per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [1], [-], [-], [6], [5], [2], [*14*],
        [Francesco \ Marcon], [-], [-], [-], [6], [4], [1,25], [*11,25*],
        [Alessandro \ Mazzariol], [-], [-], [-], [6], [5], [1], [*12*],
        [Leonardo \ Preo], [-], [-], [-], [7], [4], [1], [*12*],
        [Valerio \ Solito], [-], [-], [-], [4], [3], [1], [*8*],
        [Matteo \ Mantoan], [-], [-], [-], [4], [5], [1], [*10*],
        [Mario De\ Pasquale], [-], [-], [-], [4], [4], [1], [*9*],
      )
    ],
  )<tab:Sprint9-ore-effettive>

  ==== Consuntivo del periodo
  Durante lo Sprint corrente, il Team è ritrovato ad affrontare la complessità notevole che il Sistema presentava quindi
  il verificarsi di RT1 (Rischio tecnologico legato all'apprendimento delle tecnologie richieste), in particolare nella
  fase di implementazione. La difficoltà principale è stata quella di riuscire ad adattare la tecnologia richiesta alle
  esigenze del progetto, portando ad un aumento significativo del carico di lavoro di codifica. Durante le prime fasi di
  rilascio del codice, sono state implementate regole per diminuire il verificarsi di RT2 (Rischio tecnologico legato ad
  errori di programmazione), come ad esempio l'adozione di un sistema di code review automatico.
  ==== Retrospettiva
  In conclusione, il Team afferma che il periodo ha portato un miglioramento della qualità del lavoro svolto, grazie
  alla maggiore frequenza degli Sprint, che ha permesso di aumentare l'efficienza. Il Team tuttavia ha deciso di
  posticipare la consegna del MVP al 3 aprile 2026, al fine di poter avere il tempo necessario a completare le attività
  fissate.

  ==== Misure correttive e aggiornamento dei rischi
  Per rispondere alle difficoltà incontrate, il Team ha introdotto pratiche di verifica più strette durante il rilascio
  del codice e ha confermato il monitoraggio dei rischi RT1 e RT2, entrambi risultati rilevanti in questa fase di
  transizione verso l'implementazione. Il rischio RP1 rimane presente ma non ha compromesso in modo significativo il
  completamento delle attività pianificate.

  ==== Aggiornamento pianificazione futura
  La pianificazione futura prevede sprint brevi e ravvicinati, con priorità al completamento del MVP, alla
  stabilizzazione dell'infrastruttura e all'aumento della produttività complessiva del Team entro la nuova scadenza
  interna fissata.

  ==== Preventivo a finire
  #figure(
    numbering: "1",
    caption: [Sprint 9 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [7], [210],
      [Amministratore], [4], [80],
      [Analista], [0,5], [12,50],
      [Progettista], [73], [1825],
      [Programmatore], [87], [1305],
      [Verificatore], [33,5], [502,50],
      [*Totale*], [*205*], [*3935*],
    ),
  )<tab:Sprint9-costi>



  === Sprint 10
  Inizio: *2026-03-23* \
  Fine prevista: *2026-03-29* \
  Fine reale: *2026-03-29*\
  Giorni di ritardo: 0 \

  ==== Informazioni generali e attività pianificate
  In questo Sprint, il Team si è concentrato principalmente sulla fase di implementazione, con l'obiettivo di completare
  l'infrastruttura del sistema e di implementare i test necessari per garantire una qualità conforme del MVP.
  ==== Ore previste
  #figure(
    numbering: "1",
    caption: [Sprint 10 - Ore previste per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [-], [-], [-], [5], [3], [2], [*10*],
        [Francesco \ Marcon], [-], [-], [-], [5], [4], [1,5], [*10,5*],
        [Alessandro \ Mazzariol], [-], [-], [-], [4], [6], [1], [*11*],
        [Leonardo \ Preo], [-], [-], [-], [6], [4], [1], [*11*],
        [Valerio \ Solito], [-], [-], [-], [6], [3], [1], [*10*],
        [Matteo \ Mantoan], [2], [-], [-], [5], [3], [1], [*11*],
        [Mario De\ Pasquale], [-], [-], [-], [5], [5], [-], [*10*],
      )
    ],
  )<tab:Sprint10-ore-previste>
  ==== Possibili rischi
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.
  - RT1: Rischio legato all'apprendimento delle tecnologie richieste.
  - RT2: Rischio tecnologico legato ad errori di programmazione.

  ==== Ore effettive
  #figure(
    numbering: "1",
    caption: [Sprint 10 - Ore effettive per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [-], [-], [-], [6], [3], [2], [*11*],
        [Francesco \ Marcon], [-], [-], [-], [5], [4], [1,5], [*10,5*],
        [Alessandro \ Mazzariol], [-], [-], [-], [4], [6], [1], [*11*],
        [Leonardo \ Preo], [-], [-], [-], [6], [4], [1], [*11*],
        [Valerio \ Solito], [-], [-], [-], [6], [3], [1], [*10*],
        [Matteo \ Mantoan], [2], [-], [0,25], [5], [3], [1], [*11,25*],
        [Mario De\ Pasquale], [-], [-], [-], [4], [5], [-], [*9*],
      )
    ],
  )<tab:Sprint10-ore-effettive>

  ==== Consuntivo del periodo
  Nel corso dello Sprint 10, il Team ha portato avanti soprattutto le attività di implementazione e verifica del MVP,
  concentrandosi sul completamento dell'infrastruttura di sistema e sull'avanzamento dei test. Le attività pianificate
  sono state svolte con un impiego più mirato delle risorse rispetto al monte ore inizialmente previsto, privilegiando
  gli interventi tecnici ritenuti più urgenti per il consolidamento del prodotto.

  ==== Retrospettiva
  Lo Sprint 10 ha permesso al Team di consolidare in modo significativo l'avanzamento del MVP, con una buona
  progressione nella codifica e nella verifica dei microservizi di backend e con il proseguimento della progettazione
  delle componenti frontend. È emerso però che la fase di implementazione ha reso evidenti alcune complessità tecniche e
  infrastrutturali sottostimate in precedenza, in particolare nella comprensione operativa delle tecnologie adottate e
  nella stabilizzazione dell'infrastruttura di supporto ai test.

  ==== Misure correttive e aggiornamento dei rischi
  A seguito delle criticità emerse, il Team ha confermato il verificarsi di RT1 (Rischio tecnologico legato
  all'apprendimento delle tecnologie richieste), poiché alcune difficoltà si sono manifestate pienamente solo durante
  l'implementazione concreta del sistema. Parallelamente, per mitigare RT2 (Rischio tecnologico legato ad errori di
  programmazione), il gruppo ha intensificato le attività di verifica e consolidato il processo di integrazione tramite
  pull request di dimensioni ridotte, così da individuare più rapidamente eventuali difetti e ridurre il rischio di
  regressioni.

  ==== Aggiornamento pianificazione futura
  Alla luce di quanto osservato, il Team ha ricalibrato le priorità degli sprint successivi, assegnando maggiore
  attenzione alla stabilizzazione dell'infrastruttura e al completamento dei test di integrazione e di sistema. La
  pianificazione a breve termine mantiene quindi sprint brevi e un monitoraggio ravvicinato dell'avanzamento, così da
  consentire un recupero più rapido delle criticità emerse e un migliore controllo sul completamento del MVP. Il monte
  ore residuo viene pertanto conservato per gli sprint conclusivi e riallocato sui ruoli tecnici ancora aperti,
  mantenendo come vincolo la convergenza a zero delle ore rimanenti entro lo Sprint 12.

  ==== Preventivo a finire
  #figure(
    numbering: "1",
    caption: [Sprint 10 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [5], [150],
      [Amministratore], [4], [80],
      [Analista], [0,25], [6,25],
      [Progettista], [37], [925],
      [Programmatore], [59], [885],
      [Verificatore], [26], [390],
      [*Totale*], [*131,25*], [*2436,25*],
    ),
  )<tab:Sprint10-costi>


  === Sprint 11
  Inizio: *2026-03-30* \
  Fine prevista: *2026-04-05* \
  Fine reale: *2026-04-05*\
  Giorni di ritardo: 0 \

  ==== Informazioni generali e attività pianificate
  In questo Sprint, il Team si è concentrato sul consolidamento finale del prodotto, proseguendo l'avanzamento della
  documentazione di progetto, lo sviluppo delle componenti frontend e l'integrazione operativa dei microservizi. In
  parallelo, sono state definite le principali attività di test di sistema, così da arrivare allo Sprint 12 con un
  prodotto sostanzialmente completo e con le sole rifiniture finali ancora da svolgere.
  ==== Ore previste
  #figure(
    numbering: "1",
    caption: [Sprint 11 - Ore previste per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [-], [-], [-], [3], [3,5], [2], [*8,5*],
        [Francesco \ Marcon], [-], [-], [-], [4], [3], [2], [*9*],
        [Alessandro \ Mazzariol], [-], [-], [-], [4], [4], [1], [*9*],
        [Leonardo \ Preo], [-], [-], [-], [5], [5], [1], [*11*],
        [Valerio \ Solito], [2], [-], [-], [4], [4], [2], [*12*],
        [Matteo \ Mantoan], [-], [-], [-], [5], [3], [2], [*10*],
        [Mario De\ Pasquale], [-], [-], [-], [5], [5], [-], [*10*],
      )
    ],
  )<tab:Sprint11-ore-previste>
  ==== Possibili rischi
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.
  - RT1: Rischio legato all'apprendimento delle tecnologie richieste.
  - RT2: Rischio tecnologico legato ad errori di programmazione.

  ==== Ore effettive
  #figure(
    numbering: "1",
    caption: [Sprint 11 - Ore effettive per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [-], [-], [-], [3], [4], [2,5], [*9,5*],
        [Francesco \ Marcon], [-], [-], [-], [4], [4], [2], [*10*],
        [Alessandro \ Mazzariol], [-], [-], [-], [4], [5], [1], [*10*],
        [Leonardo \ Preo], [-], [-], [-], [4], [6], [1], [*11*],
        [Valerio \ Solito], [2], [-], [-], [4], [5], [2], [*13*],
        [Matteo \ Mantoan], [-], [-], [-], [5], [3], [2], [*10*],
        [Mario De\ Pasquale], [-], [-], [-], [5], [5], [-], [*10*],
      )
    ],
  )<tab:Sprint11-ore-effettive>

  ==== Consuntivo del periodo
  Nel corso dello Sprint 11, il Team ha concentrato il lavoro sulle attività necessarie a portare il progetto in una
  fase prossima alla conclusione. In particolare, è proseguita la redazione e l'aggiornamento della documentazione
  tecnica, sono state completate ulteriori funzionalità lato frontend e si è lavorato all'integrazione dei microservizi,
  verificando la correttezza del flusso complessivo del sistema. Parallelamente, sono stati definiti i principali
  scenari e criteri di esecuzione dei test di sistema, in modo da predisporre una validazione finale più ordinata nello
  Sprint successivo.

  ==== Retrospettiva
  Lo Sprint 11 ha rappresentato un passaggio decisivo verso la chiusura del progetto. Il Team è riuscito a ridurre in
  modo significativo le attività aperte, migliorando il livello di integrazione tra le componenti sviluppate e
  aumentando la maturità complessiva del prodotto. La scelta di dedicare spazio sia alla documentazione sia alla
  definizione dei test di sistema si è rivelata utile per arrivare all'ultimo Sprint con una visione più chiara delle
  ultime verifiche da completare.


  ==== Misure correttive e aggiornamento dei rischi
  Durante lo Sprint, il rischio RT2 (Rischio tecnologico legato ad errori di programmazione) è rimasto sotto
  osservazione, in particolare nelle fasi di integrazione tra i microservizi e di verifica delle interazioni con il
  frontend. Per contenerne l'impatto, il Team ha continuato ad adottare verifiche incrementali e revisioni puntuali
  delle modifiche introdotte. Il rischio RT1 (Rischio legato all'apprendimento delle tecnologie richieste), pur ancora
  presente, ha avuto un'incidenza più contenuta rispetto agli sprint precedenti, grazie alla maggiore familiarità
  maturata dal gruppo con l'infrastruttura e con gli strumenti adottati.

  ==== Aggiornamento pianificazione futura
  Alla conclusione dello Sprint 11, la pianificazione futura è stata aggiornata prevedendo per lo Sprint 12 il solo
  completamento delle ultime attività di rifinitura, la chiusura della documentazione rimanente e l'esecuzione finale
  delle verifiche conclusive. In questa pianificazione conclusiva, le ore ancora disponibili risultano ormai
  circoscritte ai soli ruoli tecnici e di coordinamento effettivamente necessari per la chiusura del progetto, così da
  far confluire il monte ore complessivo verso un residuo nullo. Il progetto risulta quindi impostato per terminare
  entro lo Sprint 12, senza la necessità di introdurre ulteriori sprint di sviluppo.

  ==== Preventivo a finire
  #figure(
    numbering: "1",
    caption: [Sprint 11 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [3], [90],
      [Amministratore], [4], [80],
      [Analista], [0,25], [6,25],
      [Progettista], [8], [200],
      [Programmatore], [27], [405],
      [Verificatore], [15,50], [232,50],
      [*Totale*], [*57,75*], [*1013,75*],
    ),
  )<tab:Sprint11-costi>



  === Sprint 12
  Inizio: *2026-04-06* \
  Fine prevista: *2026-04-13* \
  Fine reale: *2026-04-06*\
  Giorni di ritardo: 0 \

  ==== Informazioni generali e attività pianificate
  In questo Sprint conclusivo, il Team ha pianificato il completamento delle attività residue emerse dallo Sprint 11,
  concentrandosi sulle ultime rifiniture del frontend, sulla chiusura dell'integrazione tra i microservizi, sul
  consolidamento dei test di sistema e sulla finalizzazione della documentazione necessaria alla consegna del prodotto.

  ==== Ore previste
  #figure(
    numbering: "1",
    caption: [Sprint 12 - Ore previste per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [-], [2], [-], [-], [3], [3], [*8*],
        [Francesco \ Marcon], [-], [1], [-], [1], [3], [3,5], [*8,5*],
        [Alessandro \ Mazzariol], [-], [-], [-], [-], [6], [1], [*7*],
        [Leonardo \ Preo], [3], [-], [-], [-], [4], [1], [*8*],
        [Valerio \ Solito], [-], [1], [-], [3], [5], [1], [*10*],
        [Matteo \ Mantoan], [-], [-], [-], [4], [2], [3], [*9*],
        [Mario De\ Pasquale], [-], [-], [-], [-], [4], [3], [*7*],
      )
    ],
  )<tab:Sprint12-ore-previste>
  ==== Possibili rischi
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.
  - RT1: Rischio legato all'apprendimento delle tecnologie richieste.
  - RT2: Rischio tecnologico legato ad errori di programmazione.

  ==== Ore effettive
  #figure(
    numbering: "1",
    caption: [Sprint 12 - Ore effettive per componente],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [-], [2], [-], [-], [3], [3], [*8*],
        [Francesco \ Marcon], [-], [1], [-], [1], [3], [3,5], [*8,5*],
        [Alessandro \ Mazzariol], [-], [-], [-], [-], [6], [1], [*7*],
        [Leonardo \ Preo], [3], [-], [-], [-], [4], [1], [*8*],
        [Valerio \ Solito], [-], [1], [-], [3], [5], [1], [*10*],
        [Matteo \ Mantoan], [-], [-], [-], [4], [2], [3,25], [*9,25*],
        [Mario De\ Pasquale], [-], [-], [-], [-], [4], [3], [*7*],
      )
    ],
  )<tab:Sprint12-ore-effettive>

  ==== Consuntivo del periodo
  Nel corso dello Sprint 12, il Team ha completato le attività residue lasciate aperte al termine dello Sprint 11,
  portando a chiusura il prodotto e la documentazione collegata. Le ore sono state impiegate soprattutto per le ultime
  rifiniture del frontend, per la verifica finale delle integrazioni tra i microservizi e per l'esecuzione conclusiva
  dei test di sistema pianificati in precedenza. Questo ha permesso di confermare il raggiungimento dello stato finale
  del progetto entro la data effettiva di conclusione.

  ==== Retrospettiva
  Lo Sprint 12 ha confermato la bontà della scelta di distribuire una parte delle attività finali su un periodo
  conclusivo dedicato. La disponibilità di uno sprint breve ma focalizzato ha consentito di effettuare le ultime
  verifiche con maggiore attenzione, riducendo il rischio di chiudere il progetto con attività ancora parzialmente
  aperte. Il Team valuta quindi positivamente la gestione dell'ultima fase di lavoro.


  ==== Misure correttive e aggiornamento dei rischi
  Nel corso dello Sprint conclusivo, i rischi RT1 e RT2 sono rimasti monitorati ma non hanno prodotto impatti tali da
  compromettere la consegna. Le verifiche finali e il completamento incrementale delle integrazioni hanno permesso di
  contenere il rischio di difetti residui, mentre il rischio RP1 non ha inciso in modo significativo sulla conclusione
  delle attività previste.

  ==== Aggiornamento pianificazione futura
  Con la chiusura dello Sprint 12, non risultano ulteriori attività pianificate all'interno del progetto. La
  pianificazione futura si considera quindi conclusa, avendo il Team terminato lo sviluppo, le verifiche e la
  documentazione entro l'orizzonte temporale stabilito. Le riallocazioni deliberate negli Sprint precedenti hanno
  permesso di assorbire gli scostamenti tra ruoli e di chiudere il progetto con un residuo complessivo nullo.

  ==== Preventivo a finire
  #figure(
    numbering: "1",
    caption: [Sprint 12 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [0], [0],
      [Amministratore], [0], [0],
      [Analista], [0,25], [6,25],
      [Progettista], [0], [0],
      [Programmatore], [0], [0],
      [Verificatore], [-0,25], [-3,75],
      [*Totale*], [*0*], [*2,50*],
    ),
  )<tab:Sprint12-costi>

  #pagebreak()

  = Riassunto delle risorse utilizzate durante il progetto
  #figure(
    numbering: "1",
    caption: [Ore utilizzate da ogni componente per ciascun ruolo],
    [
      #set text(size: 9pt)

      #table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.6em,

        table.header(
          [],
          [*Responsabile*],
          [*Amministratore*],
          [*Analista*],
          [*Progettista*],
          [*Programmatore*],
          [*Verificatore*],
          [*Totale*],
        ),

        [Alessandro \ Contarini], [7], [10], [11], [19], [22], [22], [*91*],
        [Francesco \ Marcon], [8], [9], [11], [20], [25], [20], [*93*],
        [Alessandro \ Mazzariol], [7], [9], [9], [20], [28], [20], [*93*],
        [Leonardo \ Preo], [7], [8], [12], [22], [25], [19], [*93*],
        [Valerio \ Solito], [7], [8], [14], [20], [22], [20], [*91*],
        [Matteo \ Mantoan], [6], [12], [11,75], [20], [21], [20,25], [*91*],
        [Mario De\ Pasquale], [9], [8], [11], [20], [24], [19], [*91*],
        [*Totale*], [*51*], [*64*], [*79,75*], [*141*], [*167*], [*140,25*], [*643*],
      )
    ],
  )<tab:Progetto-ore-effettive>

  Come si evidenzia dalla @tab:Sprint12-costi, ovvero le risorse rimanenti alla fine dell’ultimo sprint, il gruppo
  termina la realizzazione di quanto necessario per affrontare la PB con un saldo rimanente di *2,50€*, spendendo dunque
  un totale di *12.937,50€*, al sotto del saldo inizialmente a disposizione pari a *12.940€*.

  Dalla @tab:Progetto-ore-effettive si evidenzia invece l’impegno concreto e uniforme apportato al progetto da parte di
  tutti i componenti del gruppo, con un un numero di ore consumate totale in linea con la pianificazione.

  Come analizzato nella @pianificazione_lungo_termine, tra RTB e PB è stato necessario modificare il quantitativo di ore
  previsto a ciascun ruolo: il consumo percentuale di ciascun ruolo è esposto qui di seguito:

  #figure(
    caption: "Percentuale utilizzo ore di ciascun ruolo sul totale",
  )[
    #image("assets/chart.svg", width: 75%)
  ]

]
