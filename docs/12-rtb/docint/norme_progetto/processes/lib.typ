#let cite-norm(norm) = context {
  let label = label(norm)
  let title = query(label).first().body
  text(fill: blue)[#ref(label)] + " " + link(label)[#title]
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
) = {
  [
    #heading(level: 4, title)
    #if label != none { label }
  ]

  content

  if rationale != none {
    heading(level: 5, outlined: false, "Note")
    rationale
  }
}


#let activity(
  title: "",
  roles: none,
  norms: none,
  input: none,
  output: none,
  procedure: none,
  rationale: none,
) = {
  heading(level: 4, title)

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
    heading(level: 5, outlined: false, "Note")
    rationale
  }
}
