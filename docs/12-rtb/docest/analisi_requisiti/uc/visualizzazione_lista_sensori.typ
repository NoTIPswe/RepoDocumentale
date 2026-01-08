#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_lista_sensori",
  system: CLOUD_SYS,
  title: "Visualizzazione lista sensori",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L'attore primario visualizza i dettagli di un gateway o la sezione sensori del Tenant",
  ),
  postconds: (
    "Il sistema mostra l'elenco dei sensori associati",
  ),
  trigger: "L’attore primario richiede visualizzazione sensori collegati ad un gateway",
  main-scen: (
    (
      descr: "Il sistema renderizza le voci per ogni sensore presente",
      inc: "visualizzazione_singolo_sensore",
    ),
  ),
)[
  #uml-schema("22.1", "Diagramma visualizzazione lista sensori")
]
