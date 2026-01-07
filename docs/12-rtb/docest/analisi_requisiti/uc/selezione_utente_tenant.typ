#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "selezione_utente_tenant",
  system: CLOUD_SYS,
  title: "Selezione utente tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il Tenant possiede degli utenti",
  ),
  postconds: (
    "Un utente del tenant è stato selezionato",
  ),
  trigger: "L’attore principale vuole selezionare un utente per visualizzarne o modificarne le proprietà",
  main-scen: (
    (descr: "L’attore seleziona un utente del tenant dalla lista"),
  ),
)