#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_utente_log_entry",
  system: CLOUD_SYS,
  title: "Visualizzazione Utente log entry",
  level: 2,
  prim-actors: (CA.tenant-adm, CA.sys-adm),
  preconds: (
    "Il Sistema mostra all'Attore primario i log di Audit del Tenant",
  ),
  postconds: (
    "L’Attore visualizza correttamente l’Utente relativo ad una singola entry del log di Audit",
  ),
  trigger: "L'Attore vuole visualizzare i dati di una singola entry del log di Audit",
  main-scen: (
    (descr: "L’Attore visualizza l’Utente relativo alla entry del log di Audit"),
  ),
)
