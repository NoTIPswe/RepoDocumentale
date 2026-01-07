#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "selezione_sensore_simulato",
  level: 1,
  title: "Selezione sensore simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore si trova nella sezione dedicata alla visualizzazione dei sensori simulati relativi ad un Gateway simulato",
    "L’attore sta visualizzando la lista dei sensori simulati",
  ),
  postconds: (
    "L’attore ha selezionato correttamente uno dei sensori simulati",
  ),
  trigger: "L’attore vuole selezionare, per effettuare qualche operazione, un sensore",
  main-scen: (
    (descr: "L’attore seleziona uno o più sensori tramite il loro identificativo"),
  ),
)