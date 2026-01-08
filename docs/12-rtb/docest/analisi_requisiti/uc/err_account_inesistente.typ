#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "err_account_inesistente",
  system: CLOUD_SYS,
  title: "Errore - Account non esistente",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "L'attore primario ha inserito nel campo mail un indirizzo non associato a nessun account",
  ),
  postconds: (
    "L'attore primario ricompila il campo mail",
  ),
  trigger: "Inserimento di una mail non associata ad un account",
  main-scen: (
    (descr: "L'attore primario viene notificato dell'inserimento di una mail non associata a nessun account"),
  ),
)[
  #uml-schema("8", "Account Non Esistente")

]
