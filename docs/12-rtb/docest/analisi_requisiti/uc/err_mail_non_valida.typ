#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "err_mail_non_valida",
  system: CLOUD_SYS,
  title: "Errore mail non valida",
  level: 1,
  prim-actors: (CA.authd-usr,),
  preconds: (
    "La mail fornita non rispetta il formato valido richiesto dal Sistema",
  ),
  postconds: (
    "La mail inserita viene rifiutata",
  ),
  trigger: "L’Attore ha fornito una email non valida",
  main-scen: (
    (descr: "L’Attore viene notificato che l’email inserita non è valida ed invitato a inserirla nuovamente"),
  ),
)
