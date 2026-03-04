#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_ultimo_accesso_utente",
  system: CLOUD_SYS,
  title: "Visualizzazione ultimo accesso dell’Utente",
  level: 3,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Utente associato al Tenant",
    "Il Sistema sta mostrando la lista di Utenti associati al Tenant",
    "I dati dell'Utente sono visibili",
  ),
  postconds: (
    "L'Attore visualizza il timestamp dell'ultimo accesso dell'Utente",
  ),
  trigger: "L'Attore vuole visualizzare l'ultimo accesso dell'Utente",
  main-scen: (
    (descr: "L’Attore visualizza la data e ora dell'ultimo accesso effettuato dall'Utente"),
  ),
)
