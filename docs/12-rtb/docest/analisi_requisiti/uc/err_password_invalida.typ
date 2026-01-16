#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "err_password_invalida",
  system: CLOUD_SYS,
  title: "Errore - Password non valida",
  level: 1,
  prim-actors: (CA.non-authd-usr, CA.authd-usr),
  preconds: (
    "La password fornita non soddisfa i criteri di validazione definiti dal sistema",    
  ),
  postconds: (
    "La password inserita viene rifiutata",
  ),
  trigger: "L’attore ha fornito una password non valida/abbastanza sicura",
  main-scen: (
    (descr: "L’attore viene notificato che l’email inserita non è valida e viene invitato a sceglierne un’altra"),
  ),
)[
  #uml-schema("11", "Password non valida")

]
