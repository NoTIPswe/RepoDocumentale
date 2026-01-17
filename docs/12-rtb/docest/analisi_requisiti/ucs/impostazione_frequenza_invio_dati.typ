#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

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
    (descr: "L’Attore modifica il valore della frequenza di invio dati del Gateway selezionato"),
    (descr: "L’Attore viene notificato del buon esito della modifica"),
  ),
)
