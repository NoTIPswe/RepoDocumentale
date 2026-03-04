#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "inserimento_nuova_mail",
  system: CLOUD_SYS,
  title: "Inserimento mail",
  level: 2,
  prim-actors: (CA.authd-usr,),
  preconds: (
    "Il Sistema richiede all'Attore di inserire un nuovo indirizzo mail",
  ),
  postconds: (
    "L’indirizzo mail inserito è sintatticamente valido e non risulta associato ad altri account",
  ),
  trigger: "L'Attore compila il campo relativo al nuovo indirizzo mail",
  main-scen: (
    (
      descr: "L’Attore inserisce l’indirizzo mail nel campo dedicato",
      ep: "MailInvalida",
    ),
  ),
  alt-scen: (
    (
      ep: "MailInvalida",
      cond: "L’Attore inserisce una mail non valida",
      uc: "err_mail_non_valida",
    ),
    (
      ep: "MailInvalida",
      cond: "L’Attore inserisce una mail già associata ad un altro account",
      uc: "err_mail_gia_registrata",
    ),
  ),
)
