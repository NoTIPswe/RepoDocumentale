#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "inserimento_conferma_mail",
  system: CLOUD_SYS,
  title: "Inserimento e conferma mail",
  level: 1,
  prim-actors: (CA.authd-usr,),
  preconds: (
    "Il Sistema richiede l’inserimento di una nuova mail per l’account",
  ),
  postconds: (
    "L’indirizzo mail inserito è stato validato",
  ),
  trigger: "Necessità di inserire una mail e confermarla",
  main-scen: (
    (
      descr: "L’Attore primario inserisce l’indirizzo mail nel campo dedicato",
      ep: "MailInvalida",
    ),
    (
      descr: "L’Attore primario conferma l’indirizzo mail reinserendolo nel campo apposito",
      ep: "FallimentoValidazione",
    ),
  ),
  alt-scen: (
    (
      ep: "MailInvalida",
      cond: "L’Attore primario inserisce una mail non valida",
      uc: "err_mail_non_valida",
    ),
    (
      ep: "MailInvalida",
      cond: "L’Attore primario inserisce una mail già associata ad un altro account",
      uc: "err_mail_gia_registrata",
    ),
    (
      ep: "FallimentoValidazione",
      cond: "L’Attore primario inserisce due valori diversi nei due campi",
      uc: "err_campi_diversi",
    ),
  ),
)[
  #uml-schema("13", "Diagramma Inserimento e conferma mail")

]
