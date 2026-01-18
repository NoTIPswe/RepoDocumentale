#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  system: SIM_SYS,
  id: "visualizzazione_singolo_gateway_simulato",
  level: 2,
  title: "Visualizzazione singolo Gateway simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Il Sistema si trova nella sezione dedicata alla visualizzazione dei Gateway simulati istanziati",
  ),
  postconds: (
    "L’Attore visualizza una entry della lista dei gateway simulati",
  ),
  trigger: "L’Attore vuole visualizzare dettagli utili ad identificare un Gateway",
  main-scen: (
    (
      descr: "L’Attore visualizza la data di creazione del Gateway simulato",
      inc: "visualizzazione_data_creazione_simulazione",
    ),
    (
      descr: "L’Attore visualizza l’ID di fabbrica del Gateway simulato",
      inc: "visualizzazione_id_fabbrica_simulazione",
    ),
  ),
)[
  #uml-schema("S1.1", "Visualizzazione singolo Gateway simulato")
]

