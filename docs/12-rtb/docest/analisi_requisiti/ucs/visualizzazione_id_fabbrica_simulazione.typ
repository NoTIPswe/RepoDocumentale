#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_id_fabbrica_simulazione",
  level: 1,
  title: "Visualizzazione ID di fabbrica simulazione",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore ha selezionato un gateway simulato di cui visualizzare la configurazione della simulazione",
    "L’attore sta visualizzando la configurazione di un gateway simulato",
  ),
  postconds: (
    "L’attore visualizza l'identificativo di fabbrica di un Gateway",
  ),
  trigger: "L’attore accede ai dettagli di configurazione del Gateway simulato",
  main-scen: (
    (descr: "L’attore visualizza l'ID di fabbrica generato dal simulatore"),
  ),
)