#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_ruolo_utente",
  system: CLOUD_SYS,
  title: "Visualizzazione ruolo dell’utente",
  level: 3,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’attore primario si trova nella sezione dedicata alla Gestione del Tenant",
    "L’Attore primario sta visualizzando la lista Utenti del Tenant",
    "Il sistema ha identificato il livello di permessi associato dell'utente selezionato",
  ),
  postconds: (
    "Il ruolo dell'utente è visibile",
  ),
  trigger: "Necessità di visualizzare i privilegi di accesso di un utente",
  main-scen: (
    (descr: "L’attore visualizza il corrispondente ruolo dell’Utente"),
  ),
)
