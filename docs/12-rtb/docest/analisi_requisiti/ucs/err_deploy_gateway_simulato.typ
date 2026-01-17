#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "err_deploy_gateway_simulato",
  level: 1,
  title: "Errore deploy Gateway simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "È stato richiesto il deploy di un nuovo Gateway",
    "Si è verificato un errore tecnico durante il deploy del Gateway",
  ),
  postconds: (
    "Il Gateway non viene creato",
    "L’Attore viene notificato dell’errore di deploy",
  ),
  trigger: "Errore nella creazione del Gateway simulato",
  main-scen: (
    (descr: "L’operazione di creazione viene annullata"),
    (descr: "L’Attore viene notificato dell’errore"),
  ),
)
