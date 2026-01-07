#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, CSA

#uc(
  id: "err_dati_autenticazione_invalidi",
  system: CLOUD_SYS,
  title: "Dati di autenticazione non validi",
  level: 1,
  prim-actors: CA.api-client,
  sec-actors: CSA.auth-server, // bokmark - solo se usiamo auth server esterno
  preconds: (
    "L’attore primario ha fornito dei dati non validi per l’autenticazione",
  ),
  postconds: (
    "L’autenticazione non va a buon fine e all’attore primario viene notificato un errore di autenticazione",
  ),
  trigger: "I dati per l’autenticazione forniti dall’attore non sono validi",
  main-scen: (
    (descr: "L’Auth Server risponde al sistema con un errore di autenticazione"),
    (descr: "L’attore primario riceve un errore di autenticazione dal sistema"),
  ),
)