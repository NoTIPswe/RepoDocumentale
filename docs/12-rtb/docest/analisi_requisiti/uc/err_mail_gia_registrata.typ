#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "err_mail_gia_registrata",
  system: CLOUD_SYS,
  title: "Errore - Mail già registrata",
  level: 1,
  prim-actors: (CA.authd-usr,),
  preconds: (
    "L’attore primario inserisce una mail già registrata dove ne serve una “vergine”",
  ),
  postconds: (
    "La mail inserita viene rifiutata",
  ),
  trigger: "Inserimento di una mail già associata ad un account",
  main-scen: (
    (descr: "L’attore primario viene notificato che l’email inserita è già associata ad un altro account"),
  ),
)
