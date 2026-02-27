#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_chiave_fabbrica_simulazione",
  level: 2,
  title: "Visualizzazione chiave di fabbrica simulazione",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Esiste un Gateway simulato di cui si sta visualizzando la configurazione",
  ),
  postconds: (
    "L’Attore visualizza la chiave segreta di fabbrica",
  ),
  trigger: "L’Attore accede ai dettagli di configurazione del Gateway simulato",
  main-scen: (
    (descr: "L’Attore visualizza la chiave segreta del Gateway simulato"),
  ),
)
