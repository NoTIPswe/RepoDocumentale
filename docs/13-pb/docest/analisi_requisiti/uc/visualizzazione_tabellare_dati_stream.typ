#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_tabellare_dati_stream",
  system: CLOUD_SYS,
  title: "Visualizzazione tabellare dati Stream",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Esiste almeno un sensore associato al Gateway di un Tenant gestito dall’Attore primario",
    "L’Attore sta visionando i dati sullo stream",
  ),
  postconds: (
    "L’Attore visualizza i dati in tabella correttamente",
  ),
  trigger: "L’Attore vuole visualizzare lo Stream di dati in tabella",
  main-scen: (
    (descr: "L’Attore visualizza una tabella con: timestamp, Gateway, sensore, tipo misura, valore, unità"),
  ),
)[
]
