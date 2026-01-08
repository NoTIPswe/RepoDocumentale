#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "filtraggio_singolo_sensore",
  system: CLOUD_SYS,
  title: "Filtraggio dati singolo sensore",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’attore primario si trova nella sezione “Visualizzazione Stream”",
    "L’attore primario ha effettuato un filtraggio per gateway",
    "Esiste almeno un sensore associato al Gateway del Tenant gestito dall’attore",
    "L’Attore primario sta scegliendo i sensori di cui vuole visualizzare i dati",
  ),
  postconds: (
    "Viene aggiunto un sensore alla lista della richiesta",
  ),
  trigger: "L’attore primario vuole filtrare per sensori",
  main-scen: (
    (descr: "L’Attore primario seleziona un sensore da aggiungere alla lista di filtraggio"),
  ),
)[
  #uml-schema("26.1", "Diagramma filtraggio dati per singolo sensore")
]
