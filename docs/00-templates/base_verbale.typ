#import "base_document.typ" as base-document

#let INTERNAL_SCOPE = base-document.INTERNAL_SCOPE
#let EXTERNAL_SCOPE = base-document.EXTERNAL_SCOPE

#let report-point(
  discussion_point: "",
  discussion: "",
  decisions: "",
  actions: (),
) = [
  == #discussion_point

  #{
    if discussion != "" [
      *Dibattito:*  \
      #discussion  \
    ]

    if decisions != "" [
      *Decisioni:*  \
      #decisions  \
    ]

    if actions.len() > 0 [
      *Azioni da intraprendere:*  \
      #list(
        ..actions.map(a => link(a.url, a.desc))
      )
    ]
  }
]

#let apply-base-verbale(
  date: "",
  scope: "",
  front-info: (),
  abstract: "",
  changelog: (),
  glossary-highlighted: true,
  odg,
  discussion,
  other,
) = {
  base-document.apply-base-document(
    title: "Verbale " + scope + " del " + date,
    abstract: abstract,
    changelog: changelog,
    scope: scope,
    front-info: front-info,
    glossary-highlighted: glossary-highlighted
  )[

    = Info e ordine del giorno
    #odg

    = Discussione
    #discussion

    #other
  ]
}
