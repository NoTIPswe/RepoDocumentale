#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  system: SIM_SYS,
  id: "visualizzazione_data_creazione_simulazione",
  level: 3,
  title: "Visualizzazione data di creazione del Gateway Simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Il Sistema si trova nella sezione dedicata alla visualizzazione dei Gateway simulati istanziati",
    "Esiste un Gateway simulato selezionato di cui si stanno visualizzando i dettagli",
  ),
  postconds: (
    "L’Attore visualizza correttamente la data di creazione del Gateway simulato selezionato",
  ),
  trigger: "L’Attore accede ai dettagli di configurazione del Gateway simulato",
  main-scen: (
    (
      descr: "L’Attore visualizza la data di creazione del Gateway simulato",
    ),
  ),
)