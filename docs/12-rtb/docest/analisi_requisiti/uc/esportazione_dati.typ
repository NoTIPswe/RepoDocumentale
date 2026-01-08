#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "esportazione_dati",
  system: CLOUD_SYS,
  title: "Esportazione dati",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’attore primario sta visualizzando dei dati",
  ),
  postconds: (
    "I dati visualizzati vengono esportati correttamente",
  ),
  trigger: "L’attore primario vuole esportare i dati visualizzati",
  main-scen: (
    (descr: "L’attore primario seleziona la funzionalità di esportazione dati visualizzati"),
    (descr: "L’attore avvia il download dei dati di cui è stata richiesta l’esportazione"),
    (descr: "L’attore ottiene i dati esportati in un nuovo file dedicato"),
  ),
)[#uml-schema("29", "Diagramma esportazione dati")]
