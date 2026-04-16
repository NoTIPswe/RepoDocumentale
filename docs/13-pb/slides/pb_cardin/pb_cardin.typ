#import "../../00-templates/base_slides.typ" as base-slides
#import "../../00-templates/base_configs.typ" as base-configs

#base-slides.apply-base-slides(
  title: "Colloquio tecnico - PB",
  subtitle: "Gruppo 12 - A.A. 2025/2026",
  date: "2026-04-17",
)[

  = High Level Design
  #grid(
    columns: (1fr, 2fr),
    gutter: 1.2em,
    align(left + horizon)[
      == Persistenza
      #set text(size: 0.9em)
      - Database-per-Service

      - *CQRS*: Command-Query-Responsibility-Segregation
    ],
    align(center + horizon)[
      #grid(
        columns: (2fr, 3fr),
        gutter: 2em,
        image("assets/db-per-service.png", width: 70%),
        image("assets/cqrs-pattern.png", width: 100%),
      )
    ],
  )

  #pagebreak()

  #grid(
    columns: (1fr, 1fr),
    gutter: 1.2em,
    align(left + horizon)[
      == Comunicazione
      #set text(size: 0.9em)
      - Async API inter-service via NATS (+ RR pattern)
      - API REST HTTP pubbliche (+ SSE)
    ],
    align(center + horizon)[
        #image("assets/async-api.png")
        #image("assets/http-rest-api.png")
    ],
  )

  #grid(
    columns: (1fr, 1fr),
    gutter: 1.2em,
    align(left + horizon)[
      == SDK
      #set text(size: 0.9em)
      - Problema: semplificare integrazione e sviluppo per clienti
      - *CryptoSDK library*, pacchetto NPM
    ],
    align(center + horizon)[
      #image("assets/crypto-sdk.png", width: 100%)
    ],
  )

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
