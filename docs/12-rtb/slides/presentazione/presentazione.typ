#import "../../00-templates/base_slides.typ" as base-slides

#base-slides.apply-base-slides(
  title: "RTB",
  subtitle: "Gruppo 12 - A.A. 2025/2026",
  date: "2026-03-02",
)[
  == Aggiornamento della comprensione del capitolato
  === E2E Encryption
  Decisione condivisa con la proponente di rinegoziare il requisito

  === Protocollo: NATS nativo vs MQTT
  Semplicità e supporto nativo alla persistenza dei dati, rispetto a protocolli di comunicazione leggeri, che richiedono
  componenti aggiuntivi

  === Scalabilità orizzontale
  Sistema "predisposto" per la scalabilità orizzontale

  === Ampiezza architetturale
  Sottovalutazione della complessità con rischio principale tempo

  #pagebreak()

  == Migliorie ai prodotti "in progress"
  === Norme di Progetto
  Ristrutturazione completa del documento.

  === Analisi dei requisiti
  Aggiunta e correzione di numerosi Use Case.

  === Sviluppo di "notipdo"
  Tool di automazione interno che permette un controllo automatico della documentazione e una gestione rigorosa del
  versionamento.

  == Auto-valutazione del lavoro e del colloquio TB

  === Periodo invernale
  Ritardo accumulato ha portato la TB ad essere ritardata di 2 settimane

  === Organizzazione del lavoro
  - Suddivisione oraria e applicazione delle Norme di Progetto in costante miglioramento
  - Comunicazione poco efficiente

  === Esito colloquio TB
  - Valutazione complessivamente positiva
  - Suggerimento: focus su sostenibilità e obiettivi minimi garantiti

  #pagebreak()

  #let metriche_map = (
    "assets/CPI_SPI.jpeg": "CPI & SPI",
    "assets/EAC.jpeg": "Estimate At Completion (EAC)",
    "assets/AC_ETC.jpeg": "Actual Cost vs Estimate To Complete(ETC)", // or PR resolution time
    "assets/MEI.jpeg": "Meeting Efficiency Index",
    "assets/CO.png": "Correttezza Ortografica",
    "assets/QMS.jpeg": "Quality Metrics Satisfied",
  )

  #grid(
    columns: (1fr, 1fr, 1fr),
    row-gutter: 15pt,
    column-gutter: 10pt,

    ..for (img_path, metric_name) in metriche_map.pairs() {
      (
        align(center)[
          #text(size: 11pt, weight: "bold")[#metric_name]
          #v(0.3em)

          #image(img_path, width: 100%, height: 45mm, fit: "contain")
        ],
      )
    }
  )

  #pagebreak()
  == Consuntivo di periodo allo stato attuale
  #image("assets/CdP.png", width: 100%)

  #pagebreak()

  == Preventivo a finire
  #image("assets/PaF.png", width: 100%)



]
