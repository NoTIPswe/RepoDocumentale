#import "../../00-templates/base_slides.typ" as base-slides

#base-slides.apply-base-slides(
  title: "Colloquio tecnico - PB",
  subtitle: "Gruppo 12 - A.A. 2025/2026",
  date: "2026-04-xx",
)[

  = C7: Sistema di Acquisizione Dati da Sensori

  == Obiettivo del progetto
  Realizzare un sistema distribuito di acquisizione e smistamento dati, strutturato su 3 livelli:
  - *Sensori:* Raccolta dati dal campo (simulati)
  - *Gateway:* Normalizzazione ed invio sicuro (simulati)
  - *Cloud:* Piattaforma centrale di gestione

  #pagebreak()

  == Tecnologie
  - *NATS JetStream* (Message Broker)
  - *PostgreSQL + TimescaleDB* (Database)
  - *Go* (Simulatore e Consumer)
  - *NestJS* (API e servizi non critici)
  - *Angular + TypeScript SDK* (Frontend)
  - *Prometheus + Grafana* (Monitoraggio)
  - *Keycloak* (Autenticazione)
  - *Nginx* (Reverse proxy)
  - *SQLite* (Database)
  - *Docker* (Containerizzazione)

  // add immages

  #pagebreak()

  == Architettura di Deployment: microservizi

  - #link(<webapp_c4>)[*WebApp*]
  - #link(<dataAPI>)[*Data API*]
  - #link(<managementAPI_c4>)[*Management API*]
  - #link(<provisioningService>)[*Provisioning Service*]
  - #link(<dataConsumer>)[*Data Consumer*]
  - #link(<simulatorBackend>)[*Simulator Backend*]
  - #link(<simulatorCLI>)[*Simulator CLI*]
  - #link(<cryptoSDK>)[*Crypto SDK*] 

  = MVP
  #align(center)[
    #figure[
      #image("assets/Containers.svg", height: 110%)
    ]
  ]

  = WebApp 
  #align(center)[
    #figure[
      #image("../../docest/specifica_tecnica_frontend/assets/01-app-architecture.svg")
    ]<webapp_c4>
  ]

  = Management API 
  #align(center)[
    #figure[
      #image("../../docest/specifica_tecnica_management_api/assets/01-app-architecture.svg")
    ]<managementAPI_c4>
  ]

  = Data Consumer 
  #align(center)[
    #figure[
      #image("../../docest/specifica_tecnica_data_consumer/assets/data-consumer.png")
    ]<dataConsumer>
  ] 

  = Provisioning Service 
  #align(center)[
    #figure[
      #image("../../docest/specifica_tecnica_provisioning_service/assets/provisioning_service.png")
    ]<provisioningService>
  ]

  = Data API 
  #align(center)[
    #figure[
      #image("../../docest/specifica_tecnica_data_api/assets/01-app-architecture.svg")
    ]<dataAPI>
  ]

  = Simulator Backend 
  #align(center)[
    #figure[
      #image("../../docest/specifica_tecnica_simulator_backend_cli/assets/notip-simulator-backend.svg")
    ]<simulatorBackend>
  ]

  = Simulator CLI 
  #align(center)[
    #figure[
      #image("../../docest/specifica_tecnica_simulator_backend_cli/assets/simulator_cli.png")
    ]<simulatorCLI>
  ]

  = Crypto SDK 
  #align(center)[
    #figure[
      #image("../../docest/specifica_tecnica_crypto_sdk/assets/arch_class_diagram.png")
    ]<cryptoSDK>
  ]

]
