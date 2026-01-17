#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "modifica_stato_gateway",
  system: CLOUD_SYS,
  title: "Modifica stato del Gateway",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il Gateway appartiene al Tenant",
    "Il Gateway si trova in uno stato attivo/disabilitato",
  ),
  postconds: (
    "Il Gateway si trova nello stato impostato; se disabilitato, non invierà più dati al cloud",
  ),
  trigger: "L’Attore vuole abilitare/disabilitare lo stato di un Gateway",
  main-scen: (
    (
      descr: "L’Attore seleziona un Gateway appartenenti al Tenant",
      inc: "selezione_gateway",
    ),
    (
      descr: "L’Attore imposta lo stato desiderato (abilitato o disabilitato) per il Gateway",
      inc: "selezione_stato_gateway",
    ),
    (descr: "L’Attore conferma l’operazione idempotente di cambio di stato"),
  ),
)[#uml-schema("41", "Modifica stato del Gateway")]
