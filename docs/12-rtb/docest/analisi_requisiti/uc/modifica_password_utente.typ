#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "modifica_password_utente",
  system: CLOUD_SYS,
  title: "Modifica password Utente del Tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Utente associato al Tenant",
    "L'Attore ha precedentemente selezionato l'Utente del Tenant su cui operare",
  ),
  postconds: (
    "La password dell’Utente selezionato è stata aggiornata",
  ),
  trigger: "L’Attore vuole modificare la password di un singolo Utente del Tenant",
  main-scen: (
    (
      descr: "L’Attore inserisce e conferma la nuova password",
      inc: "impostazione_password",
    ),
    (descr: "L’Attore salva le modifiche apportate"),
  ),

  uml-descr: "Diagramma Modifica password Utente del Tenant",
)
