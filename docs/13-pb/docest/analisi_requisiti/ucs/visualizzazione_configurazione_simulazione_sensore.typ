#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_configurazione_simulazione_sensore",
  level: 1,
  title: "Visualizzazione configurazione simulazione sensore",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Esiste un sensore che è stato selezionato di cui si vogliono visualizzare i dettagli di configurazione della simulazione",
  ),
  postconds: (
    "L’Attore visualizza i dati di configurazione del sensore selezionato",
  ),
  trigger: "L’Attore vuole visualizzare i dettagli di configurazione del sensore selezionato",
  main-scen: (
    (
      descr: "L'Attore seleziona il sensore simulato desiderato",
    ),
    (
      descr: "L’Attore visualizza l’identificativo del sensore",
      inc: "visualizzazione_identificativo_sensore",
    ),
    (
      descr: "L’Attore visualizza il tipo di sensore",
      inc: "visualizzazione_tipo_sensore_simulato",
    ),
    (
      descr: "L’Attore visualizza il range di generazione dei dati",
      inc: "visualizzazione_range_generazione_dati",
    ),
    (
      descr: "L’Attore visualizza l’algoritmo di generazione dei dati",
      inc: "visualizzazione_algoritmo_generazione_dati",
    ),
  ),

  uml-descr: "Diagramma Visualizzazione configurazione simulazione sensore",
)

