#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "visualizzazione_id_fabbrica_gateway_sistema",
  system: CLOUD_SYS,
  title: "Visualizzazione ID fabbrica Gateway",
  level: 2,
  prim-actors: CA.sys-adm,
  preconds: (
    "L'Attore è autenticato e ha accesso autorizzato alle risorse del Sistema",
  ),
  postconds: (
    "Il Sistema mostra l'ID di fabbrica del Gateway",
  ),
  main-scen: (
    (
      descr: "L'Attore visualizza l'ID di fabbrica del Gateway",
    ),
  ),
)
