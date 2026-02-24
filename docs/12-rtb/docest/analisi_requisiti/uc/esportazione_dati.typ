#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "esportazione_dati",
  system: CLOUD_SYS,
  title: "Esportazione dati",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema mostra i dati che l’Attore ha richiesto di visualizzare",
  ),
  postconds: (
    "I dati visualizzati vengono esportati correttamente",
  ),
  trigger: "L’Attore vuole esportare i dati visualizzati",
  main-scen: (
    (descr: "L’Attore seleziona la funzionalità di esportazione dati visualizzati"),
    (descr: "L’Attore avvia il download dei dati di cui è stata richiesta l’esportazione"),
    (descr: "L’Attore ottiene i dati esportati in un nuovo file dedicato"),
  ),

  uml-descr: "Diagramma Esportazione dati",
)
