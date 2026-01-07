#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "modifica_password_account",
  system: CLOUD_SYS,
  title: "Modifica Password Account",
  level: 1,
  prim-actors: (CA.authd-usr,),
  preconds: (
    "L’attore primario rispetta il limite di cambi password in un dato periodo",
  ),
  postconds: (
    "La password dell’account è stata aggiornata",
  ),
  trigger: "Necessità e/o volontà da parte dell’attore primario di modificare la password dell’account",
  main-scen: (
    (
      descr: "L’attore primario inserisce la nuova password",
      inc: "inserimento_conferma_password",
    ),
    (
      descr: "L’attore primario conferma l’operazione di cambio password",
    ),
  ),
)
