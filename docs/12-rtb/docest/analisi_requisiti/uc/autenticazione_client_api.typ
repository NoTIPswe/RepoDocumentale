#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, CSA

#uc(
  id: "autenticazione_client_api",
  system: CLOUD_SYS,
  title: "Autenticazione del client API",
  level: 1,
  prim-actors: CA.api-client,
  sec-actors: CSA.auth-server,  // bookmark - se usiamo auth server esterno 
  preconds: (
    "Il Client API è registrato e possiede credenziali valide",
  ),
  postconds: (
    "L’attore principale possiede un token valido per effettuare chiamate successive",
  ),
  trigger: "L’attore primario vuole autenticarsi per contattare le API",
  main-scen: (
    (descr: "L’attore primario contatta l’endpoint del Sistema dedicato all’autenticazione allegando le credenziali utilizzando un protocollo sicuro e criptato"),
    (
      descr: "L’Auth Server riceve la richiesta inoltrata dal sistema",   // bookmark - se usiamo auth server esterno 
      ep: "ErroreAuthServer",
    ),
    (descr: "L’Auth Server risponde al sistema con un token valido"),
    (descr: "L’attore primario riceve il token valido dal sistema"),
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
)