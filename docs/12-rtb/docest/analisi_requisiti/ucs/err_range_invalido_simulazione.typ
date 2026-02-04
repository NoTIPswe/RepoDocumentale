#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  system: SIM_SYS,
  id: "err_range_invalido_simulazione",
  title: "Errore range invalido del sensore simulato",
  level: 1,
  prim-actors: (SA.sym-usr),
  preconds: (
    "Il Sistema richiede di inserire dei valori per il range di un sensore simulato",
    "Il range inserito non è un valore accettato",
  ),
  postconds: (
    "L'Attore principale viene notificato dell'errore",
  ),
  trigger: "L'Attore principale sta inserendo un range ma il valore inserito non è accettabile",
  main-scen: (
    (
      descr: "L’Attore viene notificato dell'invalidità del range inserito",
    ),
    (
      descr: "L'Attore viene invitato ad inserire un valore accettabile",
    ),
  ),
)[
  #uml-schema("S13", "Diagramma Errore range invalido del sensore simulato")
]
