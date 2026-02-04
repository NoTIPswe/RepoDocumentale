#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_lista_sensori",
  system: CLOUD_SYS,
  title: "Visualizzazione lista sensori",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema mostra all'Attore i dettagli del Gateway selezionato o la sezione sensori del Tenant",
  ),
  postconds: (
    "Il Sistema mostra l'elenco dei sensori associati",
  ),
  trigger: "L’Attore richiede visualizzazione sensori collegati ad un Gateway",
  main-scen: (
    (
      descr: "L’Attore richiede la visualizzazione dell’elenco dei sensori.",
      inc: "visualizzazione_singolo_sensore",
    ),
  ),
)[
  #uml-schema("22.1", "Diagramma Visualizzazione lista sensori")
]
