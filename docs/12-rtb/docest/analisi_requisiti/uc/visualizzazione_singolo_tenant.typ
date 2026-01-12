#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_singolo_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione singolo Tenant",
  level: 2,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’attore primario si trova nella sezione dedicata alla visualizzazione dei Tenant",
    "L’attore primario sta visualizzando la lista dei Tenant",
  ),
  postconds: (
    "L’attore primario visualizza i dati essenziali relativi ad un singolo Tenant nella lista",
  ),
  trigger: "L’attore primario vuole visualizzare un Tenant all'interno della lista",
  main-scen: (
    (
      descr: "L’attore visualizza il nome del Tenant",
      inc: "visualizzazione_nome_tenant",
    ),
    (
      descr: "L’attore visualizza lo stato del Tenant",
      inc: "visualizzazione_stato_tenant",
    ),
    (
      descr: "L’attore visualizza l’identificativo del Tenant",
      inc: "visualizzazione_id_tenant",
    ),
  ),
)[#uml-schema("78.1", "Visualizzazione singolo Tenant")]
