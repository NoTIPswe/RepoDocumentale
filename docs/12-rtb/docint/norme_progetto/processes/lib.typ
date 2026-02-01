#let cite-norm(norm) = context {
  let label = label(norm)
  let target = query(label).first()
  let title = query(label).first().body

  if target.func() == heading and target.numbering == none{
    //text(fill: blue)[#ref(label)] + " " + link(label)[#title]
    link(label)[#text(fill: blue)[#target.body]]
  } else {
    link(label)[#text(fill: blue)[#ref(label) #target.body]]
  }
}

#let ROLES = (
  amm: "Amministratore",
  resp: "Responsabile",
  proge: "Progettista",
  progr: "Programmatore",
  anal: "Analista",
  ver: "Verificatore",
  aut: [Autore (vedi #cite-norm("matr-ruolo-documento"))],
)

#let info-section(title: "", content) = {
  heading(level: 3, title)
  content
}

#let norm(
  content,
  title: none,
  label: none,
  rationale: none,
  level: 4,
) = {
  [
    #if title != none {
      if level > 4 {
        heading(level: level, numbering: none, outlined: false, title)
      } else {
        heading(level: 4, title)
      }
    }
    #if label != none { label }
  ]

  content

  if rationale != none {
    if level > 4{
      heading(level: level+1, numbering: none, outlined: false, text(style: "italic", weight: "bold")[Note])
    } else {
      heading(level: level+1, outlined: false, text(style: "italic", weight: "bold")[Note])
    }
    rationale
  }
  v(1.3em)
}


#let activity(
  label: none,
  title: "",
  roles: none,
  norms: none,
  input: none,
  output: none,
  procedure: none,
  rationale: none,
  level: 4,
) = {
  [
    #if title != none {
      if level > 4 {
      heading(level: level, numbering: none, outlined: false, title)
      } else {
      heading(level: 4, title)
      }
    }
    #if label != none { label }
  ]
  grid(
    columns: (auto, 1fr),
    gutter: 1em,

    [*Ruoli*], roles.join(", "),
    [*Riferimenti*], list(..norms.map(n => cite-norm(n))),
    [*Input*], input,
    [*Output*], output,
    [*Procedura*],
    enum(..procedure.map(step => [
      #text(weight: "bold")[#step.name]: #step.desc
    ])),
  )

 if rationale != none {
    if level > 4{
      heading(level: level+1, numbering: none, outlined: false, text(style: "italic", weight: "bold")[Note])
    } else {
      heading(level: level+1, outlined: false, text(style: "italic", weight: "bold")[Note])
    }
    rationale
  }
  v(1.3em)
}
