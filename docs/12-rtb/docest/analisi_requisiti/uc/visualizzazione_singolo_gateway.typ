#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_singolo_gateway",
  system: CLOUD_SYS,
  title: "Visualizzazione singolo gateway",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L'attore primario sta visualizzando la lista dei gateway",
  ),
  postconds: (
    "L'attore primario visualizza, nel singolo elemento della lista, nome e stato del gateway",
  ),
  trigger: "Visualizzazione rapida di un dispositivo nella lista",
  main-scen: (
    (
      descr: "Il sistema mostra il nome identificativo del gateway",
      inc: "visualizzazione_nome_gateway",
    ),
    (
      descr: "Il sistema mostra la condizione operativa attuale",
      inc: "visualizzazione_stato_gateway",
    ),
  ),
)[
  #uml-schema("18.1", "Visualizzazione singolo gateway")

]
