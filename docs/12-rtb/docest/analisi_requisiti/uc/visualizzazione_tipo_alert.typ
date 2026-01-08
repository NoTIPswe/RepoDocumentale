#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_tipo_alert",
  system: CLOUD_SYS,
  title: "Visualizzazione tipo di alert",
  level: 3,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’attore primario si trova nella sezione dedicata agli alert",
    "L’attore primario sta visualizzando lo storico degli alert",
    "(Da inserire qualcosa)",
  ),
  postconds: (
    "Il sistema mostra il tipo di alert",
  ),
  trigger: "L’attore primario deve visualizzare lo storico degli alert del tenant",
  main-scen: (
    (descr: "L’attore primario visualizza il tipo dell’alert"),
  ),
)[
  #uml-schema("33.1.1", "Diagramma visualizzazione tipo di alert")
]
