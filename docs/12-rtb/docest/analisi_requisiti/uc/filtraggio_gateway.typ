#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "filtraggio_gateway",
  system: CLOUD_SYS,
  title: "Filtraggio dati per Gateway",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Esiste almeno un Gateway nel Tenant",
  ),
  postconds: (
    "Il Sistema salva la richiesta di visualizzazione",
  ),
  trigger: "L’Attore vuole filtrare per Gateway",
  main-scen: (
    (
      descr: "L’Attore seleziona i Gateway dei quali visualizzare i dati",
      inc: "filtraggio_singolo_gateway",
    ),
    (
      descr: "Il Sistema salva le informazioni di visualizzazione",
    ),
  ),
  alt-scen: (),
)[
  #uml-schema("25", "Diagramma Filtraggio dati per Gateway")
]
