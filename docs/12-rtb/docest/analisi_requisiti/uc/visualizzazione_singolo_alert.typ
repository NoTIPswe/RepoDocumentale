#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_singolo_alert",
  system: CLOUD_SYS,
  title: "Visualizzazione singolo alert",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’attore primario sta visualizzando lo storico degli alert",
  ),
  postconds: (
    "L’attore primario visualizza, nel singolo elemento della lista, timestamp emissione alert, tipo di alert e l’hardware interessato",
  ),
  trigger: "L’attore primario deve visualizzare lo storico degli alert del tenant",
  main-scen: (
    (
      descr: "L’attore primario visualizza il timestamp dell’emissione dell’alert",
      inc: "visualizzazione_timestamp_emissione_alert",
    ),
    (
      descr: "L’attore primario visualizza il tipo di alert",
      inc: "visualizzazione_tipo_alert",
    ),
    (
      descr: "L’attore primario visualizza l’hardware interessato",
      inc: "visualizzazione_hardware_interessato",
    ),
  ),
)