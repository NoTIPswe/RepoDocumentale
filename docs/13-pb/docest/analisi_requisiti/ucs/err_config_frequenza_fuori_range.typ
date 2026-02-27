#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "err_config_frequenza_fuori_range",
  level: 1,
  title: "Errore configurazione frequenza invio dati fuori range ammesso",
  prim-actors: (SA.cloud),
  preconds: (
    "Il valore di frequenza ricevuto è sintatticamente corretto ma non accettabile dal Gateway",
  ),
  postconds: (
    "La modifica della frequenza viene ignorata",
    "L'Attore riceve una notifica di errore",
  ),
  trigger: "Ricezione di un valore di frequenza non valido logicamente",
  main-scen: (
    (descr: "L’Attore riceve una notifica di errore di configurazione per errore semantico nel range"),
  ),
)
