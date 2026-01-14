#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "registrazione_associazione_gateway",
  system: CLOUD_SYS,
  title: "Provisioning Gateway - Registrazione e associazione Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il Gateway esiste ed è operativo, ma non ancora configurato",
    "L’attore possiede credenziali di fabbrica del gateway",
    "Il Tenant a cui si desidera associare il gateway è attivo",
  ),
  postconds: (
    "Il Gateway è stato provisionato correttamente nel sistema",
    "Il Gateway è stato associato correttamente al Tenant",
    "Il Gateway è posto in stato “not provisioned” con nome e id generati automaticamente",
  ),
  trigger: "L’attore vuole effettuare la registrazione e l'associazione di un nuovo Gateway ad un Tenant",
  main-scen: (
    (
      descr: "L’attore seleziona un Tenant attivo dalla lista",
      inc: "selezione_tenant",
    ),
    (
      descr: "L’attore inserisce le credenziali di fabbrica del Gateway",
      inc: "inserimento_credenziali_fabbrica_gateway",
    ),
    (descr: "L’attore conferma l’operazione"),
    (
      descr: "L’attore viene notificato dell’avvenuta connessione del gateway non appena il dispositivo contatta il Cloud e riceve le credenziali",
    ),
  ),
)[#uml-schema("92", "Provisioning Gateway - Registrazione e associazione Tenant")]
