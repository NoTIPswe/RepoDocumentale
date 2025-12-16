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
  Il documento fornisce un'analisi complessiva delle attività, coprendo in particolare, la stima del tempo previsto ed
  effettivo e i potenziali rischi che il gruppo potrebbe affrontare.

  == Glossario
  Il #link("https://notipswe.github.io/docs/12-rtb/docest/glossario.pdf")[Glossario] è un documento soggetto a continuo
  aggiornamento per l'intera durata del progetto; il suo scopo è definire la terminologia tecnica per garantire una
  comprensione chiara e univoca dei contenuti. I termini presenti nel Glossario sono contrassegnati nel testo da una
  lettera "G" posta a pedice (es. parola#sub[G]).
  == Riferimenti
  === Riferimenti normativi
  - Capitolato d'appalto C7 Sistema di acquisizione dati da sensori BLE (M31) \
    https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf
  - Piano di Qualifica \
    https://notipswe.github.io/docs/12-rtb/docest/piano_qualifica.pdf
  - Analisi dei Requisiti \
    https://notipswe.github.io/docs/12-rtb/docest/analisi_requisiti.pdf
  - Norme di Progetto \
    https://notipswe.github.io/docs/12-rtb/docint/norme_progetto.pdf
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
        utilizzo delle tecnologie richieste nel progetto, causando un progressivo rallentamento nello sviluppo.],

      [Mitigazione],
      [Appena stabilite le tecnologie da utilizzare, è bene stabilire un periodo di "palestra" per formarsi al meglio,
        dato che questo problema potrebbe presentarsi anche dopo questo periodo, qualora fosse un problema generale, il
        gruppo organizzerà un meeting con _M31_ per chiedere chiarimenti sulla tecnologia. Dato che non è garantito lo
        stesso livello di conoscenza tra i componenti, è più probabile che i problemi vengano risolti internamente al
        gruppo.],

      [Probabilità], [Elevata],
      [Impatto prestazionale], [Alta],
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
      [Il gruppo farà affidamento su numerosi test durante lo sviluppo per garantire il funzionamento del prodotto.
        Qualora il gruppo non riuscisse ad andare avanti chiederà supporto all'Azienda proponente.],

      [Probabilità], [Alto],
      [Impatto prestazionale], [Medio],
    ),
    caption: [Rischio sugli errori di programmazione],
  )
  }<tab:RT2>
  == Rischi organizzativi
  #figure(
    numbering: "1",
    table(
      columns: (1fr, 2fr),
      [Tipologia Dato], [Valore],
      [Codice], [RO1],
      [Nome], [Mancato rispetto delle scadenze stabilite],
      [Descrizione],
      [Durante lo sviluppo del prodotto possono verificarsi ritardi rispetto al conseguimento delle task fissate, i
        quali comportano un prolungamento dei tempi di consegna e blocco delle attività successive.],

      [Mitigazione],
      [Il gruppo è consapevole che i ritardi sono possibili e si impegna in modo responsabile affinchè non avvengano,
        tuttavia qualora non si riuscisse ad evitarli, essi devono essere comunicati tempestivamente e giustificati in
        modo adeguato senza compromettere le attività degli altri componenti del gruppo. Qualora il ritardo causasse un
        disagio generale, tale da compromettere i tempi di consegna, il Gruppo organizzerà il prima possibile una
        riunione con _M31_ per rinegoziare le richieste.],

      [Probabilità], [Medio - Basso],
      [Impatto prestazionale], [Alto],
    ),
    caption: [Mancato rispetto delle scadenza stabilite],
  )<tab:RO1>
  == Rischi personali
  #figure(
    numbering: "1",
    table(
      columns: (1fr, 2fr),
      [Tipologia Dato], [Valore],
      [Codice], [RP1],
      [Nome], [Problematiche personali o attività universitarie],
      [Descrizione],
      [Data la partecipazione dei componenti del Gruppo ad altri corsi universitari oltre a quello di Ingegneria del
        Software, è dunque altamente probabile che vi siano possibili indisponibilità momentanee derivante da attività
        legate a questi corsi, inoltre non sono da escludere indisponibilità per attività al di fuori della sfera
        accademica.],

      [Mitigazione],
      [Il componente che si ritrova in tale situazione dovrà comunicare tempestivamente agli altri componenti la
        problematica e una possibile stima del tempo che la problematica occupa e, qualora fosse necessario, il lavoro
        che il componente doveva fare verrà suddiviso tra gli altri componenti del gruppo. Appena risolta la
        problematica, il componente si impegnerà a recuperare le ore perse.],

      [Probabilità], [Media],
      [Impatto prestazionale], [Medio],
    ),
    caption: [Problematiche personali o attività universitarie],
  )<tab:RP1>

  = Pianificazione nel lungo termine
  Come anticipato nella #link(
    "https://notipswe.github.io/docs/11-candidatura/docest/dichiarazione_impegni.pdf",
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
  === Sprint 1
  Inizio: *16-11-2025* \
  Fine prevista: *29-11-2025* \
  Fine reale: *29-11-2025* \
  Giorni di ritardo: *0* \

  === Informazioni generali e attività pianificate
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

  === Possibili rischi
  Il gruppo pensa sia possibile che possano presentarsi i seguenti rischi:
  - RP1: Rischio personale legato a problematiche personali o attività universitarie

  === Ore previste
  A seguito di una mancanza di organizzazione delle ore previste, il gruppo non ha lavorato nella maniera corretta, per
  questo si potrebbe vedere uno squilibrio nelle ore effettive. Il gruppo nel prossimo Sprint si impegnerà ad
  organizzarsi e rispettare le ore previste.

  === Ore effettive
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

        [Alessandro \ Contarini], [1], [-], [-], [-], [-], [-], [*1*],
        [Francesco \ Marcon], [-], [3], [-], [-], [-], [-], [*3*],
        [Alessandro \ Mazzariol], [-], [-], [-], [-], [-], [-], [*0*],
        [Leonardo \ Preo], [-], [-], [2], [-], [-], [-], [*2*],
        [Valerio \ Solito], [-], [-], [-], [-], [-], [-], [*0*],
        [Matteo \ Mantoan], [-], [4], [-], [-], [-], [-], [*4*],
        [Mario De\ Pasquale], [-], [-], [-], [-], [-], [-], [*0*],
      )
    ],
  )<tab:Sprint1-ore-effettive>

  === Aggiornamento risorse monetarie rimanenti
  #figure(
    numbering: "1",
    caption: [Sprint 1 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [60], [1800],
      [Amministratore], [53], [1060],
      [Analista], [78], [1950],
      [Progettista], [137], [3425],
      [Programmatore], [165], [2475],
      [Verificatore], [134], [2010],
      [*Totale*], [*637*], [*12720*],
    ),
  )<tab:Sprint1-costi>

  === Rischi incontrati
  Durante questo sprint il gruppo ha avuto difficoltà nel capire come organizzare il lavoro tra i vari componenti e,
  come si può evincere dalla @tab:Sprint1-ore-effettive, ci sono componenti che non hanno impiegato più di un'ora nel
  fare le mansioni, questo sia a causa del rischio *RP1*, sia per l'inesperienza generale.

  === Retrospettiva
  Questo Sprint è stato dedicato nel risolvere questioni importanti come il trasferimento del workflow su Jira, e la
  prima stesura dei documenti più importanti. Tutte le attività previste sono state comunque eseguite senza ritardi.

  === Sprint 2
  Inizio: *02-12-2025* \
  Fine prevista: *14-12-2025* \
  Fine reale: *15-12-2025* \
  Giorni di ritardo: *0*\

  === Informazioni generali e attività pianificate
  In questo periodo il gruppo rispetto al periodo precedente si è suddiviso equamente le task.

  In particolare, le attività fissate in questo periodo sono:
  - Prima stesura Piano di Progetto (PDP).
  - Continuazione delle Norme di Progetto.
  - Continuazione Analisi dei Requisiti.
  - Prima stesura Piano di Qualifica (PDQ)

  === Possibili rischi
  Il gruppo pensa sia possibile che possano presentarsi i seguenti rischi:
  - RP1: Rischio personale legato a problematiche personali o attività universitarie

  === Ore previste
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

        [Alessandro \ Contarini], [-], [-], [8], [-], [-], [-], [*8*],
        [Francesco \ Marcon], [-], [-], [5], [-], [-], [2], [*7*],
        [Alessandro \ Mazzariol], [7], [-], [-], [-], [-], [-], [*7*],
        [Leonardo \ Preo], [-], [-], [8], [-], [-], [-], [*8*],
        [Valerio \ Solito], [-], [-], [5], [-], [-], [2], [*7*],
        [Matteo \ Mantoan], [-], [5], [-], [-], [-], [3], [*8*],
        [Mario De\ Pasquale], [-], [-], [8], [-], [-], [-], [*8*],
      )
    ],
  )<tab:Sprint2-ore-previste>

  === Ore effettive
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

        [Alessandro \ Contarini], [-], [-], [1.5], [-], [-], [-], [*1.5*],
        [Francesco \ Marcon], [-], [3.2], [1], [-], [-], [-], [*4.3*],
        [Alessandro \ Mazzariol], [6], [-], [-], [-], [-], [-], [*6*],
        [Leonardo \ Preo], [-], [-], [4.5], [-], [-], [-], [*4.5*],
        [Valerio \ Solito], [-], [-], [?], [-], [-], [1.8], [*1.8*],
        [Matteo \ Mantoan], [-], [5.2], [-], [-], [-], [2.5], [*7.7*],
        [Mario De\ Pasquale], [-], [-], [?], [-], [-], [-], [*?*],
      )
    ],
  )<tab:Sprint2-ore-effettive>
  === Aggiornamento risorse monetarie rimanenti
  #figure(
    numbering: "1",
    caption: [Sprint 1 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [54], [1620],
      [Amministratore], [44.5], [1060],
      [Analista], [71], [1775],
      [Progettista], [137], [3425],
      [Programmatore], [165], [2475],
      [Verificatore], [129.5], [1935],
      [*Totale*], [*601*], [*12290*],
    ),
  )<tab:Sprint1-costi>

  === Rischi incontrati

  === Retrospettiva
  Questo Sprint è servito al gruppo per attuare in maniera concreta il workflow idealizzato. Il Gruppo tuttavia ha
  dovuto affrontare modifiche importanti per quanto riguarda l'#link(
    "https://notipswe.github.io/docs/12-rtb/docest/analisi_requisiti.pdf",
  )[Analisi dei Requisiti] che hanno causato un rinvio al prossimo Sprint del raggiungimento della versione *0.3.0* e
  *0.4.0*.

  === Sprint 3
  Inizio: *15-12-2025* \
  Fine prevista: *28-12-2025* \
  Fine reale: \
  Giorni di ritardo: \

  === Informazioni generali e attività pianificate
  /* Da Scrivere */
  Le attività fissate per questo Sprint sono:
  - Analisi dei requisiti: casi d'uso finiti, requisiti almeno iniziati.
  - Norme di Progetto: set di cambiamenti di NT-67; devono essere presenti le sezioni: processo di fornitura, processo
    di sviluppo, processo di gestione della configurazione, metriche (citate nel piano di qualifica).
  - Piano di Qualifica: metriche riviste e confermate, cruscotto di valutazione, metodi di testing da iniziare se c'è
    tempo.
  - Piano di Progetto: sprint 2 aggiornato, sprint 3 creato, rischi aggiornati.

  === Possibili rischi
  Il gruppo pensa sia possibile che possano presentarsi i seguenti rischi:
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.

  === Ore previste

  === Ore effettive
  === Aggiornamento risorse monetarie rimanenti

  === Rischi incontrati

  === Retrospettiva

  == Attività fissate per la Product Baseline (PB)


]
