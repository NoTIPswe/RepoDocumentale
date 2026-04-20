#import "../../00-templates/base_slides.typ" as base-slides
#import "../../00-templates/base_configs.typ" as base-configs

#let shot(path, width: 100%, height: auto, caption: []) = figure(
  image(path, width: width, height: height, fit: "contain"),
  caption: caption,
)

#base-slides.apply-base-slides(
  title: "Colloquio - PB",
  subtitle: "Gruppo 12 - A.A. 2025/2026",
  date: "2026-04-20",
)[

  = Stato del prodotto rispetto alle attese iniziali
  #grid(
    columns: (1fr, 1fr),
    gutter: 1.2cm,
  )[
    == Dove siamo in linea

    #set text(size: 0.88em)
    - MVP completo nel flusso *end-to-end*: simulazione, ingestione, persistenza, consultazione e gestione operativa.
    - Implementazione concreta delle funzionalità essenziali del capitolato lato cloud.
    - Documentazione tecnica e utente sufficiente a rendere il prodotto comprensibile e verificabile.
    - Riscontro del proponente complessivamente buono: il MVP ha rispecchiato le aspettative.
  ][
    == Dove siamo sotto attesa

    #set text(size: 0.88em)
    - Piano di deployment in produzione non ancora maturo.
    - Scalabilità trattata in modo architetturale, ma non validata a fondo sul piano operativo.
    - Alcune scelte di progettazione sono rimaste in *tech debt*, in particolare sul `Provisioning Service`.
    - Per arrivare al MVP sono stati tagliati diversi angoli: scelta consapevole, ma da esplicitare.
  ]

  #pagebreak()

  == Lettura del divario rispetto alle attese

  - Come baseline consideriamo il *capitolato* raffinato tramite la nostra analisi dei requisiti: non una promessa
    astratta, ma il perimetro che il Team ha progressivamente reso realizzabile.
  - In questo quadro, la *progettazione* è stata in parte rinegoziata per rendere il prodotto chiudibile entro i vincoli
    reali di tempo, competenze e complessità.
  - La *codifica* e la *verifica* sono invece coerenti con la parte progettata e poi effettivamente portata a termine:
    abbiamo privilegiato il completamento del nucleo essenziale rispetto all'inseguimento di ambizioni premature.

  = Feedback ricevuti e autovalutazione

  #grid(
    columns: (1fr, 1fr),
    gutter: 1.2cm,
  )[
    == Riscontro del proponente

    #set text(size: 0.88em)
    - Il riscontro sul MVP è stato buono e sostanzialmente in linea con ciò che ci aspettavamo.
    - La piattaforma è stata percepita come coerente con l'idea di prodotto presentata.
    - Questo conferma che la scelta di convergere su un MVP concreto, invece di inseguire più ampiezza, è stata corretta.
  ][
    == Riscontro del docente

    #set text(size: 0.88em)
    - Il colloquio con il docente ha prodotto molte osservazioni e correzioni.
    - Anche questo era atteso: eravamo consapevoli delle parti più deboli del nostro lavoro.
    - Il valore del confronto è stato soprattutto direzionale: ci ha dato un feedback critico che durante il progetto è
      mancato spesso.
  ]

  #pagebreak()

  == Autovalutazione del colloquio PB

  - L'esito viene valutato positivamente non perché tutto fosse già rifinito, ma perché il prodotto era abbastanza
    solido da sostenere una discussione tecnica vera.
  - La critica principale che ci portiamo via è che il sistema, per un progetto didattico, è forse risultato un po'
    troppo complesso.
  - Alcune parole-chiave del capitolato hanno spinto verso una soluzione ampia e ambiziosa; in retrospettiva, una
    maggiore semplificazione iniziale avrebbe ridotto il carico di rischio.

  = Difficoltà incontrate e mitigazione

  #grid(
    columns: (1fr, 1fr),
    gutter: 1.2cm,
  )[
    == Difficoltà principali

    #set text(size: 0.86em)
    - Complessità tecnica elevata in fase di progettazione e integrazione.
    - Mancanza di una figura di riferimento costante con cui validare progressivamente le scelte.
    - Necessità di tagliare costi e tempi senza snaturare il progetto.
    - Ultimo periodo vissuto come *emotional rollercoaster*, con pressione alta sulla chiusura.
  ][
    == Mitigazioni adottate

    #set text(size: 0.86em)
    - Progettazione svolta spesso in gruppo per avere più punti di vista e intercettare errori prima.
    - Rinegoziazione del perimetro progettuale per proteggere la consegna del MVP.
    - Sprint brevi e ravvicinati nella fase finale per aumentare controllo e capacità di recupero.
    - Verifiche più strette su codice e artefatti per contenere regressioni e difetti.
  ]

  #pagebreak()

  == Lezione appresa più importante

  - La criticità non è stata solo tecnica: è stata soprattutto di *governo della complessità*.
  - Quando il feedback esterno è poco frequente, diventa fondamentale costruire rapidamente meccanismi interni di
    riallineamento: review, quality gate, integrazione continua, retrospettive e rinegoziazione esplicita delle priorità.
  - In altre parole, il progetto ci ha insegnato che un buon risultato finale dipende almeno quanto dal *processo* quanto
    dalla soluzione tecnica.

  = Miglioramenti del way of working

  #grid(
    columns: (1.15fr, 0.85fr),
    gutter: 1cm,
  )[
    #set text(size: 0.84em)
    == Evoluzione del modo di lavorare

    - Lo sviluppo e la verifica sono diventati progressivamente più strutturati.
    - Il Team è arrivato a un *way of working* solido, condiviso e soprattutto adottato da tutti.
    - L'automazione introdotta ha reso più affidabili i controlli di qualità e ha ridotto il carico di verifica manuale.
    - Pur con qualche eccesso didattico, i controlli bloccanti hanno migliorato il livello medio degli output prodotti.

    == Limite riconosciuto

    - È mancato un confronto continuo con soluzioni esterne o benchmark forti.
    - Questo rende più difficile capire non solo se qualcosa *funziona*, ma se funziona *nel modo migliore possibile*.
  ][
    #shot(
      "../../docest/piano_qualifica/assets/QMS.png",
      width: 100%,
      caption: [Andamento delle metriche di qualità soddisfatte],
    )

    #shot(
      "../../docest/piano_qualifica/assets/TE.png",
      width: 100%,
      caption: [Crescita dell'efficienza temporale negli sprint PB],
    )
  ]

  #pagebreak()

  == Qualità raggiunta nel periodo PB

  - Le metriche di qualità sono rimaste sopra la soglia di accettabilità per tutta la fase PB, attestandosi nella parte
    finale intorno al *95%* di *Quality Metrics Satisfied*.
  - La *Time Efficiency* è cresciuta in modo costante sprint dopo sprint, segnale di un Team più consapevole e più
    efficace nell'uso del tempo.
  - I *Quality Gate* hanno sostenuto la chiusura del progetto: nella documentazione finale tutti i repository risultano
    in stato `Passed`.

  = Consuntivo finale di progetto

  #set text(size: 0.72em)
  #figure(
    caption: [Ore complessive effettive per componente e per ruolo],
    [
      #table(
        columns: (1fr, 0.9fr, 0.9fr, 0.9fr, 0.9fr, 0.9fr, 0.9fr, 0.9fr),
        align: (left, center, center, center, center, center, center, center),
        inset: 0.45em,
        table.header(
          [],
          [*Resp.*],
          [*Amm.*],
          [*Anal.*],
          [*Prog.*],
          [*Cod.*],
          [*Ver.*],
          [*Tot.*],
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
  )

  #pagebreak()

  #grid(
    columns: (1fr, 1fr),
    gutter: 1.2cm,
  )[
    == Dati finali

    #set text(size: 0.9em)
    - Totale ore effettive consumate: *643*.
    - Budget finale speso: *12.937,50 EUR*.
    - Residuo conclusivo: *2,50 EUR*, quindi chiusura sostanzialmente allineata al preventivo.
    - Distribuzione dell'impegno uniforme tra i componenti: *91-93 ore* a persona.
  ][
    == Messaggio conclusivo

    #set text(size: 0.9em)
    - Il progetto si chiude con un MVP reale, una documentazione estesa e un processo di lavoro sensibilmente maturato.
    - Restano margini di miglioramento su semplificazione, feedback esterno e maturità del deployment.
    - L'apprendimento principale è aver trasformato un sistema complesso in un prodotto consegnabile senza perdere il
      controllo su qualità e responsabilità.
  ]

]
