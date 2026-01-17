#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_identificativo_sensore",
  level: 1,
  title: "Visualizzazione identificativo sensore",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’Attore ha selezionato un sensore relativo ad un Gateway simulato di cui visualizzare la configurazione della simulazione",
    "L’Attore sta visualizzando la configurazione di un sensore simulato",
  ),
  postconds: (
    "L’Attore visualizza l’identificativo del sensore",
  ),
  trigger: "L’Attore vuole visualizzare l’identificativo di un sensore simulato",
  main-scen: (
    (descr: "L’Attore visualizza l’identificativo del sensore simulato"),
  ),
)
