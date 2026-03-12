#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "visualizzazione_id_tenant_gateway_nd",
  system: CLOUD_SYS,
  title: "Visualizzazione ID Tenant Gateway non associato",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L'Attore è autenticato e ha accesso autorizzato alle risorse del Sistema",
  ),
  postconds: (
    "Il Sistema mostra che il Gateway non è associato ad alcun Tenant",
  ),
  main-scen: (
    (
      descr: "L'Attore viene informato che il Gateway non è associato ad alcun Tenant",
    ),
  ),
)
