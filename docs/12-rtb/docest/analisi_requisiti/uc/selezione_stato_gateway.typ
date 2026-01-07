#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "selezione_stato_gateway",
  system: CLOUD_SYS,
  title: "Selezione stato del Gateway",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "I Gateway selezionati appartengono al Tenant",
    "I Gateway sono raggiungibili",
    "L’attore sta modificando lo stato di alcuni Gateway",
  ),
  postconds: (
    "Lo stato selezionato viene applicato ai Gateway in fase di modifica",
  ),
  trigger: "L’attore primario vuole abilitare o disabilitare un Gateway per gestire l’attività del sistema",
  main-scen: (
    (descr: "L’attore seleziona lo stato desiderato (abilitato o disabilitato) per i Gateway"),
  ),
)
