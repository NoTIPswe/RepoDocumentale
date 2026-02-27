#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_singole_api",
  system: CLOUD_SYS,
  title: "Visualizzazione singole credenziali API del Tenant",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Tenant",
    "Il Tenant risulta attivo",
    "Al Tenant risulta associato almeno un client ID e una Secret API",
    "Il Sistema sta mostrando la lista di API associate al Tenant",
  ),
  postconds: (
    "L’Attore visualizza delle specifiche credenziali API",
  ),
  trigger: "L’Attore vuole visualizzare delle specifiche credenziali API",
  main-scen: (
    (
      descr: "L’Attore visualizza il nome descrittivo delle credenziali",
      inc: "visualizzazione_nome_descrittivo_api",
    ),
    (
      descr: "L’Attore visualizza il Client ID delle credenziali",
      inc: "visualizzazione_client_id",
    ),
    (
      descr: "L’Attore visualizza la mail dell’Utente che ha creato le credenziali",
      inc: "visualizzazione_mail_utente",
    ),
    (
      descr: "L’Attore visualizza il timestamp di creazione delle credenziali",
      inc: "visualizzazione_timestamp_api",
    ),
  ),

  uml-descr: "Diagramma Visualizzazione singole credenziali API del Tenant",
)
