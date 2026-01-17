#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "monitoraggio_latenza",
  system: CLOUD_SYS,
  title: "Monitoraggio latenza",
  level: 2,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’Attore primario si trova nella sezione dedicata al monitoraggio del sistema",
    "Il sistema di monitoraggio della latenza risulta attivo",
  ),
  postconds: (
    "Le informazioni relative alla latenza media del sistema sono visualizzate correttamente",
  ),
  trigger: "Si desidera monitorare la latenza media del sistema",
  main-scen: (
    (descr: "L’Attore primario visualizza la latenza media del sistema"),
    (descr: "L’Attore primario visualizza l’andamento della latenza del sistema in forma tabellare"),
    (descr: "L’Attore visualizza un grafico di andamento della latenza del sistema"),
  ),
)
