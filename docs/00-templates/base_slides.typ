#import "base_configs.typ" as base-configs

#let slide-paper = "presentation-16-9"
#let slide-margin-top = 2.5cm
#let slide-margin-x = 2cm
#let slide-margin-bottom = 1.8cm

#let apply-base-slides(
  title: "",
  subtitle: none,
  date: none,
  glossary-highlighted: true,
  body,
) = {
  show: base-configs.apply-base-configs.with(glossary-highlighted: glossary-highlighted)

  let current-section = state("current-section", "")

  set page(
    paper: slide-paper,
    margin: (top: 1cm, x: slide-margin-x, bottom: 1.3cm),
  )

  let title_ = text(size: 40pt, weight: 800, font: base-configs.sans-font)[#title]
  let subtitle_ = if subtitle != none { text(size: 22pt, weight: 500, font: base-configs.sans-font)[#subtitle] }
  context {
    let title_width = measure(title_).width
    let subtitle_width = measure(subtitle_).width

    let max_width = calc.max(title_width, subtitle_width)
    align(center + horizon)[
      #grid(columns: (auto, 1fr, auto), align: center)[
        #image("assets/logo_unipd.png", height: 3cm)
      ][][
        #image("assets/logo.png", height: 3cm)
      ]
      #v(1em)
      #line(length: max_width + 20%, stroke: 4pt + base-configs.color-primary)
      #title_
      #v(1em)
      #subtitle_
      #line(length: max_width + 20%, stroke: 4pt + base-configs.color-primary)
      #v(2fr)
      #set text(size: 20pt, font: base-configs.serif-font, lang: "it")
      #grid(
        row-gutter: 0.4em,
        align: center, columns: (1fr, 1fr, 1fr)
      )[Francesco Marcon][Leonardo Preo][Matteo Mantoan][Alessandro Contarini][Alessandro Mazzariol][Mario De Pasquale][][Valerio Solito]
      #if date != none { text(size: 18pt, font: base-configs.serif-font)[#date] }
    ]
  }

  // Rest of slides (with footer)
  set page(
    paper: slide-paper,
    margin: (top: slide-margin-top, x: slide-margin-x, bottom: slide-margin-bottom),
    footer: base-configs.default-footer,
    header: context {
      let section-title = current-section.get()
      base-configs.default-header(title: title, section: section-title)
    },
  )

  context {
    set text(font: base-configs.serif-font, size: 20pt, lang: "it")
    set par(justify: false, leading: 0.6em)
    show heading: it => {
      set text(font: base-configs.sans-font)
      it
    }

    show heading.where(level: 1): it => {
      pagebreak()
      let t_width = measure(it).width
      set text(size: 32pt, weight: "bold", font: base-configs.sans-font)
      set align(center + horizon)
      set page(header: base-configs.default-header(title: title))
      stack(
        dir: ttb,
        it,
        v(0.8em),
        line(length: t_width + 15%, stroke: 4pt + base-configs.color-primary),
      )
      pagebreak()
      current-section.update(it.body)
    }

    show heading.where(level: 2): it => {
      set text(size: 26pt, weight: "bold")
      let t_width = measure(it).width
      stack(
        dir: ttb,
        it,
        v(0.5em),
        line(length: t_width + 3%, stroke: 4pt + base-configs.color-primary),
      )
    }
    body
  }
}

