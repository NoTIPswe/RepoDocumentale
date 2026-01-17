#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_log_audit_sysadmin",
  system: CLOUD_SYS,
  title: "Visualizzazione Log di Audit di un Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’Attore si trova nella sezione dedicata alla visualizzazione dei Tenant",
  ),
  postconds: (
    "I log di audit del Tenant selezionato sono visualizzati correttamente",
    "I log visualizzati non includono dati sensibili", // bookmark - da vedere se mantenere
  ),
  trigger: "Si desidera consultare i log di audit relativi ad un Tenant",
  main-scen: (
    (
      descr: "L’Attore seleziona un Tenant",
      inc: "selezione_tenant",
    ),
    (
      descr: "L’Attore visualizza i log di audit del Tenant selezionato",
      inc: "visualizzazione_singolo_log_audit",
    ),
  ),
)[#uml-schema("94", "Visualizzazione Log di Audit di un Tenant")]
