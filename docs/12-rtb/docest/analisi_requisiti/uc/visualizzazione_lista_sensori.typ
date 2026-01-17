#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_lista_sensori",
  system: CLOUD_SYS,
  title: "Visualizzazione lista sensori",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L'Attore primario visualizza i dettagli di un Gateway o la sezione sensori del Tenant",
  ),
  postconds: (
    "Il sistema mostra l'elenco dei sensori associati",
  ),
  trigger: "L’Attore primario richiede visualizzazione sensori collegati ad un Gateway",
  main-scen: (
    (
      descr: "Il sistema renderizza le voci per ogni sensore presente",
      inc: "visualizzazione_singolo_sensore",
    ),
  ),
)[
  #uml-schema("22.1", "Diagramma visualizzazione lista sensori")
]
