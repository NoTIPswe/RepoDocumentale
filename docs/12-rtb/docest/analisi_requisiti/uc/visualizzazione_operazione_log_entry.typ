#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_operazione_log_entry",
  system: CLOUD_SYS,
  title: "Visualizzazione operazione log entry",
  level: 2,
  prim-actors: (CA.tenant-adm, CA.sys-adm),
  preconds: (
    "L’Attore sta visualizzando i log di Audit del Tenant",
  ),
  postconds: (
    "L’Attore visualizza correttamente l’azione relativa ad una singola entry del log di audit",
  ),
  trigger: "L’Attore desidera visualizzare una entry del log di Audit del Tenant",
  main-scen: (
    (descr: "L’Attore visualizza l’azione relativa alla entry del log di audit"),
  ),
)[#uml-schema("63.4", "Visualizzazione operazione log entry")]
