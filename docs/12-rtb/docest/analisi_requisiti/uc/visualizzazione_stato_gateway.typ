#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "visualizzazione_stato_gateway",
  system: CLOUD_SYS,
  title: "Visualizzazione stato gateway",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L'attore primario sta visualizzando una lista di gateway o i dettagli di uno di essi",
  ),
  postconds: (
    "L'attore primario visualizza lo stato del gateway",
  ),
  trigger: "Necessità di verificare lo stato del dispositivo",
  main-scen: (
    (descr: "Viene visualizzato lo stato del gateway (sospeso, online, offline)"),
  ),
)
