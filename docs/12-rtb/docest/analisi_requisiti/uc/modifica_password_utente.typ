#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "modifica_password_utente",
  system: CLOUD_SYS,
  title: "Modifica password Utente del Tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Utente associato al Tenant",
    "Il Sistema sta attendendo le modifiche dell'Utente da parte dell'Attore",
  ),
  postconds: (
    "La password dell’Utente selezionato è stata aggiornata",
  ),
  trigger: "L’Attore vuole modificare la password di un singolo Utente del Tenant",
  main-scen: (
    (
      descr: "L’Attore seleziona un Utente del Tenant",
      inc: "selezione_utente_tenant",
    ),
    (
      descr: "L’Attore inserisce e conferma la nuova password",
      inc: "inserimento_conferma_password",
    ),
    (descr: "L’Attore salva le modifiche apportate"),
  ),
)[#uml-schema("57", "Diagramma Modifica password Utente del Tenant")]
