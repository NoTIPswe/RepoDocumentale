#import "../../00-templates/base_slides.typ" as base-slides

#let meta = yaml(sys.inputs.at("meta-path", default: "m31_2026-04-13.meta.yaml"));

#base-slides.apply-base-slides(
  title: meta.title,
  date: "2026-04-13",
)[
  == Obiettivo del MVP

  - Realizzare una piattaforma cloud per acquisire, gestire e visualizzare dati provenienti da sensori IoT.
  - Validare un flusso completo, dalla generazione della telemetria fino alla consultazione da parte degli utenti.
  - Dimostrare la fattibilità di un sistema multi-tenant, sicuro e scalabile, aderente agli obiettivi del capitolato.
  - Concentrarsi sul livello cloud del sistema, sostituendo l'hardware reale con una simulazione controllata dei
    gateway.

  #pagebreak()

  == Cosa abbiamo sviluppato

  - Un'architettura a microservizi composta da `Management API`, `Data API`, `Data Consumer` e `Provisioning Service`.
  - Una Web Application per utenti tenant, tenant admin e system admin, con viste live e storiche dei dati raccolti e
    funzionalita' di gestione dedicate.
  - Un sottosistema di simulazione con `Simulator Backend`, `Simulator CLI` e dashboard dedicata al controllo dei
    gateway virtuali.
  - Un'infrastruttura di comunicazione interna event-driven basata su NATS, con persistenza dei dati telemetrici e
    monitoraggio dello stato dei gateway.

  #pagebreak()

  == Funzionalita' mostrate dal MVP

  - Simulazione di piu' gateway in parallelo, con generazione di dati sensoriali realistici e invio sicuro della
    telemetria al cloud.
  - Consultazione dei dati in due modalita': `Live Stream` per il tempo reale e `Historical Analysis` per l'analisi
    storica, con filtri ed esportazione CSV.
  - Gestione operativa di tenant, utenti, gateway, soglie, alert di gateway offline e client API per integrazioni
    esterne.
  - Supporto a comandi verso i gateway, come configurazione operativa e aggiornamento firmware.
  - Produzione della documentazione tecnica di progetto: una specifica tecnica generale di sistema e una specifica
    tecnica dedicata per ciascun microservizio.
  - Definizione di un `Test Book` per descrivere strategia di validazione, casi di test e criteri di verifica.
  - Redazione dei manuali d'uso per utenti tenant e tenant admin, focalizzati sulle funzionalita' operative della
    piattaforma.
  - Redazione del manuale operativo per il System Admin, dedicato alla gestione multi-tenant e al supporto
    amministrativo.

  #pagebreak()

  == Aspetti distintivi del progetto

  - Multi-tenancy reale: ogni tenant accede solo alle proprie risorse e ai propri dati.
  - Sicurezza by design: provisioning sicuro dei gateway, autenticazione centralizzata, audit log e cifratura della
    telemetria.
  - Pipeline dati opaca: il backend non decifra i payload sensibili, che vengono interpretati solo lato client.
  - Supporto amministrativo avanzato: impersonazione controllata con `Obfuscated Mode`, che permette assistenza tecnica
    senza esporre dati sensibili in chiaro.
]
