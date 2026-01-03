#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_grafico_dati_stream",
  system: CLOUD_SYS,
  title: "Visualizzazione grafico dati Stream",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Eredita da UC: visualizzazione_dati_stream",
    "L’Attore primario sta visionando i dati sullo stream",
  ),
  postconds: (
    "L’Attore primario visualizza i dati in grafico correttamente",
  ),
  trigger: "L’Attore primario vuole visualizzare lo Stream di dati su grafici",
  main-scen: (
    (descr: "L’Attore primario visualizza uno o più grafici (in base alla tipologia dato) su base temporale"),
    (descr: "Il sistema distingue le serie nel caso i dati includano più sensori (es. per sensore o tipo misura)"),
  ),
)
