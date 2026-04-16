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
      - Microservizio di backend in *NestJS* con architettura *Layered* orientata a *ports e adapters*.
      *Design patterns*: \
      - Scelta architetturale: *Layered*: 
        - Presentation \ 
        - Application \ 
        - Infrastructure \ 
        - Persistence \ con *driving ports* e *driven ports*.
      - *Adapter Pattern*
      - *Dependency Injection*
      - *Interceptor Pattern* e *Exception Filter*
    ],
    align(center + horizon)[
      #figure[
        #image("../../docest/specifica_tecnica_provisioning_service/assets/provisioning_service.png")
      ]
    ],
  )

  = Simulator Backend
  #grid(
    columns: (5fr, 7fr),
    align(left + horizon)[
      #set text(size: 0.8em)
      - *Servizio rappresentativo*: simulazione *Go*, rappresenta anche l'accoppiata *Backend + CLI*.
      - *Scelta architetturale*: *Ports & Adapters* con core isolato e adapter HTTP, NATS e SQLite.
      *Design patterns:* \
      - *Repository Pattern* tramite `GatewayStore`.
      - *Strategy + Factory* per i generatori `sine`, `spike`, ...
      - *Observer Pattern* per il decommissioning dei gateway.
      - *Value Object Pattern* per `EncryptionKey`.
      *Scelte implementative*: 
        - concorrenza `1 goroutine = 1 gateway`.
        - buffer *drop-oldest* e *defer-and-flush* durante anomalie.
    ],
    align(center + horizon)[
      #figure[
        #image("../../docest/specifica_tecnica_simulator_backend_cli/assets/notip-simulator-backend.svg")
      ]
    ],
  )
]
