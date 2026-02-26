#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "selezione_tenant",
  system: CLOUD_SYS,
  title: "Selezione Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il Sistema mostra all’Attore primario la lista dei tenant",
  ),
  postconds: (
    "Il Tenant è stato selezionato correttamente",
  ),
  trigger: "",
  main-scen: (
    (descr: "L’Attore seleziona un tenant dalla lista"),
  ),

  uml-descr: "Diagramma Selezione Tenant",
)
