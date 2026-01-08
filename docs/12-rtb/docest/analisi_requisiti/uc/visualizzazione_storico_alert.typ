#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_storico_alert",
  system: CLOUD_SYS,
  title: "Visualizzazione Storico Alert",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’attore primario si trova nella sezione dedicata agli alert",
  ),
  postconds: (
    "L’attore primario visualizza lo storico di tutti gli alert registrati",
  ),
  trigger: "L’attore primario vuole visualizzare la lista degli alert registrati",
  main-scen: (
    (
      descr: "L’attore primario visualizza la lista degli alert",
      inc: "visualizzazione_singolo_alert",
      ep: "Dettagli",
    ),
  ),
)
