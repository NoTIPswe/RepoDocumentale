#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "modifica_permessi_utente",
  system: CLOUD_SYS,
  title: "Modifica permessi Utente del Tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Utente associato al Tenant",
    "Il Sistema sta attendendo le modifiche dell'Utente da parte dell'Attore",
  ),
  postconds: (
    "I permessi dell’Utente selezionato sono aggiornati",
  ),
  trigger: "L’Attore vuole modificare i permessi di un singolo Utente del Tenant",
  main-scen: (
    (
      descr: "L’Attore seleziona un Utente del Tenant",
      inc: "selezione_utente_tenant",
    ),
    (
      descr: "L’Attore seleziona i permessi da concedere all’Utente",
      inc: "selezione_permessi_utente",
    ),
    (descr: "L’Attore salva le modifiche apportate"),
  ),
)[#uml-schema("55", "Diagramma Modifica permessi Utente del Tenant")]
