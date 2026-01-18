#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_nome_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione nome Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il sistema mostra all’Attore primario la lista dei Tenant",
  ),
  postconds: (
    "L’Attore visualizza il nome identificativo del Tenant",
  ),
  trigger: "",
  main-scen: (
    (descr: "L’Attore visualizza il nome del Tenant"),
  ),
)[#uml-schema("80", "Visualizzazione nome Tenant")]
