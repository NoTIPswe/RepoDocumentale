#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_dettagli_singolo_alert",
  system: CLOUD_SYS,
  title: "Visualizzazione dettagli singolo alert",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’attore primario sta visualizzando lo storico degli alert",
    "L’attore primario ha selezionato un alert per vederne i dettagli",
  ),
  postconds: (
    "L’attore primario visualizza i dettagli dell’alert",
  ),
  trigger: "L’attore primario seleziona un alert per vederne i dettagli",
  main-scen: (
    (
      descr: "L’attore primario visualizza l'orario di emissione dell’alert",
      inc: "visualizzazione_timestamp_emissione_alert",
    ),
    (descr: "L’attore primario visualizza le informazioni riguardanti l’alert"),
  ),
)
