#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "filtraggio_sensore",
  system: CLOUD_SYS,
  title: "Filtraggio dati per sensore",
  gen-parent: "filtraggio_dati",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’Attore ha effettuato un filtraggio per Gateway",
    "Esiste almeno un sensore associato al Gateway del Tenant gestito dall’Attore",
  ),
  postconds: (
    "Il Sistema salva la richiesta di visualizzazione",
  ),
  trigger: "L’Attore vuole filtrare per sensori",
  main-scen: (
    (
      descr: "L’Attore seleziona i sensori di cui visualizzare i dati",
      inc: "filtraggio_singolo_sensore",
    ),
    (
      descr: "Il Sistema salva le preferenze di visualizzazione",
    ),
  ),

  uml-descr: none,
)
