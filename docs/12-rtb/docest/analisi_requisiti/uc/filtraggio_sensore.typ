#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "filtraggio_sensore",
  system: CLOUD_SYS,
  title: "Filtraggio dati per sensore",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’Attore primario si trova nella sezione “Visualizzazione Stream”",
    "L’Attore primario ha effettuato un filtraggio per Gateway",
    "Esiste almeno un sensore associato al Gateway del Tenant gestito dall’Attore",
  ),
  postconds: (
    "Il sistema salva la richiesta di visualizzazione",
  ),
  trigger: "L’Attore primario vuole filtrare per sensori",
  main-scen: (
    (
      descr: "L’Attore primario seleziona i sensori di cui visualizzare i dati",
      inc: "filtraggio_singolo_sensore",
    ),
    (
      descr: "Il sistema salva le preferenze di visualizzazione",
      ep: "Filtraggio",
    ),
  ),
)[
  #uml-schema("26", "Diagramma filtraggio dati per sensore")
]
