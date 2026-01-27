#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "err_id_gateway_invalido",
  system: CLOUD_SYS,
  title: "Errore ID Gateway invalido",
  level: 1,
  prim-actors: CA.api-client,
  preconds: (
    "Il Sistema riceve un token di autenticazione valido",
    "Il Sistema riceve dall’Attore uno o più ID Gateway non validi allegati ad una richiesta",
  ),
  postconds: (
    "L’Attore non può procedere con la richiesta",
    "L’Attore riceve una risposta di errore",
  ),
  trigger: "",
  main-scen: (
    (descr: "L’Attore riceve una risposta di errore che segnala gli ID dei Gateway non validi"),
  ),
)[#uml-schema("75", "Diagramma Errore ID Gateway invalido")]
