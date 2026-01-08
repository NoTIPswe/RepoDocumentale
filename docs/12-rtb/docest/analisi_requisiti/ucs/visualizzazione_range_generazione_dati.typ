#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_range_generazione_dati",
  level: 2,
  title: "Visualizzazione range generazione dati",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore ha selezionato un sensore relativo ad un gateway simulato di cui visualizzare la configurazione della simulazione",
    "L’attore sta visualizzando la configurazione di un sensore simulato",
  ),
  postconds: (
    "L’attore visualizza i limiti numerici entro cui vengono generati i dati",
  ),
  trigger: "L’attore accede ai dettagli del sensore simulato e vuole visualizzarne il range di generazione dati",
  main-scen: (
    (descr: "L’attore visualizza il valore minimo impostato per la generazione dei dati"),
    (descr: "L’attore visualizza il valore massimo impostato per la generazione dei dati simulati"),
  ),
)
