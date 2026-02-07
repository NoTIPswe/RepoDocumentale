#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  system: SIM_SYS,
  id: "visualizzazione_id_fabbrica_simulazione",
  level: 1,
  title: "Visualizzazione ID di fabbrica simulazione",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Il Sistema si trova nella sezione dedicata alla visualizzazione dei Gateway simulati istanziati",
    "Esiste un Gateway simulato selezionato di cui si stanno visualizzando i dettagli",
  ),
  postconds: (
    "L’Attore visualizza l'identificativo di fabbrica di un Gateway",
  ),
  trigger: "L’Attore accede ai dettagli di configurazione del Gateway simulato",
  main-scen: (
    (descr: "L’Attore visualizza l'ID di fabbrica generato dal simulatore"),
  ),
)[
  #uml-schema("S2", "Visualizzazione ID di fabbrica simulazione")
]

