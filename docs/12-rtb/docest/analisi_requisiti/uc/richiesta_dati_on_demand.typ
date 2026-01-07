#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, CSA

#uc(
  id: "richiesta_dati_on_demand",
  system: CLOUD_SYS,
  title: "Richiesta dati On-Demand",
  level: 1,
  prim-actors: CA.api-client,
  preconds: (
    "L’attore dispone di un token di autenticazione",
  ),
  postconds: (
    "L’attore riceve i dati relativi alla richiesta effettuata",
  ),
  trigger: "L’attore primario vuole recuperare dati storici tramite una chiamata API",
  main-scen: (
    (
      descr: "L’attore invia una richiesta allegando un token di autenticazione, identificativi dei gateway/sensori e intervallo temporale",
      ep: "DatiNonValidi",
    ),
    (descr: "L’attore riceve i dati storici richiesti"),
  ),
  alt-scen: (
    (
      ep: "DatiNonValidi",
      cond: "Il token fornito dall’utente non è valido",
      uc: "err_token_api_invalido",
    ),
    (
      ep: "DatiNonValidi",
      cond: "ID Gateway invalido",
      uc: "err_id_gateway_invalido",
    ),
    (
      ep: "DatiNonValidi",
      cond: "ID sensore invalido",
      uc: "err_id_sensore_invalido",
    ),
    (
      ep: "DatiNonValidi",
      cond: "Intervallo temporale malformato",
      uc: "err_intervallo_temporale_invalido",
    ),
  ),
)