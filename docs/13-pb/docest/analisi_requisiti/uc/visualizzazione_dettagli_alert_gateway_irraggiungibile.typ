#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_dettagli_alert_gateway_irraggiungibile",
  system: CLOUD_SYS,
  title: "Visualizzazione dettagli alert Gateway non raggiungibile",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema sta mostrando i dettagli di un alert riferito a un Gateway non raggiungibile"
  ),
  postconds: (
    "L’Attore visualizza i dettagli dell’alert",
  ),
  trigger: "L’Attore vuole visualizzare i dettagli di una alert Gateway non raggiungibile",
  main-scen: (
    (
      descr: "L’Attore visualizza l’identificativo del Gateway interessato",
      inc: "visualizzazione_nome_gateway",
    ),
    (
      descr: "L’Attore visualizza il timestamp dell’ultima comunicazione",
      inc: "visualizzazione_timestamp_ultimo_invio_dati_gateway",
    ),
  ),

  uml-descr: "Diagramma Visualizzazione dettagli alert Gateway non raggiungibile",
)
