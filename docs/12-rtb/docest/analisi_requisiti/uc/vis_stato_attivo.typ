#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "vis_stato_attivo",
  system: CLOUD_SYS,
  title: "Visualizzazione stato Tenant attivo",
  level: 2,
  gen-parent: "visualizzazione_stato_tenant",
  prim-actors: CA.sys-adm,
  preconds: (
    "Il Sistema mostra all’Attore primario la lista dei Tenant",
  ),
  postconds: (
    "L’Attore visualizza lo stato operativo del Tenant",
  ),
  main-scen: (
    (descr: "L’Attore visualizza lo stato corrente del Tenant come 'Attivo'"),
  ),
)
