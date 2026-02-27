#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_tipo_sensore_simulato",
  level: 1,
  title: "Visualizzazione tipo sensore simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Esiste un sensore che è stato selezionato di cui si stanno visualizzando i dettagli di configurazione di simulazione",
  ),
  postconds: (
    "L’Attore visualizza la tipologia del sensore",
  ),
  trigger: "L’Attore vuole visualizzare il tipo di un sensore simulato",
  main-scen: (
    (descr: "L’Attore visualizza la tipologia di sensore simulato"),
  ),

  uml-descr: "Diagramma Visualizzazione tipo sensore simulato",
)

