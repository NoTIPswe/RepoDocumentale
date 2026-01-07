#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "err_autenticazione_gateway",
  system: CLOUD_SYS,
  title: "Errore Autenticazione Gateway",
  level: 1,
  prim-actors: CA.p-gway,
  preconds: (
    "Le credenziali fornite non sono valide",
  ),
  postconds: (
    "Il canale sicuro non viene instaurato",
  ),
  trigger: "Il processo di autenticazione del gateway fallisce",
  main-scen: (
    (descr: "L’attore riceve un errore di autenticazione"),
    (descr: "Il canale sicuro non viene instaurato"),
  ),
)