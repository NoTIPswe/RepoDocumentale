#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "modifica_mail_utente",
  system: CLOUD_SYS,
  title: "Modifica mail Utente del Tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’utente di cui si vuole modificare la mail non è Owner del Tenant",
  ),
  postconds: (
    "La mail dell’utente selezionato è stata aggiornata",
  ),
  trigger: "L’attore principale vuole modificare la mail di un singolo utente del tenant",
  main-scen: (
    (
      descr: "L’attore seleziona un utente del tenant",
      inc: "selezione_utente_tenant",
    ),
    (
      descr: "L’attore inserisce la mail da assegnare all’utente",
      inc: "inserimento_conferma_mail",
    ),
    (descr: "L’attore salva le modifiche apportate"),
  ),
)