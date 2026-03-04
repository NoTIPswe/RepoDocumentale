#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "selezione_tipo_sensore",
  system: CLOUD_SYS,
  title: "Selezione tipo di sensore",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste un sensore di tipologia disponibile a modifiche nel Sistema",
  ),
  postconds: (
    "Il tipo di sensore è stato selezionato",
  ),
  trigger: "L’Attore sta eseguendo un’operazione che interessa un tipo specifico di sensore",
  main-scen: (
    (descr: "L’Attore seleziona un tipo di sensore fra quelli disponibili"),
  ),

  uml-descr: "Diagramma Selezione tipo di sensore",
)
