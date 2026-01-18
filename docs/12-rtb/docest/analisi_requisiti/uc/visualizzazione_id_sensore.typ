#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_id_sensore",
  system: CLOUD_SYS,
  title: "Visualizzazione ID sensore",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il sistema mostra una lista di sensori o un alert riguardante un sensore",
  ),
  postconds: (
    "L’Attore primario visualizza l’ID del sensore",
  ),
  trigger: "Necessità di distinguere univocamente i sensori",
  main-scen: (
    (descr: "L’Attore primario visualizza l’identificativo del sensore (UUID)"),
  ),
)[
  #uml-schema("23", "Diagrammaza visualizzazione id sensore")
]
