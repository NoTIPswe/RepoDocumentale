#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "err_id_sensore_invalido",
  system: CLOUD_SYS,
  title: "Errore ID Sensore invalido",
  level: 1,
  prim-actors: CA.api-client,
  preconds: (
    "Il Sistema ha ricevuto un token di autenticazione valido dall'Attore primario",
    "Il Sistema verifica che l’ID del sensore fornito non è valido/registrato",
  ),
  postconds: (
    "L’Attore non può procedere con la richiesta",
    "L’Attore riceve una risposta di errore",
  ),
  trigger: "",
  main-scen: (
    (descr: "L’Attore riceve una risposta di errore che segnala gli ID dei sensori non validi per Gateway"),
  ),
)
