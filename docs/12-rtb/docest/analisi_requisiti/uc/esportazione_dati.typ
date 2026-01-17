#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "esportazione_dati",
  system: CLOUD_SYS,
  title: "Esportazione dati",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’Attore primario sta visualizzando dei dati",
  ),
  postconds: (
    "I dati visualizzati vengono esportati correttamente",
  ),
  trigger: "L’Attore primario vuole esportare i dati visualizzati",
  main-scen: (
    (descr: "L’Attore primario seleziona la funzionalità di esportazione dati visualizzati"),
    (descr: "L’Attore avvia il download dei dati di cui è stata richiesta l’esportazione"),
    (descr: "L’Attore ottiene i dati esportati in un nuovo file dedicato"),
  ),
)[#uml-schema("29", "Diagramma esportazione dati")]
