#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  system: SIM_SYS,
  id: "err_valore_numerico_invalido",
  title: "Errore valore numerico invalido",
  level: 1,
  prim-actors: (SA.sym-usr),
  preconds: (
    "Il Sistema richiede di inserire un valore numerico",
    "Il valore inserito non è un valore accettato (negativo o non numerico)",
  ),
  postconds: (
    "L'Attore principale viene notificato dell'errore",
  ),
  trigger: "L'Attore principale sta inserendo un valore numerico il valore inserito non è accettabile",
  main-scen: (
    (
      descr: "L’Attore viene notificato dell'invalidità del valore inserito",
    ),
    (
      descr: "L'Attore viene invitato ad inserire un valore accettabile",
    ),
  ),
)[
  #uml-schema("S16", "Diagramma Errore valore numerico invalido")
]
