#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "filtraggio_intervallo_temporale",
  system: CLOUD_SYS,
  title: "Filtraggio dati per intervallo temporale",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’attore primario si trova nella sezione “Visualizzazione Stream”",
  ),
  postconds: (
    "Il sistema salva la richiesta di visualizzazione",
  ),
  trigger: "L’Attore primario vuole visualizzare i dati relativi ad uno specifico intervallo temporale",
  main-scen: (
    (descr: "L’attore primario seleziona un intervallo di tempo per visualizzare i dati al suo interno"),
    (descr: "Il sistema salva le preferenze di visualizzazione"),
  ),
)
