#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "creazione_utente_tenant",
  system: CLOUD_SYS,
  title: "Creazione Utente del Tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il Sistema sta mostrando la pagina di gestione del Tenant",
    "Il Sistema sta attendendo l'inserimento dei dati per la creazione Utente da parte dell'Attore",
  ),
  postconds: (
    "L’Attore ha creato con successo l’Utente",
  ),
  trigger: "L’Attore vuole creare un nuovo Utente del tenant",
  main-scen: (
    (
      descr: "L’Attore inserisce il nome dell’Utente",
      inc: "inserimento_nome_utente",
    ),
    (
      descr: "L’Attore seleziona i permessi dell’Utente",
      inc: "selezione_permessi_utente",
    ),
    (
      descr: "L’Attore inserisce e conferma la mail dell’Utente",
      inc: "inserimento_conferma_password",
    ),
    (
      descr: "L’Attore inserisce e conferma la password dell’Utente",
      inc: "inserimento_conferma_password",
    ),
    (descr: "L’Attore salva le modifiche e crea l’Utente"),
  ),
)[#uml-schema("51", "Creazione Utente del Tenant")]
