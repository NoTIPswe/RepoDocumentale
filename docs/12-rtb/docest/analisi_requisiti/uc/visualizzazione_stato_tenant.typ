#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_stato_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione stato Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’Attore primario si trova nella sezione dedicata alla visualizzazione dei Tenant",
  ),
  postconds: (
    "L’Attore visualizza lo stato operativo del Tenant",
  ),
  trigger: "Necessità di verificare se il Tenant è operativo",
  main-scen: (
    (descr: "L’Attore visualizza lo stato corrente del Tenant"),
  ),
)[#uml-schema("81", "Visualizzazione stato del Tenant")]
