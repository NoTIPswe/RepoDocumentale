#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Documento contenente la specifica tecnica del progetto, con particolare attenzione alle scelte tecnologiche e di design adottate",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione
  == Scopo del documento
  == Glossario
  Per tutte le definizioni, acronimi e abbreviazioni utilizzati in questo documento, si faccia riferimento al #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf")[Glossario v2.0.0], fornito come documento separato, che contiene tutte le spiegazioni necessarie per garantire una comprensione uniforme dei termini tecnici e dei concetti rilevanti per il progetto. Le parole che possiedono un riferimento nel Glossario saranno indicate nel modo che segue:
  #align(center)[#emph([parola#sub[G]])]
  == Riferimenti
  === Riferimenti normativi
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato d'appalto C7 - Sistema di acquisizione dati da sensori]\ _Ultimo accesso: 2026-03-09_
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/norme_di_progetto.pdf")[Norme di Progetto v1.1.0] 
  === Riferimenti informativi
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf")[Glossario v2.0.0]
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/PD1.pdf")[PD1 - Regolamento del Progetto Didattico]\ _Ultimo Accesso: 2026-03-09_

  = Tecnologie
  = Architettura
  = Stato dei requisiti funzionali
]