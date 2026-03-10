#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "visualizzazione_id_tenant_gateway_provisionato",
  system: CLOUD_SYS,
  title: "Visualizzazione ID Tenant Gateway provisionato",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L'Attore è autenticato e ha accesso autorizzato alle risorse del Sistema",
  ),
  postconds: (
    "Il Sistema mostra l'ID del Tenant associato al Gateway provisionato",
  ),
  main-scen: (
    (
      descr: "L'Attore visualizza l'ID del Tenant associato al Gateway",
    ),
  ),
)
