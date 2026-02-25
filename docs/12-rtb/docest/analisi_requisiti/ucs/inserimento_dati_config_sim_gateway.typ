#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

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

#uc(
  system: SIM_SYS,
  id: "sel_sn_gateway",
  level: 3,
  title: "Selezione Serial Number Gateway",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Il Sistema mostra all'Attore la lista dei Serial Number disponibili per la simulazione",
  ),
  postconds: (
    "L'Attore ha selezionato un Serial Number valido",
  ),
  main-scen: (
    (descr: "L'Attore seleziona il Serial Number desiderato"),
  ),
)

#uc(
  system: SIM_SYS,
  id: "sel_modello_gateway",
  level: 3,
  title: "Selezione Modello Gateway",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Il Sistema mostra all'Attore la lista dei modelli di Gateway disponibili",
  ),
  postconds: (
    "L'Attore ha selezionato un modello di Gateway valido",
  ),
  main-scen: (
    (descr: "L'Attore seleziona il modello desiderato"),
  ),
)

#uc(
  system: SIM_SYS,
  id: "sel_versione_sw_gateway",
  level: 3,
  title: "Selezione Versione Software Gateway",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Il Sistema mostra all'Attore la lista delle versioni software compatibili e disponibili",
  ),
  postconds: (
    "L'Attore ha selezionato una versione software valida",
  ),
  main-scen: (
    (descr: "L'Attore seleziona la versione desiderata"),
  ),
)
