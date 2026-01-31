#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  system: SIM_SYS,
  id: "visualizzazione_lista_sensori_gateway_simulato",
  level: 1,
  title: "Visualizzazione lista sensori Gateway simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Il Sistema si trova nella sezione dedicata alla visualizzazione dei sensori del Gateway simulato selezionato",
  ),
  postconds: (
    "L’Attore visualizza la lista dei sensori simulati relativi al Gateway selezionato",
  ),
  trigger: "L’Attore vuole visualizzare la lista dei sensori relativi ad un gateway simulato",
  main-scen: (
    (
      descr: "L’Attore visualizza la lista dei sensori simulati relativi al gateway selezionato",
      inc: "visualizzazione_singolo_sensore_simulato",
    ),
  ),
)[
  #uml-schema("S4", "Diagramma Visualizzazione lista sensori Gateway simulato")
]

