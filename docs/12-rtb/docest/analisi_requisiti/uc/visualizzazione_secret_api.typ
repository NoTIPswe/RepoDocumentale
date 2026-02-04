#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_secret_api",
  system: CLOUD_SYS,
  title: "Visualizzazione Client Secret",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Tenant",
    "Il Tenant risulta attivo",
    "Al Tenant risulta associato un Client ID",
  ),
  postconds: (
    "La chiave segreta è stata mostrata a video; il Sistema non permetterà una seconda visualizzazione in futuro",
  ),
  trigger: "Fase finale della creazione delle credenziali API",
  main-scen: (
    (descr: "L’Attore visualizza la chiave segreta (Client Secret)"),
    (
      descr: "L’Attore viene informato del fatto che si tratta dell'unica occasione per visualizzare e copiare la chiave",
    ),
  ),
)
