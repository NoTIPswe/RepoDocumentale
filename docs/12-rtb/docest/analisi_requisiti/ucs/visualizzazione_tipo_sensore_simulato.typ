#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_tipo_sensore_simulato",
  level: 1,
  title: "Visualizzazione tipo sensore simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore ha selezionato un sensore relativo ad un gateway simulato di cui visualizzare la configurazione della simulazione",
    "L’attore sta visualizzando la configurazione di un sensore simulato",
  ),
  postconds: (
    "L’attore visualizza la tipologia del sensore",
  ),
  trigger: "L’attore vuole visualizzare il tipo di un sensore simulato",
  main-scen: (
    (descr: "L’attore visualizza la tipologia di sensore simulato"),
  ),
)
