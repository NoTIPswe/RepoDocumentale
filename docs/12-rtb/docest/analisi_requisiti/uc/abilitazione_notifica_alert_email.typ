#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "abilitazione_notifica_alert_email",
  system: CLOUD_SYS,
  title: "Abilitazione notifica alert via email",
  level: 1,
  gen-parent: "modifica_impostazioni_notifica_alert_email",
  prim-actors: CA.tenant-usr,
  preconds: (
    "L'attore sta visualizzando le preferenze e la ricezione via email è attualmente disattivata",
  ),
  postconds: (
    "L'Attore potrà ricevere mail di notifica",
  ),
  trigger: "L’Attore sceglie di attivare la ricezione di alert via email",
  main-scen: (
    (descr: "L’Attore imposta la preferenza su 'Attivo' (ON)"),
  ),
  uml-descr: none,
)
