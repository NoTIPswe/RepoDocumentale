#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "err_id_sensore_invalido",
  system: CLOUD_SYS,
  title: "ID Sensore invalido",
  level: 1,
  prim-actors: CA.api-client,
  preconds: (
    "Il sistema ha ricevuto un token di autenticazione valido dall'Attore primario",
    "Il sistema verifica che l’ID del sensore fornito non è valido/registrato",
  ),
  postconds: (
    "L’Attore non può procedere con la richiesta",
    "L’Attore riceve una risposta di errore",
  ),
  trigger: "",
  main-scen: (
    (descr: "L’Attore riceve una risposta di errore che segnala gli ID dei sensori non validi per Gateway"),
  ),
)[#uml-schema("75", "Errore ID sensore invalido")]
