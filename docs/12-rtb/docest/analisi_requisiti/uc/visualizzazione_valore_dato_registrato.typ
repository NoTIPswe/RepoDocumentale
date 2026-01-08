#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_valore_dato_registrato",
  system: CLOUD_SYS,
  title: "Visualizzazione valore del dato registrato",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "La sessione è attiva",
    "L’attore sta visualizzando un alert relativo a dati fuori range",
  ),
  postconds: (
    "L’attore visualizza il dato fuori range registrato",
  ),
  trigger: "Un dato registrato risulta essere fuori range previsto",
  main-scen: (
    (descr: "L’Attore visualizza il valore del dato registrato"),
  ),
)[
  #uml-schema("31.1", "Diagramma visualizzazione valore del dato registrato")
]
