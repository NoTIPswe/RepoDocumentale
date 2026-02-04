#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_singolo_gateway",
  system: CLOUD_SYS,
  title: "Visualizzazione singolo Gateway",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema mostra la lista dei Gateway associati al Tenant dell'Attore",
  ),
  postconds: (
    "L'Attore visualizza, nel singolo elemento della lista, nome e stato del Gateway",
  ),
  trigger: "Visualizzazione rapida di un dispositivo nella lista",
  main-scen: (
    (
      descr: "Il Sistema mostra il nome identificativo del Gateway",
      inc: "visualizzazione_nome_gateway",
    ),
    (
      descr: "Il Sistema mostra la condizione operativa attuale",
      inc: "visualizzazione_stato_gateway",
    ),
  ),
)[
  #uml-schema("18.1", "Diagramma Visualizzazione singolo Gateway")

]
