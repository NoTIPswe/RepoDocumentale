#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "creazione_gateway_multipli_default",
  level: 1,
  title: "Creazione Gateway multipli con configurazione di default",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’Attore si trova in una sezione dedicata alla Gestione della simulazione",
  ),
  postconds: (
    "Vengono avviate più istanze di Gateway simulati in parallelo con una configurazione di sistema di default e credenziali di fabbrica casuali",
  ),
  trigger: "Necessità di verificare il comportamento del sistema all’aumentare del numero di istanze",
  main-scen: (
    (descr: "L’Attore inserisce il numero di istanze di Gateway da simulare in parallelo"),
    (descr: "L’Attore avvia la creazione delle nuove istanze"),
    (descr: "L’Attore riceve una notifica della corretta istanziazione dei processi simulati richiesti"),
  ),
)
