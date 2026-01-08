#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "filtraggio_gateway",
  system: CLOUD_SYS,
  title: "Filtraggio dati per Gateway",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’attore primario è nella sezione “Visualizzazione Stream”",
    "Esiste almeno un Gateway nel Tenant",
  ),
  postconds: (
    "Il sistema salva la richiesta di visualizzazione",
  ),
  trigger: "L’attore primario vuole filtrare per gateway",
  main-scen: (
    (
      descr: "L’attore primario seleziona i gateway dei quali visualizzare i dati",
      inc: "filtraggio_singolo_gateway",
    ),
    (
      descr: "Il sistema salva le informazioni di visualizzazione",
      ep: "Filtraggio",
    ),
  ),
  alt-scen: (
    (
      ep: "Filtraggio",
      cond: "L’attore primario decide di filtrare i dati per sensore",
      uc: "filtraggio_sensore",
    ),
  ),
)[
  #uml-schema("25", "Diagramma filtraggio dati per gateway")
]
