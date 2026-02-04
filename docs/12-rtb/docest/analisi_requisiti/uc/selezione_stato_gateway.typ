#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "selezione_stato_gateway",
  system: CLOUD_SYS,
  title: "Selezione stato del Gateway",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il Gateway appartiene al Tenant",
    "Il Gateway si trova in uno stato attivo/disabilitato",
  ),
  postconds: (
    "Lo stato selezionato viene applicato al Gateway in fase di modifica",
  ),
  trigger: "L’Attore vuole abilitare/disabilitare un Gateway.",
  main-scen: (
    (descr: "L’Attore seleziona lo stato desiderato (abilitato o disabilitato) per il Gateway"),
  ),
)
