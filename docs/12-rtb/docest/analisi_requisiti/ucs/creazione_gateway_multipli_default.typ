#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "creazione_gateway_multipli_default",
  level: 1,
  title: "Creazione gateway multipli con configurazione di default",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore si trova in una sezione dedicata alla Gestione della simulazione",
  ),
  postconds: (
    "Vengono avviate più istanze di gateway simulati in parallelo con una configurazione di sistema di default e credenziali di fabbrica casuali",
  ),
  trigger: "Necessità di verificare il comportamento del sistema all’aumentare del numero di istanze",
  main-scen: (
    (descr: "L’attore inserisce il numero di istanze di gateway da simulare in parallelo"),
    (descr: "L’attore avvia la creazione delle nuove istanze"),
    (descr: "L’attore riceve una notifica della corretta istanziazione dei processi simulati richiesti"),
  ),
)
