#import "../../00-templates/base_slides.typ" as base-slides
#import "../../00-templates/base_configs.typ" as base-configs

#let shot(path, width: 100%, height: auto, caption: []) = figure(
  image(path, width: width, height: height, fit: "contain"),
  caption: caption,
)

#base-slides.apply-base-slides(
  title: "Colloquio - PB",
  subtitle: "Gruppo 12 - A.A. 2025/2026",
  date: "DATE TBD",
)[
  #set text(16pt)

  = Stato del prodotto rispetto alle attese iniziali

  - Progettazione, codifica e verifica sempre allineati.

  #v(1em)

  - MVP completo nel flusso dati end-to-end sicuro e multi-tenant.
  - Documentazione tecnica e utente adeguata.

  #pagebreak()

  - Scalabilità e deployment in produzione:
    - buone basi tecnologiche,
    - assenza di un piano maturo.

  - E2EE rinegoziata per Opaque Pipeline.

  - GUI di simulazione gateway rimpiazzata da CLI.

  - Logging portato come PoC.

  = Feedback ricevuti e autovalutazione

  == Riscontro MVP del proponente
  - Il riscontro sul MVP è stato buono e sostanzialmente in linea con ciò che ci aspettavamo.
  - Poca guidance, critica costruttiva, direzione.

  == Riscontro del docente
  - Molte osservazioni e correzioni.
  - Eravamo consapevoli delle parti più deboli del nostro lavoro.
  - Molto valore costruttivo.

  = Difficoltà incontrate e mitigazione

  == Difficoltà principali
  - Complessità tecnica elevata in fase di progettazione e integrazione.
  - Mancanza di una figura di riferimento costante con cui validare progressivamente le scelte.
  - Necessità di tagliare costi e tempi senza snaturare il progetto.

  == Mitigazioni adottate
  - Progettazione svolta spesso in gruppo.
  - Rinegoziazione dei requisiti.
  - Sprint brevi nella fase finale.
  - Verifiche più strette su codice e artefatti.

  = Way of working e gestione di progetto

  Il Team è arrivato a un way of working solido e adottato da tutti.

  == Miglioramenti
  - Capacità individuale di stima dei tempi.
    // ridotto ottimismo (circa)

  - Automazione estensiva: sviluppo, verifica, gestione della configurazione.
    // CI/CD, SonarQube, GitHub Actions, OpenAPI + AsyncAPI code gen, ecc.
  - Controlli di qualità automatici bloccanti.
    // check PR, SonarQube, ecc.
  - Miglioramento comunicazione, collaborazione, apprendimento.

  == Autovalutazione
  // Bookmark: arrivati qui come contenuti
  // TODO: continuare
  - Costruzione bottom-up, mancanza di feedback professionale.

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
