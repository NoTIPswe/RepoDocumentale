#import "../../00-templates/base_configs.typ" as base
#let oggetto(text) = block(
  align(center)[
    *#text*
  ],
  stroke: none,
  inset: (top: 0.7cm, bottom: 0.5cm),
)

#base.apply-base-configs(glossary-highlighted: false)[

  #show link: set text(fill: blue)

  #grid(
    columns: (1fr, 5cm),
    gutter: 0.8cm,
    [
      Alla cortese attenzione di \
      Prof. Vardanega Tullio, \
      Prof. Cardin Riccardo, \
      Università degli Studi di Padova
    ],
    align(right)[
      *NoTIP* \
      Gruppo 12 \
      #link("mailto:notip.swe@gmail.com")[#raw("notip.swe@gmail.com")]
      #image("../../../00-common_assets/logo.png", width: 3.8cm)
    ],
  )


  Egregio Prof. Vardanega, \
  Egregio Prof. Cardin,


  #let oggetto(contenuto) = block(
    width: 100%,
    inset: (top: 0.7cm, bottom: 0.5cm),
    align(center)[
      #text(size: 1.5em, weight: "bold")[#contenuto]
    ],
  )

  #oggetto("Presentazione PB")


  Con la presente il gruppo *NoTIP* comunica formalmente la propria intenzione di sostenere la revisione della Product
  Baseline (PB), relativamente al progetto proposto dall'azienda M31, capitolato *C7*, intitolato: *"Sistema di
  acquisizione dati da sensori"*, a seguito dell'approvazione formale ricevuta durante il #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/verbest/verbest_2026-04-13.pdf",
  )[colloquio] con l'azienda proponente, avvenuto in data 13 aprile 2026. \

  La documentazione completa relativa alla revisione PB è disponibile sul #link(
    "https://notipswe.github.io/RepoDocumentale",
  )[sito ufficiale] del gruppo. \
  In particolare, si sottopongono alla Vostra attenzione i seguenti documenti:

  - Lettera di presentazione (documento attuale)
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docint/norme_progetto.pdf")[Norme di Progetto v2.0.1]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/piano_progetto.pdf")[Piano di Progetto v2.0.0]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/analisi_requisiti.pdf")[Analisi dei Requisiti
      v2.0.0]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/piano_qualifica.pdf")[Piano di Qualifica v2.0.0]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf")[Glossario v3.0.0]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica.pdf")[Specifica Tecnica
      v1.0.0]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_data_api.pdf")[Specifica
      Tecnica - Data API v1.0.0]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_data_consumer.pdf")[Specifica
      Tecnica - Data Consumer v1.0.0]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_management_api.pdf")[Specifica
      Tecnica - Management API v1.0.0]
  - #link(
      "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_provisioning_service.pdf",
    )[Specifica Tecnica - Provisioning Service v1.0.0]
  - #link(
      "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_simulator_backend_cli.pdf",
    )[Specifica Tecnica - Simulator Backend & CLI v1.0.0]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_frontend.pdf")[Specifica
      Tecnica - Frontend v1.0.0]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_crypto_sdk.pdf")[Specifica
      Tecnica - Crypto SDK v1.0.0]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/manuale_utente.pdf")[Manuale Utente v1.0.0]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/manuale_admin.pdf")[Manuale Amministratore
      v1.0.0]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/manuale_infrastruttura.pdf")[Manuale di
      Infrastruttura v1.0.0]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/manuale_client_api.pdf")[Manuale Client API
      v1.0.0]

  Il gruppo mette inoltre a disposizione tutti i verbali delle riunioni interne e dei colloqui intercorsi con l'azienda
  proponente M31. \
  Infine, vengono riconfermati gli impegni assunti nella #link(
    "https://notipswe.github.io/RepoDocumentale/docs/11-candidatura/docest/dichiarazione_impegni.pdf",
  )[Dichiarazione degli impegni v1.0.0], relativamente al preventivo di costo massimo stimato (*12.940 €*). La data di
  consegna finale è confermata al *13 aprile 2026*, in accordo con il rinvio concordato con l'azienda proponente M31.

  #v(0.8cm)

  Ringraziamo nuovamente per la Vostra disponibilità, \
  Cordiali saluti.

  #v(0.5cm)

  *Team NoTIP*

]
