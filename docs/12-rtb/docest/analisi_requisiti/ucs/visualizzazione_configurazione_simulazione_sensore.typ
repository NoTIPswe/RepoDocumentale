#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_configurazione_simulazione_sensore",
  level: 1,
  title: "Visualizzazione configurazione simulazione sensore",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore ha selezionato un sensore relativo ad un gateway simulato di cui visualizzare la configurazione della simulazione",
  ),
  postconds: (
    "L’attore visualizza i dati di configurazione del sensore selezionato",
  ),
  trigger: "L’attore vuole visualizzare i dettagli di configurazione del sensore selezionato",
  main-scen: (
    (
      descr: "L’attore visualizza l’identificativo del sensore",
      inc: "visualizzazione_identificativo_sensore",
    ),
    (
      descr: "L’attore visualizza il tipo di sensore",
      inc: "visualizzazione_tipo_sensore_simulato",
    ),
    (
      descr: "L’attore visualizza il range di generazione dei dati",
      inc: "visualizzazione_range_generazione_dati",
    ),
    (
      descr: "L’attore visualizza l’algoritmo di generazione dei dati",
      inc: "visualizzazione_algoritmo_generazione_dati",
    ),
  ),
)
