#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_utente_log_entry",
  system: CLOUD_SYS,
  title: "Visualizzazione Utente log entry",
  level: 2,
  prim-actors: (CA.tenant-adm, CA.sys-adm),
  preconds: (
    "L’Attore sta visualizzando i log di Audit del Tenant",
  ),
  postconds: (
    "L’Attore visualizza correttamente l’Utente relativo ad una singola entry del log di audit",
  ),
  trigger: "L’Attore desidera visualizzare una entry del log di Audit del Tenant",
  main-scen: (
    (descr: "L’Attore visualizza l’Utente relativo alla entry del log di audit"),
  ),
)[#uml-schema("63.3", "Visualizzazione Utente log entry")]
