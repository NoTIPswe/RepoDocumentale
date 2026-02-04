#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_dettagli_gateway",
  system: CLOUD_SYS,
  title: "Visualizzazione dettagli Gateway",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema mostra la lista di Gateway",
  ),
  postconds: (
    "L'Attore visualizza nome, stato, ultimo timestamp dati inviati ed i sensori del Gateway",
  ),
  trigger: "L'Attore vuole vedere i dettagli di un singolo Gateway",
  main-scen: (
    (
      descr: "L'attore seleziona un Gateway dalla lista",
    ),
    (
      descr: "L'Attore visualizza l'identificativo del Gateway",
      inc: "visualizzazione_nome_gateway",
    ),
    (
      descr: "L'Attore visualizza lo stato del Gateway",
      inc: "visualizzazione_stato_gateway",
    ),
    (
      descr: "L'Attore visualizza l'ultimo timestamp dati inviati",
      inc: "visualizzazione_timestamp_ultimo_invio_dati_gateway",
    ),
    (
      descr: "L'Attore visualizza la lista dei sensori collegati",
      inc: "visualizzazione_lista_sensori",
    ),
  ),
)[
  #uml-schema("21", "Diagramma Visualizzazione dettagli Gateway")
]
