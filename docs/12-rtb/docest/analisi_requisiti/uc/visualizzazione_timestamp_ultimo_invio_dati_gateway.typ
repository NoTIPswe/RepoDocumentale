#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_timestamp_ultimo_invio_dati_gateway",
  system: CLOUD_SYS,
  title: "Visualizzazione timestamp ultimo invio dati Gateway",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema mostra i dettagli di un Gateway o di un alert riguardante un Gateway non raggiungibile",
  ),
  postconds: (
    "L'orario dell'ultimo pacchetto dati ricevuto è visibile",
  ),
  trigger: "Visualizzazione dettagli di un Gateway o di un alert ad esso collegato",
  main-scen: (
    (descr: "L'Attore primario visualizza l’orario dell’ultimo invio dati da parte del Gateway"),
  ),
)[
  #uml-schema("22", "Diagramma Visualizzazione timestamp ultimo invio dati Gateway")
]
