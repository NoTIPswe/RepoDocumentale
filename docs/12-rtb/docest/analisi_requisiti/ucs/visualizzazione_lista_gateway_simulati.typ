#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_lista_gateway_simulati",
  level: 1,
  title: "Visualizzazione lista Gateway simulati",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’Attore si trova nella sezione dedicata alla visualizzazione dei Gateway simulati istanziati",
  ),
  postconds: (
    "L’Attore visualizza la lista dei Gateway simulati",
  ),
  trigger: "L’Attore vuole visualizzare i Gateway istanziati fino a quel momento",
  main-scen: (
    (
      descr: "L’Attore visualizza la lista dei Gateway simulati",
      inc: "visualizzazione_singolo_gateway_simulato",
    ),
  ),
)
