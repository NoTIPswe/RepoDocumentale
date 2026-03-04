#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "inserimento_nome_utente",
  system: CLOUD_SYS,
  title: "Inserimento nome Utente",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il Sistema sta mostrando la pagina di gestione del Tenant",
    "Il Sistema sta attendendo l'inserimento dei dati per la creazione Utente da parte dell'Attore",
  ),
  postconds: (
    "L’Attore principale assegna un nome all’Utente",
  ),
  trigger: "L’Attore vuole dare un nome ad un nuovo Utente creato",
  main-scen: (
    (descr: "L'Attore inserisce un nome per le nuovo Utente in creazione"),
  ),
)
