#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "abilitazione_notifica_alert_dashboard",
  system: CLOUD_SYS,
  title: "Abilitazione notifica alert via dashboard",
  level: 1,
  gen-parent: "modifica_impostazioni_notifica_alert_dashboard",
  prim-actors: CA.tenant-usr,
  preconds: (
    "L'attore sta visualizzando le preferenze e la ricezione via dashboard è attualmente disattivata",
  ),
  postconds: (
    "L'Attore riceverà notifiche di alert all'interno della dashboard",
  ),
  trigger: "L’Attore sceglie di attivare la ricezione di alert via dashboard",
  main-scen: (
    (descr: "L’Attore imposta la preferenza su 'Attivo' (ON)"),
  ),

  uml-descr: none,
)
