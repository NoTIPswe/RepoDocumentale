#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "esportazione_log_audit_tenant_sysadmin",
  system: CLOUD_SYS,
  title: "Esportazione Log di Audit di un Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il Sistema si trova nella sezione dedicata alla visualizzazione dei Tenant",
    "Esiste un Tenant che è stato selezionato",
    "L’Attore entra nella relativa sezione di Gestione",
  ),
  postconds: (
    "L’Attore scarica i log di audit del tenant",
  ),
  trigger: "Si desidera consultare i log di audit relativi ad un Tenant",
  main-scen: (
    (
      descr: "L’Attore seleziona un Tenant",
    ),
    (
      descr: "L’Attore esporta i log di audit del Tenant selezionato",
      inc: "esportazione_log_audit_tenant",
    ),
  ),
)[#uml-schema("95", "Esportazione Log di Audit di un Tenant")]
