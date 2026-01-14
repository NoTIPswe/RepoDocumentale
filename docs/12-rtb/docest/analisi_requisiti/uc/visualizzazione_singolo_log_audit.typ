#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_singolo_log_audit",
  system: CLOUD_SYS,
  title: "Visualizzazione singola entry log di Audit del Tenant",
  level: 2,
  prim-actors: (CA.tenant-adm, CA.sys-adm),
  preconds: (
    "L’attore sta visualizzando i log di Audit del Tenant",
  ),
  postconds: (
    "L’Attore visualizza correttamente i dati di una singola entry del log di audit",
  ),
  trigger: "L’attore desidera visualizzare i log di Audit del Tenant",
  main-scen: (
    (
      descr: "L’attore visualizza il timestamp relativo all’azione loggata",
      inc: "visualizzazione_timestamp_log_entry",
    ),
    (
      descr: "L’attore visualizza l’utente che ha eseguito l’operazione",
      inc: "visualizzazione_utente_log_entry",
    ),
    (
      descr: "L’attore visualizza una descrizione testuale dell’operazione eseguita",
      inc: "visualizzazione_operazione_log_entry",
    ),
    // bookmark
    // codice -> indica l'operazione tracciandola
  ),
)[#uml-schema("63.1", "Visualizzazione singola entry log di Audit del tenant")]
