#import "base_configs.typ" as base

#let INTERNAL_SCOPE = "Interno"
#let EXTERNAL_SCOPE = "Esterno"

#let margin-top = 3cm
#let margin-x = 2cm
#let margin-bottom = 2cm

#let font-size-base = 12pt
#let font-size-title = 30pt

#let front-matter(
  title: "",
  version: "",
  last-modified-date: "",
  scope: "",
  abstract: "",
  front-info: (),
) = {
  // Logo
  align(top + center)[
    #image("assets/logo.png", width: 70%)
  ]

  // Title
  align(center + top)[
    #set par(justify: false)
    #text(size: font-size-title, weight: "bold", font: base.sans-font, title)
    #v(3em)
  ]

  // Metadata grid
  align(bottom + center)[
    #set text(size: 14pt, font: base.serif-font)
    #set table(
      stroke: none,
      gutter: 0.2em,
      fill: none,
    )
    #show table.cell.where(y: 0): t => text(weight: "thin")[#t]

    #place(center)[
      #grid(
        columns: auto,
        rows: auto,
        align: center,

        grid.cell(
          table(
            columns: 2,
            align: (right, left),
            table.vline(x: 1),

            align(right + top)[*Versione*], str(version),
            align(right + top)[*Data Modifica*], last-modified-date,
            align(right + top)[*Utilizzo*], scope,

            ..front-info.map(info => (align(right + top)[*#info.at(0)*], info.at(1))).flatten(),
          ),
        ),
      )
    ]
  ]

  // Abstract
  align(bottom + center)[
    #if abstract != "" {
      text(font: base.serif-font, size: 16pt, weight: 800, style: "italic", "Abstract dei contenuti")
      v(1.7em)
      text(font: base.serif-font, size: 14pt, abstract)
    }
  ]
}

#let render-changelog(changelog) = {
  heading(level: 1, outlined: false, numbering: none)[Changelog]

  let formatNamesForChangelog(names) = {
    names.map(n => n.split(" ").join("\n")).sorted().join(",\n")
  }

  table(
    columns: (auto, auto, auto, auto, 1fr),
    align: (center + horizon, left + horizon, left + horizon, left + horizon, left),

    table.header[Versione][Data][Autori][Verificatore][Descrizione],

    ..changelog
      .map(c => (
        str(c.version),
        c.date,
        formatNamesForChangelog(c.authors),
        formatNamesForChangelog(c.verifiers),
        c.description,
      ))
      .flatten(),
  )

  pagebreak()
}

#let toc() = {
  outline()
  pagebreak()
}

#let table_list() = context {
  let tab = query(figure.where(kind: table))

  if tab.len() > 0 {
    outline(title: "Indice delle tabelle", target: figure.where(kind: table))

    pagebreak()
  }
}

#let figure_list() = context {
  let figs = query(figure.where(kind: image))

  if figs.len() > 0 {
    outline(title: "Indice delle figure", target: figure.where(kind: image))

    pagebreak()
  }
}

#let apply-base-document(
  title: "",
  abstract: "",
  front-info: (),
  changelog: (),
  scope: "",
  glossary-highlighted: true,
  content,
) = {
  show: base.apply-base-configs.with(glossary-highlighted: glossary-highlighted)

  // Settings
  set page(margin: (top: margin-top, x: margin-x, bottom: margin-bottom), paper: "a4")
  set document(title: title)
  set text(lang: "it", size: font-size-base, font: base.serif-font)
  set par(justify: true)
  show link: set text(fill: blue)
  set figure(numbering: "1.", gap: 0.5em)
  set heading(numbering: "1.")

  // Content
  front-matter(
    title: title,
    version: changelog.at(0).version,
    last-modified-date: changelog.at(0).date,
    front-info: front-info,
    abstract: abstract,
    scope: scope,
  )
  pagebreak()

  set page(
    footer: base.default-footer,
    header: base.default-header(title: title),
  )

  render-changelog(changelog)

  toc()

  figure_list()

  table_list()

  content
}



