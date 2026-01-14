#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "selezione_tipo_sensore",
  system: CLOUD_SYS,
  title: "Selezione tipo di sensore",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’attore primario si trova nella sezione dedicata alla modifica",
    "Esiste almeno un tipo di sensore configurato nel sistema per il quale è possibile modificare il range di default",
    "L’attore principale sta eseguendo un’operazione che interessa un tipo specifico di sensore",
  ),
  postconds: (
    "Il tipo di sensore è stato selezionato",
  ),
  trigger: "L’attore principale sta eseguendo un’operazione che interessa un tipo specifico di sensore",
  main-scen: (
    (descr: "L’attore principale seleziona un tipo di sensore fra quelli disponibili"),
  ),
)[#uml-schema("46", "Selezione tipo di sensore")]
