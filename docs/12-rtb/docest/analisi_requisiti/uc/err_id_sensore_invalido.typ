#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "err_id_sensore_invalido",
  system: CLOUD_SYS,
  title: "ID Sensore invalido",
  level: 1,
  prim-actors: CA.api-client,
  preconds: (
    "L’attore ha allegato un token di autenticazione valido",
    "L’ID del sensore fornito non è valido/registrato nel sistema",
  ),
  postconds: (
    "L’attore non può procedere con la richiesta",
    "L’attore riceve una risposta di errore",
  ),
  trigger: "L’ID di almeno un sensore fornito dall’attore primario non esiste",
  main-scen: (
    (descr: "L’attore riceve una risposta di errore che segnala gli ID dei sensori non validi per gateway"),
  ),
)
