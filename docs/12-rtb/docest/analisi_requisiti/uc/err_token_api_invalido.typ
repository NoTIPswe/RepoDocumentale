#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "err_token_api_invalido",
  system: CLOUD_SYS,
  title: "Token autenticazione API invalido",
  level: 1,
  prim-actors: CA.api-client,
  preconds: (
    "L’attore dispone di un token di autenticazione",
    "Il token di autenticazione è stato valutato invalido o scaduto dal sistema",
  ),
  postconds: (
    "L’attore non può procedere con la richiesta",
    "L’attore deve ripetere l’autenticazione prima di effettuare una nuova richiesta",
  ),
  trigger: "Il token fornito dall’attore primario risulta essere scaduto o non valido",
  main-scen: (
    (descr: "L’attore riceve una risposta di errore di autenticazione"),
  ),
)
