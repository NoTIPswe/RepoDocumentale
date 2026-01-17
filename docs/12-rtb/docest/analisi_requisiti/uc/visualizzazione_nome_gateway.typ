#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_nome_gateway",
  system: CLOUD_SYS,
  title: "Visualizzazione nome Gateway",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L'Attore primario sta visualizzando una lista di Gateway, i dettagli di uno di essi o un alert riguardante un Gateway",
  ),
  postconds: (
    "L'Attore primario visualizza il nome identificativo del Gateway",
  ),
  trigger: "Necessità di distinguere univocamente il Gateway",
  main-scen: (
    (descr: "Viene visualizzato il nome del Gateway"),
  ),
)[
  #uml-schema("19", "Visualizzazione nome Gateway")
]
