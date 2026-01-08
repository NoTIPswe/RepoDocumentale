#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "lista_gateway",
  system: CLOUD_SYS,
  title: "Visualizzazione lista gateway",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L'attore primario è autenticato e ha accesso autorizzato alle risorse del proprio Tenant",
  ),
  postconds: (
    "L'attore primario visualizza l'elenco di tutti i gateway associati al suo Tenant",
  ),
  trigger: "L'attore primario vuole visualizzare i gateway del proprio tenant",
  main-scen: (
    (descr: "L'attore accede alla sezione dedicata alla visualizzazione dei dispositivi"),
    (
      descr: "L'attore visualizza la lista dei gateway associati al proprio tenant",
      inc: "visualizzazione_singolo_gateway",
    ),
  ),
)[
  #uml-schema("18", "Visualizzazione lista gateway")

]
