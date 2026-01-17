#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_timestamp_emissione_alert",
  system: CLOUD_SYS,
  title: "Visualizzazione timestamp emissione alert",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema sta mostrando lo storico degli alert registrati nel Sistema o i dettagli di un alert",
  ),
  postconds: (
    "L'Attore visualizza il timestamp dell’emissione dell’alert",
  ),
  trigger: "L’Attore vuole visualizzare il timestamp di emissione di un alert",
  main-scen: (
    (descr: "L’Attore visualizza il timestamp dell’emissione dell’alert"),
  ),
)[
  #uml-schema("34", "Diagramma visualizzazione timestamp emissione alert")
]
