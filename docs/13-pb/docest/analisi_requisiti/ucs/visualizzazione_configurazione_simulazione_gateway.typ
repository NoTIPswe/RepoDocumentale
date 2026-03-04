#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "visualizzazione_configurazione_simulazione_gateway",
  level: 1,
  title: "Visualizzazione configurazione simulazione Gateway",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Esiste un Gateway simulato di cui si vuole visualizzare la configurazione",
  ),
  postconds: (
    "L’Attore visualizza i dati di configurazione della simulazione del Gateway simulato",
  ),
  trigger: "L’Attore vuole visualizzare i dettagli della configurazione di simulazione di un Gateway",
  main-scen: (
    (
      descr: "L’attore seleziona il Gateway simulato desiderato",
    ),
    (
      descr: "L’Attore visualizza l’ID di fabbrica del Gateway simulato",
      inc: "visualizzazione_id_fabbrica_simulazione",
    ),
    (
      descr: "L’Attore visualizza la chiave di fabbrica del Gateway simulato",
      inc: "visualizzazione_chiave_fabbrica_simulazione",
    ),
    (
      descr: "L’attore visualizza il serial number del Gateway simulato",
      inc: "visualizzazione_serial_number_gateway_simulato",
    ),
    (
      descr: "L'attore visualizza la versione del software del Gateway simulato",
      inc: "visualizzazione_software_gateway_simulato",
    ),
    (
      descr: "L'attore visualizza il modello del Gateway simulato",
      inc: "visualizzazione_modello_gateway_simulato",
    ),
    // bookmark - non sappiamo ancora cosa altro visualizzare
    // serial number
    // versione software
    // versione firmware
    // modello
    // pin geografico
    // ...
  ),

  uml-descr: "Diagramma Visualizzazione configurazione simulazione Gateway",
)

