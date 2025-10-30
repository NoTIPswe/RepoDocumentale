#import "../01-living_documents/esterno/glossario/termini_glossario.typ" as glossary-terms

#let project-email = "notip.swe@gmail.com"
#let project-url = "https://notipswe.github.io/"
#let project_name = link(project-url, [NoTIP])

#let sans-font = "Noto Sans"
#let serif-font = "Noto Serif"
#let mono-font = "Noto Sans Mono"

#let color-primary = rgb(181, 17, 25)
#let color-secondary = rgb(180, 0, 30)

#let default-header(
  title: "",
  section: "",
) = context {
  v(2fr)
  grid(
    columns: (auto, 1fr, auto), align: center + horizon
  )[
    #image("assets/logo_unipd.png", fit: "contain", height: 1.5cm)

  ][][
    #align(right)[
      #text(12pt, font: serif-font, weight: 500)[#text(10pt)[#title] \ #section]]
  ]
  v(1fr)
  line(length: 100%, stroke: 1.5pt + color-primary)
}

#let default-footer = context {
  line(length: 100%, stroke: 1.5pt + color-primary)
  v(1fr)
  grid(columns: (auto, 1fr, auto), align: center + horizon)[
    #image("assets/logo.png", fit: "contain", height: 0.7cm)
  ][
    #text(10pt, font: serif-font, weight: 400)[ #project_name — #project-email ]
  ][
    #text(10pt, font: serif-font, weight: 400)[#counter(page).display("1/1", both: true)]
  ]
  v(1fr)
}

#let apply-base-configs(doc) = {
  
  show regex(glossary-terms.terms.keys().map(k => "\b" + k + "\b").join("|")): t => [
    _#t#sub("G")_
  ]

  set par(justify: true)

  show "NoTIP": it => link(project-url, it)
  set text(lang: "it", font: serif-font)
  show raw: set text(font: mono-font)

  show table.cell.where(y: 0): strong
  set table(
    fill: (x, y) => if y == 0 {
      gray.lighten(60%)
    } else if calc.even(y) {
      gray.lighten(80%)
    },
    stroke: 0.5pt + gray.darken(50%),
  )

  doc
}

