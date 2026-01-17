#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "recupero_password",
  system: CLOUD_SYS,
  title: "Recupero password",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "Esiste un account associato alla mail fornita",
    "Il sistema consente l’avvio della procedura di recupero password",
  ),
  postconds: (
    "La password è stata aggiornata e l'Utente può effettuare il login con le nuove credenziali",
  ),
  trigger: "Le credenziali di accesso sono state perse/dimenticate da parte di un Utente con un account registrato",
  main-scen: (
    (
      descr: "L'Attore primario inserisce la mail",
      inc: "ins_mail",
      ep: "UtenteInesistente",
    ),
    (
      descr: "L'Attore primario inserisce il codice monouso ricevuto alla mail registrata",
    ),
    (
      descr: "L'Attore primario imposta la nuova password",
      inc: "cambio_password",
    ),
  ),
  alt-scen: (
    (
      ep: "UtenteInesistente",
      cond: "L'Attore primario inserisce una mail non registrata",
      uc: "err_account_inesistente",
    ),
  ),
)[
  #uml-schema("7", "Recupero Password")

]
