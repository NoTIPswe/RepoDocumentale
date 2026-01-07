#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_lista_sensori_gateway_simulato",
  level: 1,
  title: "Visualizzazione lista sensori Gateway simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore ha selezionato un Gateway simulato",
  ),
  postconds: (
    "L’attore visualizza la lista dei sensori simulati relativi al Gateway selezionato",
  ),
  trigger: "L’attore vuole visualizzare la lista dei sensori relativi ad un gateway simulato",
  main-scen: (
    (
      descr: "L’attore visualizza la lista dei sensori simulati relativi al gateway selezionato",
      inc: "visualizzazione_singolo_sensore_simulato"
    ),
  ),
)