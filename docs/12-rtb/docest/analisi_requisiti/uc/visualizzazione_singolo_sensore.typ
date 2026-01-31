#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_singolo_sensore",
  system: CLOUD_SYS,
  title: "Visualizzazione singolo sensore",
  level: 3,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema mostra all’Attore la lista di sensori associati ad un Gateway",
  ),
  postconds: (
    "L’Attore visualizza, nel singolo elemento della lista, ID sensore e timestamp ultimo invio dati",
  ),
  trigger: "Identificazione dei sensori nel campo",
  main-scen: (
    (
      descr: "L’Attore visualizza l'identificativo del sensore",
      inc: "visualizzazione_id_sensore",
    ),
    (
      descr: "L’Attore visualizza il timestamp dell'ultima lettura",
      inc: "visualizzazione_timestamp_ultimo_invio_dati_sensore",
    ),
  ),
)[
  #uml-schema("22.1.1", "Diagramma Visualizzazione singolo sensore")
]
