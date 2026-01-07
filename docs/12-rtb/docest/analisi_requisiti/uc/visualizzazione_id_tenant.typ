#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_id_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione ID Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’attore primario si trova nella sezione dedicata alla visualizzazione dei Tenant",
  ),
  postconds: (
    "L’attore visualizza l’identificativo univoco del Tenant",
  ),
  trigger: "Necessità di conoscere l'identificativo del Tenant",
  main-scen: (
    (descr: "L’attore visualizza l’ID univoco associato al Tenant"),
  ),
)
