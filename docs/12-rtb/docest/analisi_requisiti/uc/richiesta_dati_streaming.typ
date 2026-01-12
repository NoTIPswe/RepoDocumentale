#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "richiesta_dati_streaming",
  system: CLOUD_SYS,
  title: "Richiesta dati Streaming",
  level: 1,
  prim-actors: CA.api-client,
  preconds: (
    "L’attore dispone di un token di autenticazione",
  ),
  postconds: (
    "L’attore riceve i dati relativi alla richiesta effettuata",
  ),
  trigger: "L’attore primario vuole recuperare dati real-time tramite un endpoint API",
  main-scen: (
    (
      descr: "L’attore invia una richiesta allegando un token di autenticazione e identificativi dei gateway e dei relativi sensori",
      ep: "DatiNonValidi",
    ),
    (descr: "L’attore inizia a ricevere i dati real-time richiesti"),
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
  ),
)[#uml-schema("77", "Richiesta dati streaming")]
