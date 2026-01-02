#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "err_mail_non_valida",
  system: CLOUD_SYS,
  title: "Errore - Mail non valida",
  level: 1,
  prim-actors: (CA.authd-usr,),
  preconds: (
    "L’attore primario è in fase di registrazione di una email",
    "L’attore primario ha inserito una mail non valida",
  ),
  postconds: (
    "La mail inserita viene rifiutata",
  ),
  trigger: "L’attore primario ha fornito una email non valida",
  main-scen: (
    (descr: "L’attore primario viene notificato che l’email inserita non è valida ed invitato a inserirla nuovamente"),
  ),
)
