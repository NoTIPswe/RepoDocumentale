#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "inserimento_dati_config_sim_sensore",
  level: 2,
  title: "Inserimento dati configurazione simulazione sensore",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore primario si trova nella sezione di Gestione Gateway simulato",
    "È stato selezionato un Gateway simulato esistente",
  ),
  postconds: (
    "L’attore ha inserito dati validi per la configurazione della simulazione di un sensore",
  ),
  trigger: "All’attore viene richiesto di inserire dati di configurazione per la simulazione di un sensore",
  main-scen: (
    (
      descr: "L’attore principale seleziona il tipo di sensore",
      inc: "selezione_tipo_sensore_simulato",
    ),
    (
      descr: "L’attore inserisce il range di generazione dei dati",
      inc: "inserimento_range_generazione_dati",
    ),
    (
      descr: "L’attore seleziona l’algoritmo di generazione dei dati",
      inc: "selezione_algoritmo_generazione_dati_sensore",
    ),
    // bookamrk - ancora non li sappiamo
  ),
)
