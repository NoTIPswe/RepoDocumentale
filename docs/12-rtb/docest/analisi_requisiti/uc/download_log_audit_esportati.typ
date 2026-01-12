#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "download_log_audit_esportati",
  system: CLOUD_SYS,
  title: "Download log audit esportati",
  level: 2,
  prim-actors: (CA.tenant-adm, CA.sys-adm),
  preconds: (
    "L’attore si trova nella sezione dedicata alla visualizzazione dei log",
    "Il sistema ha prodotto il file scaricabile contenente i log di audit esportati",
  ),
  postconds: (
    "L’Attore scarica i log sul proprio dispositivo",
  ),
  trigger: "L’attore desidera esportare i log per fare Audit del Tenant",
  main-scen: (
    (descr: "L’attore viene notificato della disponibilità del log esportato"),
    (descr: "L’attore scarica il file di log sul proprio dispositivo"),
  ),
)[#uml-schema("64.2", "Download log audit esportati")]
