#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  system: SIM_SYS,
  id: "comando_anomalia_degrado_rete",
  level: 1,
  title: "Comando anomalia gateway - degrado rete",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Il Sistema si trova in una sezione dedicata all’invio di comandi per simulazione eventi",
  ),
  postconds: (
    "Il Gateway selezionato simula una situazione di degrado della rete",
  ),
  trigger: "Necessità di testare il comportamento di un gateway in caso di degrado della rete",
  main-scen: (
    (
      descr: "L’attore seleziona un gateway"
    ),
    (descr: "L’attore inserisce la latenza desiderata in millisecondi",
    ep: "ValoreNumericoInvalido",
    ),
    (descr: "L’attore inserisce la percentuale di pacchetti persi",
    ep: "ValoreNumericoInvalido",
    ),
    (descr: "L’attore inserisce la durata dell’evento in secondi",
    ep: "ValoreNumericoInvalido",
    ),
    (descr: "L’attore conferma l’invio del comando"),
    (descr: "L’attore viene informato della corretta ricezione del comando e inizio dell’evento"),
  ),
  alt-scen: (
    (
      ep: "ValoreNumericoInvalido",
      cond: "È stato inserito un valore numerico non valido",
      uc: "err_valore_numerico_invalido",
    ),
  ),
)[
  #uml-schema("S17", "Comando anomalia gateway - degrado rete")
]

