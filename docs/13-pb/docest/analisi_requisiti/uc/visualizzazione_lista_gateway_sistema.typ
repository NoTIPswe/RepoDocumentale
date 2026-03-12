#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "visualizzazione_lista_gateway_sistema",
  system: CLOUD_SYS,
  title: "Visualizzazione lista Gateway Sistema",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L'Attore è autenticato e ha accesso autorizzato alle risorse del Sistema",
  ),
  postconds: (
    "Il Sistema mostra l'elenco dei Gateway conosciuti dal Sistema",
  ),
  main-scen: (
    (
      descr: "L’Attore richiede la visualizzazione dell’elenco dei Gateway.",
      inc: "visualizzazione_singolo_gateway_sistema",
    ),
  ),
  uml-descr: "Diagramma Visualizzazione lista Gateway Sistema",
)
