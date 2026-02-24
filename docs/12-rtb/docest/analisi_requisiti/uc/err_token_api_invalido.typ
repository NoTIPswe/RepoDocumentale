#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "err_token_api_invalido",
  system: CLOUD_SYS,
  title: "Errore token autenticazione API invalido",
  level: 1,
  prim-actors: CA.api-client,
  preconds: (
    "L’Attore primario dispone di un token di autenticazione",
    "Il Sistema ha valutato il token di autenticazione è stato valutato invalido o scaduto",
  ),
  postconds: (
    "L’Attore non può procedere con la richiesta",
    "L’Attore deve ripetere l’autenticazione prima di effettuare una nuova richiesta",
  ),
  trigger: "Il token fornito dall’Attore primario risulta essere scaduto o non valido",
  main-scen: (
    (descr: "L’Attore riceve una risposta di errore di autenticazione"),
  ),

  uml-descr: "Diagramma Errore token di autenticazione API invalido",
)
