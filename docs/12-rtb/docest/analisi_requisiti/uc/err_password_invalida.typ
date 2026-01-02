#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "err_password_invalida",
  system: CLOUD_SYS,
  title: "Errore - Password non valida",
  level: 1,
  prim-actors: (CA.non-authd-usr, CA.authd-usr),
  preconds: (
    "L’attore primario è in fase di registrazione di una password",
    "L’attore primario ha inserito una mail non valida secondo le politiche di sicurezza",
  ),
  postconds: (
    "La mail inserita viene rifiutata",
  ),
  trigger: "L’attore ha fornito una password non valida/abbastanza sicura",
  main-scen: (
    (descr: "L’attore viene notificato che l’email inserita non è valida e viene invitato a sceglierne un’altra"),
  ),
)
