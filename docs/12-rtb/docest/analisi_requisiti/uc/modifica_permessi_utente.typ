#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "modifica_permessi_utente",
  system: CLOUD_SYS,
  title: "Modifica Permessi Utente del Tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’utente di cui si vogliono modificare i permessi non è Owner del Tenant",
  ),
  postconds: (
    "I permessi dell’utente selezionato sono aggiornati",
  ),
  trigger: "L’attore principale vuole modificare i permessi di un singolo utente del tenant",
  main-scen: (
    (
      descr: "L’attore seleziona un utente del tenant",
      inc: "selezione_utente_tenant",
    ),
    (
      descr: "L’attore seleziona i permessi da concedere all’utente",
      inc: "selezione_permessi_utente",
    ),
    (descr: "L’attore salva le modifiche apportate"),
  ),
)