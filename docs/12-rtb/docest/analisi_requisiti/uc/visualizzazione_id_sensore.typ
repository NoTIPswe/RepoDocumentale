#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_id_sensore",
  system: CLOUD_SYS,
  title: "Visualizzazione ID sensore",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’attore primario sta visualizzando una lista di sensori o un alert riguardante un sensore",
  ),
  postconds: (
    "L’attore primario visualizza l’ID del sensore",
  ),
  trigger: "Necessità di distinguere univocamente i sensori",
  main-scen: (
    (descr: "L’attore primario visualizza l’identificativo del sensore (UUID)"),
  ),
)
