#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_timestamp_ultimo_invio_dati_sensore",
  system: CLOUD_SYS,
  title: "Visualizzazione timestamp ultimo invio dati sensore",
  level: 4,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il sistema mostra all'Attore primario la lista dei sensori collegati ad un Gateway",
  ),
  postconds: (
    "L’Attore primario visualizza timestamp ultima lettura del sensore",
  ),
  trigger: "Viene richiesta la lista dei sensori collegati al Gateway",
  main-scen: (
    (descr: "L’Attore primario visualizza il timestamp associato all'ultimo dato ricevuto dal sensore"),
  ),
)
