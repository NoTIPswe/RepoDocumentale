#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_timestamp_ultimo_invio_dati_gateway",
  system: CLOUD_SYS,
  title: "Visualizzazione timestamp ultimo invio dati gateway",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L'attore primario sta visualizzando i dettagli di un gateway o di un alert riguardante un gateway non raggiungibile",
  ),
  postconds: (
    "L'orario dell'ultimo pacchetto dati ricevuto è visibile",
  ),
  trigger: "Visualizzazione dettagli di un gateway o di un alert ad esso collegato",
  main-scen: (
    (descr: "L'attore primario visualizza l’orario dell’ultimo invio dati da parte del gateway"),
  ),
)[
  #uml-schema("22", "Diagramma visualizzazione timestamp ultimo invio dati gateway")
]
