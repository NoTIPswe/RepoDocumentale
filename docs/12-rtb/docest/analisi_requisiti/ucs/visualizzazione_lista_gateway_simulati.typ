#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_lista_gateway_simulati",
  level: 1,
  title: "Visualizzazione lista Gateway simulati",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore si trova nella sezione dedicata alla visualizzazione dei Gateway simulati istanziati",
  ),
  postconds: (
    "L’attore visualizza la lista dei gateway simulati",
  ),
  trigger: "L’attore vuole visualizzare i Gateway istanziati fino a quel momento",
  main-scen: (
    (
      descr: "L’attore visualizza la lista dei gateway simulati",
      inc: "visualizzazione_singolo_gateway_simulato"
    ),
  ),
)