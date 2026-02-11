#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)
//Glossario
//Use Case
//Glossario
//RTB
//forse tutti i codici di rischi in questo file?
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
  Il #link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/glossario.pdf")[Glossario] è un documento
  soggetto a continuo aggiornamento per l'intera durata del progetto; il suo scopo è definire la terminologia tecnica
  per garantire una comprensione chiara e univoca dei contenuti. I termini presenti nel Glossario sono contrassegnati
  nel testo da una lettera "G" posta a pedice (es. parola#sub[G]).
  == Riferimenti
  === Riferimenti normativi
  - Capitolato d'appalto C7 Sistema di acquisizione dati da sensori BLE (M31) \
    https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf
  - Piano di Qualifica \
    https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/piano_qualifica.pdf
  - Analisi dei Requisiti \
    https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/analisi_requisiti.pdf
  - Norme di Progetto \
    https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docint/norme_progetto.pdf
  === Riferimenti informativi
  - Ciclo di via del Software \
    https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/T03.pdf
  - Gestione di Progetto\
    https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/T04.pdf

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
        criticità dovesse coinvolgere l’intero gruppo, il team potrà organizzare un incontro con M31 per richiedere
        chiarimenti sulla tecnologia oggetto di analisi. Tuttavia, poiché il livello di conoscenza tra i membri potrebbe
        non essere omogeneo, è verosimile che molte problematiche vengano risolte internamente al team.],

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
      [Il team farà ampio ricorso ai test durante le fasi di sviluppo, così da assicurare il corretto funzionamento del
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
    caption: [Mancato rispetto delle scadenza stabilite],
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

  = Pianificazione nel lungo termine
  Come anticipato nella #link(
    "https://notipswe.github.io/RepoDocumentale/docs/11-candidatura/docest/dichiarazione_impegni.pdf",
  )[Dichiarazione degli impegni], il gruppo prevede di terminare il progetto entro il giorno *21 Marzo 2026* con un
  budget di spesa fissato a *12.940 Euro*.\
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
    caption: [Ore e costo per ciascun ruolo, e preventivo finale],
  )<tab:costi>
  == Attività fissate per la Requirements and Technology Baseline (RTB)
  === Redazione Analisi dei Requisiti (AdR)
  All'interno di questo periodo verranno redatte le seguenti parti del documento:
  - Parte introduttiva
  - Casi d'Uso relativi a requisiti funzionali
  - Casi d'Uso relativi a requisiti non funzionali
  - Tracciamento requisiti - fonte

  Queste parti verranno redatte nei periodi seguenti:
  - Sprint 1
  - Sprint 2
  - Sprint 3
  - Sprint 4
  - Sprint 5

  Lo Stato attuale del documento:
  - Completato per RTB

  === Redazione Norme di Progetto (NdP)
  All'interno di questo periodo verranno redatte le seguenti parti del documento:
  - Parte introduttiva
  - Processi primari, di supporto e organizzativi
  - Metriche di qualità utilizzate

  Queste parti verranno redatte nei periodi seguenti:
  - Sprint 1
  - Sprint 2
  - Sprint 3
  - Sprint 4
  - Sprint 5
  - Sprint 6

  Lo Stato attuale del documento
  - Completato per RTB

  === Redazione Piano di Progetto (PdP)
  All'interno di questo periodo verranno redatte le seguenti parti del documento:
  - Parte introduttiva
  - Analisi e gestione dei Rischi
  - Pianificazione a lungo termine
  - Pianificazione a breve termine
  - Descrizione degli Sprint

  Queste parti verranno redatte nei periodi seguenti:
  - Sprint 2
  - Sprint 3
  - Sprint 4
  - Sprint 5
  - Sprint 6

  Lo Stato attuale del documento:
  - Completato per RTB

  === Redazione Piano di Qualifica (PdQ)
  All'interno di questo periodo verranno redatte le seguenti parti del documento:
  - Parte introduttiva
  - Processi primari, di supporto e organizzativi
  - Metriche di qualità di processo
  - Metriche di qualità di prodotto
  - Metodi di testing
  - Cruscotto di valutazione


  Queste parti verranno redatte nei periodi seguenti:
  - Sprint 2
  - Sprint 3
  - Sprint 4
  - Sprint 5
  - Sprint 6

  Lo Stato attuale del documento
  - Completato per RTB

  === Redazione Glossario
  All'interno di questo periodo verranno redatte le seguenti parti del documento:
  - Termini

  Queste parti verranno redatte nei periodi seguenti:
  - Tutti gli sprint
  Lo Stato attuale del documento
  - Completato per RTB

  === Realizzazione del Proof of Concept
  All'interno di questo periodo sono stati fatti i Test sulle seguenti tecnologie:
  - Golang;
  - NATS;
  - Docker;
  - (Test di sincronizzazione).

  Queste parti verranno redatte nei periodi seguenti:
  - Sprint 4
  - Sprint 5
  - Sprint 6

  Lo stato attuale è
  - Completato

  === Sprint 1
  Inizio: *16-11-2025* \
  Fine prevista: *29-11-2025* \
  Fine reale: *29-11-2025* \
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

  ==== Possibili rischi
  Il gruppo pensa sia possibile che possano presentarsi i seguenti rischi:
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.
  - RT1: Rischio legato all'apprendimento delle tecnologie richieste.

  ==== Ore previste
  A seguito di una mancanza di organizzazione delle ore previste, il gruppo non ha lavorato nella maniera corretta, per
  questo si potrebbe vedere uno squilibrio nelle ore effettive. Il gruppo nel prossimo Sprint si impegnerà ad
  organizzarsi e rispettare le ore previste.

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
        [Matteo \ Mantoan], [-], [4], [-], [-], [-], [1,25], [*5,5*],
        [Mario De\ Pasquale], [-], [-], [1,5], [-], [-], [1], [*2,5*],
      )
    ],
  )<tab:Sprint1-ore-effettive>

  ==== Aggiornamento risorse monetarie rimanenti
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

  ==== Rischi incontrati
  Durante questo sprint il gruppo ha avuto difficoltà nel capire come organizzare il lavoro tra i vari componenti e,
  come si può evincere dalla @tab:Sprint1-ore-effettive, ci sono componenti che non hanno impiegato più di un'ora nel
  fare le mansioni, questo sia a causa del rischio *RP1*, sia per l'inesperienza generale.

  ==== Retrospettiva
  Questo Sprint è stato dedicato nel risolvere questioni importanti come il trasferimento del workflow su Jira, e la
  prima stesura dei documenti più importanti. Tutte le attività previste sono state comunque eseguite senza ritardi.

  === Sprint 2
  Inizio: *02-12-2025* \
  Fine prevista: *14-12-2025* \
  Fine reale: *15-12-2025* \
  Giorni di ritardo: *1*\

  ==== Informazioni generali e attività pianificate
  In questo sprint il gruppo, rispetto al periodo precedente, si è suddiviso equamente le task.

  In particolare, le attività fissate in questo periodo sono:
  - Prima stesura Piano di Progetto (PdP).
  - Continuazione delle Norme di Progetto (NdP).
  - Continuazione Analisi dei Requisiti (AdR).
  - Prima stesura Piano di Qualifica (PdQ)

  ==== Possibili rischi
  Il gruppo pensa sia possibile che possano presentarsi i seguenti rischi:
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.
  - RT1: Rischio legato all'apprendimento delle tecnologie richieste.
  - RO1: Mancato rispetto delle scadenza stabilite.

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
        [Matteo \ Mantoan], [-], [5,25], [-], [-], [-], [2,5], [*7,75*],
        [Mario De\ Pasquale], [-], [3,5], [1,5], [-], [-], [-], [*5*],
      )
    ],
  )<tab:Sprint2-ore-effettive>
  ==== Aggiornamento risorse monetarie rimanenti
  #figure(
    numbering: "1",
    caption: [Sprint 2 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [51], [1530],
      [Amministratore], [33,5], [670],
      [Analista], [63], [1575],
      [Progettista], [137], [3425],
      [Programmatore], [165], [2475],
      [Verificatore], [111], [1665],
      [*Totale*], [*560,5*], [*11340*],
    ),
  )<tab:Sprint2-costi>

  ==== Rischi incontrati
  Rallentamento nello sviluppo dell'Analisi dei Requisiti (RT1).
  ==== Retrospettiva
  Questo Sprint è servito al gruppo per attuare in maniera concreta il workflow idealizzato. Il Gruppo tuttavia ha
  dovuto affrontare modifiche importanti per quanto riguarda l'#link(
    "https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/analisi_requisiti.pdf",
  )[Analisi dei Requisiti] che hanno causato un rinvio al prossimo Sprint del raggiungimento della versione *0.3.0* e
  *0.4.0*.

  === Sprint 3
  Inizio: *15-12-2025* \
  Fine prevista: *28-12-2025* \
  Fine reale: *04-01-2026*\
  Giorni di ritardo: 0\

  ==== Informazioni generali e attività pianificate
  Le attività fissate per questo Sprint sono:
  - Analisi dei requisiti: casi d'uso da finire, iniziare la stesura dei requisiti.
  - Norme di Progetto: set di cambiamenti di NT-67; realizzare le seguenti sezioni: processo di fornitura, processo di
    sviluppo, processo di gestione della configurazione, metriche (citate nel _PdQ_).
  - Piano di Qualifica: metriche da rivedere e confermare, cruscotto di valutazione, metodi di testing da iniziare
    (qualora avanzasse tempo).
  - Piano di Progetto: Sprint 2 da aggiornare, stesura della sezione dello Sprint 3 , rischi da aggiornare.

  ==== Possibili rischi
  Il gruppo pensa sia possibile che possano presentarsi i seguenti rischi:
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.
  - RT1: Rischio legato all'apprendimento delle tecnologie richieste.
  - RO1: Mancato rispetto delle scadenza stabilite.

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

  ==== Aggiornamento risorse monetarie rimanenti
  #figure(
    numbering: "1",
    caption: [Sprint 3 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [47], [1410],
      [Amministratore], [23], [460],
      [Analista], [31], [775],
      [Progettista], [137], [3425],
      [Programmatore], [165], [2475],
      [Verificatore], [99], [1485],
      [*Totale*], [*502*], [*10030*],
    ),
  )<tab:Sprint3-costi>

  ==== Rischi incontrati
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


  === Sprint 4
  Inizio: *04-01-2026* \
  Fine prevista: *18-01-2026* \
  Fine reale: *18-01-2026*\
  Giorni di ritardo: 0\

  ==== Informazioni generali e attività pianificate
  In questo Sprint il Gruppo si concentrerà sull'Analisi dello Stato dell'Arte e sulla fase progettuale del PoC (che non
  risulterà nelle ore effettive o previste, essendo ore di palestra), e sull'ultimare l'Analisi dei Requisiti. Inoltre,
  si prevede l'aggiornamento e l'aggiunta delle sezioni dedicate allo sprint 3 e 4 del _Piano di Progetto_.

  ==== Possibili rischi
  Il gruppo pensa sia possibile che possano presentarsi i seguenti rischi:
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.
  - RT1: Rischio legato all'apprendimento delle tecnologie richieste.
  - RO1: Mancato rispetto delle scadenza stabilite.

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

  ==== Aggiornamento risorse monetarie rimanenti
  #figure(
    numbering: "1",
    caption: [Sprint 4 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [43,5], [1305],
      [Amministratore], [20], [400],
      [Analista], [8], [200],
      [Progettista], [137], [3425],
      [Programmatore], [165], [2475],
      [Verificatore], [88], [1320],
      [*Totale*], [*461,5*], [*9125*],
    ),
  )<tab:Sprint4-costi>

  ==== Rischi incontrati
  In seguito ad un incontro con il Prof. Cardin e, successivamente con l'azienda, sono stati rivisti molti Use Case,
  sicuramente frutto dell'inesperienza del gruppo nell'analizzare correttamente il capitolato (RT1). Inoltre, dato
  l'inizio della sessione d'esami invernale, il lavoro ha subito alcuni rallentamenti (RP1).
  ==== Retrospettiva
  Nel corso di questo Sprint il team si è concentrato sugli obiettivi stabiliti. Sebbene diversi membri abbiano
  registrato un numero inferiore di ore, a causa dell’attenzione dedicata all’analisi dello stato dell’arte e al Proof
  of Concept (POC), gli obiettivi prefissati sono stati comunque raggiunti senza ritardi significativi.

  === Sprint 5
  Inizio: *18-01-2026* \
  Fine prevista: *01-02-2026* \
  Fine reale: *03-01-2026*\
  Giorni di ritardo: 2\

  ==== Informazioni generali e attività pianificate
  In questo Sprint, il Team si concentrerà sulla fase di programmazione del PoC e sulla verifica/approvazione
  dell'Analisi dei Requisiti al fine di assicurarsi la piena completezza del documento per la revisione RTB. Inoltre, si
  porterà avanti il Piano di Qualifica, aggiungendo una sezione dedicata ai test, le Norme di Progetto e il Piano di
  Progetto, completando e aggiungendo la sezione dedicata allo Sprint 4 e 5.

  ==== Possibili rischi
  Il gruppo pensa sia possibile che possano presentarsi i seguenti rischi:
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.
  - RT1: Rischio legato all'apprendimento delle tecnologie richieste.
  - RT2: Rischio tecnologico legato ad errori di programmazione.
  - RO1: Mancato rispetto delle scadenza stabilite.

  ==== Ore Previste
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

  ==== Aggiornamento risorse monetarie rimanenti
  #figure(
    numbering: "1",
    caption: [Sprint 5 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [36], [1080],
      [Amministratore], [9], [180],
      [Analista], [8], [200],
      [Progettista], [137], [3425],
      [Programmatore], [134], [2010],
      [Verificatore], [75], [1125],
      [*Totale*], [*399*], [*8020*],
    ),
  )<tab:Sprint5-costi>

  ==== Rischi incontrati
  Il Team ha speso ore di palestra nel comprendere come svolgere al meglio la fase di Progettazione e Programmazione del
  PoC (RT1 e RT2). Inoltre, dati gli esami universitari svolti in questo periodo, ci sono stati lievi rallentamenti nel
  lavoro da svolgere (RP1).
  ==== Retrospettiva
  Nello Sprint 5 anche se il gruppo ha incontrato alcuni rallentamenti, i compiti assegnati sono stati svolti. Anche in
  questo caso alcuni membri hanno meno ore registrate, perché hanno ultimato la progettazione del PoC.
  === Sprint 6
  Inizio: *04-02-2026* \
  Fine prevista: *17-02-2026* \
  Fine reale: *17-02-2026*\
  Giorni di ritardo: 0 \

  ==== Informazioni generali e attività pianificate
  Per lo Sprint 6 il Team si è prefissato di ultimare il PoC, e di portare in avanti le norme di progetto e il piano di
  qualifica, affinché siano pronti per la RTB. Una volta che i documenti saranno stati ultimati verrà anche aggiornato
  il Glossario, aggiungendo così tutti i nuovi termini utilizzati. L'obiettivo è quello di ultimare e validare tutti i
  documenti (verbali, NdP, AdR, PdQ, PdP) finora stilati in vista della RTB.
  
  A causa dei vari impegni dei componenti del
  gruppo, causati principalmente dallo studio per alcuni esami, le ore a disposizione da dedicare al progetto sono sotto la media, ma comunque
  sufficienti per completare tutte le attività sopra citate.


  ==== Possibili rischi
  Il gruppo pensa sia possibile che possano presentarsi i seguenti rischi:
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.
  - RT1: Rischio legato all'apprendimento delle tecnologie richieste.
  - RT2: Rischio tecnologico legato ad errori di programmazione.

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

  ==== Aggiornamento risorse monetarie rimanenti
  #figure(
    numbering: "1",
    caption: [Sprint 6 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [26], [780],
      [Amministratore], [5], [100],
      [Analista], [8], [200],
      [Progettista], [137], [3425],
      [Programmatore], [130], [1950],
      [Verificatore], [57], [855],
      [*Totale*], [*363*], [*7310*],
    ),
  )<tab:Sprint6-costi>

  ==== Rischi incontrati
  Come preventivato, a causa degli impegni universitari dei componenti del Team, è stato difficile incastrare le ore di
  lavoro (RP1); tuttavia, tutti gli obiettivi prefissati sono stati raggiunti con successo.
  ==== Retrospettiva
  Nello Sprint 6, il Team si è concentrato principalmente sull'ultimare il PoC e sull'aggiornare i documenti in vista
  della RTB. Nonostante le ore dedicate siano state inferiori alla media, sono stati raggiunti tutti gli obiettivi
  prefissati.
]
