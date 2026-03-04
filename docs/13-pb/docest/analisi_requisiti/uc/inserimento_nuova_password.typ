#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "inserimento_nuova_password",
  system: CLOUD_SYS,
  title: "Inserimento nuova password",
  level: 2,
  prim-actors: (CA.non-authd-usr, CA.authd-usr),
  preconds: (
    "Il Sistema richiede all'Attore di definire una password",
  ),
  postconds: (
    "La password inserita risulta sintatticamente valida e rispetta i criteri di sicurezza",
  ),
  trigger: "L'Attore compila il campo relativo alla nuova password",
  main-scen: (
    (
      descr: "L'Attore inserisce la stringa della password",
      ep: "PasswordInvalida",
    ),
  ),
  alt-scen: (
    (
      ep: "PasswordInvalida",
      cond: "La password inserita non rispetta le policy di sicurezza del Sistema (es. lunghezza minima, presenza di caratteri speciali)",
      uc: "err_password_invalida",
    ),
  ),
)
