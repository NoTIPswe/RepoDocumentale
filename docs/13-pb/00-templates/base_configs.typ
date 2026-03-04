#import "../docest/glossario/termini_glossario.typ" as glossary-terms

#let project-email = "notip.swe@gmail.com"
#let project-url = "https://notipswe.github.io/RepoDocumentale/"
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
    #image("../../00-common_assets/logo_unipd.png", fit: "contain", height: 1.5cm)

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
    #image("../../00-common_assets/logo.png", fit: "contain", height: 0.7cm)
  ][
    #text(10pt, font: serif-font, weight: 400)[ #project_name — #project-email ]
  ][
    #text(10pt, font: serif-font, weight: 400)[#counter(page).display("1/1", both: true)]
  ]
  v(1fr)
}

#let apply-base-configs(doc, glossary-highlighted: true) = {
  // show the _g automatically for glossary terms outside links
  // ordina i termini per lunghezza decrescente così i composti (es. "GitHub Projects") matchano prima dei semplici (es. "GitHub")
  let sorted-keys = glossary-terms.terms.keys().sorted(key: k => -k.len())
  let glossary-regex = regex("(?i)" + sorted-keys.map(k => "\b" + k.replace(".", "\\.") + "\b").join("|"))

  show glossary-regex: t => {
    if glossary-highlighted {
      [#t#sub("G")]
    } else {
      t
    }
  }

  show link: it => {
    show glossary-regex: t => t
    it
  }

  set par(justify: true)

  show "NoTIP": it => link(project-url, text(fill: black)[#it])
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

