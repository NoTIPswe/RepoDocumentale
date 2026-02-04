#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "err_account_inesistente",
  system: CLOUD_SYS,
  title: "Errore account non esistente",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "La mail fornita dall'Attore non risulta associata ad alcun account registrato nel Sistema",
  ),
  postconds: (
    "L'Attore ricompila il campo mail",
  ),
  trigger: "Inserimento di una mail non associata ad un account",
  main-scen: (
    (descr: "L'Attore viene notificato dell'inserimento di una mail non associata a nessun account"),
  ),
)[
  #uml-schema("8", "Diagramma Errore account non esistente")

]
