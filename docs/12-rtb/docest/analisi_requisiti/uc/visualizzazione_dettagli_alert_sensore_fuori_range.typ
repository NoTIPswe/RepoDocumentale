#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_dettagli_alert_sensore_fuori_range",
  system: CLOUD_SYS,
  title: "Visualizzazione dettagli alert sensore fuori range",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’attore primario sta visualizzando lo storico degli alert",
    "L’attore primario ha selezionato un alert per vederne i dettagli",
  ),
  postconds: (
    "L’attore primario visualizza i dettagli dell’alert",
  ),
  trigger: "L’attore primario seleziona un alert sensore fuori range per vederne i dettagli",
  main-scen: (
    (
      descr: "L’attore primario visualizza l’ID del sensore interessato",
      inc: "visualizzazione_id_sensore",
    ),
    (
      descr: "L’attore primario visualizza il valore del dato registrato fuori range",
      inc: "visualizzazione_valore_dato_registrato",
    ),
    (
      descr: "L’attore primario visualizza l’orario di registrazione del dato",
      inc: "visualizzazione_timestamp_dato_irregolare",
    ),
    (
      descr: "L’attore primario visualizza il range accettato",
      inc: "visualizzazione_range_accettato",
    ),
  ),
)[
  #uml-schema("37", "Diagramma visualizzazione dettagli alert sensore fuori range")
]
