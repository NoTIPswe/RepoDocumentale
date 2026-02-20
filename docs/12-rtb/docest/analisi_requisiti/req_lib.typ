// Variables 
#let OBBLIGATORIO = "Obbligatorio"
#let DESIDERABILE = "Desiderabile"

#let F = "F"
#let Q = "Q"
#let V = "V"
#let S = "S"

#let CLOUD = 0
#let SIM = 1

// Indipendent counters 
#let _req-f-ctr = counter("req-f")
#let _req-sf-ctr = counter("req-sf")
#let _req-q-ctr = counter("req-q")
#let _req-v-ctr = counter("req-v")
#let _req-s-ctr = counter("req-s")

// Private helpers
#let _req-counter(tipo, system) = {
  if tipo == F and system == SIM { _req-sf-ctr }
  else if tipo == F               { _req-f-ctr }
  else if tipo == Q               { _req-q-ctr }
  else if tipo == V               { _req-v-ctr }
  else                            { _req-s-ctr }
}

#let _req-prefix(tipo, system) = {
  if tipo == F and system == SIM { "R-S-" }
  else { "R-" }
}

// Create requisite
#let req(
  id: none,
  tipo: none,
  system: CLOUD,
  priorita: OBBLIGATORIO,
  descrizione: none,
  fonti: none,
) = {
  let ctr    = _req-counter(tipo, system)
  let prefix = _req-prefix(tipo, system)
  let lbl    = label("REQ:" + id)

  let code-cell = [
    #ctr.step()
    #context {
      let n       = ctr.get().first()
      let display = prefix + str(n) + "-" + tipo
      [#metadata(display) #lbl #display]
    }
  ]

  (code-cell, [#priorita], descrizione, if fonti == none { [] } else { fonti })
}

// Create reference to requisite
#let ref-req(id) = context {
  let lbl     = label("REQ:" + id)
  let results = query(lbl)
  if results.len() == 0 {
    text(fill: red)[⚠ REQ:#id]
  } else {
    let display = results.first().value
    link(lbl)[#display]
  }
}
