#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "ins_conf_mail",
  system: CLOUD_SYS,
  title: "Inserimento e Conferma Mail",
  level: 1,
  prim-actors: (CA.authd-usr,),
  preconds: (
    "L’attore primario deve compilare un campo mail e un campo di conferma mail",
  ),
  postconds: (
    "L’indirizzo mail inserita è stato validato",
  ),
  trigger: "Necessità di inserire una mail e confermarla",
  main-scen: (
    (
      descr: "L’attore primario inserisce l’indirizzo mail nel campo dedicato",
      ep: "MailInvalida",
    ),
    (
      descr: "L’attore primario conferma l’indirizzo mail reinserendolo nel campo apposito",
      ep: "MailDiverse",
    ),
  ),
  alt-scen: (
    (
      ep: "MailInvalida",
      cond: "L’attore primario inserisce una mail non valida",
      uc: "err_mail_non_valida",
    ),
    (
      ep: "MailInvalida",
      cond: "L’attore primario inserisce una mail già associata ad un altro account",
      uc: "err_mail_gia_registrata",
    ),
    (
      ep: "MailDiverse",
      cond: "L’attore primario inserisce due valori diversi nei due campi",
      uc: "err_campi_diversi",
    ),
  ),
)
