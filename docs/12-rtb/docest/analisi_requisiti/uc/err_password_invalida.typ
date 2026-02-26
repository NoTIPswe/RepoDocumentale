#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "err_password_invalida",
  system: CLOUD_SYS,
  title: "Errore password non valida",
  level: 1,
  prim-actors: (CA.non-authd-usr, CA.authd-usr),
  preconds: (
    "La password fornita non soddisfa i criteri di validazione definiti dal Sistema",
  ),
  postconds: (
    "La password inserita viene rifiutata",
  ),
  trigger: "L’Attore ha fornito una password non valida/abbastanza sicura",
  main-scen: (
    (descr: "L’Attore viene notificato che l’email inserita non è valida e viene invitato a sceglierne un’altra"),
  ),

)
