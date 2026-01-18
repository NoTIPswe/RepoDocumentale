#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  system: SIM_SYS,
  id: "err_creazione_sensore_simulato",
  level: 1,
  title: "Errore creazione Sensore simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "È stato richiesta la creazione di un nuovo sensore simulato da associare ad un Gateway",
    "Si è verificato un errore tecnico durante la creazione del sensore",
  ),
  postconds: (
    "Il Sensore non viene creato",
    "L'Attore viene notificato dell’errore",
  ),
  trigger: "Errore nella creazione del sensore simulato",
  main-scen: (
    (descr: "L’operazione di creazione viene annullata"),
    (descr: "L’Attore viene notificato dell’errore"),
  ),
)[
  #uml-schema("S14", "Errore creazione sensore simulato")
]

