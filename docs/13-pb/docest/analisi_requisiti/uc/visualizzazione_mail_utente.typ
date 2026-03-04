#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_mail_utente",
  system: CLOUD_SYS,
  title: "Visualizzazione mail dell’Utente",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Utente associato al Tenant",
    "L'indirizzo email dell'Utente è disponibile",
  ),
  postconds: (
    "L'Attore visualizza l'email dell'Utente",
  ),
  trigger: "L'Attore vuole visualizzare l'email associata all'Utente",
  main-scen: (
    (descr: "L’Attore visualizza l'indirizzo email primario utilizzato dall'Utente per la comunicazione e il login"),
  ),

  uml-descr: "Diagramma Visualizzazione mail dell'Utente",
)
