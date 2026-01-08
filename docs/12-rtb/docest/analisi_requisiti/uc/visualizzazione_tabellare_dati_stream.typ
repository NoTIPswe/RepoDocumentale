#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_tabellare_dati_stream",
  system: CLOUD_SYS,
  title: "Visualizzazione tabellare dati Stream",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Eredita da UC: visualizzazione_dati_stream",
    "L’Attore primario sta visionando i dati sullo stream",
  ),
  postconds: (
    "L’Attore primario visualizza i dati in tabella correttamente",
  ),
  trigger: "L’Attore primario vuole visualizzare lo Stream di dati in tabella",
  main-scen: (
    (descr: "L’Attore primario visualizza una tabella con: timestamp, Gateway, sensore, tipo misura, valore, unità"),
  ),
)[
  #uml-schema("24.1", "Diagramma visualizzazione tabellare dati Stream")
]
