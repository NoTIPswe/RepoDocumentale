#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "ins_conf_password",
  system: CLOUD_SYS,
  title: "Inserimento e Conferma Password",
  level: 1,
  prim-actors: (CA.non-authd-usr, CA.authd-usr),
  preconds: (
    "L'attore primario deve inserire e confermare una password",
  ),
  postconds: (
    "Password validata e salvata",
  ),
  trigger: "L'attore primario deve inserire e confermare una password",
  main-scen: (
    (
      descr: "L'attore primario inserisce la password",
      ep: "PasswordInvalida",
    ),
    (
      descr: "L'attore primario conferma la password",
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
)
