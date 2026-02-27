#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "selezione_utente_tenant",
  system: CLOUD_SYS,
  title: "Selezione Utente Tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Utente associato al Tenant"
  ),
  postconds: (
    "Un Utente del Tenant è stato selezionato",
  ),
  trigger: "L’Attore vuole selezionare un Utente per visualizzarne o modificarne le proprietà",
  main-scen: (
    (descr: "L’Attore seleziona un Utente del Tenant dalla lista"),
  ),

  uml-descr: "Diagramma Selezione Utente del Tenant",
)
