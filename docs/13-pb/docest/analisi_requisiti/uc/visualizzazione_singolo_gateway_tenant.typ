#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "visualizzazione_singolo_gateway_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione singolo Gateway Tenant",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema mostra la lista dei Gateway associati al Tenant dell'Attore",
  ),
  postconds: (
    "L'Attore visualizza, nel singolo elemento della lista, nome e stato del Gateway",
  ),
  trigger: "Visualizzazione rapida di un dispositivo nella lista",
  main-scen: (
    (
      descr: "Il Sistema mostra il nome identificativo del Gateway",
      inc: "visualizzazione_nome_gateway_tenant",
    ),
    (
      descr: "Il Sistema mostra la condizione operativa attuale",
      inc: "visualizzazione_stato_gateway_tenant",
    ),
  ),

  uml-descr: "Diagramma Visualizzazione singolo Gateway Tenant",
)
