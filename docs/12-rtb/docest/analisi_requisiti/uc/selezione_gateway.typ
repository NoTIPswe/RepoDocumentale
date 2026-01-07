#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "selezione_gateway",
  system: CLOUD_SYS,
  title: "Selezione Gateway",
  level: 1,
  prim-actors: (CA.tenant-adm, CA.sys-adm),
  preconds: (
    "L’attore visualizza l’elenco dei Gateway del proprio Tenant",
  ),
  postconds: (
    "I Gateway sono stati selezionati correttamente",
  ),
  trigger: "L’attore vuole selezionare dei Gateway per effettuare un’operazione",
  main-scen: (
    (descr: "L’Attore seleziona uno o più Gateway tramite il loro identificativo"),
  ),
)