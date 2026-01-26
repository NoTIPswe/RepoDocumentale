#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "esportazione_log_audit_tenant",
  system: CLOUD_SYS,
  title: "Esportazione log di audit del Tenant",
  level: 1,
  prim-actors: (CA.tenant-adm, CA.sys-adm),
  preconds: (
    "Il sistema mostra all'Attore primario i log di audit del Tenant",
  ),
  postconds: (
    "L’Attore esporta correttamente i dati di suo interesse",
  ),
  trigger: "L'Attore vuole esportare dei log di audit di un Tenant",
  main-scen: (
    (
      descr: "L’Attore seleziona l’intervallo temporale (data e ora) degli audit da esportare",
      inc: "selezione_intervallo_temporale",
    ),
    (descr: "L’Attore conferma l’esportazione per avviare la procedura"),
    (
      descr: "L’Attore scarica i log di Audit non appena sono pronti",
      inc: "download_log_audit_esportati",
    ),
  ),
)[#uml-schema("65", "Esportazione log di Audit del Tenant")]
