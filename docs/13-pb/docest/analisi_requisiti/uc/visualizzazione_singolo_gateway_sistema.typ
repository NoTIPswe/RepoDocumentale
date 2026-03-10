#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "visualizzazione_singolo_gateway_sistema",
  system: CLOUD_SYS,
  title: "Visualizzazione singolo Gateway Sistema",
  level: 2,
  prim-actors: CA.sys-adm,
  preconds: (
    "L'Attore è autenticato e ha accesso autorizzato alle risorse del Sistema",
  ),
  postconds: (
    "Il Sistema mostra le informazioni relative al Gateway",
  ),
  main-scen: (
    (
      descr: "L'Attore visualizza l'id di fabbrica del Gateway",
      inc: "visualizzazione_id_fabbrica_gateway_sistema",
    ),
    (
      descr: "L'Attore visualizza l'id del Tenant a cui appartiene il Gateway",
      inc: "visualizzazione_id_tenant_gateway",
    ),
  ),
  uml-descr: "Diagramma Visualizzazione singolo Gateway Sistema",
)
