#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_singolo_sensore",
  system: CLOUD_SYS,
  title: "Visualizzazione singolo sensore",
  level: 3,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L'Attore primario sta visualizzando la lista di sensori collegati ad un Gateway",
  ),
  postconds: (
    "L’Attore primario visualizza, nel singolo elemento della lista, ID sensore e timestamp ultimo invio dati",
  ),
  trigger: "Identificazione dei sensori nel campo",
  main-scen: (
    (
      descr: "L’Attore primario visualizza identificativo sensore",
      inc: "visualizzazione_id_sensore",
    ),
    (
      descr: "L’Attore primario visualizza timestamp dell'ultima lettura",
      inc: "visualizzazione_timestamp_ultimo_invio_dati_sensore",
    ),
  ),
)[
  #uml-schema("22.1.1", "Diagramma visualizzazione singolo sensore")
]
