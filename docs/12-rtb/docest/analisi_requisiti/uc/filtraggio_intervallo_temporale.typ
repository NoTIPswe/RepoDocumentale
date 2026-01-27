#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "filtraggio_intervallo_temporale",
  system: CLOUD_SYS,
  title: "Filtraggio dati per intervallo temporale",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema mostra i dati relativi allo Stream del Tenant",
  ),
  postconds: (
    "Il Sistema salva la richiesta di visualizzazione",
  ),
  trigger: "L’Attore primario vuole visualizzare i dati relativi ad uno specifico intervallo temporale",
  main-scen: (
    (descr: "L’Attore primario seleziona un intervallo di tempo per visualizzare i dati al suo interno"),
    (descr: "Il Sistema salva le preferenze di visualizzazione"),
  ),
)[
  #uml-schema("27", "Diagramma Filtraggio dati per intervallo temporale")
]
