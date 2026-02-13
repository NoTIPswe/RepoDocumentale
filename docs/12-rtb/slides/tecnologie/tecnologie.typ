#import "../../00-templates/base_slides.typ" as base-slides

#base-slides.apply-base-slides(
  title: "Tecnologie",
  subtitle: "Gruppo 12 - A.A. 2025/2026",
  date: "12/02/2026",
)[
  = C7: Sistema di Acquisizione Dati da Sensori
  == Obiettivo del progetto
  Realizzare un sistema distribuito di acquisizione e smistamento dati, strutturato su 3 livelli:
  - *Sensori:* Raccolta dati dal campo (simulati)
  - *Gateway:* Normalizzazione ed invio sicuro (simulati)
  - *Cloud:* Piattaforma centrale di gestione

  #pagebreak()

  #align(center)[
    #image("assets/es_architettura.png")
  ]

  #pagebreak()

  #align(center)[
    #image("assets/es_architettura_grande.png")
  ]

  #pagebreak()

  == Requisiti Fondamentali
  - *Scalabilità e Sicurezza:* Progettare un'infrastruttura capace di gestire dati sensibili da sensori eterogenei in
    modo robusto
  - *Multi-tenancy:* Garantire la segregazione logica dei dati, permettendo a più clienti di condividere il sistema in
    totale isolamento
  - *Canali Sicuri:* Implementare comunicazioni protette end-to-end
  - *Fruibilità:* Fornire dashboard per il monitoraggio in tempo reale e API per l'integrazione con sistemi esterni

  = Architettura
  - *Microservizi*
    - _*Alternative considerate:*_ Serverless, Edge Computing
    - _*Scelta:*_ Garantisce isolamento dei guasti e facilita lo sviluppo parallelo del team. Permette la scalabilità
      orizzontale dei servizi

  = Tecnologie Utilizzate
  - *Go* (Linguaggio Simulatore e Consumer)
    - _*Alternative considerate:*_ TypeScript (Nest.js o Node.js)
    - _*Scelta:*_ Gestione ottimale della concorrenza (Goroutines) per simulare insiemi di dispositivi con basso
      footprint di risorse
  - *NATS JetStream* (Message Broker)
    - _*Alternative considerate:*_ Apache Kafka, Google Cloud Pub/Sub
    - _*Scelta:*_ Semplicità di implementazione rispetto a Kafka, sicurezza integrata

  #pagebreak()

  - *PostgreSQL + TimescaleDB* (Database)
    - _*Alternative considerate:*_ Database Relazionali puri e/o Time-Series puri
    - _*Scelta:*_ Unisce l'affidabilità SQL per i dati strutturati (tenant) alle performance delle Hypertables per le
      serie temporali. \
      TimescaleDB permette di gestire efficientemente lo storico temporale dei sensori, evitando l'introduzione di un
      database NoSQL dedicato

  #pagebreak()

  - *NestJS* (DataAPI)
    - _*Alternative considerate:*_ Gin (Go)
    - _*Scelta:*_ Struttura modulare e integrazione con TypeORM per query ottimizzate e gestione manutenibile della
      logica di business. Permette la facile costruzione delle API.
  - *Angular + TypeScript SDK* (Frontend)
    - _*Scelta:*_ TypeScript SDK permette di gestire la decifrazione dei dati "lato client" (End-to-End Encryption),
      garantendo che il dato in chiaro sia visibile solo all'utente finale. Framework molto completo e pieno sostegno da
      parte dell'azienda proponente

  = PoC

  == Componenti realizzati
  1. *Gateway Simulator (Go):* Simula invio dati, mTLS, e concorrenza
  2. *Data Queue (NATS):* Ingestion diretta; garantisce bufferizzazione e resilienza
  3. *Storage & Segregazione:* Implementazione della multi-tenancy logica su TimescaleDB
  4. *Dashboard (Angular):* Visualizzazione Real-Time con decifrazione client-side

  == Esclusi dalla realizzazione
  - *Monitoraggio* e *Auth Utente* rimandati all'MVP

  #pagebreak()

  #align(center)[
    #image("assets/architettura_poc.svg")
  ]

]
