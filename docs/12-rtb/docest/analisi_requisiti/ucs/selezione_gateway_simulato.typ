#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "selezione_gateway_simulato",
  level: 1,
  title: "Selezione Gateway simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’Attore si trova nella sezione dedicata alla visualizzazione dei Gateway simulati istanziati",
    "L’Attore sta visualizzando la lista dei Gateway simulati",
  ),
  postconds: (
    "L’Attore ha selezionato correttamente uno dei Gateway simulati",
  ),
  trigger: "L’Attore vuole selezionare, per effettuare qualche operazione, un Gateway",
  main-scen: (
    (descr: "L’Attore seleziona uno o più Gateway tramite il loro identificativo"),
  ),
)
