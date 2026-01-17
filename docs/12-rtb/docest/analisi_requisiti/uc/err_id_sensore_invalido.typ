#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "err_id_sensore_invalido",
  system: CLOUD_SYS,
  title: "ID Sensore invalido",
  level: 1,
  prim-actors: CA.api-client,
  preconds: (
    "L’Attore ha allegato un token di autenticazione valido",
    "L’ID del sensore fornito non è valido/registrato nel sistema",
  ),
  postconds: (
    "L’Attore non può procedere con la richiesta",
    "L’Attore riceve una risposta di errore",
  ),
  trigger: "L’ID di almeno un sensore fornito dall’Attore primario non esiste",
  main-scen: (
    (descr: "L’Attore riceve una risposta di errore che segnala gli ID dei sensori non validi per Gateway"),
  ),
)[#uml-schema("75", "Errore ID sensore invalido")]
