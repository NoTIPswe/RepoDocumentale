#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_software_gateway_simulato",
  level: 2,
  title: "Visualizzazione versione software del gateway simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Esiste un Gateway simulato di cui si sta visualizzando la configurazione",
  ),
  postconds: (
    "L’attore visualizza correttamente i dati desiderati",
  ),
  trigger: "L’attore accede ai dettagli di configurazione del Gateway simulato",
  main-scen: (
    (
      descr: "L’attore visualizza la versione del software del Gateway simulato",
    ),
  ),
)