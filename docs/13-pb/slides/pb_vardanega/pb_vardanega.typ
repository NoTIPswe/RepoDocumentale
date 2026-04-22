#import "../../00-templates/base_slides.typ" as base-slides
#import "../../00-templates/base_configs.typ" as base-configs

#let shot(path, width: 100%, height: auto, caption: []) = figure(
  image(path, width: width, height: height, fit: "contain"),
  caption: caption,
)

#base-slides.apply-base-slides(
  title: "Colloquio - PB",
  subtitle: "Gruppo 12 - A.A. 2025/2026",
  date: "2026-04-23",
)[
  #set text(16pt, font: base-configs.sans-font)

  = Stato del prodotto rispetto alle attese iniziali

  #grid(
    columns: (2fr, 3fr),
    gutter: 1em,
    [
      == Filosofia adottata

      *Progettazione, codifica e verifica sempre allineati*.

      #v(1em)

      == Stato del prodotto

      - *MVP* completo, *sicuro* e *multi-tenant*.
      - *Documentazione* tecnica e utente *adeguata*.
    ],
    [
      #image(
        "../../docest/manuale_utente/assets/historical.png",
      )
    ],
  )


  #pagebreak()

  #grid(
    columns: (1fr, 1fr),
    align: (left + top, left + top),
    gutter: 2em,
    [
      == Requisiti soddisfatti

      - *Interfaccia* utente per 3 tipi di utenti.

      - *Flusso dati* end-to-end completo (streaming + storici).

      - *Simulazione* gateway e anomalie.

      - *Zero-touch provisioning* dei gateway.

      - Esposizione *API* per integrazione con sistemi esterni.

      - Fornitura *SDK* per sviluppo di applicazioni client.

      - *Observability* via Grafana.
    ],
    [
      == Requisiti rinegoziati

      - *Scalabilità e deployment* in produzione:
        - *buone basi* tecnologiche,
        - *assenza* di un *piano solido*.

      - E2EE rinegoziata per *Opaque Pipeline*.

      - *GUI* di simulazione gateway rimpiazzata da *CLI*.

      - *Logging* (auditing) portato come *PoC*.
    ],
  )

  = Feedback ricevuti e autovalutazione

  == Riscontro MVP del proponente

  - Riscontro MVP *ottimo* e *in linea* con le nostre *aspettative*.

  - *Poca _guidance_*, critica costruttiva, direzione.

  #v(2em)

  #align(right)[
    #image("assets/notip-handshake-m31.png", width: 40%)
  ]

  #pagebreak()


  #grid(
    columns: (auto, auto),
    align: (left + top, center + bottom),
    gutter: 5em,
    [
      == Riscontro colloquio PB

      - Eravamo *consapevoli* delle *parti più deboli* del nostro lavoro.
      // - Debito tecnico ragionato

      - *Molte osservazioni* e correzioni tecniche.
      // - Comprensione non perfetta di alcuni concetti (es. CQRS, esposizione design logico Angular, ecc.)
      // - Design logico provisioning service.

      - Molto *valore costruttivo*.
      // - Indicazioni su come migliorare presentazione e esposizione
      // - LLM

      #v(10em)
    ],
    image("assets/greenlight.png", height: 50%),
  )

  = Difficoltà incontrate e mitigazione

  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    align: (left + top, left + top),
    [
      == Difficoltà principali

      - *Complessità tecnica* elevata in fase di progettazione e integrazione.

      - *Mancanza* di una *figura di riferimento* costante.

      - *Ampiezza* del capitolato: necessità di *abbattere costi* e tempi *senza snaturare* il progetto.
    ],
    [
      == Mitigazioni adottate

      - Progettazione svolta spesso *in gruppo*.

      - *Rinegoziazione* dei requisiti.

      - *Sprint brevi* nella fase finale.

      - *Verifiche strette* su codice e artefatti.
    ],
  )


  = Way of working e gestione di progetto

  #grid(
    columns: (1fr, 1fr),
    align: (left, center),
    gutter: 1em,
    [
      Il Team è arrivato a un _way of working_ *solido e adottato da tutti*.

      == Miglioramenti
      - Capacità individuale di *stima dei tempi*.
      - *Automazione estensiva*: sviluppo, verifica, gestione della configurazione.
      - *Controlli* di qualità automatici *bloccanti*.
      - Miglioramento di *comunicazione, collaborazione, apprendimento*.

      == Autovalutazione
      - Costruzione _from first principles_, *mancanza di feedback* esterno.
    ],
    [
      #image("../../docest/piano_qualifica/assets/QMS.png", width: 80%)

      #image("assets/just-in-time-wow.png", width: 80%)
    ],
  )

  = Consuntivo finale di progetto

  #grid(
    columns: (1.5fr, 2fr),
    [
      #v(1em)
      *Spesa*: €12.937,50

      *Ritardo*: 23 giorni

      #image("../../docest/piano_progetto/assets/chart.svg")
    ],
    [
      #set text(size: 0.75em)
      #figure(
        [
          #table(
            columns: (1.1fr, 0.7fr, 0.7fr, 0.7fr, 0.7fr, 0.7fr, 0.7fr, 0.7fr),
            align: (left, center, center, center, center, center, center, center),
            inset: 0.45em,
            table.header([], [*Resp.*], [*Amm.*], [*Anal.*], [*Prog.*], [*Cod.*], [*Ver.*], [*Tot.*]),

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
    ],
  )


]
