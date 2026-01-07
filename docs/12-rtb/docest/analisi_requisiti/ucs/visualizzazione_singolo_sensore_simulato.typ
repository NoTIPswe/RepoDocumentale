#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_singolo_sensore_simulato",
  level: 2,
  title: "Visualizzazione singolo sensore simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore ha selezionato un Gateway simulato",
    "L’attore sta visualizzando la lista dei sensori relativi al Gateway simulato",
  ),
  postconds: (
    "L’attore visualizza una entry della lista dei sensori simulati relativi al Gateway selezionato",
  ),
  trigger: "L’attore vuole visualizzare dettagli utili ad identificare un sensore relativo ad un gateway simulato",
  main-scen: (
    (
      descr: "L’attore visualizza l’identificativo del sensore",
      inc: "visualizzazione_identificativo_sensore"
    ),
    (
      descr: "L’attore visualizza il tipo di sensore",
      inc: "visualizzazione_tipo_sensore_simulato"
    ),
  ),
)