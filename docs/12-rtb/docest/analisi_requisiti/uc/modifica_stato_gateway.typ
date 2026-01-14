#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "modifica_stato_gateway",
  system: CLOUD_SYS,
  title: "Modifica stato del Gateway",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "I Gateway sono raggiungibili",
  ),
  postconds: (
    "I gateway si trovano nello stato selezionato; se disabilitati, non invieranno più dati al cloud",
  ),
  trigger: "L’attore primario vuole abilitare o disabilitare dei gateway per gestire l’attività del sistema",
  main-scen: (
    (
      descr: "L’attore seleziona dei gateway appartenenti al Tenant",
      inc: "selezione_gateway",
    ),
    (
      descr: "L’attore imposta lo stato desiderato (abilitato o disabilitato) per i gateway",
      inc: "selezione_stato_gateway",
    ),
    (descr: "L’attore conferma l’operazione idempotente di cambio di stato"),
  ),
)[#uml-schema("41", "Modifica stato del Gateway")]
