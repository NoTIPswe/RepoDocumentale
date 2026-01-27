#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_client_id",
  system: CLOUD_SYS,
  title: "Visualizzazione Client ID",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Tenant",
    "Il Tenant risulta attivo",
    "Al Tenant risulta associato un Client ID",
  ),
  postconds: (
    "L’Attore visualizza la stringa identificativa",
  ),
  trigger: "L'Attore vuole visualizzare il Client ID di alcune credenziali API",
  main-scen: (
    (descr: "Il Sistema mostra a video la stringa alfanumerica corrispondente al Client ID"),
  ),
)[#uml-schema("60", "Diagramma Visualizzazione Client ID")]
