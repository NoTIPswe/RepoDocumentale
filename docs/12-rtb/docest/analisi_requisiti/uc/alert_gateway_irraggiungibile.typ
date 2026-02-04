#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "alert_gateway_irraggiungibile",
  system: CLOUD_SYS,
  title: "Ricezione alert Gateway non raggiungibile",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "La sessione è attiva",
  ),
  postconds: (
    "L’Attore viene notificato della non disponibilità del Gateway",
  ),
  trigger: "Un Gateway diventa irraggiungibile",
  main-scen: (
    (descr: "Il Sistema notifica l’Attore dell’irraggiungibilità del Gateway"),
    (
      descr: "L’Attore visualizza il nome Gateway interessato",
      inc: "visualizzazione_nome_gateway",
    ),
    (
      descr: "L’Attore visualizza il timestamp dell’ultima comunicazione",
      inc: "visualizzazione_timestamp_ultimo_invio_dati_gateway",
    ),
  ),
)[
  #uml-schema("30", "Diagramma Ricezione alert Gateway non raggiungibile")
]
