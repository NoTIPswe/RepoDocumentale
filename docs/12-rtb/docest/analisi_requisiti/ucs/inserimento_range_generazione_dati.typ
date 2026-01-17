#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "inserimento_range_generazione_dati",
  level: 3,
  title: "Inserimento range generazione dati",
  prim-actors: (SA.sym-usr),
  preconds: (
    "È stato selezionato un Gateway simulato esistente",
  ),
  postconds: (
    "L’Attore ha inserito in intervallo di generazione dati valido",
  ),
  trigger: "L’Attore vuole creare un nuovo sensore",
  main-scen: (
    (descr: "L’Attore inserisce un valore minimo"),
    (descr: "L’Attore inserisce un valore massimo maggiore o uguale al minimo"),
  ),
)
