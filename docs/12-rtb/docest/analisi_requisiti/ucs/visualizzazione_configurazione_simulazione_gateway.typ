#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_configurazione_simulazione_gateway",
  level: 1,
  title: "Visualizzazione configurazione simulazione Gateway",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore ha selezionato un gateway simulato di cui visualizzare la configurazione della simulazione",
  ),
  postconds: (
    "L’attore visualizza i dati di configurazione della simulazione del Gateway simulato",
  ),
  trigger: "L’attore vuole visualizzare i dettagli della configurazione di simulazione di un Gateway",
  main-scen: (
    (
      descr: "L’attore visualizza l’ID di fabbrica del Gateway simulato",
      inc: "visualizzazione_id_fabbrica_simulazione",
    ),
    (
      descr: "L’attore visualizza la chiave di fabbrica del Gateway simulato",
      inc: "visualizzazione_chiave_fabbrica_simulazione",
    ),
    // bookmark - non sappiamo ancora cosa altro visualizzare
    // serial number 
    // versione software 
    // versione firmware
    // modello 
    // pin geografico 
    // ...
  ),
)
