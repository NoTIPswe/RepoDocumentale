#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_lista_api",
  system: CLOUD_SYS,
  title: "Visualizzazione lista credenziali API del Tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Tenant",
    "Il Tenant risulta attivo",
    "Al Tenant risulta associato almeno un client ID e una Secret API",
    "Il Sistema sta mostrando la lista di API associate al Tenant",
  ),
  postconds: (
    "L’Attore visualizza le credenziali API relative al Tenant",
  ),
  trigger: "L’Attore vuole visualizzare gli API token",
  main-scen: (
    (
      descr: "L’Attore visualizza la lista di tutte le credenziali API relative al Tenant",
      inc: "visualizzazione_singole_api",
    ),
  ),
)[#uml-schema("61", "Visualizzazione lista credenziali API del Tenant")]
