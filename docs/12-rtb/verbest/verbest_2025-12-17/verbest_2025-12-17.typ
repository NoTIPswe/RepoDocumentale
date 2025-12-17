#import "../../00-templates/base_verbale.typ" as base-report

#let metadata = yaml("verbest_2025-12-17.meta.yaml")
#base-report.apply-base-verbale(
  date: "2025-12-17",
  scope: base-report.EXTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Francesco Marcon \
        Leonardo Preo \
        Matteo Mantoan \
        Mario De Pasquale \
        Valerio Solito \
        Alessandro Contarini \
        Alessandro Mazzariol \
      ],
    ),
  ),
  abstract: "Il presente documento riporta il resoconto dell'incontro di Sprint Review esterna tenutosi in remoto. L'incontro ha avuto come oggetto la presentazione dello stato avanzamento e la discussione delle criticità riscontrate.",
  changelog: metadata.changelog,
)[
  Il presente documento attesta formalmente che, in data *17 Dicembre 2025*, si è tenuto un incontro in remoto tramite Microsoft Teams con la proponente _M31_, con una durata compresa tra le *14:30* e le *15:30*.

  A rappresentare l’Azienda erano presenti Cristian Pirlog e Moones Mobaraki.
][
  L’incontro è stato dedicato alla revisione della documentazione prodotta dal gruppo durante lo Sprint 2. Ogni documento è stato analizzato e commentato congiuntamente al referente aziendale, in modo più o meno approfondito a seconda dell'entità dello stesso.

  Tale modalità ha permesso di illustrare nel dettaglio le scelte effettuate e di ricevere feedback immediati riguardanti principalmente i documenti nati proprio durante lo Sprint di cui la Review tratta.
][

  #base-report.report-point(
    discussion_point: [Analisi dei Requisiti e ritardi sulla timeline.],
    discussion: [
      Il gruppo ha esposto nel dettaglio la metodologia adottata per la stesura dei Casi d'Uso (UC). È stata evidenziata la scelta di procedere con una granularità molto fine (definita "quasi a passo singolo"), ritenuta indispensabile per far emergere i requisiti in modo esaustivo, seguendo quanto richiesto dal corso.
      Si è discusso di come tale approccio, seppur estremamente oneroso in termini di tempo, sia necessario per ridurre ambiguità future. 
      
      Il gruppo ha quindi motivato il ritardo accumulato rispetto alla timeline prevista come conseguenza diretta di questa fase di analisi e comprensione delle criticità dell'approccio finora adottato.
    ],
    decisions: [
      L'Azienda ha validato il nuovo approccio proposto dal gruppo. È stato concordato che investire tempo ora nella definizione precisa dei casi d'uso è preferibile rispetto a dover correggere errori strutturali in fasi successive nel progetto.
    ]
  )

  #base-report.report-point(
    discussion_point: [Revisione Timeline e pianificazione Milestone interne.],
    discussion: [
      È stata presentata la nuova strategia di pianificazione temporale. Per mitigare il rischio di disallineamenti futuri, il gruppo deciso di introdurre delle *milestone interne* volte a frazionare maggiormente il lavoro tra le scadenze ufficiali imposte dal corso.
      È stata successivamente presentata la nuova timeline prevista, da cui abbiamo ricevuto conferma che le scadenze proposte si allineano correttamente con le loro aspettative.
    ],
    decisions: [
      La nuova pianificazione è stata approvata. L'Azienda ha inoltre invita il gruppo a trasmettere eventuali dubbi o richieste di chiarimento prima della pausa natalizia, al fine di garantire continuità operativa ed evitare blocchi durante le festività.
    ]
  )

  #base-report.report-point(
    discussion_point: [Revisione Piano di Qualifica e delle Metriche.],
    discussion: [
      Il gruppo ha illustrato la struttura del Piano di Qualifica e le metriche individuate. Il confronto con l'Azienda ha fatto emergere diversi punti di attenzione:
      - *Validità delle metriche (es. RSI)*, L'indice di stabilità dei requisiti (RSI) è stato giudicato spesso poco realistico in contesti agili, dove i requisiti sono soggetti a cambiamenti frequenti ("mondo reale" vs "mondo ideale").
      - *Soglie di accettazione*, È stato notato che definire soglie di accettazione meramente "superiori allo 0%" non è indice di qualità realmente sufficente.
      - *Qualità dei commit*, in riferimento alla metrica associata, l'azienda consiglia l'adozione dello standard *Conventional Commits* per garantire ordine e leggibilità nella history del progetto.
      - *Usabilità vs Funzionalità*, In questa fase iniziale, le metriche di usabilità sono considerate secondarie rispetto alla necessità di fornire un applicativo funzionante e stabile.
      - *Applicazione al POC*, Molte metriche di processo e prodotto saranno applicate in ottica migliorativa solo per l'MVP, mentre per il POC si adotterà un approccio più orientato al produrre qualcosa di concreto.
    ],
    decisions: [
      Il gruppo decide quindi di aggiornare il Piano di Qualifica secondo i seguenti punti:
      - Revisione di alcune metriche ostiche da misurare;
      - Revisione delle soglie di accettazione;
      - Focalizzazione sull'MVP per l'applicazione rigorosa delle metriche discusse.
    ],
    // actions: (
    //   (
    //     desc: "Palestra su Conventionnal Commit", 
    //     url: "a"
    //   ),
    //   (
    //     desc: "Rivedere le metriche Criticate", 
    //     url: "a"
    //   ),
    // ),
  )

  #base-report.report-point(
    discussion_point: [Analisi dei Rischi e Piano di Progetto.],
    discussion: [
      Su specifica richiesta del referente aziendale, riflettendo quello che avviene in contesti professionali e lavorativi, è stato richiesto di presentare la sezione del Piano di Progetto relativa al all'Analisi dei Rischi. Il gruppo ha presentato la matrice dei rischi individuati, analizzandone probabilità, impatto e le relative strategie di mitigazione previste.
    ],
    decisions: [
      L'Azienda ha confermato la validità dell'analisi svolta, ritenendo i rischi identificati coerenti con la natura del progetto e le contromisure adeguate per lo stato attuale del progetto.
    ]
  )

  #base-report.report-point(
    discussion_point: [Definizione requisiti e aspettative per il POC.],
    discussion: [
      La discussione si è concentrata sui deliverable attesi per il Proof of Concept (POC). L'Azienda ha delineato le seguenti richieste:
      - *Simulazione Gateway:* Realizzazione di una bozza di gateway (anche simulato) capace di instaurare una comunicazione.
      - *Sicurezza:* Implementazione di una sincronizzazione sicura e protetta verso il Cloud per il trasferimento dati.
      - *Interfacce Dati:* Esposizione di API per la richiesta dei dati, testabili tramite client standard (come Postman o client MQTT).
      - *Frontend:* La presenza di una dashboard grafica non è un requisito bloccante per il POC, ma è considerata un valore aggiunto ("nice to have").
    ],
    decisions: [
      Viene confermata la natura esplorativa del POC. Il codice prodotto potrà essere "usa e getta", focalizzato sulla validazione architetturale e tecnologica.
    ]
  )
]