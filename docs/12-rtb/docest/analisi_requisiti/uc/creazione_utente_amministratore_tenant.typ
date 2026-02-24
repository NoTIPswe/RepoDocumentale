#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "creazione_utente_amministratore_tenant",
  system: CLOUD_SYS,
  title: "Creazione Utente Amministratore Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "Esiste un Tenant attivo ed è stato selezionato",
  ),
  postconds: (
    "L’Utente Amministratore Tenant è stato creato correttamente",
    "L’Utente Amministratore Tenant risulta associato al Tenant selezionato",
  ),
  trigger: "Si desidera creare un Utente con ruolo di Amministratore Tenant per un Tenant",
  main-scen: (
    (descr: "L’Attore avvia l’operazione di creazione di un nuovo Utente Amministratore Tenant"),
    (
      descr: "L’Attore inserisce e conferma la mail dell’utente",
      inc: "inserimento_conferma_mail",
    ),
    (
      descr: "L’Attore inserisce e conferma la password dell’utente",
      inc: "inserimento_conferma_password",
    ),
    (descr: "L’Attore conferma l’operazione"),
    (descr: "L’Attore viene informato del successo dell’operazione"),
  ),

  uml-descr: "Diagramma Creazione Utente Amministratore Tenant",
)
