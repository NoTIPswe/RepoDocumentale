#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_lista_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione lista Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’Attore primario si trova nella sezione dedicata alla visualizzazione dei Tenant",
  ),
  postconds: (
    "L’Attore primario visualizza l’elenco completo dei Tenant registrati nel sistema",
  ),
  trigger: "L’Attore primario vuole consultare l’elenco dei Tenant per attività di gestione o monitoraggio",
  main-scen: (
    (
      descr: "L’Attore primario visualizza la lista dei Tenant del sistema",
      inc: "visualizzazione_singolo_tenant",
    ),
  ),
)[#uml-schema("78", "Visualizzazione lista Tenant")]
