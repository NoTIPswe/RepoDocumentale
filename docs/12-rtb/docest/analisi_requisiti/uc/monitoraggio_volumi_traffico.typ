#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "monitoraggio_volumi_traffico",
  system: CLOUD_SYS,
  title: "Monitoraggio Volumi di Traffico",
  level: 2,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’Attore primario si trova nella sezione dedicata al monitoraggio del sistema",
    "Il sistema di monitoraggio dei volumi di traffico risulta attivo",
  ),
  postconds: (
    "Le informazioni relative ai volumi di traffico del sistema sono visualizzate correttamente",
  ),
  trigger: "Si desidera monitorare i volumi di traffico del sistema",
  main-scen: (
    (descr: "L’Attore primario visualizza l’andamento dei volumi di traffico del sistema in forma tabellare"),
    (descr: "L’Attore primario visualizza un grafico di andamento dei volumi di traffico del sistema"),
  ),
)
