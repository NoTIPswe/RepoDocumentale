#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "eliminazione_credenziali_api",
  system: CLOUD_SYS,
  title: "Eliminazione credenziali API",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il sistema mostra le credenziali dell'API all'Attore primario",
  ),
  postconds: (
    "Le credenziali eliminate non sono più attive e valide all’interno del sistema",
  ),
  trigger: "",
  main-scen: (
    (
      descr: "L’Attore seleziona un API token da eliminare",
      inc: "selezione_credenziali_api",
    ),
    (descr: "L’Attore viene informato delle conseguenze dell’eliminazione"),
    (descr: "L’Attore conferma la volontà di eliminazione del token"),
  ),
)[#uml-schema("61", "Eliminazione credenziali API")]
