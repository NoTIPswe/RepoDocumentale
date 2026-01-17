#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "impersonificazione_utente_tenant",
  system: CLOUD_SYS,
  title: "Impersonificazione Utenti Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’Attore si trova nella sezione di Visualizzazione Tenant",
    "L’Attore seleziona un Tenant",
    "L’Attore è entrato nella relativa sezione di Gestione",
  ),
  postconds: (
    "La sessione di impersonificazione è stata avviata correttamente",
    "L’Attore visualizza l’applicazione con un insieme di funzionalità equiparabile a quello dell’Utente Tenant impersonificato",
  ),
  trigger: "Si desidera operare/verificare funzionalità e configurazioni di un Tenant dal punto di vista di un Utente Tenant",
  main-scen: (
    (descr: "L’Attore primario seleziona l’opzione di impersonificazione di un Utente per il Tenant selezionato"),
    (descr: "L’Attore viene reindirizzato nell’ambiente applicativo come “Utente Tenant” o “Amministratore Tenant”"),
    (descr: "L’Attore utilizza le funzionalità disponibili, nel rispetto dei permessi dell’Utente impersonificato"),
  ),
)[#uml-schema("91", "Impersonificazione Utenti Tenant")]
