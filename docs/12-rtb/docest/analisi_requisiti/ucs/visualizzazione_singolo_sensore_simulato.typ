#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_singolo_sensore_simulato",
  level: 2,
  title: "Visualizzazione singolo sensore simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’Attore ha selezionato un Gateway simulato",
    "L’Attore sta visualizzando la lista dei sensori relativi al Gateway simulato",
  ),
  postconds: (
    "L’Attore visualizza una entry della lista dei sensori simulati relativi al Gateway selezionato",
  ),
  trigger: "L’Attore vuole visualizzare dettagli utili ad identificare un sensore relativo ad un Gateway simulato",
  main-scen: (
    (
      descr: "L’Attore visualizza l’identificativo del sensore",
      inc: "visualizzazione_identificativo_sensore",
    ),
    (
      descr: "L’Attore visualizza il tipo di sensore",
      inc: "visualizzazione_tipo_sensore_simulato",
    ),
  ),
)
