#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "err_range_invalido",
  system: CLOUD_SYS,
  title: "Errore range invalido",
  level: 1,
  prim-actors: (CA.tenant-adm,),
  preconds: (
    "Il Sistema richiede di inserire dei valori per il range di un sensore ",
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
  #uml-schema("102", "Diagramma Errore range invalido")
]
