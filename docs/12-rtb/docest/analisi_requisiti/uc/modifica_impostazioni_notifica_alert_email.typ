#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "modifica_impostazioni_notifica_alert_email",
  system: CLOUD_SYS,
  title: "Modifica impostazioni notifica alert via email",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema sta mostrando le preferenze impostate per la ricezione delle notifiche di alert via email",
  ),
  postconds: (
    "Il Sistema salva le preferenze di ricezione alert",
  ),
  trigger: "L’Attore vuole attivare/disattivare la ricezione di alert via email",
  main-scen: (
    (descr: "L’Attore esprime la preferenza di ricezione notifiche via email (on/off)"),
    (descr: "Il Sistema salva le preferenze"),
  ),

  uml-descr: "Diagramma Modifica impostazioni notifica alert via email",
)
