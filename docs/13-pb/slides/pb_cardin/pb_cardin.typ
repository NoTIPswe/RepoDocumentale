#import "../../00-templates/base_slides.typ" as base-slides
#import "../../00-templates/base_configs.typ" as base-configs

#base-slides.apply-base-slides(
  title: "Colloquio tecnico - PB",
  subtitle: "Gruppo 12 - A.A. 2025/2026",
  date: "2026-04-17",
)[

  = MVP (Capitolato C7) \ Architettura e Design Pattern

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
      - *Guard* per policy e metadati endpoint.
      - *Integration pattern*: *NATS Request-Reply* per API interne tra microservizi.
    ],
    align(center + horizon)[
      #figure[
        #image("assets/mgmt-api.svg")
      ]
    ],
  )

  = Provisioning Service
  #grid(
    columns: (5fr, 7fr),
    align(left + horizon)[
      #set text(size: 0.8em)
      - Microservizio di backend in *NestJS* con architettura *Layered* orientata a *ports e adapters*.
      _*Design patterns:*_ \
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
        #image("assets/provisioning_service.jpeg", height: 105%)
      ]
    ],
  )

  = Simulator Backend & Data Consumer
  #grid(
    columns: (5fr, 7fr),
    align(left + horizon)[
      #set text(size: 0.8em)
      *Hexagonal Architecture*
      
      _*Design patterns:*_ \
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
        #image("assets/notip-simulator-backend.jpg")
      ]
    ],
  )

  = Frontend
  #grid(
    columns: (5fr, 7fr),
    align(left + horizon)[
      #set text(size: 0.8em)
      *Layered Feature-Based Architecture*

      _*Design patterns:*_ \
        - *Interceptor Pattern* HTTP
      _*Scelte implementative*:_ \
        *RouteGuards* per protezione rotte
        *State Management ibrido*: Signal Angular + RxJS
    ],
    align(center + horizon)[
      #figure[
        #image("assets/CommandService.png")
        #image("assets/GatewayDetailComponent.png")
      ]
    ],
   )
]
