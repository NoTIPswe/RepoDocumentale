#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "esportazione_dati_json",
  system: CLOUD_SYS,
  title: "Esportazione dati in formato JSON",
  gen-parent: "esportazione_dati",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema mostra i dati che l’Attore ha richiesto di visualizzare",
    "L'Attore ha selezionato il formato JSON per l'esportazione",
  ),
  postconds: (
    "I dati vengono salvati localmente sul dispositivo dell'Attore in un file .json",
  ),
  trigger: "L’Attore conferma la volontà di scaricare i dati in JSON",
  main-scen: (
    (descr: "L'Attore ottiene i dati formattati in un file .json di cui ha richiesto il download"),
  ),
)
