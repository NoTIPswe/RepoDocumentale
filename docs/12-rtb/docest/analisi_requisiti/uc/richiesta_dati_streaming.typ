#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "richiesta_dati_streaming",
  system: CLOUD_SYS,
  title: "Richiesta dati Streaming",
  level: 1,
  prim-actors: CA.api-client,
  preconds: (
    "L’Attore dispone di un token di autenticazione",
  ),
  postconds: (
    "L’Attore riceve i dati relativi alla richiesta effettuata",
  ),
  trigger: "L’Attore primario vuole recuperare dati real-time tramite un endpoint API",
  main-scen: (
    (
      descr: "L’Attore invia una richiesta allegando un token di autenticazione e identificativi dei Gateway e dei relativi sensori",
      ep: "DatiNonValidi",
    ),
    (descr: "L’Attore inizia a ricevere i dati real-time richiesti"),
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
  ),
)[#uml-schema("77", "Richiesta dati streaming")]
