#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "err_dati_non_disponibili",
  system: CLOUD_SYS,
  title: "Errore dati non disponibili",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’Attore si trova in una sezione di visualizzazione",
    "Non sono stati registrati dati",
  ),
  postconds: (
    "L’Attore è informato che non ci sono dati visualizzabili/esportabili",
  ),
  trigger: "I dati non sono disponibili in fase di visualizzazione dei dettagli",
  main-scen: (
    (
      descr: "L’Attore riceve una notifica di errore che indica che i dati non sono temporaneamente disponibili/esistenti",
    ),
  ),
)[
  #uml-schema("28", "Diagramma Errore dati non disponibili")
]
