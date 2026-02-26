#import "../uc_lib.typ": CA, CLOUD_SYS, CSA, SA, SIM_SYS, uc

#uc(
  id: "autenticazione_client_api",
  system: CLOUD_SYS,
  title: "Autenticazione del client API",
  level: 1,
  prim-actors: CA.api-client,
  sec-actors: CSA.auth-server, // bookmark - se usiamo auth server esterno
  preconds: (
    "Il Client API è registrato e possiede credenziali valide",
  ),
  postconds: (
    "L’Attore principale possiede un token valido per effettuare chiamate successive",
  ),
  trigger: "",
  main-scen: (
    (
      descr: "L’Attore primario contatta l’endpoint del Sistema dedicato all’autenticazione allegando le credenziali utilizzando un protocollo sicuro e criptato",
    ),
    (
      descr: "L’Auth Server riceve la richiesta inoltrata dal Sistema", // bookmark - se usiamo auth server esterno
      ep: "ErroreAuthServer",
    ),
    (descr: "L’Auth Server risponde al Sistema con un token valido"),
    (descr: "L’Attore primario riceve il token valido dal Sistema"),
  ),
  alt-scen: (
    (
      // bookmark - se usiamo auth server esterno
      ep: "ErroreAuthServer",
      cond: "ClientID e/o ClientSecret forniti non sono validi",
      uc: "err_dati_autenticazione_invalidi",
    ),
    (
      // bookmark - se usiamo auth server esterno
      ep: "ErroreAuthServer",
      cond: "L’Auth Server esterno non è raggiungibile",
      uc: "err_auth_server_non_disponibile",
    ),
  ),

  uml-descr: "Diagramma Autenticazione del client API",
)
