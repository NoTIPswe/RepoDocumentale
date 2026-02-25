#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_log_audit_sysadmin",
  system: CLOUD_SYS,
  title: "Visualizzazione log di Audit di un Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il Sistema si trova nella sezione dedicata alla visualizzazione dei Tenant",
    "L'Attore ha precedentemente selezionato il Tenant di cui visualizzare i log di Audit",
  ),
  postconds: (
    "I log di Audit del Tenant selezionato sono visualizzati correttamente",
  ),
  trigger: "Si desidera consultare i log di Audit relativi ad un Tenant",
  main-scen: (
    (
      descr: "L’Attore visualizza i log di Audit del Tenant selezionato",
      inc: "visualizzazione_singolo_log_audit",
    ),
  ),

  uml-descr: "Diagramma Visualizzazione log di Audit di un Tenant",
)
