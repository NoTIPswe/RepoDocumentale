#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "conferma_eliminazione_tenant",
  system: CLOUD_SYS,
  title: "Conferma eliminazione Tenant",
  level: 2,
  prim-actors: CA.sys-adm,
  preconds: (
    "(Ereditate da UC. Eliminazione Tenant)",
    "Il Sistema riceve la conferma dell’operazione di eliminazione del Tenant dall’Attore primario",
  ),
  postconds: (
    "La richiesta di eliminazione del Tenant è stata confermata con successo",
  ),
  trigger: "L'Attore vuole eliminare un Tenant di interesse",
  main-scen: (
    (descr: "L’Attore viene informato delle conseguenze dell’eliminazione del Tenant selezionato"),
    (descr: "L’Attore conferma il desiderio di eliminare il Tenant in analisi"),
  ),
)
