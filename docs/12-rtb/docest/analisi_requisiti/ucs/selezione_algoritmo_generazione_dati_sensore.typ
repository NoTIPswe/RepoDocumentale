#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "selezione_algoritmo_generazione_dati_sensore",
  level: 3,
  title: "Selezione algoritmo di generazione dati sensore",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’Attore primario si trova nella sezione di Gestione Gateway simulato",
    "È stato selezionato un Gateway simulato esistente",
  ),
  postconds: (
    "L’Attore ha selezionato un algoritmo di generazione",
  ),
  trigger: "L’Attore vuole decidere in che modo i dati verranno creati",
  main-scen: (
    (descr: "L’Attore seleziona un algoritmo di generazione tra quelli disponibili"),
  ),
)
