#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "filtraggio_singolo_gateway",
  system: CLOUD_SYS,
  title: "Filtraggio dati per singolo Gateway",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’attore primario è nella sezione “Visualizzazione Stream”",
    "Esiste almeno un Gateway nel Tenant",
    "L’Attore primario sta scegliendo i Gateway di cui vuole visualizzare lo Stream di dati",
  ),
  postconds: (
    "Viene aggiunto un gateway alla lista della richiesta",
  ),
  trigger: "L’attore primario vuole filtrare per gateway",
  main-scen: (
    (descr: "L’attore primario seleziona un gateway da aggiungere alla lista di filtraggio"),
  ),
)
