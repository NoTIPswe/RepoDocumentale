#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "alert_sensore_fuori_range",
  system: CLOUD_SYS,
  title: "Ricezione alert dati sensore fuori range",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "La sessione è attiva",
  ),
  postconds: (
    "L’attore viene notificato dell'anomalia nei dati registrati dal sensore",
  ),
  trigger: "Un sensore registra valori fuori range accettato",
  main-scen: (
    (descr: "Il sistema notifica l’attore primario di una irregolarità nelle misurazioni di un sensore"),
    (
      descr: "L’attore visualizza l’ID del sensore interessato",
      inc: "visualizzazione_id_sensore",
    ),
    (
      descr: "L’attore visualizza il valore del dato registrato",
      inc: "visualizzazione_valore_dato_registrato",
    ),
    (
      descr: "L’Attore visualizza il range accettato",
      inc: "visualizzazione_range_accettato",
    ),
    (
      descr: "L’attore visualizza timestamp di registrazione del dato",
      inc: "visualizzazione_timestamp_dato_irregolare",
    ),
  ),
)[
  #uml-schema("31", "Diagramma ricezione alert dati sensore fuori range")
]
