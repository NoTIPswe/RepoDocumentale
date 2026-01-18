#import "../uc_lib.typ": CA, CLOUD_SYS, CSA, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "err_auth_server_non_disponibile",
  system: CLOUD_SYS,
  title: "Auth Server non disponibile",
  level: 1,
  prim-actors: CA.api-client,
  sec-actors: CSA.auth-server,
  preconds: (
    "Il sistema ha ricevuto la richiesta di autenticazione dall'Attore primario",
    "L’Auth Server non è raggiungibile o risponde con un errore interno",
  ),
  postconds: (
    "L’autenticazione non va a buon fine e all’Attore primario viene notificato un errore interno",
  ),
  trigger: "",
  main-scen: (
    (descr: "L’Auth Server non è raggiungibile o risponde al sistema con un errore interno"),
    (descr: "L’Attore primario riceve un messaggio di errore interno dal sistema"),
  ),
)[#uml-schema("71", "Errore auth server non disponibile")]
