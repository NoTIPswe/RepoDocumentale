#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_singole_api",
  system: CLOUD_SYS,
  title: "Visualizzazione singole credenziali API del Tenant",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’Attore si trova nella sezione dedicata alla visualizzazione degli API token",
    "L’attore ha visualizzato la lista delle credenziali API",
  ),
  postconds: (
    "L’attore visualizza delle specifiche credenziali API",
  ),
  trigger: "L’Attore vuole visualizzare delle specifiche credenziali API",
  main-scen: (
    (
      descr: "L’attore visualizza il nome descrittivo delle credenziali",
      inc: "visualizzazione_nome_descrittivo_api",
    ),
    (
      descr: "L’attore visualizza il Client ID delle credenziali",
      inc: "visualizzazione_client_id",
    ),
    (
      descr: "L’attore visualizza la mail dell’utente che ha creato le credenziali",
      inc: "visualizzazione_mail_utente",
    ),
    (
      descr: "L’attore visualizza il timestamp di creazione delle credenziali",
      inc: "visualizzazione_timestamp_api",
    ),
  ),
)