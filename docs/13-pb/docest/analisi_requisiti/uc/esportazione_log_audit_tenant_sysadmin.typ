#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "esportazione_log_audit_tenant_sysadmin",
  system: CLOUD_SYS,
  title: "Esportazione log di Audit di un Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il Sistema si trova nella sezione dedicata alla visualizzazione dei Tenant",
    "Esiste un Tenant che è stato selezionato",
    "L’Attore entra nella relativa sezione di Gestione",
  ),
  postconds: (
    "L’Attore scarica i log di Audit del tenant",
  ),
  trigger: "Si desidera consultare i log di Audit relativi ad un Tenant",
  main-scen: (
    (
      descr: "L’Attore seleziona un Tenant",
      inc: "selezione_tenant",
    ),
    (
      descr: "L’Attore esporta i log di Audit del Tenant selezionato",
      inc: "esportazione_log_audit_tenant",
    ),
  ),

  uml-descr: "Diagramma Esportazione log di Audit di un Tenant",
)
