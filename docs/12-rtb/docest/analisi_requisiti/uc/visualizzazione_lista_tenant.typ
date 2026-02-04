#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_lista_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione lista Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il Sistema mostra all’Attore primario la lista dei Tenant",
  ),
  postconds: (
    "L’Attore primario visualizza l’elenco completo dei Tenant registrati nel Sistema",
  ),
  trigger: "",
  main-scen: (
    (
      descr: "L’Attore primario visualizza la lista dei Tenant del Sistema",
      inc: "visualizzazione_singolo_tenant",
    ),
  ),
)[#uml-schema("79", "Diagramma Visualizzazione lista Tenant")]
