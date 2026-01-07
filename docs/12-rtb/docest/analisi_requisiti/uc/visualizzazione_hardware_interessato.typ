#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_hardware_interessato",
  system: CLOUD_SYS,
  title: "Visualizzazione hardware interessato",
  level: 3,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’attore primario si trova nella sezione dedicata agli alert",
    "L’attore primario sta visualizzando lo storico degli alert",
  ),
  postconds: (
    "Il sistema mostra l’hardware interessato",
  ),
  trigger: "L’attore primario deve visualizzare lo storico degli alert del tenant",
  main-scen: (
    (descr: "L’attore primario visualizza l’identificativo dell’hardware interessato dall’alert"),
  ),
)
