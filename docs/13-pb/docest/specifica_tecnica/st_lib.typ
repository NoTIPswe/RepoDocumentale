// ═══════════════════════════════════════════════════════════════
// st_lib.typ — Standard di Esposizione · Specifica Tecnica NoTIP
// ═══════════════════════════════════════════════════════════════
// Macro disponibili:
//   - design-pattern  → decisione architetturale in stile ADR
//   - port-interface   → contratto di confine (driving/driven)
//   - design-rationale → motivazione puntuale di una scelta
// ═══════════════════════════════════════════════════════════════

#import "../../00-templates/base_configs.typ" as base

// Design Pattern

#let design-pattern(
  name: "",
  problem: [],
  decision: [],
  alternatives: [],
  consequences: [],
) = {
  [=== #name]
  [==== Contesto e Problema]
  problem
  [==== Decisione]
  decision
  [==== Alternative Considerate]
  alternatives
  [==== Conseguenze]
  consequences
}

// Port Interface

#let port-interface(
  name: "",
  kind: "driven",
  description: [],
  methods: (),
) = {
  let label = if kind == "driving" [ DRIVING PORT ] else [ DRIVEN PORT ]

  block(
    width: 100%,
    inset: (left: 10pt, rest: 8pt),
    above: 1.2em,
    below: 1.2em,
  )[
    #text(weight: "bold", size: 11pt)[#name]
    #h(1fr)
    #text(size: 8pt, weight: "bold")[#label]

    #v(4pt)
    #description

    #if methods.len() > 0 {
      v(4pt)
      table(
        columns: (auto, 1fr),
        [Metodo], [Responsabilità],
        ..methods.map(m => (raw(m.at(0)), m.at(1))).flatten(),
      )
    }
  ]
}

// Design Rationale

#let design-rationale(title: "", body) = {
  block(
    width: 100%,
    inset: (left: 10pt, rest: 8pt),
    above: 0.8em,
    below: 0.8em,
  )[
    #text(weight: "bold", size: 10pt)[▸ #title]
    #v(2pt)
    #body
  ]
}
