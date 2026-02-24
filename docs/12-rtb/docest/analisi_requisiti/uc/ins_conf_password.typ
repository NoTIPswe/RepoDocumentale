#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "inserimento_conferma_password",
  system: CLOUD_SYS,
  title: "Inserimento e conferma password",
  level: 1,
  prim-actors: (CA.non-authd-usr, CA.authd-usr),
  preconds: (
    "Il Sistema richiede l’impostazione di una nuova password per l’account",
  ),
  postconds: (
    "Password validata e salvata",
  ),
  trigger: "L'Attore deve inserire e confermare una password",
  main-scen: (
    (
      descr: "L'Attore inserisce la password",
      ep: "PasswordInvalida",
    ),
    (
      descr: "L'Attore conferma la password",
      ep: "PasswordDiverse",
    ),
  ),
  alt-scen: (
    (
      ep: "PasswordInvalida",
      cond: "La password inserita non rispetta i criteri di sicurezza",
      uc: "err_password_invalida",
    ),
    (
      ep: "PasswordDiverse",
      cond: "Le password inserite non corrispondono",
      uc: "err_campi_diversi",
    ),
  ),

  uml-descr: "Diagramma Inserimento e conferma password",
)
