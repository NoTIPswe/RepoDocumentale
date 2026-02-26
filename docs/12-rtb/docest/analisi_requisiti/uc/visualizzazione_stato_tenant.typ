#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_stato_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione stato Tenant",
  level: 1,
  specialized-by: ("vis_stato_attivo", "vis_stato_sospeso"),
  prim-actors: CA.sys-adm,
  preconds: (
    "Il Sistema mostra all’Attore primario la lista dei Tenant",
  ),
  postconds: (
    "L’Attore visualizza lo stato operativo del Tenant",
  ),
  trigger: "",
  main-scen: (
    (descr: "L’Attore visualizza lo stato corrente del Tenant"),
  ),

  uml-descr: "Diagramma Visualizzazione stato del Tenant",
)
