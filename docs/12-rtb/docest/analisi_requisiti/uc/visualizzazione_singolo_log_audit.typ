#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_singolo_log_audit",
  system: CLOUD_SYS,
  title: "Visualizzazione singola entry log di Audit del Tenant",
  level: 2,
  prim-actors: (CA.tenant-adm, CA.sys-adm),
  preconds: (
    "Il Sistema mostra all'Attore primario il singolo entry log di Audit del Tenant",
  ),
  postconds: (
    "L’Attore visualizza correttamente i dati di una singola entry del log di Audit",
  ),
  trigger: "L'Attore vuole visualizzare i dati di una singola entry del log di Audit",
  main-scen: (
    (
      descr: "L’Attore visualizza il timestamp relativo all’azione loggata",
      inc: "visualizzazione_timestamp_log_entry",
    ),
    (
      descr: "L’Attore visualizza l’Utente che ha eseguito l’operazione",
      inc: "visualizzazione_utente_log_entry",
    ),
    (
      descr: "L’Attore visualizza una descrizione testuale dell’operazione eseguita",
      inc: "visualizzazione_operazione_log_entry",
    ),
    // bookmark
    // codice -> indica l'operazione tracciandola
  ),

  uml-descr: "Diagramma Visualizzazione singola entry log di Audit del tenant",
)
