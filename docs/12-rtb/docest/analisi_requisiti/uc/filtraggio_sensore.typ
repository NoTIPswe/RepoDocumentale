#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "filtraggio_sensore",
  system: CLOUD_SYS,
  title: "Filtraggio dati per sensore",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’attore primario si trova nella sezione “Visualizzazione Stream”",
    "L’attore primario ha effettuato un filtraggio per gateway",
    "Esiste almeno un sensore associato al Gateway del Tenant gestito dall’attore",
  ),
  postconds: (
    "Il sistema salva la richiesta di visualizzazione",
  ),
  trigger: "L’attore primario vuole filtrare per sensori",
  main-scen: (
    (
      descr: "L’attore primario seleziona i sensori di cui visualizzare i dati",
      inc: "filtraggio_singolo_sensore",
    ),
    (
      descr: "Il sistema salva le preferenze di visualizzazione",
      ep: "Filtraggio",
    ),
  ),
)
