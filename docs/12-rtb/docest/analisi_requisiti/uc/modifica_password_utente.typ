#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "modifica_password_utente",
  system: CLOUD_SYS,
  title: "Modifica password Utente del Tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’utente di cui si vuole modificare la password non è Owner del Tenant",
  ),
  postconds: (
    "La password dell’utente selezionato è stata aggiornata",
  ),
  trigger: "L’attore principale vuole modificare la password di un singolo utente del tenant",
  main-scen: (
    (
      descr: "L’attore seleziona un utente del tenant",
      inc: "selezione_utente_tenant",
    ),
    (
      descr: "L’attore inserisce e conferma la nuova password",
      inc: "inserimento_conferma_password",
    ),
    (descr: "L’attore salva le modifiche apportate"),
  ),
)[#uml-schema("56", "Modifica password Utente del Tenant")]
