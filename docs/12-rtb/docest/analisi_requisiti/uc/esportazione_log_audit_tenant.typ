#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "esportazione_log_audit_tenant",
  system: CLOUD_SYS,
  title: "Esportazione log di Audit del Tenant",
  level: 1,
  prim-actors: (CA.tenant-adm, CA.sys-adm),
  preconds: (
    "Esiste un Tenant che è stato selezionato",
    "Il Sistema mostra all'Attore primario i log di Audit del Tenant",
  ),
  postconds: (
    "L’Attore esporta correttamente i dati di suo interesse",
  ),
  trigger: "L'Attore vuole esportare dei log di Audit di un Tenant",
  main-scen: (
    (
      descr: "L’Attore seleziona un Tenant",
      inc: "selezione_tenant",
    ),
    (
      descr: "L’Attore seleziona l’intervallo temporale (data e ora) degli Audit da esportare",
      inc: "selezione_intervallo_temporale",
    ),
    (descr: "L’Attore conferma l’esportazione per avviare la procedura"),
    (
      descr: "L’Attore scarica i log di Audit non appena sono pronti",
      inc: "download_log_audit_esportati",
    ),
  ),

  uml-descr: "Diagramma Esportazione log di Audit del Tenant",
)
