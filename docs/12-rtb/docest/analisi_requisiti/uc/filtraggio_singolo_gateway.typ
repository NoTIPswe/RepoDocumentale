#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "filtraggio_singolo_gateway",
  system: CLOUD_SYS,
  title: "Filtraggio dati per singolo Gateway",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’Attore primario è nella sezione “Visualizzazione Stream”",
    "Esiste almeno un Gateway nel Tenant",
    "L’Attore primario sta scegliendo i Gateway di cui vuole visualizzare lo Stream di dati",
  ),
  postconds: (
    "Viene aggiunto un Gateway alla lista della richiesta",
  ),
  trigger: "L’Attore primario vuole filtrare per Gateway",
  main-scen: (
    (descr: "L’Attore primario seleziona un Gateway da aggiungere alla lista di filtraggio"),
  ),
)[
  #uml-schema("25.1", "Diagramma filtraggio dati per singolo Gateway")
]
