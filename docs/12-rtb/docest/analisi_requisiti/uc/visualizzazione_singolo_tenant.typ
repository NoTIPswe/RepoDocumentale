#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_singolo_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione singolo Tenant",
  level: 2,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il sistema mostra all’Attore primario la lista dei Tenant",
    "Il sistema mostra all’Attore primario un singolo Tenant",
  ),
  postconds: (
    "L’Attore primario visualizza i dati essenziali relativi ad un singolo Tenant nella lista",
  ),
  trigger: "",
  main-scen: (
    (
      descr: "L’Attore visualizza il nome del Tenant",
      inc: "visualizzazione_nome_tenant",
    ),
    (
      descr: "L’Attore visualizza lo stato del Tenant",
      inc: "visualizzazione_stato_tenant",
    ),
    (
      descr: "L’Attore visualizza l’identificativo del Tenant",
      inc: "visualizzazione_id_tenant",
    ),
  ),
)[#uml-schema("79.1", "Visualizzazione singolo Tenant")]
