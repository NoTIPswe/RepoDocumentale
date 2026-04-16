#import "../../00-templates/base_slides.typ" as base-slides
#import "../../00-templates/base_configs.typ" as base-configs

#base-slides.apply-base-slides(
  title: "Colloquio tecnico - PB",
  subtitle: "Gruppo 12 - A.A. 2025/2026",
  date: "2026-04-17",
)[

  = MVP (Capitolato C7) \ Architettura e Design Pattern

  #align(center)[
    #figure[
      #image("assets/Containers.svg")
    ]
  ]

  = Management API
  #grid(
    columns: (5fr, 7fr),
    align(left + horizon)[
      #set text(size: 0.8em)
      - *Servizio rappresentativo*: backend *NestJS* layerizzato.
      - *Scelta architetturale*: *Layered Architecture* + *logic modules*.
      _*Design patterns:*_ \
      - *Controller-Service-Persistence*.
      - *Dependency Injection* tramite provider NestJS e constructor injection.
      - *Mapper Pattern* per `Entity -> Model -> DTO`.
      - *Guard + Decorator Pattern* per policy e metadati endpoint.
      - *Integration pattern*: *NATS Request-Reply* per API interne tra microservizi.
    ],
    align(center + horizon)[
      #figure[
        #image("../../docest/specifica_tecnica_management_api/assets/01-app-architecture-part3.svg")
      ]
    ],
  )

  = Provisioning Service
  #grid(
    columns: (5fr, 7fr),
    align(left + horizon)[
      #set text(size: 0.8em)
      - *Servizio rappresentativo*: backend *NestJS* con architettura a *port e adapter*.
      - *Scelta architetturale*: strati *Presentation / Application / Infrastructure / Persistence*.
      *Design patterns:* \
      - *Ports & Adapters* con *driving* e *driven port* espliciti.
      - *Dependency Injection* per comporre use case e componenti infrastrutturali.
      - *Adapter Pattern* per NATS, PKI, AES generator e file store della CA.
      - *Interceptor Pattern* per audit log e metriche sul boundary HTTP.
    ],
    align(center + horizon)[
      #figure[
        #image("../../docest/specifica_tecnica_provisioning_service/assets/provisioning_service.png")
      ]
    ],
  )

  = Simulator Backend & Data Consumer
  #grid(
    columns: (5fr, 7fr),
    align(left + horizon)[
      #set text(size: 0.8em)
      *Hexagonal Architecture*
      
      *Design patterns:* \
      - *Adapter Pattern*
      - *Repository Pattern*
      - *Strategy + Factory* per i gateway simulati
      - *Observer Pattern* per il decommissioning dei gateway
      *Scelte implementative*: 
        - concorrenza `1 goroutine = 1 gateway`
        - Heartbeat tracking dei gateway e cache lock-free di configurazione
        - Batch processing e buffering
    ],
    align(center + horizon)[
      #figure[
        #image("../../docest/specifica_tecnica_simulator_backend_cli/assets/notip-simulator-backend.svg")
      ]
    ],
  )
]
