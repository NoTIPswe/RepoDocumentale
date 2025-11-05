#import "../../../00-templates/base_configs.typ" as base

#let oggetto(text) = block(
  align(center)[
    *#text*
  ],
  stroke: none,
  inset: (top: 0.7cm, bottom: 0.5cm),
)

#base.apply-base-configs(glossary-highlighted: false)[


]
