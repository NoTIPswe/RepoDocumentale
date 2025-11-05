#import "../../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Il seguente documento contiene la dichiarazione degli impegni preventivata per lo svolgimento del capitolato C7",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
]