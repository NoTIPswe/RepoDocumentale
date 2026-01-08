#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "conferma_eliminazione_tenant",
  system: CLOUD_SYS,
  title: "Conferma Eliminazione Tenant",
  level: 2,
  prim-actors: CA.sys-adm,
  preconds: (
    "(Ereditate da UC. Eliminazione Tenant)",
    "L’attore primario ha selezionato l’operazione di eliminazione del Tenant",
  ),
  postconds: (
    "La richiesta di eliminazione del Tenant è stata confermata con successo",
  ),
  trigger: "Si desidera confermare l’eliminazione di un Tenant",
  main-scen: (
    (descr: "L’attore primario viene informato delle conseguenze dell’eliminazione del Tenant selezionato"),
    (descr: "L’attore primario conferma il desiderio di eliminare il Tenant in analisi"),
  ),
)
