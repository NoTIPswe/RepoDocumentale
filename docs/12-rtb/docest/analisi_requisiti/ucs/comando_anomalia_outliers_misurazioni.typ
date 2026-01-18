#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  system: SIM_SYS,
  id: "comando_anomalia_outliers_misurazioni",
  level: 1,
  title: "Comando anomalia sensore - outliers nelle misurazioni",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Il Sistema si trova in una sezione dedicata all’invio di comandi per simulazione eventi",
  ),
  postconds: (
    "Il sensore selezionato simula una situazione di misurazioni fuori scala",
  ),
  trigger: "Necessità di testare il comportamento del sistema quando un sensore misura valori inaspettati",
  main-scen: (
    (descr: "L’Attore inserisce la durata dell’evento in secondi",
    ep: "ValoreNumericoInvalido"
    ),
    (
      descr: "L’Attore inserisce un range fuori scala per le misurazioni",
      inc: "inserimento_range_generazione_dati",
    ),
    (descr: "L’Attore conferma l’invio del comando"),
    (descr: "L’Attore viene informato della corretta ricezione del comando e inizio dell’evento"),
  ),
  alt-scen: (
    (
      ep: "ValoreNumericoInvalido",
      cond: "È stato inserito un valore numerico non valido",
      uc: "err_valore_numerico_invalido",
    ),
  ),
)[
  #uml-schema("S19", "Comando anomalia sensore - outliers nelle misurazioni")
]

