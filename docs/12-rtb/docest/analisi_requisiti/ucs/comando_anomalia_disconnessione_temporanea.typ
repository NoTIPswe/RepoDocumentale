#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "comando_anomalia_disconnessione_temporanea",
  level: 1,
  title: "Comando anomalia gateway - disconnessione temporanea",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore si trova in una sezione dedicata all’invio di comandi per simulazione eventi",
  ),
  postconds: (
    "Il gateway selezionato simula una situazione di disconnessione temporanea",
  ),
  trigger: "Necessità di testare il comportamento di un gateway in caso di disconnessione temporanea dalla rete",
  main-scen: (
    (
      descr: "L’attore seleziona un gateway",
      inc: "selezione_gateway_simulato",
    ),
    (descr: "L’attore inserisce la durata dell’evento in secondi"),
    (descr: "L’attore conferma l’invio del comando"),
    (descr: "L’attore viene informato della corretta ricezione del comando e inizio dell’evento"),
  ),
)
