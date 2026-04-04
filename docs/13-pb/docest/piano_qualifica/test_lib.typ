#import "../analisi_requisiti/req_lib.typ": render_req_test_traceability

#let _req-code-map = json("../../01-requirements/req/_req_codes.generated.json")
#let _req-code(req-id) = _req-code-map.at(req-id, default: req-id)

#let _test_u_counter = counter("test-u")
#let _test_i_counter = counter("test-i")
#let _test_s_counter = counter("test-s")

#let _test_counter(test_type) = {
  if test_type == "unit" {
    _test_u_counter
  } else if test_type == "integration" {
    _test_i_counter
  } else {
    _test_s_counter
  }
}

#let _test_prefix(test_type) = {
  if test_type == "unit" {
    "T-U-"
  } else if test_type == "integration" {
    "T-I-"
  } else {
    "T-S-"
  }
}

#let _test_id_token(test_type) = {
  if test_type == "unit" {
    "u"
  } else if test_type == "integration" {
    "i"
  } else {
    "s"
  }
}

#let _test_code_from_id(test_type, test-id, fallback) = {
  let raw-id = str(test-id)
  let raw-prefix = "t_" + _test_id_token(test_type) + "_"

  if raw-id.starts-with(raw-prefix) and raw-id.len() > raw-prefix.len() {
    _test_prefix(test_type) + raw-id.slice(raw-prefix.len())
  } else {
    fallback
  }
}

#let _test_status(status) = {
  if status == "passed" {
    "S"
  } else if status == "failed" {
    "NS"
  } else {
    "NI"
  }
}

#let _ref_test(code) = context {
  let lbl = label("TEST:" + code)
  let results = query(lbl)
  if results.len() == 0 {
    code
  } else {
    link(lbl)[#code]
  }
}

#let _test_row(test_type, test) = {
  let ctr = _test_counter(test_type)
  let status_text = _test_status(test.at("status", default: "not_implemented"))
  let req_cells = list(..test.requirements.map(req_id => _req-code(req_id)))
  let code = [
    #ctr.step()
    #context {
      let n = ctr.get().first()
      let fallback-code = _test_prefix(test_type) + str(n)
      let test-code = _test_code_from_id(test_type, test.at("id", default: ""), fallback-code)
      [#metadata(test-code) #label("TEST:" + test-code) #test-code]
    }
  ]

  (
    code,
    [#test.description],
    [#req_cells],
    [#status_text],
  )
}

#let render_test_table(path, component: none) = {
  let data = yaml(path)
  let filtered_tests = if component == none {
    data.tests.filter(test => test.at("component", default: none) == none)
  } else {
    data.tests.filter(test => test.at("component", default: none) == component)
  }
  table(
    columns: (1fr, 3.5fr, 1.2fr, 0.8fr),
    stroke: 0.5pt,
    inset: 6pt,
    table.header([*Codice*], [*Descrizione*], [*Requisiti di riferimento*], [*Stato*]),
    ..filtered_tests.map(test => _test_row(data.type, test)).flatten(),
  )
}

#let render_req_test_matrix(trace-map) = render_req_test_traceability(trace-map)

#let render_req_test_traceability_with_links(trace-map) = {
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
          [#list(..tests.map(test => _ref_test(test)))],
        )
      })
      .flatten(),
  )
}
