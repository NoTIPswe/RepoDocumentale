#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "creazione_utente_tenant",
  system: CLOUD_SYS,
  title: "Creazione Utente del Tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’Attore primario si trova nella sezione dedicata alla gestione del proprio tenant",
    "L’Attore primario vuole creare un nuovo utente associato al proprio tenant",
  ),
  postconds: (
    "L’Attore primario ha creato con successo l’Utente",
  ),
  trigger: "L’attore principale vuole creare un nuovo Utente del tenant",
  main-scen: (
    (
      descr: "L’attore inserisce il nome dell’utente",
      inc: "inserimento_nome_utente",
    ),
    (
      descr: "L’attore seleziona i permessi dell’utente",
      inc: "selezione_permessi_utente",
    ),
    (
      descr: "L’attore inserisce e conferma la mail dell’utente",
      inc: "ins_conf_password",
    ),
    (
      descr: "L’attore inserisce e conferma la password dell’utente",
      inc: "ins_conf_password",
    ),
    (descr: "L’attore salva le modifiche e crea l’utente"),
  ),
)