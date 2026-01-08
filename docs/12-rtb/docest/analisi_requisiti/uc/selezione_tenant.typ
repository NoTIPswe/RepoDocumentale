#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "selezione_tenant",
  system: CLOUD_SYS,
  title: "Selezione Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’attore visualizza la lista dei tenant",
  ),
  postconds: (
    "Il Tenant è stato selezionato correttamente",
  ),
  trigger: "L’attore vuole selezionare un tenant",
  main-scen: (
    (descr: "L’Attore seleziona un tenant dalla lista"),
  ),
)
