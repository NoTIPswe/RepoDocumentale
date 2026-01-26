#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_log_audit_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione log di Audit del Tenant",
  level: 1,
  prim-actors: (CA.tenant-adm, CA.sys-adm),
  preconds: (
    "Il sistema mostra all'Attore primario la sezione dedicata ai log di Audit",
  ),
  postconds: (
    "L’Attore visualizza correttamente i dati di suo interesse",
  ),
  trigger: "L’Attore desidera visualizzare i log di Audit del Tenant",
  main-scen: (
    (
      descr: "L’Attore visualizza l'elenco cronologico dei log di Audit in una tabella riepilogativa",
      inc: "visualizzazione_singolo_log_audit",
    ),
  ),
)[#uml-schema("64", "Visualizzazione log di audit tenant")]
