#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "modifica_mail_account",
  system: CLOUD_SYS,
  title: "Modifica Mail Account",
  level: 1,
  prim-actors: (CA.authd-usr,),
  preconds: (
    "L’attore primario rispetta il limite di cambi mail in un dato periodo",
  ),
  postconds: (
    "L’attore primario ha correttamente modificato la mail del proprio account",
  ),
  trigger: "Necessità e/o volontà da parte dell’utente di cambiare la mail del proprio account",
  main-scen: (
    (
      descr: "L’attore primario inserisce la nuova mail",
      inc: "inserimento_conferma_mail",
    ),
    (
      descr: "L’attore primario conferma l’operazione di cambio mail",
    ),
  ),
)[
  #uml-schema("12", "Modifica Mail Account")

]
