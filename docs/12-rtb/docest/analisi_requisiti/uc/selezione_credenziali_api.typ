#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "selezione_credenziali_api",
  system: CLOUD_SYS,
  title: "Selezione credenziali client API",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il sistema mette a disposizione all'Attore primario la lista delle credenziali dell'API",
  ),
  postconds: (
    "Delle credenziali API sono state correttamente selezionate",
  ),
  trigger: "",
  main-scen: (
    (descr: "L’Attore seleziona una entry di credenziali API dalla lista"),
  ),
)[#uml-schema("61.1", "Selezione credenziali API")]
