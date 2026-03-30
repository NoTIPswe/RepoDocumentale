#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml("piano_progetto.meta.yaml")
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
      acquisizione dati da sensori]\ _Ultimo accesso: 2026-03-09_
  - #link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/piano_qualifica.pdf")[Piano di Qualifica
      v1.1.0]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/analisi_requisiti.pdf")[Analisi dei Requisiti
      v1.1.0]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docint/norme_progetto.pdf")[Norme di Progetto v1.1.0]
  === Riferimenti informativi
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/T03.pdf")[T03 - Ciclo di via del Software] \ _Ultimo
    accesso: 2026-03-09_
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/T04.pdf")[T04 - Gestione di Progetto] \ _Ultimo accesso:
    2026-03-09_

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
  )[Dichiarazione degli impegni v1.0.0], il gruppo prevede di terminare il progetto entro il giorno *21 Marzo 2026* con
  un budget di spesa fissato a *12.940 Euro*.\
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
  === Redazione Norme di Progetto (NdP)
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


  === Redazione Piano di Progetto (PdP)
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


  === Redazione Piano di Qualifica (PdQ)
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


  === Redazione Glossario
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

  === Realizzazione del Proof of Concept
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

    ],
    table.cell(colspan: 2, align: center)[*Completato per RTB*],
  )


  == Attività fissate per la Product Baseline (PB)
  === Correzione errori nei documenti segnalati
  #figure(
    table(
      columns: (0.25fr, 0.25fr),
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
        - Sprint 7
      ],
      table.cell(colspan: 2, align: center)[*Completato per PB*],
    ),
  )<tab:Correzione-RTB>

  === Redazione Manuale Test
  #table(
    columns: (0.25fr, 0.25fr),
    table.header(
      table.cell(align: center)[*Attività*],
      table.cell(align: center)[*Periodo*],
    ),
    [
      - Da Definire
    ],
    [
      - Sprint 7
      - Sprint 8
      - Sprint 9

    ],
    table.cell(colspan: 2, align: center)[*Non completato*],
  )

  === Redazione Manuale Utente
  #table(
    columns: (0.25fr, 0.25fr),
    table.header(
      table.cell(align: center)[*Attività*],
      table.cell(align: center)[*Periodo*],
    ),
    [
      - Da Definire
    ],
    [
      - Sprint 7
      - Sprint 8
      - Sprint 9

    ],
    table.cell(colspan: 2, align: center)[*Non completato*],
  )

  === Realizzazione Minimum Viable Product (MVP)
  #table(
    columns: (0.25fr, 0.25fr),
    table.header(
      table.cell(align: center)[*Attività*],
      table.cell(align: center)[*Periodo*],
    ),
    [
      - Da Definire
    ],
    [
      - Sprint 7
      - Sprint 8
      - Sprint 9

    ],
    table.cell(colspan: 2, align: center)[*Non completato*],
  )

  = Pianificazione nel breve termine
  == Introduzione
  Il gruppo NoTIP ha deciso di adottare un approccio Agile per tutta la durata del progetto, suddividendo lo sviluppo in
  sprint di due settimane. Il gruppo si impegna a definire, all'inizio di ogni periodo, la pianificazione delle
  settimane successive e una rotazione dei ruoli coerente, mantenendo la flessibilità necessaria per eventuali
  cambiamenti organizzativi.

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
        [Matteo \ Mantoan], [-], [4], [-], [-], [-], [1,25], [*5,5*],
        [Mario De\ Pasquale], [-], [-], [1,5], [-], [-], [1], [*2,5*],
      )
    ],
  )<tab:Sprint1-ore-effettive>

  ==== Rischi incontrati
  Durante questo sprint il gruppo ha avuto difficoltà nel capire come organizzare il lavoro tra i vari componenti e,
  come si può evincere dalla @tab:Sprint1-ore-effettive, ci sono componenti che non hanno impiegato più di un'ora nel
  fare le mansioni, questo sia a causa del rischio *RP1*, sia per l'inesperienza generale.

  ==== Retrospettiva
  Questo Sprint è stato dedicato nel risolvere questioni importanti come il trasferimento del workflow su Jira, e la
  prima stesura dei documenti più importanti. Tutte le attività previste sono state comunque eseguite senza ritardi.

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
  - RO1: Mancato rispetto delle scadenza stabilite.

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
  ==== Rischi incontrati
  Rallentamento nello sviluppo dell'Analisi dei Requisiti (RT1).

  ==== Retrospettiva
  Questo Sprint è servito al gruppo per attuare in maniera concreta il workflow idealizzato. Il Gruppo tuttavia ha
  dovuto affrontare modifiche importanti per quanto riguarda l'#link(
    "https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/analisi_requisiti.pdf",
  )[Analisi dei Requisiti v1.1.0] che hanno causato un rinvio al prossimo Sprint del raggiungimento della versione
  *0.3.0* e *0.4.0*.

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
  - RO1: Mancato rispetto delle scadenza stabilite.
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
  - RO1: Mancato rispetto delle scadenza stabilite.

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



  ==== Rischi incontrati
  In seguito ad un incontro con il Prof. Cardin e, successivamente con l'azienda, sono stati rivisti molti Use Case,
  sicuramente frutto dell'inesperienza del gruppo nell'analizzare correttamente il capitolato (RT1). Inoltre, dato
  l'inizio della sessione d'esami invernale, il lavoro ha subito alcuni rallentamenti (RP1).
  ==== Retrospettiva
  Nel corso di questo Sprint il team si è concentrato sugli obiettivi stabiliti. Sebbene diversi membri abbiano
  registrato un numero inferiore di ore, a causa dell’attenzione dedicata all’analisi dello stato dell’arte e al Proof
  of Concept (POC), gli obiettivi prefissati sono stati comunque raggiunti senza ritardi significativi.
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
  ==== Possibili rischi
  Il gruppo pensa sia possibile che possano presentarsi i seguenti rischi:
  - RP1: Rischio personale legato a problematiche personali o attività universitarie.
  - RT1: Rischio legato all'apprendimento delle tecnologie richieste.
  - RT2: Rischio tecnologico legato ad errori di programmazione.
  - RO1: Mancato rispetto delle scadenza stabilite.

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



  ==== Rischi incontrati
  Il Team ha speso ore di palestra nel comprendere come svolgere al meglio la fase di Progettazione e Programmazione del
  PoC (RT1 e RT2). Inoltre, dati gli esami universitari svolti in questo periodo, ci sono stati lievi rallentamenti nel
  lavoro da svolgere (RP1).
  ==== Retrospettiva
  Nello Sprint 5 anche se il gruppo ha incontrato alcuni rallentamenti, i compiti assegnati sono stati svolti. Anche in
  questo caso alcuni membri hanno meno ore registrate, perché hanno ultimato la progettazione del PoC.
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



  ==== Rischi incontrati
  Come preventivato, a causa degli impegni universitari dei componenti del Team, è stato difficile incastrare le ore di
  lavoro (RP1); tuttavia, tutti gli obiettivi prefissati sono stati raggiunti con successo.
  ==== Retrospettiva
  Nello Sprint 6, il Team si è concentrato principalmente sull'ultimare il PoC e sull'aggiornare i documenti in vista
  della RTB. Nonostante le ore dedicate siano state inferiori alla media, sono stati raggiunti tutti gli obiettivi
  prefissati.
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

        [Alessandro \ Contarini], [0], [2], [0,75], [0], [0], [0], [*2,75*],
        [Francesco \ Marcon], [5], [0,25], [2,5], [0], [0], [0], [*7,75*],
        [Alessandro \ Mazzariol], [0], [1,5], [0], [0], [0], [3], [*4,5*],
        [Leonardo \ Preo], [0], [1], [0], [0], [0], [4,5], [*5,5*],
        [Valerio \ Solito], [0], [0], [0], [0], [5], [6], [*11*],
        [Matteo \ Mantoan], [0], [0], [4,25], [0], [0], [0,25], [*4,5*],
        [Mario De\ Pasquale], [0], [0,5], [0], [0], [4], [1,5], [*6*],
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

        [Alessandro \ Contarini], [0], [2], [0,75], [0], [0], [0], [*2,75*],
        [Francesco \ Marcon], [5], [0,25], [2,5], [0], [0], [0], [*7,75*],
        [Alessandro \ Mazzariol], [0], [1,5], [0], [0], [0], [3], [*4,5*],
        [Leonardo \ Preo], [0], [1], [0], [0], [0], [4,5], [*5,5*],
        [Valerio \ Solito], [0], [0], [0], [0], [5], [6], [*11*],
        [Matteo \ Mantoan], [0], [0], [4,25], [0], [0], [0,25], [*4,5*],
        [Mario De\ Pasquale], [0], [0,5], [0], [0], [4], [1,5], [*6*],
      )
    ],
  )<tab:Sprint7-ore-effettive>

  ==== Rischi incontrati
  Durante lo sprint corrente, il team ha riscontrato delle criticità nel rispettare le tempistiche previste per la
  revisione RTB. Tali ritardi sono stati causati da difficoltà operative nel completamento e nella successiva
  approvazione della documentazione necessaria, determinando il verificarsi del rischio RO1 (Ritardo Operativo). La
  situazione è stata ulteriormente influenzata dalla concomitanza di sessioni d’esame per diversi membri del gruppo; la
  ridotta disponibilità oraria ha quindi portato all'insorgere del rischio RP1 (Indisponibilità dei Componenti),
  rendendo necessaria una ricalibrazione del carico di lavoro.
  ==== Retrospettiva
  Durante lo Sprint 7, l'attività si è concentrata sulla finalizzazione della documentazione per la RTB. Questa
  focalizzazione ha comportato l'esaurimento del monte ore allocato per il ruolo di Amministratore. Per sopperire alle
  necessità residue nelle fasi successive, il Team ha deliberato di attingere alle ore eccedenti del ruolo di
  Responsabile, garantendo così la copertura delle attività burocratiche e di coordinamento senza intaccare il budget
  totale previsto per il progetto.

  ==== Aggiornamento risorse monetarie rimanenti
  #figure(
    numbering: "1",
    caption: [Sprint 7 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [21], [630],
      [Amministratore], [0], [0],
      [Analista], [0,5], [12,5],
      [Progettista], [137], [3425],
      [Programmatore], [121], [1815],
      [Verificatore], [41,75], [626,25],
      [*Totale*], [*321,25*], [*6508,75*],
    ),
  )<tab:Sprint7-costi>
  #pagebreak()

  == Product Baseline (PB)
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

        [Alessandro \ Contarini], [0], [0], [0], [10], [4], [0], [*14*],
        [Francesco \ Marcon], [0], [1], [0], [10], [4], [0], [*15*],
        [Alessandro \ Mazzariol], [0], [0], [1], [10], [6], [0], [*17*],
        [Leonardo \ Preo], [0], [1], [0], [10], [4], [4,5], [*19*],
        [Valerio \ Solito], [0], [0], [0], [10], [1], [3], [*14*],
        [Matteo \ Mantoan], [5], [0], [0], [10], [4], [0], [*16*],
        [Mario De\ Pasquale], [0], [0], [1], [10], [4], [0], [*15*],
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

        [Alessandro \ Contarini], [0], [0], [0], [10], [4], [0], [*14*],
        [Francesco \ Marcon], [0], [1], [0], [10], [4], [0], [*15*],
        [Alessandro \ Mazzariol], [0], [0], [1], [10], [6], [0], [*17*],
        [Leonardo \ Preo], [0], [1], [0], [10], [4], [4,5], [*19,5*],
        [Valerio \ Solito], [0], [0], [0], [10], [1], [3], [*14*],
        [Matteo \ Mantoan], [5], [0], [0], [10], [4], [0], [*16*],
        [Mario De\ Pasquale], [0], [0], [1], [10], [4], [0], [*15*],
      )
    ],
  )<tab:Sprint8-ore-effettive>

  ==== Rischi incontrati
  Durante lo sprint corrente, il team si è ritrovato ad affrontare difficoltà nella progettazione del sistema, in
  particolare nella definizione dell'architettura dei singoli microservizi e nella stesura di un piano completo per la
  fase di implementazione. Queste sfide insieme ai ritardi accumulati nelle fasi precedenti hanno portato ad un mancato
  rispetto delle scadenze stabilite internamente, proiettando così il verificarsi del rischio RO1 (Ritardo Operativo).

  ==== Retrospettiva
  Al netto dei problemi descritti nella sezione precedente, lo Sprint 8 ha visto il Team immerso positivamente nella
  progettazione, portando ad avere anche grazie alle ore di palestra una visione del Sistema uniforme per tutti i
  membri. Tuttavia, è emersa la necessità di migliorare le ore produttive, al fine di rispettare le scadenze e
  recuperare il ritardo accumulato.

  ==== Aggiornamento risorse monetarie rimanenti
  #figure(
    numbering: "1",
    caption: [Sprint 8 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [16], [480],
      [Amministratore], [-2], [-40],
      [Analista], [-1,5], [-37,5],
      [Progettista], [67], [1675],
      [Programmatore], [97], [1455],
      [Verificatore], [34,25], [513,75],
      [*Totale*], [*210,75*], [*4046,25*],
    ),
  )<tab:Sprint8-costi>

  === Sprint 9
  Inizio: *2026-03-16* \
  Fine prevista: *2026-03-22* \
  Fine reale: *2026-03-22*\
  Giorni di ritardo: 0 \

  ==== Informazioni generali e attività pianificate
  Da questo sprint in poi, il Team ha deciso di passare da periodi di 2 settimane a periodi di 1 settimana, al fine di
  aumentare il monte di lavoro svolto per periodo, permettendo il raggiungimento della quota ore nel tempo previsto.
  Alcune parti del team in questo periodo sono passati dal progettare, alla codifica, iniziando con un periodo intenso
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

        [Alessandro \ Contarini], [1,5], [0], [0], [4], [7], [3,5], [*16*],
        [Francesco \ Marcon], [0], [0], [1], [4], [5], [4,25], [*14,25*],
        [Alessandro \ Mazzariol], [0], [0], [1], [5], [6], [0], [*12*],
        [Leonardo \ Preo], [0], [0], [0], [5], [5], [2], [*12*],
        [Valerio \ Solito], [0], [1], [0], [4], [8], [0], [*13*],
        [Matteo \ Mantoan], [0], [0], [0], [5], [9], [3], [*17*],
        [Mario De\ Pasquale], [0], [0], [0], [5], [5], [0], [*10*],
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

        [Alessandro \ Contarini], [1,5], [0], [0], [4], [7], [3,5], [*16*],
        [Francesco \ Marcon], [0], [0], [1], [4], [5], [4,25], [*14,25*],
        [Alessandro \ Mazzariol], [0], [0], [1], [5], [6], [0], [*12*],
        [Leonardo \ Preo], [0], [0], [0], [5], [5], [2], [*12*],
        [Valerio \ Solito], [0], [1], [0], [4], [8], [0], [*13*],
        [Matteo \ Mantoan], [0], [0], [0], [5], [9], [3], [*17*],
        [Mario De\ Pasquale], [0], [0], [0], [5], [5], [0], [*10*],
      )
    ],
  )<tab:Sprint9-ore-effettive>

  ==== Rischi incontrati
  Durante lo Sprint corrente, il Team si é ritrovato ad affrontare la complessità notevole che il Sistema presentava
  quindi il verificarsi di RT1 (Rischio tecnologico legato all'apprendimento delle tecnologie richieste), in particolare
  nella fase di implementazione. La difficoltà principale è stata quella di riuscire ad adattare la tecnologia richiesta
  alle esigenze del progetto, portando ad un aumento significativo del carico di lavoro di codifica. Durante le prime
  fasi di rilascio del codice, sono state implementate regole per diminuire il verificarsi di RT2 (Rischio tecnologico
  legato ad errori di programmazione), come ad esempio l'adozione di un sistema di code review automatico.
  ==== Retrospettiva
  In conclusione, il Team afferma che il periodo ha portato un miglioramento della qualità del lavoro svolto, grazie
  alla maggiore frequenza degli Sprint, che ha permesso di aumentare l'efficienza. Il Team tuttavia ha deciso di
  posticipare la consegna del MVP al 3 aprile 2026, al fine di poter avere il tempo necessario a completare le attività
  fissate.

  ==== Aggiornamento risorse monetarie rimanenti
  #figure(
    numbering: "1",
    caption: [Sprint 9 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [14,5], [435],
      [Amministratore], [-3], [-60],
      [Analista], [-3,5], [-87,5],
      [Progettista], [35], [875],
      [Programmatore], [52], [780],
      [Verificatore], [21,5], [322,5],
      [*Totale*], [*116,5*], [*2265*],
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

        [Alessandro \ Contarini], [1,5], [0], [0], [4], [7], [3,5], [*16*],
        [Francesco \ Marcon], [0], [0], [1], [4], [5], [4,25], [*14,25*],
        [Alessandro \ Mazzariol], [0], [0], [1], [5], [6], [0], [*12*],
        [Leonardo \ Preo], [0], [0], [0], [5], [5], [2], [*12*],
        [Valerio \ Solito], [0], [1], [0], [4], [8], [0], [*13*],
        [Matteo \ Mantoan], [0], [0], [0], [5], [9], [3], [*17*],
        [Mario De\ Pasquale], [0], [0], [0], [5], [5], [0], [*10*],
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

        [Alessandro \ Contarini], [1,5], [0], [0], [4], [7], [3,5], [*16*],
        [Francesco \ Marcon], [0], [0], [1], [4], [5], [4,25], [*14,25*],
        [Alessandro \ Mazzariol], [0], [0], [1], [5], [6], [0], [*12*],
        [Leonardo \ Preo], [0], [0], [0], [5], [5], [2], [*12*],
        [Valerio \ Solito], [0], [1], [0], [4], [8], [0], [*13*],
        [Matteo \ Mantoan], [0], [0], [0], [5], [9], [3], [*17*],
        [Mario De\ Pasquale], [0], [0], [0], [5], [5], [0], [*10*],
      )
    ],
  )<tab:Sprint10-ore-effettive>

  ==== Rischi incontrati

  ==== Retrospettiva


  ==== Aggiornamento risorse monetarie rimanenti
  #figure(
    numbering: "1",
    caption: [Sprint 10 - Variazione risorse monetarie rimanenti],
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 0.8em,
      table.header([*Ruolo*], [*Ore*], [*Costo*]),

      [Responsabile], [14,5], [435],
      [Amministratore], [-3], [-60],
      [Analista], [-3,5], [-87,5],
      [Progettista], [35], [875],
      [Programmatore], [52], [780],
      [Verificatore], [21,5], [322,5],
      [*Totale*], [*116,5*], [*2265*],
    ),
  )<tab:Sprint10-costi>
]
