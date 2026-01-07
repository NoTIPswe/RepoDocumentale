#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_algoritmo_generazione_dati",
  level: 2,
  title: "Visualizzazione algoritmo generazione dati",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore ha selezionato un sensore relativo ad un gateway simulato di cui visualizzare la configurazione della simulazione",
    "L’attore sta visualizzando la configurazione di un sensore simulato",
  ),
  postconds: (
    "L’attore visualizza l'algoritmo utilizzato per la sintesi dei dati",
  ),
  trigger: "L’attore accede ai dettagli del sensore simulato e vuole visualizzare con che algoritmo vengono generati i dati",
  main-scen: (
    (descr: "L’attore visualizza il nome dell'algoritmo utilizzato per generare i valori"),
  ),
)