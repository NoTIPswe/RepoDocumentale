#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "selezione_gateway_simulato",
  level: 1,
  title: "Selezione gateway simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore si trova nella sezione dedicata alla visualizzazione dei Gateway simulati istanziati",
    "L’attore sta visualizzando la lista dei gateway simulati",
  ),
  postconds: (
    "L’attore ha selezionato correttamente uno dei Gateway simulati",
  ),
  trigger: "L’attore vuole selezionare, per effettuare qualche operazione, un Gateway",
  main-scen: (
    (descr: "L’attore seleziona uno o più Gateway tramite il loro identificativo"),
  ),
)