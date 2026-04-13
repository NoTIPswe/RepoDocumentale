#import "../../00-templates/base_slides.typ" as base-slides

#let meta = yaml(sys.inputs.at("meta-path", default: "m31_2026-04-13.meta.yaml"));

#let shot(path, width: 100%, height: auto, caption: []) = figure(
  image(path, width: width, height: height, fit: "contain"),
  caption: caption,
)

#base-slides.apply-base-slides(
  title: meta.title,
  date: "2026-04-13",
)[
  = NoTIP MVP: sistema\ completo, multi-tenant e operativo

  - Il sistema realizza un flusso *end-to-end* completo: simulazione gateway, ingestione telemetria, persistenza,
    visualizzazione e gestione operativa.
  - La piattaforma è realmente *multi-tenant*: tenant, utenti e dispositivi sono isolati e governati da ruoli distinti.
  - Le funzionalità principali non sono mockup, ma parti operative della Web Application e dei microservizi backend.
  - Il focus del MVP è sulla porzione cloud del capitolato, con gateway fisici sostituiti da una simulazione controllata
    ma credibile.

  #pagebreak()

  == Dal gateway simulato all'utente finale

  1. I gateway virtuali generano dati sensoriali realistici e li inviano in modo sicuro alla piattaforma.
  2. La pipeline cloud riceve, instrada e persiste la telemetria attraverso microservizi dedicati.
  3. Gli utenti tenant consultano i dati sia in *Live Stream* sia in *Historical Analysis*.
  4. Tenant Admin e System Admin possono gestire gateway, utenti, soglie, alert e operazioni di supporto.

  = Dashboard tenant: monitoraggio e controllo

  #shot(
    "../../docest/manuale_utente/assets/dashboard.png",
    width: 72%,
    caption: [Dashboard reale del tenant con vista operativa dei dati raccolti],
  )

  - Accesso immediato alle funzionalità di consultazione.
  - Vista dati live con filtri per gateway, tipo sensore e sensori specifici.
  - Interfaccia adatta sia al monitoraggio quotidiano sia alla diagnosi rapida.

  = Analisi storica e consultazione del dato

  #shot(
    "../../docest/manuale_utente/assets/historical.png",
    width: 72%,
    caption: [Analisi storica con intervallo temporale, grafici e export CSV],
  )

  - Il sistema consente analisi retrospettiva, confronto temporale e navigazione paginata dei risultati.
  - L'export CSV rende il dato riusabile anche fuori piattaforma.
  - Questo rafforza il MVP come strumento operativo, non solo come vetrina tecnologica.

  = Gestione operativa dei gateway

  #grid(columns: (1fr, 1.8fr), gutter: 1.2cm)[
    #shot(
      "../../docest/manuale_utente/assets/gateway_admin.png",
      width: 100%,
      caption: [Azioni disponibili per il Tenant Admin],
    )
  ][
    #shot(
      "../../docest/manuale_utente/assets/gateway_detail.png",
      width: 100%,
      caption: [Dettaglio gateway con telemetria e controllo operativo],
    )
  ]
  #pagebreak()

  - Configurazione del gateway, aggiornamento firmware ed eliminazione sono già integrate nei flussi applicativi.
  - La piattaforma non si limita a mostrare dati: consente intervento amministrativo e manutenzione.

  = Multi-tenancy e supporto sicuro

  #grid(columns: (1.8fr, 1fr), gutter: 1.2cm)[
    #shot(
      "../../docest/manuale_admin/assets/tenant_detail.png",
      width: 100%,
      caption: [Dettaglio tenant e avvio dell'impersonazione],
    )
  ][
    #shot(
      "../../docest/manuale_admin/assets/indicatore_ObfuscatedMode.png",
      width: 100%,
      caption: [Indicatore persistente di Obfuscated Mode],
    )
  ]
  #pagebreak()

  - Il System Admin può intervenire in contesto tenant senza esporre dati sensibili in chiaro.
  - L'*Obfuscated Mode* è un elemento distintivo: abilita supporto tecnico preservando la privacy.
  - La separazione tra ruoli rafforza la credibilità architetturale del MVP.

  = Architettura MVP: servizi chiari,\ responsabilità separate

  #image("assets/c4.png", width: 100%, fit: "contain")

  #pagebreak()

  == Architettura MVP: lettura del diagramma

  - L'architettura è suddivisa in servizi con responsabilità definite: `Management API`, `Data API`, `Data Consumer`,
    `Provisioning Service`, Web App e sottosistema di simulazione.
  - La comunicazione interna event-driven e la separazione dei ruoli preparano il sistema alla scalabilità.
  - La struttura implementata è coerente con l'obiettivo di un prodotto manutenibile oltre il solo MVP.

  = Documentazione a supporto del MVP

  - È stata prodotta una *specifica tecnica generale di sistema* che descrive l'architettura complessiva della
    piattaforma.
  - È stata redatta una *specifica tecnica dedicata per ciascun microservizio*, per documentarne responsabilità,
    interfacce e scelte implementative.
  - È stato prodotto un *manuale utente* per Tenant Users e per Tenant Admin, focalizzato sui flussi
    operativi della Web Application.
  - È stato prodotto un *manuale operativo per il System Admin*, dedicato alla gestione multi-tenant, assegnazione gateway e alle attività di
    supporto clienti tramite impersonazione.
  #pagebreak()
  - È stato prodotto un *manuale di gestione infrastruttura* che descrive la configurazione e il deployment dei microservizi, del database e della simulazione gateway.
  - È stato prodotto un *manuale sull'utilizzo delle API* che descrive le interfacce REST esposte dai microservizi, per rendere possibile ai clienti lo sviluppo di un proprio client esterno.
  - È stato redatto un *TestBook* che raccoglie strategia di validazione, casi di test e criteri di verifica.

  #pagebreak()





  == Traguardo raggiunto:\ un MVP concreto, usabile e valutabile

  - *Funzionalità dimostrabili*: viste live e storiche, gestione gateway, gestione tenant, alert, soglie e supporto
    amministrativo.
  - *Solidità tecnica*: microservizi separati, autenticazione centralizzata, audit log e provisioning sicuro.
  - *Maturità progettuale*: sono stati prodotti specifica tecnica di sistema, specifiche dei servizi, manuali e
    `TestBook`.

  #v(0.8em)
  Il MVP da noi sviluppato dimostra che la piattaforma richiesta è stata resa concreta, usabile e valutabile su
  basi sia funzionali sia architetturali.
]
