#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "logout",
  system: CLOUD_SYS,
  title: "Logout",
  level: 1,
  prim-actors: (CA.authd-usr,),
  preconds: (
    "Non sono in corso operazioni da parte dell’attore primario",
  ),
  postconds: (
    "La sessione viene riavviata e si torna al login",
  ),
  trigger: "Necessità di chiudere la sessione attiva",
  main-scen: (
    (descr: "L’attore primario seleziona la funzionalità di logout"),
    (descr: "L’attore primario conferma l’operazione di logout"),
  ),
)
