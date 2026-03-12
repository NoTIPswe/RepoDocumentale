#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "visualizzazione_id_tenant_gateway",
  system: CLOUD_SYS,
  title: "Visualizzazione ID Tenant Gateway",
  level: 3,
  prim-actors: CA.sys-adm,
  preconds: (
    "L'Attore è autenticato e ha accesso autorizzato alle risorse del Sistema",
  ),
  postconds: (
    "Il Sistema mostra l'ID del Tenant associato al Gateway",
  ),
  main-scen: (
    (
      descr: "L'Attore visualizza l'ID del Tenant associato al Gateway",
    ),
  ),
  specialized-by: ("visualizzazione_id_tenant_gateway_nd", "visualizzazione_id_tenant_gateway_provisionato"),
  uml-descr: "Diagramma Visualizzazione ID Tenant Gateway",
)
