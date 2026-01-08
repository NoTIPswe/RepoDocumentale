#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "esportazione_log_audit_tenant",
  system: CLOUD_SYS,
  title: "Esportazione log di Audit del Tenant",
  level: 1,
  prim-actors: (CA.tenant-adm, CA.sys-adm),
  preconds: (
    "L’attore si trova nella sezione dedicata alla visualizzazione dei log",
  ),
  postconds: (
    "L’Attore esporta correttamente i dati di suo interesse",
  ),
  trigger: "L’attore desidera esportare i log per fare Audit del Tenant",
  main-scen: (
    (
      descr: "L’attore seleziona l’intervallo temporale (data e ora) degli audit da esportare",
      inc: "selezione_intervallo_temporale",
    ),
    (descr: "L’attore conferma l’esportazione per avviare la procedura"),
    (
      descr: "L’attore scarica i log di Audit non appena sono pronti",
      inc: "download_log_audit_esportati",
    ),
  ),
)
