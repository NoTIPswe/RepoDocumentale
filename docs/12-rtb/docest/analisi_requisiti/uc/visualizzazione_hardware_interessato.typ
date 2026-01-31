#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_hardware_interessato",
  system: CLOUD_SYS,
  title: "Visualizzazione hardware interessato",
  level: 3,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Esiste almeno un alert registrato nel Sistema",
    "Il Sistema sta mostrando lo storico degli alert registrati nel Sistema",
  ),
  postconds: (
    "L'Attore visualizza l’hardware interessato",
  ),
  trigger: "L’Attore vuole visualizzare lo storico degli alert registrati nel Sistema",
  main-scen: (
    (descr: "L’attore visualizza l’identificativo dell’hardware interessato dall’alert"),
  ),
)
