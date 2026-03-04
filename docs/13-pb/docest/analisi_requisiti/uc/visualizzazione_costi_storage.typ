#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_costi_storage",
  system: CLOUD_SYS,
  title: "Visualizzazione costi stimati per storage",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il Gateway appartiene al Tenant e ha dei costi stimati associati",
  ),
  postconds: (
    "L’Attore visualizza i costi stimati relativi allo storage del Gateway selezionato",
  ),
  trigger: "L’Attore vuole visualizzare i costi stimati per il Tenant di cui è amministratore",
  main-scen: (
    (descr: "L'Attore visualizza il riepilogo dei costi stimati per storage dei dati relativi ai Gateway selezionati"),
  ),
)
