#import "uc_lib.typ": tag_uc

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
  if tipo == F and system == SIM { _req-sf-ctr } else if tipo == F { _req-f-ctr } else if tipo == Q {
    _req-q-ctr
  } else if tipo == V { _req-v-ctr } else { _req-s-ctr }
}

#let _req-prefix(tipo, system) = {
  if tipo == F and system == SIM { "R-S-" } else { "R-" }
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
  let ctr = _req-counter(tipo, system)
  let prefix = _req-prefix(tipo, system)
  let lbl = label("REQ:" + id)

  let code-cell = [
    #ctr.step()
    #context {
      let n = ctr.get().first()
      let display = prefix + str(n) + "-" + tipo
      [#metadata(display) #lbl #display]
    }
  ]

  (
    code-cell,
    [#priorita],
    descrizione,
    [#align(left)[#if fonti == none { [] } else { fonti }]],
  )
}

// Create reference to requisite
#let ref_req(id) = context {
  let lbl = label("REQ:" + id)
  let results = query(lbl)
  if results.len() == 0 {
    text(fill: red)[⚠ REQ:#id]
  } else {
    let display = results.first().value
    link(lbl)[#display]
  }
}

#let _req-priority-from-yaml(priority) = {
  if priority == "mandatory" {
    OBBLIGATORIO
  } else if priority == "desirable" {
    DESIDERABILE
  } else {
    "Opzionale"
  }
}

#let _req-kind-from-yaml(req-type) = {
  if req-type == "quality" {
    Q
  } else if req-type == "constraint" {
    V
  } else if req-type == "security" {
    S
  } else {
    F
  }
}

#let _req-system-from-yaml(req-type) = {
  if req-type == "functional_sim" {
    SIM
  } else {
    CLOUD
  }
}

#let _render-req-source(src) = {
  if src.at("uc", default: none) != none {
    tag_uc(src.uc)
  } else if src.at("url", default: none) != none {
    link(src.url)[src.text]
  } else {
    src.text
  }
}

#let render_req_table(path) = {
  let data = yaml(path)
  let kind = _req-kind-from-yaml(data.type)
  let req-system = _req-system-from-yaml(data.type)

  table(
    columns: (auto, auto, 2fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
    ..data
      .requirements
      .map(r => {
        let sources = r.at("sources", default: ())
        req(
          id: r.id,
          tipo: kind,
          system: req-system,
          priorita: _req-priority-from-yaml(r.priority),
          descrizione: [#r.description],
          fonti: if sources.len() == 0 {
            none
          } else {
            list(..sources.map(src => _render-req-source(src)))
          },
        )
      })
      .flatten(),
  )
}

#let render_uc_req_traceability(trace-map) = {
  table(
    columns: (2fr, 2fr),
    [Use Case], [Requisiti],
    ..trace-map
      .pairs()
      .map(pair => {
        let uc-id = pair.at(0)
        let req-ids = pair.at(1)
        (
          [#tag_uc(uc-id)],
          [#list(..req-ids.map(req_id => ref_req(req_id)))],
        )
      })
      .flatten(),
  )
}

#let render_req_uc_traceability(trace-map) = {
  table(
    columns: (2fr, 2fr),
    [Requisito], [Use Case],
    ..trace-map
      .pairs()
      .map(pair => {
        let req-id = pair.at(0)
        let uc-ids = pair.at(1)
        (
          [#ref_req(req-id)],
          [#list(..uc-ids.map(uc-id => tag_uc(uc-id)))],
        )
      })
      .flatten(),
  )
}

#let render_req_test_traceability(trace-map) = {
  table(
    columns: (2fr, 2fr),
    [Requisito], [Test],
    ..trace-map
      .pairs()
      .map(pair => {
        let req-code = pair.at(0)
        let tests = pair.at(1)
        (
          [#req-code],
          [#list(..tests)],
        )
      })
      .flatten(),
  )
}
