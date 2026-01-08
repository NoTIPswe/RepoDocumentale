#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "inserimento_nome_utente",
  system: CLOUD_SYS,
  title: "Inserimento nome utente",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’Attore primario si trova nella sezione dedicata alla gestione del proprio tenant",
    "L’Attore primario vuole creare un nuovo utente associato al proprio tenant",
    "Il sistema necessita di un nome da associare al nuovo utente",
  ),
  postconds: (
    "L’Attore principale assegna un nome all’Utente",
  ),
  trigger: "L’Attore vuole dare un nome ad un nuovo utente creato",
  main-scen: (
    (descr: "L'Attore inserisce un nome per le nuovo utente in creazione"),
  ),
)
