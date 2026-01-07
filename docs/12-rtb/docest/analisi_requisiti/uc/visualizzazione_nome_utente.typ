#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_nome_utente",
  system: CLOUD_SYS,
  title: "Visualizzazione nome dell’utente",
  level: 3,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’attore primario si trova nella sezione dedicata alla Gestione del Tenant",
    "L’Attore primario sta visualizzando la lista Utenti del Tenant",
    "I dati dell'utente sono disponibili",
  ),
  postconds: (
    "Il nome dell'utente è visibile",
  ),
  trigger: "Necessità di identificare l'utente con un nome",
  main-scen: (
    (descr: "L’attore visualizza il nome dell’utente"),
  ),
)