#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_stato_gateway",
  system: CLOUD_SYS,
  title: "Visualizzazione stato Gateway",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema presenta all’Attore primario la lista di Gateway associata al Tenant di appartenenza o i dettagli di uno di essi",
  ),
  postconds: (
    "L'Attore primario visualizza lo stato del Gateway",
  ),
  trigger: "Necessità di verificare lo stato del dispositivo",
  main-scen: (
    (descr: "Viene visualizzato lo stato del Gateway (sospeso, online, offline)"),
  ),
)[
  #uml-schema("20", "Diagramma Visualizzazione stato Gateway")
]
