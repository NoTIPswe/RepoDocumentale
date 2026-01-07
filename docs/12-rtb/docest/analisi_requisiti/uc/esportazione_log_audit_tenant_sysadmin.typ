#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "esportazione_log_audit_tenant_sysadmin",
  system: CLOUD_SYS,
  title: "Esportazione Log di Audit di un Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’Attore si trova nella sezione dedicata alla visualizzazione dei Tenant",
    "L’attore seleziona un Tenant ed entra nella relativa sezione di Gestione",
  ),
  postconds: (
    "L’attore scarica i log di audit del tenant",
  ),
  trigger: "Si desidera consultare i log di audit relativi ad un Tenant",
  main-scen: (
    (
      descr: "L’attore seleziona un Tenant",
      inc: "selezione_tenant",
    ),
    (
      descr: "L’attore esporta i log di audit del Tenant selezionato",
      inc: "esportazione_log_audit_tenant",
    ),
  ),
)