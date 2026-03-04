#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_nome_utente",
  system: CLOUD_SYS,
  title: "Visualizzazione nome dell’Utente",
  level: 3,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Utente associato al Tenant",
    "Il Sistema sta mostrando la lista di Utenti associati al Tenant",
    "I dati dell'Utente sono visibili",
  ),
  postconds: (
    "L'Attore visualizza il nome dell'Utente",
  ),
  trigger: "L'Attore vuole visualizzare il nome dell'Utente",
  main-scen: (
    (descr: "L’Attore visualizza il nome dell’Utente"),
  ),
)
