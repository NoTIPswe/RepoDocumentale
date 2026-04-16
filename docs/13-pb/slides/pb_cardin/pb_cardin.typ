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

    link(<simulatorBackend>)[#underline(stroke: 1.2pt)[*Simulator Backend*]], [], [*Data Consumer*],
    [], link(<managementAPI_c4>)[#underline(stroke: 1.2pt)[*Management API*]], [],
    [*Simulator CLI*], [], link(<provisioningService>)[#underline(stroke: 1.2pt)[*Provisioning Service*]],
    [], [*Data API*], [],
    [*Crypto SDK*],
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
        - *Servizio rappresentativo*: backend *NestJS* layerizzato, rappresenta anche *Data API*.
        - *Scelta architetturale*: *Layered Architecture* + *logic modules*.
        *Design patterns:* \
        - *Controller-Service-Persistence*.
        - *Dependency Injection* tramite provider NestJS e constructor injection.
        - *Mapper Pattern* per `Entity -> Model -> DTO`.
        - *Guard + Decorator Pattern* per policy e metadati endpoint.
        - *Event-Driven* con `EventEmitter2` e listener verso NATS.
        - *Integration pattern*: *NATS Request-Reply* per API interne tra microservizi.
      ],
      align(center + horizon)[
        #figure[
          #image("../../docest/specifica_tecnica_management_api/assets/01-app-architecture-part3.svg")
        ]<managementAPI_c4>
      ],
    )
  ])

  #inline-slide([Provisioning Service], [
    #grid(
      columns: (1fr, 4fr, 7fr),
      align(top)[#link(<home>)[<]],
      align(left + horizon)[
        #set text(size: 0.8em)
        - *Servizio rappresentativo*: backend *NestJS* con architettura a *port e adapter*.
        - *Scelta architetturale*: strati *Presentation / Application / Infrastructure / Persistence*.
        *Design patterns:* \
        - *Ports & Adapters* con *driving* e *driven port* espliciti.
        - *Dependency Injection* per comporre use case e componenti infrastrutturali.
        - *Adapter Pattern* per NATS, PKI, AES generator e file store della CA.
        - *Interceptor Pattern* per audit log e metriche sul boundary HTTP.
        - *Exception Filter* per tradurre errori di dominio in risposte HTTP stabili.
        - *Integration pattern*: workflow di onboarding orchestrato via *NATS Request-Reply*.
      ],
      align(center + horizon)[
        #figure[
          #image("../../docest/specifica_tecnica_provisioning_service/assets/provisioning_service.png")
        ]<provisioningService>
      ],
    )
  ])

  #inline-slide([Simulator Backend], [
    #grid(
      columns: (1fr, 4fr, 7fr),
      align(top)[#link(<home>)[<]],
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
        ]<simulatorBackend>
      ],
    )
  ])

 

]
