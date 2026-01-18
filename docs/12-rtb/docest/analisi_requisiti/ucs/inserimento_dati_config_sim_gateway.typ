#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  system: SIM_SYS,
  id: "inserimento_dati_config_sim_gateway",
  level: 2,
  title: "Inserimento dati configurazione simulazione gateway",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Il Sistema si trova nella sezione di configurazione del gateway simulato",
  ),
  postconds: (
    "L’Attore ha inserito dati validi per la configurazione della simulazione di un Gateway",
  ),
  trigger: "All’Attore viene richiesto di inserire dati di configurazione per la simulazione di un Gateway",
  main-scen: (
    (
      descr: "L'Attore seleziona il serial number del Gateway tra quelli a disposizione",
    ),
    (
      descr: "L'Attore seleziona il modello del Gateway tra quelli a disposizione",
    ),
    (
      descr: "L'Attore seleziona la versione del software del Gateway tra quelli a disposizione",
    ),
  ),
)