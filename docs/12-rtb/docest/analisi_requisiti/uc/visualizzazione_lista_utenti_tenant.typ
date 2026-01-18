#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_lista_utenti_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione lista Utenti del Tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Utente associato al Tenant",
    "Il Sistema sta mostrando la lista di Utenti associati al Tenant",
  ),
  postconds: (
    "L’Attore visualizza la lista degli Utenti associati al Tenant selezionato",
  ),
  trigger: "L’Attore vuole visualizzare gli Utenti associati al proprio tenant",
  main-scen: (
    (
      descr: "L’Attore visualizza la lista di utenti del tenant",
      inc: "visualizzazione_singolo_utente_tenant",
    ),
  ),
)[#uml-schema("49", "Visualizzazione lista Utenti del Tenant")]
