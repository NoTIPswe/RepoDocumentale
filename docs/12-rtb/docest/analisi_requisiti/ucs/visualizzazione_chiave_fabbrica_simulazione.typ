#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_chiave_fabbrica_simulazione",
  level: 2,
  title: "Visualizzazione chiave di fabbrica simulazione",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore ha selezionato un gateway simulato di cui visualizzare la configurazione della simulazione",
    "L’attore sta visualizzando la configurazione di un gateway simulato",
  ),
  postconds: (
    "L’attore visualizza la chiave segreta di fabbrica",
  ),
  trigger: "L’attore accede ai dettagli di configurazione del Gateway simulato",
  main-scen: (
    (descr: "L’attore visualizza la chiave segreta del Gateway simulato"),
  ),
)