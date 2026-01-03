#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_range_accettato",
  system: CLOUD_SYS,
  title: "Visualizzazione range accettato",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "La sessione è attiva",
    "L’attore sta visualizzando un alert relativo a dati fuori range",
  ),
  postconds: (
    "Viene visualizzato il valore del range accettato",
  ),
  trigger: "Un dato registrato risulta essere fuori range previsto",
  main-scen: (
    (descr: "L’Attore visualizza il valore del range accettato"),
  ),
)