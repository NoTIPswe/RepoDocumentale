#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "alert_sensore_fuori_range",
  system: CLOUD_SYS,
  title: "Ricezione alert dati sensore fuori range",
  level: 1,
  prim-actors: CA.tenant-usr,
  sec-actors: CA.p-gway,
  preconds: (
    "Esiste un'irregolarità nelle misurazioni del sensore",
  ),
  postconds: (
    "L’Attore viene notificato dell'anomalia nei dati registrati dal sensore",
  ),
  trigger: "Un valore registrato dal sensore risulta fuori dal range previsto",
  main-scen: (
    (descr: "Il Sistema rileva una irregolarità nelle misurazioni di un sensore"),
    (descr: "Il Sistema notifica l’Attore"),
    (
      descr: "L’Attore visualizza l’ID del sensore interessato",
      inc: "visualizzazione_id_sensore",
    ),
    (
      descr: "L’Attore visualizza il valore del dato registrato",
      inc: "visualizzazione_valore_dato_registrato",
    ),
    (
      descr: "L’Attore visualizza il range accettato",
      inc: "visualizzazione_range_accettato",
    ),
    (
      descr: "L’Attore visualizza timestamp di registrazione del dato",
      inc: "visualizzazione_timestamp_dato_irregolare",
    ),
  ),
)[
  #uml-schema("31", "Diagramma Ricezione alert dati sensore fuori range")
]
