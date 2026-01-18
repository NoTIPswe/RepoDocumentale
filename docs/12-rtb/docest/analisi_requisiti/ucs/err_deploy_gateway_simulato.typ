#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  system: SIM_SYS,
  id: "err_deploy_gateway_simulato",
  level: 1,
  title: "Errore deploy Gateway simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "È stato richiesto il deploy di una o più istanze di Gateway",
    "Si è verificato un errore tecnico durante il deploy del Gateway",
  ),
  postconds: (
    "Le istanze non vengono create",
    "L'Attore viene notificato dell’errore di deploy",
  ),
  trigger: "Errore nella creazione dei Gateway simulati",
  main-scen: (
    (descr: "L’operazione di creazione viene annullata"),
    (descr: "L’Attore viene notificato dell’errore"),
  ),
)[
  #uml-schema("S11", "Errore deploy Gateway simulato")
]

