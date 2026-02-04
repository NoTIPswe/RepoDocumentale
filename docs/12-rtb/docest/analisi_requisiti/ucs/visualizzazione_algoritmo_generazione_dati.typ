#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_algoritmo_generazione_dati",
  level: 2,
  title: "Visualizzazione algoritmo generazione dati",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Esiste un sensore che è stato selezionato di cui si stanno visualizzando i dettagli di configurazione della simulazione",
  ),
  postconds: (
    "L’Attore visualizza l'algoritmo utilizzato per la sintesi dei dati",
  ),
  trigger: "L’Attore accede ai dettagli del sensore simulato e vuole visualizzare con che algoritmo vengono generati i dati",
  main-scen: (
    (descr: "L’Attore visualizza il nome dell'algoritmo utilizzato per generare i valori"),
  ),
)
