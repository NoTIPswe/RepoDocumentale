#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "filtraggio_singolo_gateway",
  system: CLOUD_SYS,
  title: "Filtraggio dati per singolo Gateway",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Esiste almeno un Gateway nel Tenant",
    "Il Sistema mostra i Gateway di cui l'attore potrà visualizzare lo Stream di dati",
  ),
  postconds: (
    "Viene aggiunto un Gateway alla lista della richiesta",
  ),
  trigger: "L’Attore vuole filtrare per Gateway",
  main-scen: (
    (descr: "L’Attore seleziona un Gateway da aggiungere alla lista di filtraggio"),
  ),
)[
]
