#import "../../00-templates/base_slides.typ" as base-slides

#base-slides.apply-base-slides(
  title: "Tecnologie",
  subtitle: "Gruppo 12 - A.A. 2025/2026",
  date: "2026-02-16",
)[
  = C7: Sistema di Acquisizione Dati da Sensori
  == Obiettivo del progetto
  Realizzare un sistema distribuito di acquisizione e smistamento dati, strutturato su 3 livelli:
  - *Sensori:* Raccolta dati dal campo (simulati)
  - *Gateway:* Normalizzazione ed invio sicuro (simulati)
  - *Cloud:* Piattaforma centrale di gestione

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

  = Architettura di deploy

  - *Microservizi* (parte cloud)
    - _*Alternative considerate:*_ Monolite
    - _*Scelta:*_ Garantisce isolamento dei guasti e facilita lo sviluppo parallelo del team. Permette la scalabilità
      orizzontale dei servizi

  = Tecnologie Utilizzate

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

  - *Go* (Simulatore e Consumer)
    - _*Alternative considerate:*_ TypeScript (Nest.js o Node.js puro)
    - _*Scelta:*_ Gestione ottimale della concorrenza (Goroutines) per simulare insiemi di dispositivi con basso
      footprint di risorse e sviluppare servizi a bassa latenza
  - *NestJS* (API e servizi non critici)
    - _*Alternative considerate:*_ Gin (Go)
    - _*Scelta:*_ Struttura modulare e integrazione con TypeORM per query ottimizzate e gestione manutenibile della
      logica di business. Permette la facile costruzione delle API.

  #pagebreak()

  - *Angular + TypeScript SDK* (Frontend)
    - _*Scelta:*_ TypeScript SDK permette di gestire la decifrazione dei dati "lato client" (End-to-End Encryption),
      garantendo che il dato in chiaro sia visibile solo all'utente finale. Framework molto completo e pieno sostegno da
      parte dell'azienda proponente

  #pagebreak()

  - *Prometheus + Grafana* (Monitoraggio)
    - _*Scelta:*_ Standard de-facto per il monitoring cloud-native. Soluzione open-source con forte community e
      flessibilità di personalizzazione. Permette di monitorare efficacemente le performance del sistema e visualizzare
      metriche chiave

  = PoC

  == Componenti realizzati
  1. *Gateway Simulator (Go):* Simula invio dati, mTLS, e concorrenza
  2. *Data Queue (NATS):* Ingestion diretta; garantisce bufferizzazione e resilienza
  3. *Storage & Segregazione:* Implementazione della multi-tenancy logica su TimescaleDB
  4. *Dashboard (Angular):* Visualizzazione Real-Time con decifrazione client-side
  5. *Observability di base*: Setup base di Prometheus e Grafana per monitoraggio di NATS.

  == Esclusi dalla realizzazione
  - *API esterne*, *Flusso Bidirezionale* e *Auth Utente* rimandati all'MVP
  - Sistema di alerting, logging centralizzato e tracing distribuito

  #pagebreak()

  #align(center)[
    #image("assets/architettura_poc.svg")
  ]

]
