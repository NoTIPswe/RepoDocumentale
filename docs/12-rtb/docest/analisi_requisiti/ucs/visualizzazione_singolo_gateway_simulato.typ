#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_singolo_gateway_simulato",
  level: 2,
  title: "Visualizzazione singolo Gateway simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore si trova nella sezione dedicata alla visualizzazione dei Gateway simulati istanziati",
    "L’attore sta visualizzando la lista dei gateway simulati",
  ),
  postconds: (
    "L’attore visualizza una entry della lista dei gateway simulati",
  ),
  trigger: "L’attore vuole visualizzare dettagli utili ad identificare un Gateway",
  main-scen: (
    (
      descr: "L’attore visualizza la data di creazione del Gateway simulato",
      inc: "visualizzazione_data_creazione_simulazione",
    ),
    (
      descr: "L’attore visualizza l’ID di fabbrica del Gateway simulato",
      inc: "visualizzazione_id_fabbrica_simulazione",
    ),
  ),
)
