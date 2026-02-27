#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "logout",
  system: CLOUD_SYS,
  title: "Logout",
  level: 1,
  prim-actors: (CA.authd-usr,),
  preconds: (
    "Non ci sono interazioni in corso tra Sistema e Attore",
  ),
  postconds: (
    "La sessione viene riavviata e si torna al login",
  ),
  trigger: "Necessità di chiudere la sessione attiva",
  main-scen: (
    (descr: "L’Attore seleziona la funzionalità di logout"),
    (descr: "L’Attore conferma l’operazione di logout"),
  ),

  uml-descr: "Diagramma Logout",
)
