#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_storico_alert",
  system: CLOUD_SYS,
  title: "Visualizzazione storico alert",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Esiste almeno un alert registrato nel Sistema",
    "Il Sistema sta mostrando lo storico di alert registrati nel Sistema",
  ),
  postconds: (
    "L’Attore visualizza lo storico di tutti gli alert registrati",
  ),
  trigger: "L’Attore vuole visualizzare lo storico degli alert registrati nel Sistema",
  main-scen: (
    (
      descr: "L’Attore visualizza la lista degli alert",
      inc: "visualizzazione_singolo_alert",
      ep: "Dettagli",
    ),
  ),

  uml-descr: "Diagramma Visualizzazione storico alert",
)
