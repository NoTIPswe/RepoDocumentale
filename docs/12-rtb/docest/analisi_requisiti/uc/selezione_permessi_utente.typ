#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "selezione_permessi_utente",
  system: CLOUD_SYS,
  title: "Selezione permessi Utente",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Utente associato al Tenant",
    "Il Sistema sta attendendo le modifiche dell'Utente da parte dell'Attore",
  ),
  postconds: (
    "L’Attore assegna all’Utente un tipo di permesso",
  ),
  trigger: "L’Attore vuole assegnare un permesso ad un Utente",
  main-scen: (
    (descr: "L'Attore seleziona il tipo di permesso da concedere all’Utente (Amministratore Tenant o Utente Tenant)"),
  ),
)[#uml-schema("54", "Selezione permessi Utente")]
