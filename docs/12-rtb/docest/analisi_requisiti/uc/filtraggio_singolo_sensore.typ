#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "filtraggio_singolo_sensore",
  system: CLOUD_SYS,
  title: "Filtraggio dati singolo sensore",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’Attore primario ha effettuato un filtraggio per Gateway",
    "Esiste almeno un sensore associato al Gateway del Tenant gestito dall’Attore",
    "Il sistema mostra all'Attore primario l'elenco dei sensori di cui potrà visualizzare i dati",
  ),
  postconds: (
    "Viene aggiunto un sensore alla lista della richiesta",
  ),
  trigger: "L’Attore primario vuole filtrare per sensori",
  main-scen: (
    (descr: "L’Attore primario seleziona un sensore da aggiungere alla lista di filtraggio"),
  ),
)[
]
