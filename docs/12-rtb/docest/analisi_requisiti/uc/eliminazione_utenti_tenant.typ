#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "eliminazione_utenti_tenant",
  system: CLOUD_SYS,
  title: "Eliminazione Utenti del Tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Tra gli utenti che si vogliono eliminare non è presente l’Owner del Tenant",
    "L’Attore principale sta visualizzando la lista di Utenti del Tenant",
  ),
  postconds: (
    "Gli Utenti selezionati sono stati eliminati con successo",
  ),
  trigger: "L’attore principale vuole eliminare uno o più utenti del tenant",
  main-scen: (
    (
      descr: "L’Attore principale seleziona uno o più utenti del Tenant da eliminare",
      inc: "selezione_lista_utenti",
    ),
    (descr: "L’attore conferma l’eliminazione"),
    (descr: "L’Attore viene informato del buon esito dell’operazione"),
  ),
)[#uml-schema("57", "Eliminazione Utente del Tenant")]
