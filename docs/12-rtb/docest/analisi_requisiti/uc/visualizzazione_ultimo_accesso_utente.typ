#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_ultimo_accesso_utente",
  system: CLOUD_SYS,
  title: "Visualizzazione ultimo accesso dell’utente",
  level: 3,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’attore primario si trova nella sezione dedicata alla Gestione del Tenant",
    "L’Attore primario sta visualizzando la lista Utenti del Tenant",
    "Il sistema ha a disposizione il timestamp relativo all'ultima sessione valida creata dall'utente",
  ),
  postconds: (
    "La data e l’ora dell'ultimo accesso vengono visualizzate",
  ),
  trigger: "Necessità di monitorare l'attività recente dell'utente nel sistema",
  main-scen: (
    (descr: "L’attore visualizza il timestamp dell'ultimo accesso effettuato dall'utente"),
  ),
)