#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_singolo_utente_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione singolo Utente del Tenant",
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
  trigger: "L’Attore principale vuole visualizzare un singolo utente del Tenant",
  main-scen: (
    (
      descr: "L’Attore visualizza il ruolo dell’Utente (Utente o Amministratore)",
      inc: "visualizzazione_ruolo_utente",
    ),
    (
      descr: "L'Attore visualizza il nome dell’Utente",
      inc: "visualizzazione_nome_utente",
    ),
    (
      descr: "L’Attore visualizza la mail dell’Utente",
      inc: "visualizzazione_mail_utente",
    ),
    (
      descr: "L’Attore visualizza la data di ultimo accesso dell’Utente",
      inc: "visualizzazione_ultimo_accesso_utente",
    ),
  ),

  uml-descr: "Diagramma Visualizzazione singolo Utente del Tenant",
)
