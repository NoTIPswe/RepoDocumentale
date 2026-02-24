#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "monitoraggio_performance_sistema",
  system: CLOUD_SYS,
  title: "Monitoraggio performance Sistema",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il Sistema si trova nella sezione dedicata al monitoraggio del Sistema",
  ),
  postconds: (
    "Le informazioni di monitoraggio delle performance del Sistema sono visualizzate correttamente",
  ),
  trigger: "Si desidera monitorare le prestazioni complessive del Sistema",
  main-scen: (
    (
      descr: "L’Attore monitora la latenza del Sistema",
      inc: "monitoraggio_latenza",
    ),
    (
      descr: "L’Attore monitora i volumi di traffico del Sistema",
      inc: "monitoraggio_volumi_traffico",
    ),
    (
      descr: "L’Attore monitora lo storage utilizzato dal Sistema",
      inc: "monitoraggio_storage",
    ),
  ),

  uml-descr: "Diagramma Monitoraggio performance Sistema",
)
