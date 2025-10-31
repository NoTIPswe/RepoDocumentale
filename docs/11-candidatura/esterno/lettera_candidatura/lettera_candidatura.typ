#import "../../../00-templates/base_configs.typ" as base

#let oggetto(text) = block(
  align(center)[
    *#text*
  ],
  stroke: none,
  inset: (top: 1.3cm, bottom: 0.8cm),
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
      #image("../../../00-templates/assets/logo.png", width: 3.8cm)
    ],
  )

  #v(1.3cm)


  Egregio Prof. Vardanega, \
  Egregio Prof. Cardin,


  #oggetto("Candidatura capitolato C7 — Sistema di acquisizione dati da sensori")


  Con la presente il gruppo *NoTIP* desidera comunicare formalmente la propria
  candidatura per la realizzazione del capitolato *C7*, intitolato
  *"Sistema di acquisizione dati da sensori"*, proposto dall’azienda *M31*.

  Come specificato nel documento di #link("https://notipswe.github.io/docs/11-candidatura/esterno/dichiarazione_impegni.pdf", [dichiarazione degli impegni]), il gruppo ha
  stimato un costo totale per la realizzazione del progetto di *Euro 12.940* e
  ha fissato come termine ultimo di consegna il *21 marzo 2026*.

  Si riportano di seguito i principali punti di forza che hanno portato il gruppo
  alla scelta di questo capitolato:

  - Il gruppo ha ritenuto particolarmente stimolante il progetto per la *struttura
      architetturale ben definita e precisa*, illustrata nel capitolato fornito
    dall’azienda.
    \

  - L’azienda si è dimostrata chiara, disponibile e aperta al dialogo, anche durante l’incontro conoscitivo, nel quale si è riscontrato un reciproco interesse e soddisfacimento tra le parti.
  - L’utilizzo di *tecnologie moderne* è stato valutato positivamente dal team poiché riflette un *contesto realistico e professionale*.
  - Il team, grazie alla *disponibilità* dimostrata da parte dell’azienda alla *contrattazione* e al supporto da parte di professionisti, ritiene di essere in grado di realizzare efficacemente tale capitolato.
  \ 
  Per eventuali approfondimenti si rimanda all'#link("https://notipswe.github.io/docs/11-candidatura/esterno/analisi_capitolati.pdf", [analisi dei capitolati]) redatta dal gruppo.

  #v(0.8cm)

  Ringraziamo nuovamente per la Vostra disponibilità, \
  cordiali saluti.

  #v(1.0cm)
  Padova, 31 ottobre 2025, \

  *Team NoTIP*
]
