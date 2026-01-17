#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_dettagli_alert_sensore_fuori_range",
  system: CLOUD_SYS,
  title: "Visualizzazione dettagli alert sensore fuori range",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema sta mostrando i dettagli di un alert riferito a un sensore fuori dal range previsto"
  ),
  postconds: (
    "L’Attore visualizza i dettagli dell’alert",
  ),
  trigger: "L’Attore vuole visualizzare i dettagli di un alert sensore fuori dal range",
  main-scen: (
    (
      descr: "L’Attore visualizza l’ID del sensore interessato",
      inc: "visualizzazione_id_sensore",
    ),
    (
      descr: "L’Attore visualizza il valore del dato registrato fuori range",
      inc: "visualizzazione_valore_dato_registrato",
    ),
    (
      descr: "L’Attore visualizza l’orario di registrazione del dato",
      inc: "visualizzazione_timestamp_dato_irregolare",
    ),
    (
      descr: "L’Attore visualizza il range accettato",
      inc: "visualizzazione_range_accettato",
    ),
  ),
)[
  #uml-schema("37", "Diagramma visualizzazione dettagli alert sensore fuori range")
]
