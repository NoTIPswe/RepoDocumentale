#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_singolo_utente_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione singolo utente del tenant",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’attore primario si trova nella sezione dedicata alla Gestione del Tenant",
    "L’Attore primario sta visualizzando la lista Utenti del Tenant",
  ),
  postconds: (
    "L’Attore principale visualizza il singolo utente",
  ),
  trigger: "L’attore principale vuole visualizzare un singolo utente del tenant",
  main-scen: (
    (
      descr: "L’attore visualizza il ruolo dell’utente (Utente o Amministratore)",
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
)