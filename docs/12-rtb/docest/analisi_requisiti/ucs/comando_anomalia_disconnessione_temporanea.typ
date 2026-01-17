#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "comando_anomalia_disconnessione_temporanea",
  level: 1,
  title: "Comando anomalia Gateway - disconnessione temporanea",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’Attore si trova in una sezione dedicata all’invio di comandi per simulazione eventi",
  ),
  postconds: (
    "Il Gateway selezionato simula una situazione di disconnessione temporanea",
  ),
  trigger: "Necessità di testare il comportamento di un Gateway in caso di disconnessione temporanea dalla rete",
  main-scen: (
    (
      descr: "L’Attore seleziona un Gateway",
      inc: "selezione_gateway_simulato",
    ),
    (descr: "L’Attore inserisce la durata dell’evento in secondi"),
    (descr: "L’Attore conferma l’invio del comando"),
    (descr: "L’Attore viene informato della corretta ricezione del comando e inizio dell’evento"),
  ),
)
