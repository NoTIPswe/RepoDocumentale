#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_nome_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione nome Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’Attore si trova nella sezione dedicata alla visualizzazione dei Tenant",
  ),
  postconds: (
    "L’Attore visualizza il nome identificativo del Tenant",
  ),
  trigger: "Necessità da parte dell’Attore di riconoscere il Tenant tramite il suo nome",
  main-scen: (
    (descr: "L’Attore visualizza il nome del Tenant"),
  ),
)[#uml-schema("80", "Visualizzazione nome Tenant")]
