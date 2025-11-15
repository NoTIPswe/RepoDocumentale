#import "../../../01-living_documents/termini_glossario.typ": terms
#import "../../../00-templates/base_document.typ" as base-document 

#let metadata = yaml(sys.inputs.meta-path)

#let letter-of = (s) => upper(s.slice(0, 1))
#let entries = terms.pairs().sorted(key: e => lower(e.at(0)))
#let render-entry = (term, def) => [*#term*: #def]

#let capitalize-first = (s) => s.replace(regex("^[[:alpha:]]"), m => upper(m.text))

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Documento che permette di chiarificare la terminologia adoperata all'interno della documentazione del gruppo",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
  glossary-highlighted: false
)[

  #heading(level: 1, numbering: none)[Introduzione]
  Il documento di *glossario* nasce con lo scopo di andare a chiarire tutte i possibili dubbi e ambiguità che possono nascere nella terminologia utilizzata all'interno della documentazione di NoTIP. \
  Verranno esposte di seguito tutti quei termini che, come gruppo, consideriamo potenzialmente fraintendibili o di cui, semplicemente, preferiamo esplicitare il significato. \
  Lo stile che abbiamo deciso di adoperare all'interno della documentazione è il seguente: 
  #align(center)[_parola#sub[G]_]
  in modo da andare a renderla chiaramente visibile.

  #{
    for i in range(0, entries.len()) {
      let term = capitalize-first(entries.at(i).at(0))
      let def = entries.at(i).at(1)
      let letter = letter-of(term)
      
      if i == 0 or not letter-of(entries.at(i - 1).at(0)) == letter [
        #pagebreak()
        #heading(level: 1, numbering: none)[#letter]
      ]
      
      render-entry(term, def)
      v(0.5em)
    }
  }

]





