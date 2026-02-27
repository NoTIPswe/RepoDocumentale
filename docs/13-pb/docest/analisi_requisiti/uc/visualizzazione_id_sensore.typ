#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_id_sensore",
  system: CLOUD_SYS,
  title: "Visualizzazione ID sensore",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema mostra una lista di sensori o un alert riguardante un sensore",
  ),
  postconds: (
    "L’Attore visualizza l’ID del sensore",
  ),
  trigger: "Necessità di distinguere univocamente i sensori",
  main-scen: (
    (descr: "L’Attore visualizza l’identificativo del sensore (UUID)"),
  ),

  uml-descr: "Diagramma Visualizzazione ID sensore",
)
