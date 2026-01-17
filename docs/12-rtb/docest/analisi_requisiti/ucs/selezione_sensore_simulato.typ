#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "selezione_sensore_simulato",
  level: 1,
  title: "Selezione sensore simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’Attore si trova nella sezione dedicata alla visualizzazione dei sensori simulati relativi ad un Gateway simulato",
    "L’Attore sta visualizzando la lista dei sensori simulati",
  ),
  postconds: (
    "L’Attore ha selezionato correttamente uno dei sensori simulati",
  ),
  trigger: "L’Attore vuole selezionare, per effettuare qualche operazione, un sensore",
  main-scen: (
    (descr: "L’Attore seleziona uno o più sensori tramite il loro identificativo"),
  ),
)
