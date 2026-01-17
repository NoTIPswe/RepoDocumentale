#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "modifica_mail_utente",
  system: CLOUD_SYS,
  title: "Modifica mail Utente del Tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Utente associato al Tenant",
    "Il Sistema sta attendendo le modifiche dell'Utente da parte dell'Attore",
  ),
  postconds: (
    "La mail dell’Utente selezionato è stata aggiornata",
  ),
  trigger: "L’Attore vuole modificare la mail di un singolo Utente del tenant",
  main-scen: (
    (
      descr: "L’Attore seleziona un Utente del tenant",
      inc: "selezione_utente_tenant",
    ),
    (
      descr: "L’Attore inserisce la mail da assegnare all’Utente",
      inc: "inserimento_conferma_mail",
    ),
    (descr: "L’Attore salva le modifiche apportate"),
  ),
)[#uml-schema("55", "Modifica mail Utente del Tenant")]
