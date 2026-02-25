#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "disabilitazione_notifica_alert_dashboard",
  system: CLOUD_SYS,
  title: "Disabilitazione notifica alert via dashboard",
  level: 2,
  gen-parent: "modifica_impostazioni_notifica_alert_dashboard",
  prim-actors: CA.tenant-usr,
  preconds: (
    "L'Attore sta visualizzando le preferenze e la ricezione via dashboard è attualmente attivata",
  ),
  postconds: (
    "L'Attore smetterà di ricevere notifiche di alert all'interno della dashboard",
  ),
  trigger: "L’Attore sceglie di disattivare la ricezione di alert via dashboard",
  main-scen: (
    (descr: "L’Attore imposta la preferenza su 'Disattivo' (OFF)"),
  ),

  uml-descr: none,
)