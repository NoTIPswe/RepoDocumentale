#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_costi_banda",
  system: CLOUD_SYS,
  title: "Visualizzazione costi stimati per banda",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il Gateway appartiene al Tenant e ha dei costi stimati associati",
  ),
  postconds: (
    "L’Attore visualizza correttamente i costi stimati raggruppati in base alla banda",
  ),
  trigger: "L’Attore principale vuole visualizzare i costi stimati dei Gateway associati al Tenant per banda",
  main-scen: (
    (descr: "L'Attore visualizza il riepilogo dei costi stimati per banda dei dati relativi ai Gateway selezionati"),
  ),
)
