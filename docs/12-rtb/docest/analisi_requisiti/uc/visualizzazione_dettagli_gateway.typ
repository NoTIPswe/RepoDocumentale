#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_dettagli_gateway",
  system: CLOUD_SYS,
  title: "Visualizzazione dettagli Gateway",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L'attore primario sta visualizzando la lista dei gateway",
    "L'attore primario ha selezionato un Gateway specifico",
  ),
  postconds: (
    "L'attore primario visualizza nome, stato, ultimo timestamp dati inviati ed i sensori del gateway",
  ),
  trigger: "L'attore primario vuole vedere i dettagli di un singolo gateway",
  main-scen: (
    (
      descr: "L'attore primario visualizza l'identificativo",
      inc: "visualizzazione_nome_gateway",
    ),
    (
      descr: "L'attore primario visualizza lo stato del gateway",
      inc: "visualizzazione_stato_gateway",
    ),
    (
      descr: "L'attore primario visualizza l'ultimo timestamp dati inviati",
      inc: "visualizzazione_timestamp_ultimo_invio_dati_gateway",
    ),
    (
      descr: "L'attore primario visualizza la lista dei sensori collegati",
      inc: "visualizzazione_lista_sensori",
    ),
  ),
)[
  #uml-schema("21", "Diagramma visualizzazione gateway")
]
