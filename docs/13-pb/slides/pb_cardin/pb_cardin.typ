#import "../../00-templates/base_slides.typ" as base-slides
#import "../../00-templates/base_configs.typ" as base-configs

#base-slides.apply-base-slides(
  title: "Colloquio tecnico - PB",
  subtitle: "Gruppo 12 - A.A. 2025/2026",
  date: "2026-04-17",
)[

  = C7: Sistema di Acquisizione Dati da Sensori

  == Obiettivo del progetto
  Realizzare un sistema distribuito di acquisizione e smistamento dati, strutturato su 3 livelli:
  - *Sensori:* raccolta dati dal campo (simulati).
  - *Gateway:* normalizzazione ed invio sicuro (simulati).
  - *Cloud:* piattaforma centrale di gestione.

  #pagebreak()

  == Tecnologie
  #grid(
    columns: (1.3fr, 1fr),
    column-gutter: 30pt,

    // LEFT COLUMN: technology list
    [
      - *NATS JetStream* (Message Broker).
      - *PostgreSQL + TimescaleDB* (Database).
      - *Go* (Simulatore e Consumer).
      - *NestJS* (API e servizi non critici).
      - *Angular + TypeScript SDK* (Frontend).
      - *Prometheus + Grafana* (Monitoraggio).
      - *Keycloak* (Autenticazione).
      - *Nginx* (Reverse proxy).
      - *SQLite* (Database).
      - *Docker* (Containerizzazione).
    ],

    // RIGHT COLUMN: logos scattered
    [
      #grid(
        columns: (1fr, 2fr),
        column-gutter: 15pt,
        row-gutter: 20pt,
        align: center,

        image("assets/docker.png", height: 40pt), image("assets/angular.png", height: 40pt),
        image("assets/postgreSQL.png", height: 40pt), image("assets/nats.png", height: 40pt),
        image("assets/prometheus.png", height: 40pt), image("assets/keycloak.svg", height: 40pt),
        image("assets/grafana.png", height: 40pt), image("assets/go.png", height: 40pt),
        image("assets/nestjs.svg", height: 40pt), image("assets/timescaledb.png", height: 40pt),
      )
    ],
  )

  = MVP \ Architettura e Design Pattern

  #align(center)[
    #figure[
      #image("assets/Containers.svg")
    ]
  ]

  #pagebreak()

  == Architettura di Deployment: microservizi <home>

  #v(20pt)

  #grid(
    columns: (1fr, 1fr, 1fr),
    rows: (auto, auto, auto),
    column-gutter: 40pt,
    row-gutter: 50pt,
    align: center,

    [*WebApp*], [],

    [*Simulator Backend*], [], link(<dataConsumer>)[#underline(stroke: 1.2pt)[*Data Consumer*]],
    [], link(<managementAPI_c4>)[#underline(stroke: 1.2pt)[*Management API*]], [],
    [*Simulator CLI*], [], link(<provisioningService>)[#underline(stroke: 1.2pt)[*Provisioning Service*]],
    [], [*Data API*], [],
    link(<cryptoSDK>)[#underline(stroke: 1.2pt)[*Crypto SDK*]],
  )

  #let inline-slide(title, body) = [
    #pagebreak()
    #set page(header: base-configs.default-header(
      title: "Colloquio tecnico - PB",
      section: title,
    ))
    #text(size: 26pt, weight: "bold", font: base-configs.sans-font)[#title]
    #move(dy: -0.7em)[
      #line(length: 35%, stroke: 4pt + base-configs.color-primary)
    ]
    #v(0.1em)
    #body
  ]

  #inline-slide([Management API], [
    #grid(
      columns: (1fr, 4fr, 7fr),
      align(top)[#link(<home>)[<]],
      align(left + horizon)[
        #set text(size: 0.8em)
        - *Layered Architecture* + *logic modules*.
        - *Controller-Service-Persistence*.
        - *Mapper Pattern*.
        - *Event-Driven Pattern*.
        - *Guard & Decorator Pattern*. 
      ],
      align(center + horizon)[
        #figure[
          #image("../../docest/specifica_tecnica_management_api/assets/01-app-architecture-part3.svg")
        ]<managementAPI_c4>
      ],
    )
  ])

  #inline-slide([Data Consumer], [
    #grid(
      columns: (1fr, 4fr, 7fr),
      align(top)[#link(<home>)[<]],
      align(left + horizon)[
        #set text(size: 0.8em)
        - *Exhagonal Architecture* (Ports & Adapters).
        - *Value Object Pattern*.
        - *Background Dispatch*.
      ],
      align(center + horizon)[
        #figure[
          #image("../../docest/specifica_tecnica_data_consumer/assets/data-consumer.png")
        ]<dataConsumer>
      ],
    )
  ])

  #inline-slide([Provisioning Service], [
    #grid(
      columns: (1fr, 4fr, 7fr),
      align(top)[#link(<home>)[<]],
      align(left + horizon)[
        #set text(size: 0.8em)
        - *Layered Architecture*.
        - *Definizione tramite Port*.
        - *Adapter Pattern*.
        - *Interceptor Pattern*.
        - *Dependency Injection*.
        - *PKI interna*: firma CSR gateway con CA.
      ],
      align(center + horizon)[
        #figure[
          #image("../../docest/specifica_tecnica_provisioning_service/assets/provisioning_service.png")
        ]<provisioningService>
      ],
    )
  ])

 

  #inline-slide([Crypto SDK], [
    #grid(
      columns: (1fr, 4fr, 7fr),
      align(top)[#link(<home>)[<]],
      align(left + horizon)[
        #set text(size: 0.8em)
        - *Layered Architecture*.
        - *Orchestrator pattern*.
        - *Interface Segregation*: tre interfacce ristrette.
        - *Adapter Pattern* (unifica REST e SSE).
        - *Cache-aside* per `CryptoKey`.
      ],
      align(center + horizon)[
        #figure[
          #image("../../docest/specifica_tecnica_crypto_sdk/assets/arch_class_diagram.png")
        ]<cryptoSDK>
      ],
    )
  ])

 

]
