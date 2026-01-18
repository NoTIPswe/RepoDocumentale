#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "modifica_mail_account",
  system: CLOUD_SYS,
  title: "Modifica Mail Account",
  level: 1,
  prim-actors: (CA.authd-usr,),
  preconds: (
    "Il limite di cambi mail dell'account in analisi in un dato periodo di tempo non è stato superato",
  ),
  postconds: (
    "L’Attore primario ha correttamente modificato la mail del proprio account",
  ),
  trigger: "Necessità e/o volontà da parte dell’Utente di cambiare la mail del proprio account",
  main-scen: (
    (
      descr: "L’Attore primario inserisce la nuova mail",
      inc: "inserimento_conferma_mail",
    ),
    (
      descr: "L’Attore primario conferma l’operazione di cambio mail",
    ),
  ),
)[
  #uml-schema("12", "Modifica Mail Account")

]
