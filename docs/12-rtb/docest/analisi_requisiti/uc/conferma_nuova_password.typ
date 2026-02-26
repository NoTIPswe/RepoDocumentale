#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "conferma_nuova_password",
  system: CLOUD_SYS,
  title: "Conferma nuova password",
  level: 2,
  prim-actors: (CA.non-authd-usr, CA.authd-usr),
  preconds: (
    "L'Attore ha compilato il campo precedente con una password valida",
  ),
  postconds: (
    "La password inserita come conferma coincide con la password originale",
  ),
  trigger: "L'Attore compila il campo di conferma della password",
  main-scen: (
    (
      descr: "L'Attore inserisce nuovamente la stringa nel campo di conferma",
      ep: "PasswordDiverse",
    ),
  ),
  alt-scen: (
    (
      ep: "PasswordDiverse",
      cond: "La stringa inserita nel campo di conferma non corrisponde a quella inserita in precedenza",
      uc: "err_campi_diversi",
    ),
  ),
)
