#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_lista_utenti_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione lista Utenti del Tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’attore primario si trova nella sezione dedicata alla Gestione del Tenant",
  ),
  postconds: (
    "L’attore visualizza la lista degli Utenti associati al Tenant selezionato",
  ),
  trigger: "L’attore vuole visualizzare gli Utenti associati al proprio tenant",
  main-scen: (
    (
      descr: "L’attore visualizza la lista di utenti del tenant",
      inc: "visualizzazione_singolo_utente_tenant",
    ),
  ),
)[#uml-schema("49", "Visualizzazione lista Utenti del Tenant")]
