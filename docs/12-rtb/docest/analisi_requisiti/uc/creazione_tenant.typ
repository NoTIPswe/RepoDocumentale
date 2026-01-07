#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "creazione_tenant",
  system: CLOUD_SYS,
  title: "Creazione Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’attore primario si trova nella sezione dedicata alla creazione di Tenant",
  ),
  postconds: (
    "Il Tenant è stato creato correttamente all’interno del sistema",
    "I dati anagrafici sono stati salvati",
    "I namespace relativi al Tenant sono stati creati in ogni livello del flusso di dati",
  ),
  trigger: "L'Amministratore di Sistema deve registrare un nuovo cliente (Tenant)",
  main-scen: (
    (descr: "L’attore inizia la procedura di creazione Tenant"),
    (
      descr: "L’attore inserisce i dati anagrafici relativi al Tenant",
      inc: "inserimento_anagrafica_tenant",
    ),
    (
      descr: "L’attore crea l’account dell’Owner del Tenant",
      inc: "creazione_utente_tenant",
    ),
    (
      descr: "L’attore visualizza il resoconto della procedura di creazione",
      inc: "visualizzazione_dettagli_tenant",
    ),
    (
      descr: "L’attore conferma la volontà di avviare la creazione",
      ep: "ErroreInternoCreazione",
    ),
    (descr: "L’attore viene informato alla fine della procedura della corretta creazione"),
  ),
  alt-scen: (
    (
      ep: "ErroreInternoCreazione",
      cond: "Si verifica un errore interno durante la procedura di creazione del Tenant",
      uc: "err_interno_creazione_tenant",
    ),
  ),
)