#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "selezione_tipo_sensore_simulato",
  level: 3,
  title: "Selezione tipo di sensore simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’Attore primario si trova nella sezione di Gestione Gateway simulato",
    "È stato selezionato un Gateway simulato esistente",
  ),
  postconds: (
    "L’Attore ha selezionato un tipo di sensore valido",
  ),
  trigger: "L’Attore vuole creare un nuovo sensore",
  main-scen: (
    (descr: "L’Attore seleziona il tipo di sensore simulato tra quelli disponibili"),
  ),
)
