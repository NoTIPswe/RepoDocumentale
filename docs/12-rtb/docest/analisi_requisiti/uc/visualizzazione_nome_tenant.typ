#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_nome_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione nome Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’attore si trova nella sezione dedicata alla visualizzazione dei Tenant",
  ),
  postconds: (
    "L’attore visualizza il nome identificativo del Tenant",
  ),
  trigger: "Necessità da parte dell’attore di riconoscere il Tenant tramite il suo nome",
  main-scen: (
    (descr: "L’attore visualizza il nome del Tenant"),
  ),
)