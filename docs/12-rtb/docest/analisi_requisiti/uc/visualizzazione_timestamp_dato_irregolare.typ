#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_timestamp_dato_irregolare",
  system: CLOUD_SYS,
  title: "Visualizzazione timestamp registrazione dato irregolare",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’attore primario sta visualizzando un alert relativo a dati fuori range",
  ),
  postconds: (
    "L’attore primario visualizza il timestamp della registrazione del dato fuori range",
  ),
  trigger: "Un dato registrato risulta essere fuori range previsto",
  main-scen: (
    (descr: "L’attore primario visualizza l’orario di registrazione del dato da parte del sensore"),
  ),
)
