#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "eliminazione_utenti_tenant",
  system: CLOUD_SYS,
  title: "Eliminazione Utenti del Tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Utente associato al Tenant",
    "Il Sistema sta mostrando la lista di Utenti associati al Tenant",
  ),
  postconds: (
    "Gli Utenti selezionati sono stati eliminati con successo",
  ),
  trigger: "L’Attore vuole eliminare uno o più utenti del tenant",
  main-scen: (
    (
      descr: "L’Attore seleziona uno o più utenti del Tenant da eliminare",
      inc: "selezione_lista_utenti",
    ),
    (descr: "L’Attore conferma l’eliminazione"),
    (descr: "L’Attore viene informato del buon esito dell’operazione"),
  ),
)[#uml-schema("58", "Eliminazione Utente del Tenant")]
