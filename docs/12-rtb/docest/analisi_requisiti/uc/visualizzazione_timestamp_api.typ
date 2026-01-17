#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_timestamp_api",
  system: CLOUD_SYS,
  title: "Visualizzazione timestamp creazione credenziali API",
  level: 3,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Tenant",
    "Il Tenant risulta attivo",
    "Al Tenant risulta associato almeno un client ID e una Secret API",
    "Il Sistema sta mostrando la lista di API associate al Tenant",
  ),
  postconds: (
    "L’Attore visualizza il timestamp di creazione di specifiche credenziali API",
  ),
  trigger: "L’Attore vuole visualizzare delle specifiche credenziali API",
  main-scen: (
    (descr: "L’Attore visualizza il timestamp di creazione delle credenziali"),
  ),
)
