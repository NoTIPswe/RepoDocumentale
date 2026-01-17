#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "err_mail_non_valida",
  system: CLOUD_SYS,
  title: "Errore - Mail non valida",
  level: 1,
  prim-actors: (CA.authd-usr,),
  preconds: (
    "La mail fornita non rispetta il formato valido definito dal sistema",
  ),
  postconds: (
    "La mail inserita viene rifiutata",
  ),
  trigger: "L’Attore primario ha fornito una email non valida",
  main-scen: (
    (descr: "L’Attore primario viene notificato che l’email inserita non è valida ed invitato a inserirla nuovamente"),
  ),
)[
  #uml-schema("14", "Mail non Valida")

]
