#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "modifica_password_account",
  system: CLOUD_SYS,
  title: "Modifica Password Account",
  level: 1,
  prim-actors: (CA.authd-usr,),
  preconds: (
    "L’Attore primario rispetta il limite di cambi password in un dato periodo",
  ),
  postconds: (
    "La password dell’account è stata aggiornata",
  ),
  trigger: "Necessità e/o volontà da parte dell’Attore primario di modificare la password dell’account",
  main-scen: (
    (
      descr: "L’Attore primario inserisce la nuova password",
      inc: "inserimento_conferma_password",
    ),
    (
      descr: "L’Attore primario conferma l’operazione di cambio password",
    ),
  ),
)[
  #uml-schema("16", "Modifica Password Account")

]
