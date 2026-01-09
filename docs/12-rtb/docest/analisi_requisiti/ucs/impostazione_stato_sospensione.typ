#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "impostazione_stato_sospensione",
  level: 2,
  title: "Impostazione stato sospensione",
  prim-actors: (SA.cloud),
  preconds: (
    "Il Gateway simulato risulta connesso e autenticato",
    "Il messaggio di configurazione contiene un flag di abilitazione/disabilitazione valido",
  ),
  postconds: (
    "Il gateway simulato entra o esce dallo stato di sospensione",
  ),
  trigger: "L’attore desidera modificare lo stato operativo del Gateway",
  main-scen: (
    (descr: "L’attore modifica lo stato operativo del Gateway selezionato"),
    (descr: "L’attore viene notificato del buon esito della modifica"),
  ),
)