#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "modifica_mail_account",
  system: CLOUD_SYS,
  title: "Modifica mail account",
  level: 1,
  prim-actors: (CA.authd-usr,),
  preconds: (
    "Il limite di cambi mail dell'account in analisi in un dato periodo di tempo non è stato superato",
  ),
  postconds: (
    "L’Attore ha correttamente modificato la mail del proprio account",
  ),
  trigger: "Necessità e/o volontà da parte dell’Utente di cambiare la mail del proprio account",
  main-scen: (
    (
      descr: "L’Attore inserisce la nuova mail",
      inc: "impostazione_mail",
    ),
    (
      descr: "L’Attore conferma l’operazione di cambio mail",
    ),
  ),

  uml-descr: "Diagramma Modifica mail account",
)
