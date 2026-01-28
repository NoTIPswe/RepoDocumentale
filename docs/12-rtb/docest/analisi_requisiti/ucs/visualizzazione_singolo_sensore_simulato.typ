#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  system: SIM_SYS,
  id: "visualizzazione_singolo_sensore_simulato",
  level: 2,
  title: "Visualizzazione singolo sensore simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Il Sistema si trova nella sezione dedicata alla visualizzazione dei sensori del Gateway simulato selezionato",
    "Esiste un sensore che è stato selezionato di cui si vogliono visualizzare i dettagli",
  ),
  postconds: (
    "L’Attore visualizza i dettagli della entry selezionata dalla lista dei sensori simulati relativi al Gateway selezionato",
  ),
  trigger: "L’Attore vuole visualizzare dettagli utili ad identificare un sensore relativo ad un gateway simulato",
  main-scen: (
    (
      descr: "L’Attore visualizza l’identificativo del sensore",
      inc: "visualizzazione_identificativo_sensore",
    ),
    (
      descr: "L’Attore visualizza il tipo di sensore",
      inc: "visualizzazione_tipo_sensore_simulato",
    ),
  ),
)[
  #uml-schema("S4.1", "Visualizzazione singolo sensore simulato")
]

