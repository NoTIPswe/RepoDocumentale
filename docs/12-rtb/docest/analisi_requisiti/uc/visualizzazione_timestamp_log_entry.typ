#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_timestamp_log_entry",
  system: CLOUD_SYS,
  title: "Visualizzazione timestamp log entry",
  level: 2,
  prim-actors: (CA.tenant-adm, CA.sys-adm),
  preconds: (
    "Il sistema mostra all'Attore primario i log di Audit del Tenant",
  ),
  postconds: (
    "L’Attore visualizza correttamente il timestamp di una singola entry del log di audit",
  ),
  trigger: "L'Attore vuole visualizzare i dati di una singola entry del log di audit",
  main-scen: (
    (descr: "L’Attore visualizza il timestamp relativo alla entry del log di audit"),
  ),
)
