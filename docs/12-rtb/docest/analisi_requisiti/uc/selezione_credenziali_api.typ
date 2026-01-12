#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "selezione_credenziali_api",
  system: CLOUD_SYS,
  title: "Selezione credenziali client API",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’attore ha a disposizione la lista delle credenziali API",
  ),
  postconds: (
    "Delle credenziali API sono state correttamente selezionate",
  ),
  trigger: "L’attore desidera selezionare delle credenziali API",
  main-scen: (
    (descr: "L’attore seleziona una entry di credenziali API dalla lista"),
  ),
)[#uml-schema("61.1", "Selezione credenziali API")]
