#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  system: SIM_SYS,
  id: "creazione_gateway_multipli_default",
  level: 1,
  title: "Creazione Gateway multipli con configurazione di default",
  prim-actors: (SA.sym-usr),
  preconds: (
<<<<<<< HEAD
    "Il Sistema si trova in una sezione dedicata alla Gestione della simulazione",
=======
    "L’Attore si trova in una sezione dedicata alla Gestione della simulazione",
>>>>>>> bf34a471b30dfc4351927a13da43f6e23c8450d3
  ),
  postconds: (
    "Vengono avviate più istanze di Gateway simulati in parallelo con una configurazione di sistema di default e credenziali di fabbrica casuali",
  ),
  trigger: "Necessità di verificare il comportamento del sistema all’aumentare del numero di istanze",
  main-scen: (
    (descr: "L’Attore inserisce il numero di istanze di Gateway da simulare in parallelo",
    ep: "ValoreNumericoInvalido",
    ),
    (descr: "L’Attore avvia la creazione delle nuove istanze"),
    (descr: "L’Attore riceve una notifica della corretta istanziazione dei processi simulati richiesti",
    ep: "ErroreDeploy",
    ),
  ),
  alt-scen: (
    (
      ep: "ValoreNumericoInvalido",
      cond: "È stato inserito un valore numerico non valido",
      uc: "err_valore_numerico_invalido",
    ),
    (
      ep: "ErroreDeploy",
      cond: "Errore di sistema nella creazione delle istanze",
      uc: "err_deploy_gateway_simulato",
    ),
  ),
)[
  #uml-schema("S15", "Creazione gateway multipli con configurazione di default")
]