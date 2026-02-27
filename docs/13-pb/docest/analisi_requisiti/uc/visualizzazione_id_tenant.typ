#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_id_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione ID Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il Sistema mostra all’Attore primario la lista dei Tenant",
  ),
  postconds: (
    "L’Attore visualizza l’identificativo univoco del Tenant",
  ),
  trigger: "",
  main-scen: (
    (descr: "L’Attore visualizza l’ID univoco associato al Tenant"),
  ),

  uml-descr: "Diagramma Visualizzazione ID Tenant",
)
