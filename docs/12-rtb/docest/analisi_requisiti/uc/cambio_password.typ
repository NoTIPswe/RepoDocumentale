#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "cambio_password",
  system: CLOUD_SYS,
  title: "Cambio Password",
  level: 2,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "L'attore primario ha inserito un codice monouso valido e non ancora scaduto",
  ),
  postconds: (
    "La nuova password è salvata nel database",
  ),
  trigger: "Accesso alla pagina di impostazione tramite token di sicurezza",
  main-scen: (
    (
      descr: "L'attore primario inserisce la nuova password",
      inc: "inserimento_conferma_password",
    ),
  ),
)[
  #uml-schema("7.1", "Cambio Password")
]
