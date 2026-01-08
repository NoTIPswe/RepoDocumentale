#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_timestamp_ultimo_invio_dati_sensore",
  system: CLOUD_SYS,
  title: "Visualizzazione timestamp ultimo invio dati sensore",
  level: 4,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’attore primario sta visualizzando la lista dei sensori collegati ad un gateway",
  ),
  postconds: (
    "L’attore primario visualizza timestamp ultima lettura del sensore",
  ),
  trigger: "Viene richiesta la lista dei sensori collegati al gateway",
  main-scen: (
    (descr: "L’attore primario visualizza il timestamp associato all'ultimo dato ricevuto dal sensore"),
  ),
)[
  #uml-schema("22.1.1.1", "Diagramma visualizzazione timestamp ultimo invio dati sensore")
]
