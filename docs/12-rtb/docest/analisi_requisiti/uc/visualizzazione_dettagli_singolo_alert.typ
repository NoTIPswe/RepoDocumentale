#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_dettagli_singolo_alert",
  system: CLOUD_SYS,
  title: "Visualizzazione dettagli singolo alert",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema sta mostrando i dettagli di un alert"
  ),
  postconds: (
    "L’Attore visualizza i dettagli dell’alert",
  ),
  trigger: "L’Attore vuole visualizzare i dettagli di un alert registrato nel Sistema",
  main-scen: (
    (
      descr: "L’Attore visualizza l'orario di emissione dell’alert",
      inc: "visualizzazione_timestamp_emissione_alert",
    ),
    (descr: "L’Attore visualizza le informazioni riguardanti l’alert"),
  ),
)[
  #uml-schema("35", "Diagramma Visualizzazione dettagli singolo alert")
]
