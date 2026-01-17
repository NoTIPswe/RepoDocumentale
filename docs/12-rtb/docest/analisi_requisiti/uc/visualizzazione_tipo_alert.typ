#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_tipo_alert",
  system: CLOUD_SYS,
  title: "Visualizzazione tipo di alert",
  level: 3,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Esiste almeno un alert registrato nel Sistema",
    "Il Sistema sta mostrando lo storico degli alert registrati nel Sistema",
  ),
  postconds: (
    "L'Attore visualizza il tipo di alert",
  ),
  trigger: "L’Attore vuole visualizzare lo storico degli alert registrati nel Sistema",
  main-scen: (
    (descr: "L’Attore visualizza il tipo dell’alert"),
  ),
)[
  #uml-schema("33.1.1", "Diagramma visualizzazione tipo di alert")
]
