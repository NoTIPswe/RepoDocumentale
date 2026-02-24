#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "modifica_impostazioni_notifica_alert_dashboard",
  system: CLOUD_SYS,
  title: "Modifica impostazioni notifica alert via dashboard",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema sta mostrando le preferenze impostate per la ricezione delle notifiche di alert via dashboard",
  ),
  postconds: (
    "Il Sistema salva le preferenze di ricezione alert",
  ),
  trigger: "L’Attore vuole di attivare/disattivare la ricezione di alert via dashboard",
  main-scen: (
    (descr: "L’Attore esprime la preferenza di ricezione notifiche via dashboard (on/off)"),
    (descr: "Il Sistema salva le preferenze"),
  ),

  uml-descr: "Diagramma Modifica impostazioni notifica alert via dashboard",
)
