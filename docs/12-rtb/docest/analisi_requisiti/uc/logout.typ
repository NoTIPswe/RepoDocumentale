#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "logout",
  system: CLOUD_SYS,
  title: "Logout",
  level: 1,
  prim-actors: (CA.authd-usr,),
  preconds: (
    "Non ci sono interazioni in corso tra sistema e Attore primario",
  ),
  postconds: (
    "La sessione viene riavviata e si torna al login",
  ),
  trigger: "Necessità di chiudere la sessione attiva",
  main-scen: (
    (descr: "L’Attore primario seleziona la funzionalità di logout"),
    (descr: "L’Attore primario conferma l’operazione di logout"),
  ),
)[
  #uml-schema("17", "Logout")

]
