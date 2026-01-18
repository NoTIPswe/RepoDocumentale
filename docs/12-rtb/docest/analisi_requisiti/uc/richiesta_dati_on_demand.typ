#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "richiesta_dati_on_demand",
  system: CLOUD_SYS,
  title: "Richiesta dati On-Demand",
  level: 1,
  prim-actors: CA.api-client,
  preconds: (
    "L’Attore primario dispone di un token di autenticazione",
  ),
  postconds: (
    "L’Attore riceve i dati relativi alla richiesta effettuata",
  ),
  trigger: "",
  main-scen: (
    (
      descr: "L’Attore invia una richiesta allegando un token di autenticazione, identificativi dei Gateway/sensori e intervallo temporale",
      ep: "DatiNonValidi",
    ),
    (descr: "L’Attore riceve i dati storici richiesti"),
  ),
  alt-scen: (
    (
      ep: "DatiNonValidi",
      cond: "Il token fornito dall’Utente non è valido",
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
)[#uml-schema("72", "Richiesta dati On-Demand")]
