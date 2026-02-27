#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "lista_gateway",
  system: CLOUD_SYS,
  title: "Visualizzazione lista Gateway",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L'Attore è autenticato e ha accesso autorizzato alle risorse del proprio Tenant",
  ),
  postconds: (
    "L'Attore visualizza l'elenco di tutti i Gateway associati al suo Tenant",
  ),
  trigger: "L'Attore vuole visualizzare i Gateway del proprio tenant",
  main-scen: (
    (descr: "L'Attore accede alla sezione dedicata alla visualizzazione dei dispositivi"),
    (
      descr: "L'Attore visualizza la lista dei Gateway associati al proprio tenant",
      inc: "visualizzazione_singolo_gateway",
    ),
  ),

  uml-descr: "Diagramma Visualizzazione lista Gateway",
)
