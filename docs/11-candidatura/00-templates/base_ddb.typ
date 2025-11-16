#import "base_configs.typ" as base-configs
#import "base_slides.typ" as base-slides

#let apply-base-ddb(
  sprint: 1,
  date: none,
  results,
  objectives,
  problems,
) = {
  let display_date = if date != none { date } else { datetime.today().display("[day]/[month]/[year]") }

  base-slides.apply-base-slides(
    title: [Diario di Bordo],
    subtitle: [Sprint #sprint],
    date: display_date,
  )[
    = Risultati raggiunti e confronto \ con le previsioni
    #results
    = Obiettivi e attività per il \ periodo successivo
    #objectives
    = Difficoltà riscontrate e questioni aperte
    #problems
    #pagebreak()
    #set page(header: base-configs.default-header(title: [Diario di Bordo]))
    #align(center + horizon)[
      #v(1fr)
      #line(length: 50%, stroke: 4pt + base-configs.color-primary)
      #text(size: 34pt, weight: "bold", font: base-configs.sans-font)[Domande?]
      #v(1em)
      #text(size: 24pt, font: base-configs.serif-font)[Grazie per l'attenzione!]
      #line(length: 50%, stroke: 4pt + base-configs.color-primary)
      #v(1fr)
    ]
  ]
}
