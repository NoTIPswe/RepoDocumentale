#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_range_generazione_dati",
  level: 2,
  title: "Visualizzazione range generazione dati",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Esiste un sensore che è stato selezionato di cui si stanno visualizzando i dettagli di configurazione della simulazione",
  ),
  postconds: (
    "L’Attore visualizza i limiti numerici entro cui vengono generati i dati",
  ),
  trigger: "L’Attore accede ai dettagli del sensore simulato e vuole visualizzarne il range di generazione dati",
  main-scen: (
    (descr: "L’Attore visualizza il valore minimo impostato per la generazione dei dati"),
    (descr: "L’Attore visualizza il valore massimo impostato per la generazione dei dati simulati"),
  ),
)
