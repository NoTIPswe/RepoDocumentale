#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  system: SIM_SYS,
  id: "creazione_sensore_gateway_simulato",
  level: 1,
  title: "Creazione sensore Gateway simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Il Sistema si trova nella sezione di Gestione Gateway simulato",
    "È stato selezionato un Gateway simulato esistente",
  ),
  postconds: (
    "Il nuovo sensore simulato viene creato con successo",
    "Il nuovo sensore viene associato al Gateway simulato",
  ),
  trigger: "L’Attore vuole creare un nuovo sensore da associare ad un Gateway simulato",
  main-scen: (
    (
      descr: "L’Attore inserisce i dati relativi alla configurazione della simulazione del sensore",
      inc: "inserimento_dati_config_sim_sensore",
    ),
    (descr: "L’Attore principale conferma la creazione del sensore"),
    (descr: "L’Attore viene informato del successo della creazione del sensore simulato", ep: "ErroreCreazione"),
  ),
  alt-scen: (
    (
      ep: "ErroreCreazione",
      cond: "Errore di sistema nella creazione del sensore simulato",
      uc: "err_creazione_sensore_simulato",
    ),
  ),
)[
  #uml-schema("S12", "Diagramma Creazione sensore Gateway simulato")
]

