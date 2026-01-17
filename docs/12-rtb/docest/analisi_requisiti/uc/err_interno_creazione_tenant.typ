#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "err_interno_creazione_tenant",
  system: CLOUD_SYS,
  title: "Errore Interno Creazione Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’Attore ha avviato la procedura di creazione Tenant",
    "Il sistema ha riscontrato un errore interno",
  ),
  postconds: (
    "Il Tenant non è stato creato",
    "L’Attore viene informato dell’errore",
  ),
  trigger: "Si verifica un errore interno durante la procedura di creazione del Tenant",
  main-scen: (
    (descr: "L’Attore visualizza i dettagli relativi all’errore verificatosi"),
  ),
)[#uml-schema("86", "Errore interno creazione Tenant")]
