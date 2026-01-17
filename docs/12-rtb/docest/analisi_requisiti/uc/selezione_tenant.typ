#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "selezione_tenant",
  system: CLOUD_SYS,
  title: "Selezione Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’Attore visualizza la lista dei tenant",
  ),
  postconds: (
    "Il Tenant è stato selezionato correttamente",
  ),
  trigger: "L’Attore vuole selezionare un tenant",
  main-scen: (
    (descr: "L’Attore seleziona un tenant dalla lista"),
  ),
)[#uml-schema("87", "Selezione Tenant")]
