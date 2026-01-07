#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_timestamp_api",
  system: CLOUD_SYS,
  title: "Visualizzazione timestamp creazione credenziali API",
  level: 3,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’Attore si trova nella sezione dedicata alla visualizzazione degli API token",
    "L’attore ha visualizzato la lista delle credenziali API",
  ),
  postconds: (
    "L’attore visualizza il timestamp di creazione di specifiche credenziali API",
  ),
  trigger: "L’Attore vuole visualizzare delle specifiche credenziali API",
  main-scen: (
    (descr: "L’attore visualizza il timestamp di creazione delle credenziali"),
  ),
)
