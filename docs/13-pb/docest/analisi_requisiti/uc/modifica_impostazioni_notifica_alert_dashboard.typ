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
    "Il Sistema salva le nuove preferenze di ricezione alert via dashboard",
  ),
  trigger: "L’Attore vuole modificare lo stato della ricezione di alert via dashboard",
  main-scen: (
    (descr: "L’Attore modifica la preferenza di ricezione notifiche via dashboard"),
  ),
  specialized-by: ("abilitazione_notifica_alert_dashboard", "disabilitazione_notifica_alert_dashboard"),

  uml-descr: "Diagramma Modifica impostazioni notifica alert via dashboard",
)
