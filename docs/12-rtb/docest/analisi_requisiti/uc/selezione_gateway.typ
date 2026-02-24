#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "selezione_gateway",
  system: CLOUD_SYS,
  title: "Selezione Gateway",
  level: 1,
  prim-actors: (CA.tenant-adm, CA.sys-adm),
  preconds: (
    "Il Sistema mostra all’Attore primario l’elenco dei Gateway del proprio Tenant",
  ),
  postconds: (
    "I Gateway sono stati selezionati correttamente",
  ),
  trigger: "L'Attore vuole selezionare uno o più Gateway",
  main-scen: (
    (descr: "L’Attore seleziona uno o più Gateway tramite il loro identificativo"),
  ),

  uml-descr: "Diagramma selezione Gateway",
)
