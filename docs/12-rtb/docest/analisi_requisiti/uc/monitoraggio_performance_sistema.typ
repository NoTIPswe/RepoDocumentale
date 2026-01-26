#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "monitoraggio_performance_sistema",
  system: CLOUD_SYS,
  title: "Monitoraggio performance sistema",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il Sistema si trova nella sezione dedicata al monitoraggio del sistema",
  ),
  postconds: (
    "Le informazioni di monitoraggio delle performance del sistema sono visualizzate correttamente",
  ),
  trigger: "Si desidera monitorare le prestazioni complessive del sistema",
  main-scen: (
    (
      descr: "L’Attore monitora la latenza del sistema",
      inc: "monitoraggio_latenza",
    ),
    (
      descr: "L’Attore monitora i volumi di traffico del sistema",
      inc: "monitoraggio_volumi_traffico",
    ),
    (
      descr: "L’Attore monitora lo storage utilizzato dal sistema",
      inc: "monitoraggio_storage",
    ),
  ),
)[#uml-schema("97", "Monitoraggio performance Sistema")]
