#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_singolo_alert",
  system: CLOUD_SYS,
  title: "Visualizzazione singolo alert",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Esiste almeno un alert registrato nel Sistema",
    "Il Sistema sta mostrando lo storico degli alert registrati nel Sistema",
  ),
  postconds: (
    "Il Sistema mostra, nel singolo elemento dello storico, timestamp emissione alert, tipo di alert e l’hardware interessato",
  ),
  trigger: "L’Attore vuole visualizzare lo storico degli alert registrati nel Sistema",
  main-scen: (
    (
      descr: "L’Attore visualizza il timestamp dell’emissione dell’alert",
      inc: "visualizzazione_timestamp_emissione_alert",
    ),
    (
      descr: "L’Attore visualizza il tipo di alert",
      inc: "visualizzazione_tipo_alert",
    ),
    (
      descr: "L’Attore visualizza l’hardware interessato",
      inc: "visualizzazione_hardware_interessato",
    ),
  ),
)[
  #uml-schema("33.1", "Diagramma visualizzazione singolo alert")
]
