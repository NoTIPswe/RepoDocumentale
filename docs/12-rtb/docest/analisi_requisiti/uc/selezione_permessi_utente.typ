#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "selezione_permessi_utente",
  system: CLOUD_SYS,
  title: "Selezione permessi Utente",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’Attore primario sta modificando un utente",
  ),
  postconds: (
    "L’Attore principale assegna all’Utente un tipo di permesso",
  ),
  trigger: "L’attore principale vuole assegnare un permesso ad un utente",
  main-scen: (
    (descr: "L'Attore seleziona il tipo di permesso da concedere all’utente (Amministratore Tenant o Utente Tenant)"),
  ),
)[#uml-schema("53", "Selezione permessi Utente")]
