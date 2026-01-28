#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  system: SIM_SYS,
  id: "impostazione_frequenza_invio_dati",
  level: 2,
  title: "Impostazione frequenza di invio dati",
  prim-actors: (SA.cloud),
  preconds: (
    "Il Gateway simulato risulta connesso e autenticato",
    "Il messaggio di configurazione contiene un valore valido per la frequenza di invio",
  ),
  postconds: (
    "Il timer di invio dati viene aggiornato con il nuovo valore",
  ),
  trigger: "L’Attore desidera modificare la frequenza di invio dati del Gateway",
  main-scen: (
    (
      descr: "L’Attore modifica il valore della frequenza di invio dati del Gateway selezionato",
      ep: "ValoreNumericoInvalido",
    ),
    (descr: "L’Attore viene notificato del buon esito della modifica"),
  ),
  alt-scen: (
    (
      ep: "ValoreNumericoInvalido",
      cond: "Il valore numerico inserito non è valido",
      uc: "err_valore_numerico_invalido",
    ),
  ),
)[
  #uml-schema("S20.1", "Impostazione frequenza di invio dati")
]
