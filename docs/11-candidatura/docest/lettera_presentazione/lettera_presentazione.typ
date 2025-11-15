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


  #oggetto("Candidatura capitolato C7 — Sistema di acquisizione dati da sensori")


  Con la presente il gruppo *NoTIP* desidera comunicare formalmente la propria
  candidatura per la realizzazione del capitolato *C7*, intitolato
  *"Sistema di acquisizione dati da sensori"*, proposto dall’azienda *M31*.

  Come specificato nel documento di #link("https://notipswe.github.io/docs/11-candidatura/esterno/dichiarazione_impegni.pdf", [dichiarazione degli impegni]), il gruppo ha stimato un costo totale per la realizzazione del progetto di *Euro 12.940* e
  ha fissato come termine ultimo di consegna il *21 marzo 2026*.

  Viene evidenziato inoltre lo svolgersi dell'*incontro conoscitivo* svoltosi il 24 ottobre 2025 con l'azienda M31. Il colloquio è risultato complessivamente positivo per entrambe le parti, mettendo in luce la disponibilità della proponente nel chiarire i dubbi sollevati dal team.

  Per eventuali approfondimenti riguardo ai punti di forza che hanno portato NoTIP alla scelta di questo capitolato, si rimanda all'#link("https://notipswe.github.io/docs/11-candidatura/esterno/analisi_capitolati.pdf", [analisi dei capitolati]) redatta dal gruppo e al #link("https://notipswe.github.io/docs/11-candidatura/esterno/verbest_2025-10-24.pdf", [verbale esterno]) dell'incontro conoscitivo svolto.

  Qualora si desiderasse consultare ulteriore documentazione relativa alle attività svolte dal team, si invita a visionare la #link("https://github.com/NoTIPswe/NoTIPswe.github.io", [repo documentale]) e il #link("https://notipswe.github.io/", [sito web]) ad essa associato.

  #v(0.8cm)

  Ringraziamo nuovamente per la Vostra disponibilità, \
  cordiali saluti.

  #v(0.5cm)
  Padova, 5 novembre 2025, \

  *Team NoTIP*

]
