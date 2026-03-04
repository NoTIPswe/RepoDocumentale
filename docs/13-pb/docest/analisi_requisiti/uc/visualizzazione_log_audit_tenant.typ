#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_log_audit_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione log di Audit del Tenant",
  level: 1,
  prim-actors: (CA.tenant-adm, CA.sys-adm),
  preconds: (
    "Il Sistema mostra all'Attore primario la sezione dedicata ai log di Audit",
    "L'attore appartiene ad un tenant o ne ha selezionato uno",
  ),
  postconds: (
    "L’Attore visualizza correttamente i dati di suo interesse",
  ),
  trigger: "L’Attore desidera visualizzare i log di Audit del Tenant",
  main-scen: (
    (
      descr: "L’Attore visualizza i log di Audit del Tenant selezionato",
      inc: "visualizzazione_singolo_log_audit",
    ),
  ),

  uml-descr: "Diagramma Visualizzazione log di Audit Tenant",
)
