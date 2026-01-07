#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "creazione_utente_amministratore_tenant",
  system: CLOUD_SYS,
  title: "Creazione utente Amministratore Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’attore ha selezionato un tenant attivo",
  ),
  postconds: (
    "L’Utente Amministratore Tenant è stato creato correttamente",
    "L’Utente Amministratore Tenant risulta associato al Tenant selezionato",
  ),
  trigger: "Si desidera creare un Utente con ruolo di Amministratore Tenant per un Tenant",
  main-scen: (
    (descr: "L’attore avvia l’operazione di creazione di un nuovo Utente Amministratore Tenant"),
    (
      descr: "L’attore inserisce e conferma la mail dell’utente",
      inc: "inserimento_conferma_mail",
    ),
    (
      descr: "L’attore inserisce e conferma la password dell’utente",
      inc: "inserimento_conferma_password",
    ),
    (descr: "L’attore conferma l’operazione"),
    (descr: "L’attore viene informato del successo dell’operazione"),
  ),
)