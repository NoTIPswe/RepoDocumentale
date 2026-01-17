#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_id_fabbrica_simulazione",
  level: 1,
  title: "Visualizzazione ID di fabbrica simulazione",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’Attore ha selezionato un Gateway simulato di cui visualizzare la configurazione della simulazione",
    "L’Attore sta visualizzando la configurazione di un Gateway simulato",
  ),
  postconds: (
    "L’Attore visualizza l'identificativo di fabbrica di un Gateway",
  ),
  trigger: "L’Attore accede ai dettagli di configurazione del Gateway simulato",
  main-scen: (
    (descr: "L’Attore visualizza l'ID di fabbrica generato dal simulatore"),
  ),
)
