#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "err_interno_creazione_tenant",
  system: CLOUD_SYS,
  title: "Errore interno creazione Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’Attore primario ha avviato la procedura di creazione Tenant",
    "Il Sistema ha riscontrato un errore interno",
  ),
  postconds: (
    "Il Tenant non è stato creato",
    "L’Attore viene informato dell’errore",
  ),
  trigger: "Si verifica un errore interno durante la procedura di creazione del Tenant",
  main-scen: (
    (descr: "L’Attore visualizza i dettagli relativi all’errore verificatosi"),
  ),
)
