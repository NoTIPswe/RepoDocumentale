#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_client_id",
  system: CLOUD_SYS,
  title: "Visualizzazione Client ID",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il sistema ha generato l'identificativo univoco per il client",
  ),
  postconds: (
    "L’attore visualizza la stringa identificativa",
  ),
  trigger: "L'attore desidera visualizzare il Client ID di alcune credenziali API",
  main-scen: (
    (descr: "Il sistema mostra a video la stringa alfanumerica corrispondente al Client ID"),
  ),
)