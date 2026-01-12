#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "eliminazione_credenziali_api",
  system: CLOUD_SYS,
  title: "Eliminazione credenziali API",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’attore si trova nella sezione di visualizzazione delle credenziali API",
  ),
  postconds: (
    "Le credenziali eliminate non sono più attive e valide all’interno del sistema",
  ),
  trigger: "L’attore desidera eliminare delle credenziali API non più utilizzate o desecretate",
  main-scen: (
    (
      descr: "L’attore seleziona un API token da eliminare",
      inc: "selezione_credenziali_api",
    ),
    (descr: "L’attore viene informato delle conseguenze dell’eliminazione"),
    (descr: "L’attore conferma la volontà di eliminazione del token"),
  ),
)[#uml-schema("61", "Eliminazione credenziali API")]
