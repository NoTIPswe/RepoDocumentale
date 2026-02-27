#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "download_log_audit_esportati",
  system: CLOUD_SYS,
  title: "Download log Audit esportati",
  level: 2,
  prim-actors: (CA.tenant-adm, CA.sys-adm),
  preconds: (
    "Il Sistema mostra all'Attore primario i log di Audit del Tenant",
    "Il Sistema ha prodotto il file scaricabile contenente i log di Audit esportati",
  ),
  postconds: (
    "L’Attore scarica i log sul proprio dispositivo",
  ),
  trigger: "L'Attore vuole esportare dei log di Audit di un Tenant",
  main-scen: (
    (descr: "L’Attore viene notificato della disponibilità del log esportato"),
    (descr: "L’Attore scarica il file di log sul proprio dispositivo"),
  ),
)
