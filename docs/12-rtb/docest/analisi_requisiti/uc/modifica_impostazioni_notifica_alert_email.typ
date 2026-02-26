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
    "Il Sistema salva le nuove preferenze di ricezione alert via email",
  ),
  trigger: "L’Attore vuole modificare lo stato della ricezione di alert via email",
  main-scen: (
    (descr: "L’Attore modifica la preferenza di ricezione notifiche via email"),
  ),
  specialized-by: ("abilitazione_notifica_alert_email", "disabilitazione_notifica_alert_email"),
  uml-descr: "Diagramma Modifica impostazioni notifica alert via email",
)
