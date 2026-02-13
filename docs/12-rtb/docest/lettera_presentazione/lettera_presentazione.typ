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

  #v(1.3cm)


  Egregio Prof. Vardanega, \
  Egregio Prof. Cardin,


  #let oggetto(contenuto) = block(
    width: 100%,
    inset: (top: 0.7cm, bottom: 0.5cm),
    align(center)[
      #text(size: 1.5em, weight: "bold")[#contenuto]
    ],
  )

  #oggetto("Presentazione RTB")


  Con la presente il gruppo *NoTIP* comunica formalmente la propria intenzione di sostenere la revisione della
  Requirements and Technology Baseline (RTB), relativamente al progetto proposto dall'azienda M31, capitolato *C7*, dal
  titolo: *"Sistema di acquisizione dati da sensori"*.

  Nel periodo trascorso, il gruppo *NoTIP* ha sviluppato un Proof of Concept (PoC), consultabile presso la repository
  dedicata: #link("https://github.com/NoTIPswe/PoC")[PoC-Repository]. \
  La documentazione completa relativa alla revisione RTB è invece disponibile sul sito ufficiale del gruppo: #link(
    "https://notipswe.github.io/RepoDocumentale",
  )[RepoDocumentale]. \
  In particolare, si sottopongono alla Vostra attenzione i seguenti documenti:

  - Lettera di presentazione (documento attuale)
  - #link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docint/norme_progetto.pdf")[Norme di Progetto (NdP)]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/piano_progetto.pdf")[Piano di Progetto (PdP)]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/analisi_requisiti.pdf")[Analisi dei Requisiti
      (AdR)]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/piano_qualifica.pdf")[Piano di Qualifica (PdQ)]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/glossario.pdf")[Glossario]
  - #link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/analisi_stato_arte.pdf")[Analisi dello stato
      dell'arte]

  Il gruppo mette inoltre a disposizione tutti i verbali delle riunioni interne e dei colloqui intercorsi con l'azienda
  proponente M31. \
  Infine, il gruppo riconferma gli impegni assunti nella #link(
    "https://notipswe.github.io/RepoDocumentale/docs/11-candidatura/docest/dichiarazione_impegni.pdf",
  )[Dichiarazione degli impegni], relativamente alla data di consegna finale (*21 marzo 2026*) e al preventivo di costo
  massimo stimato (*12.940 €*).

  #v(0.8cm)

  Ringraziamo nuovamente per la Vostra disponibilità, \
  cordiali saluti.

  #v(0.5cm)
  Padova, 10 febbraio 2026, \

  *Team NoTIP*

]
