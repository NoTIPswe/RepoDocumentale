#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "impostazione_configurazione_gateway",
  level: 1,
  title: "Impostazione configurazione del gateway",
  prim-actors: (SA.cloud),
  preconds: (
    "Il Gateway simulato risulta connesso e autenticato",
  ),
  postconds: (
    "Il Gateway simulato aggiorna il proprio stato interno in base alla configurazione ricevuta",
  ),
  trigger: "Il Cloud (o un amministratore tramite dashboard) invia una nuova configurazione al gateway",
  main-scen: (
    (descr: "L’attore prepara una nuova configurazione per il Gateway"),
    (
      descr: "L’attore aggiorna la frequenza",
      inc: "impostazione_frequenza_invio_dati"
    ),
    (
      descr: "L’attore aggiorna lo stato",
      inc: "impostazione_stato_sospensione"
    ),
    (
      descr: "L’attore riceve una notifica di conferma dell'avvenuta configurazione",
      ep: "ConfigurazioneInvalida"
    ),
  ),
  alt-scen: (
    (
      ep: "ConfigurazioneInvalida",
      cond: "Il messaggio contiene errori di sintassi o un formato non riconosciuto",
      uc: "err_sintattico_config_gateway"
    ),
    (
      ep: "ConfigurazioneInvalida",
      cond: "La frequenza richiesta non è supportata dal gateway simulato",
      uc: "err_config_frequenza_fuori_range"
    ),
  ),
)