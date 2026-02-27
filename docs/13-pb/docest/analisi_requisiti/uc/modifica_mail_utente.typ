#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "modifica_mail_utente",
  system: CLOUD_SYS,
  title: "Modifica mail Utente del Tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Utente associato al Tenant",
    "L'Attore ha precedentemente selezionato l'Utente del Tenant su cui operare",
  ),
  postconds: (
    "La mail dell’Utente selezionato è stata aggiornata",
  ),
  trigger: "L’Attore vuole modificare la mail di un singolo Utente del Tenant",
  main-scen: (
    (
      descr: "L’Attore inserisce la mail da assegnare all’Utente",
      inc: "impostazione_mail",
    ),
    (descr: "L’Attore salva le modifiche apportate"),
  ),

  uml-descr: "Diagramma Modifica mail Utente del Tenant",
)
