#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "modifica_impostazioni_notifica_alert_email",
  system: CLOUD_SYS,
  title: "Modifica impostazioni notifica alert via email",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L’attore primario si trova nella sezione dedicata agli alert",
  ),
  postconds: (
    "Il sistema salva le preferenze di ricezione alert",
  ),
  trigger: "L’attore primario decide di attivare/disattivare la ricezione di alert via email",
  main-scen: (
    (descr: "L’attore primario esprime la preferenza di ricezione notifiche via email (on/off)"),
    (descr: "Il sistema salva le preferenze"),
  ),
)
