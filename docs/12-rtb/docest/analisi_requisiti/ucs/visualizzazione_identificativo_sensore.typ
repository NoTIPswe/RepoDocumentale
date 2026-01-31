#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  system: SIM_SYS,
  id: "visualizzazione_identificativo_sensore",
  level: 1,
  title: "Visualizzazione identificativo sensore",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Esiste un sensore che è stato selezionato di cui si stanno visualizzando i dettagli di configurazione di simulazione",
  ),
  postconds: (
    "L'Attore visualizza l’identificativo del sensore",
  ),
  trigger: "L’Attore vuole visualizzare l’identificativo di un sensore simulato",
  main-scen: (
    (descr: "L’Attore visualizza l’identificativo del sensore simulato"),
  ),
)[
  #uml-schema("S6", "Diagramma Visualizzazione identificativo sensore")
]

