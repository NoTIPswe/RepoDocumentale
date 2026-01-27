#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "err_campi_diversi",
  system: CLOUD_SYS,
  title: "Errore campi non corrispondenti",
  level: 1,
  prim-actors: (CA.non-authd-usr, CA.authd-usr),
  preconds: (
    "I valori in input da validare attraverso ripetizione non coincidono",
  ),
  postconds: (
    "Viene richiesta una nuova compilazione del campo",
  ),
  trigger: "Inserimento di un valore diverso nel campo “conferma”",
  main-scen: (
    (descr: "L'Attore primario viene notificato della differenza nelle due stringhe inserite"),
    (descr: "L'Attore primario viene invitato a ricompilare"),
  ),
)[
  #uml-schema("10", "Diagramma Errore campi non corrispondenti")

]
