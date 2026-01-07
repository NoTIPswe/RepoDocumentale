#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "monitoraggio_storage",
  system: CLOUD_SYS,
  title: "Monitoraggio Storage",
  level: 2,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’attore primario si trova nella sezione dedicata al monitoraggio del sistema",
    "Il sistema di monitoraggio dello storage risulta attivo",
  ),
  postconds: (
    "Le informazioni relative allo storage del sistema sono visualizzate correttamente",
  ),
  trigger: "Si desidera monitorare l’utilizzo dello storage del sistema",
  main-scen: (
    (
      descr: "L’attore primario visualizza le informazioni relative all’utilizzo dello storage del sistema in forma tabellare",
    ),
    (
      descr: "L’attore primario visualizza un grafico relativo alle informazioni relative all’utilizzo dello storage del sistema",
    ),
  ),
)
