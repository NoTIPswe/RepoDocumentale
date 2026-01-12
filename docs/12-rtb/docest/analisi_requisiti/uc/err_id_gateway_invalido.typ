#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "err_id_gateway_invalido",
  system: CLOUD_SYS,
  title: "ID Gateway invalido",
  level: 1,
  prim-actors: CA.api-client,
  preconds: (
    "L’attore ha allegato un token di autenticazione valido",
    "L’attore ha allegato uno o più ID gateway non validi ad una richiesta",
  ),
  postconds: (
    "L’attore non può procedere con la richiesta",
    "L’attore riceve una risposta di errore",
  ),
  trigger: "L’attore ha allegato uno o più ID gateway non validi ad una richiesta",
  main-scen: (
    (descr: "L’attore riceve una risposta di errore che segnala gli ID dei gateway non validi"),
  ),
)[#uml-schema("74", "Errore ID gateway invalido")]
