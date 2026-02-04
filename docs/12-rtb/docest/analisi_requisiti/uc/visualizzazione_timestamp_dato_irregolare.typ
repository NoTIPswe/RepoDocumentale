#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_timestamp_dato_irregolare",
  system: CLOUD_SYS,
  title: "Visualizzazione timestamp registrazione dato irregolare",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Esiste un'irregolarità nelle misurazioni del sensore",
    "Il Sistema sta mostrando un alert relativo a dati fuori range",
  ),
  postconds: (
    "L’Attore visualizza il timestamp della registrazione del dato fuori range",
  ),
  trigger: "Un valore registrato dal sensore risulta fuori dal range previsto",
  main-scen: (
    (descr: "L’Attore visualizza l’orario di registrazione del dato da parte del sensore"),
  ),
)[
  #uml-schema("32", "Diagramma Visualizzazione timestamp registrazione dato irregolare")
]
