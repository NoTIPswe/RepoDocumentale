#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "comando_anomalia_outliers_misurazioni",
  level: 1,
  title: "Comando anomalia sensore - outliers nelle misurazioni",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore si trova in una sezione dedicata all’invio di comandi per simulazione eventi",
  ),
  postconds: (
    "Il sensore selezionato simula una situazione di misurazioni fuori scala",
  ),
  trigger: "Necessità di testare il comportamento del sistema quando un sensore misura valori inaspettati",
  main-scen: (
    (descr: "L’attore inserisce la durata dell’evento in secondi"),
    (
      descr: "L’attore inserisce un range fuori scala per le misurazioni",
      inc: "inserimento_range_generazione_dati",
    ),
    (descr: "L’attore conferma l’invio del comando"),
    (descr: "L’attore viene informato della corretta ricezione del comando e inizio dell’evento"),
  ),
)
