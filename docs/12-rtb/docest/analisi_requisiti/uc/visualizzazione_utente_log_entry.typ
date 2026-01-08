#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_utente_log_entry",
  system: CLOUD_SYS,
  title: "Visualizzazione utente log entry",
  level: 2,
  prim-actors: (CA.tenant-adm, CA.sys-adm),
  preconds: (
    "L’attore sta visualizzando i log di Audit del Tenant",
  ),
  postconds: (
    "L’Attore visualizza correttamente l’utente relativo ad una singola entry del log di audit",
  ),
  trigger: "L’attore desidera visualizzare una entry del log di Audit del Tenant",
  main-scen: (
    (descr: "L’attore visualizza l’utente relativo alla entry del log di audit"),
  ),
)
