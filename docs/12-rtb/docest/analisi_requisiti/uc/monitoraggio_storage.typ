#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "monitoraggio_storage",
  system: CLOUD_SYS,
  title: "Monitoraggio Storage",
  level: 2,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il Sistema si trova nella sezione dedicata al monitoraggio del Sistema",
    "Il Sistema di monitoraggio dello storage risulta attivo",
  ),
  postconds: (
    "Le informazioni relative allo storage del Sistema sono visualizzate correttamente",
  ),
  trigger: "Si desidera monitorare l’utilizzo dello storage del Sistema",
  main-scen: (
    (
      descr: "L’Attore primario visualizza le informazioni relative all’utilizzo dello storage del Sistema in forma tabellare",
    ),
    (
      descr: "L’Attore primario visualizza un grafico relativo alle informazioni relative all’utilizzo dello storage del Sistema",
    ),
  ),
)
