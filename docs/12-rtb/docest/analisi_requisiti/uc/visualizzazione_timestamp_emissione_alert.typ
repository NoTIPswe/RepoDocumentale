#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_timestamp_emissione_alert",
  system: CLOUD_SYS,
  title: "Visualizzazione timestamp emissione alert",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’attore primario sta visualizzando lo storico degli alert o i dettagli di un alert",
  ),
  postconds: (
    "Il sistema mostra il timestamp dell’emissione dell’alert",
  ),
  trigger: "L’attore primario deve visualizzare lo storico degli alert del tenant",
  main-scen: (
    (descr: "L’attore primario visualizza il timestamp dell’emissione dell’alert"),
  ),
)[
  #uml-schema("34", "Diagramma visualizzazione timestamp emissione alert")
]
