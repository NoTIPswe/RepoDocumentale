#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "err_campi_diversi",
  system: CLOUD_SYS,
  title: "Errore - Campi non corrispondenti",
  level: 1,
  prim-actors: (CA.non-authd-usr, CA.authd-usr),
  preconds: (
    "L'attore primario ha inserito una stringa da validare attraverso ripetizione",
    "Stringa e ripetizione sono diversi",
  ),
  postconds: (
    "Viene richiesta una nuova compilazione del campo",
  ),
  trigger: "Inserimento di un valore diverso nel campo “conferma”",
  main-scen: (
    (descr: "L'attore primario viene notificato della differenza nelle due stringhe inserite"),
    (descr: "L'attore primario viene invitato a ricompilare"),
  ),
)[
  #uml-schema("10", "Campi non corrispondenti")

]
