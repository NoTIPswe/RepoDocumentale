#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_dettagli_alert_gateway_irraggiungibile",
  system: CLOUD_SYS,
  title: "Visualizzazione dettagli alert gateway non raggiungibile",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’attore primario sta visualizzando lo storico degli alert",
    "L’attore primario ha selezionato un alert per vederne i dettagli",
  ),
  postconds: (
    "L’attore primario visualizza i dettagli dell’alert",
  ),
  trigger: "L’attore primario seleziona un alert gateway non raggiungibile per vederne i dettagli",
  main-scen: (
    (
      descr: "L’attore primario visualizza l’identificativo del gateway interessato",
      inc: "visualizzazione_nome_gateway",
    ),
    (
      descr: "L’attore primario visualizza il timestamp dell’ultima comunicazione",
      inc: "visualizzazione_timestamp_ultimo_invio_dati_gateway",
    ),
  ),
)[
  #uml-schema("36", "Diagramma visualizzazione dettagli alert gateway non raggiungibile")
]
