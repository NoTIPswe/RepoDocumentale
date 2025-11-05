#import "../../../00-templates/base_configs.typ" as base

#let oggetto(text) = block(
  align(center)[
    *#text*
  ],
  stroke: none,
  inset: (top: 0.7cm, bottom: 0.5cm),
)

#base.apply-base-configs(glossary-highlighted: false)[

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

  Come specificato nel documento di  dichiarazione degli impegni, il gruppo ha
  stimato un costo totale per la realizzazione del progetto di *Euro 12.940* e
  ha fissato come termine ultimo di consegna il *21 marzo 2026*.

  Viene evidenziato inoltre lo svolgersi dell'*incontro conoscitivo* svoltosi il 24 Ottobre 2025 con l'azienda M31. Il colloquio è risultato complessivamente positivo per entrambe le parti, mettendo in luce la disponibilità della proponente nel chiarire i dubbi sollevati dal team.

]
