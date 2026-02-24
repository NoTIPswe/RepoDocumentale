#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_grafico_dati_stream",
  system: CLOUD_SYS,
  title: "Visualizzazione grafico dati Stream",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Esiste almeno un sensore associato al Gateway di un Tenant gestito dall’Attore primario",
    "L’Attore sta visionando i dati sullo stream",
  ),
  postconds: (
    "L’Attore visualizza i dati in grafico correttamente",
  ),
  trigger: "L’Attore vuole visualizzare lo Stream di dati su grafici",
  main-scen: (
    (descr: "L’Attore visualizza uno o più grafici (in base alla tipologia dato) su base temporale"),
    (descr: "Il Sistema distingue le serie nel caso i dati includano più sensori (es. per sensore o tipo misura)"),
  ),
)[
]
