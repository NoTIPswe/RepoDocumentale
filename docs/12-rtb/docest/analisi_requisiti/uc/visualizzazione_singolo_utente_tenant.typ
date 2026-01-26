#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_singolo_utente_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione singolo utente del tenant",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Utente associato al Tenant",
    "Il Sistema sta mostrando la lista di Utenti associati al Tenant",
    "I dati dell'Utente sono visibili",
  ),
  postconds: (
    "L’Attore principale visualizza il singolo Utente",
  ),
  trigger: "L’Attore principale vuole visualizzare un singolo utente del tenant",
  main-scen: (
    (
      descr: "L’Attore visualizza il ruolo dell’utente (Utente o Amministratore)",
      inc: "visualizzazione_ruolo_utente",
    ),
    (
      descr: "L'Attore visualizza il nome dell’utente",
      inc: "visualizzazione_nome_utente",
    ),
    (
      descr: "L’Attore visualizza la mail dell’utente",
      inc: "visualizzazione_mail_utente",
    ),
    (
      descr: "L’Attore visualizza la data di ultimo accesso dell’utente",
      inc: "visualizzazione_ultimo_accesso_utente",
    ),
  ),
)[#uml-schema("50.1", "Visualizzazione singolo Utente del Tenant")]
