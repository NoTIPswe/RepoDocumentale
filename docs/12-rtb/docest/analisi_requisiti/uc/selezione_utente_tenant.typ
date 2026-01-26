#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "selezione_utente_tenant",
  system: CLOUD_SYS,
  title: "Selezione Utente tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Utente associato al Tenant"
  ),
  postconds: (
    "Un Utente del tenant è stato selezionato",
  ),
  trigger: "L’Attore vuole selezionare un Utente per visualizzarne o modificarne le proprietà",
  main-scen: (
    (descr: "L’Attore seleziona un Utente del tenant dalla lista"),
  ),
)[#uml-schema("53", "Selezione Utente del Tenant")]
