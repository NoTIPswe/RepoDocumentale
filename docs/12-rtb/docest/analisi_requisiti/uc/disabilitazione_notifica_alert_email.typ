#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "disabilitazione_notifica_alert_email",
  system: CLOUD_SYS,
  title: "Disabilitazione notifica alert via email",
  level: 2,
  gen-parent: "modifica_impostazioni_notifica_alert_email",
  prim-actors: CA.tenant-usr,
  preconds: (
    "L'Attore sta visualizzando le preferenze e la ricezione via email è attualmente attivata",
  ),
  postconds: (
    "L'Attore smetterà di ricevere email di notifica ",
  ),
  trigger: "L’Attore sceglie di disattivare la ricezione di alert via email",
  main-scen: (
    (descr: "L’Attore imposta la preferenza su 'Disattivo' (OFF)"),
  ),
)