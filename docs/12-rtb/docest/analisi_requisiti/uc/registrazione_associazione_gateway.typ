#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "registrazione_associazione_gateway",
  system: CLOUD_SYS,
  title: "Provisioning Gateway - Registrazione e associazione Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il Gateway esiste ed è operativo, ma non ancora configurato",
    "L’Attore possiede credenziali di fabbrica del Gateway",
    "Il Tenant a cui si desidera associare il Gateway è attivo",
  ),
  postconds: (
    "Il Gateway è stato provisionato correttamente nel sistema",
    "Il Gateway è stato associato correttamente al Tenant",
    "Il Gateway è posto in stato “not provisioned” con nome e id generati automaticamente",
  ),
  trigger: "L’Attore vuole effettuare la registrazione e l'associazione di un nuovo Gateway ad un Tenant",
  main-scen: (
    (
      descr: "L’Attore seleziona un Tenant attivo dalla lista",
      inc: "selezione_tenant",
    ),
    (
      descr: "L’Attore inserisce le credenziali di fabbrica del Gateway",
      inc: "inserimento_credenziali_fabbrica_gateway",
    ),
    (descr: "L’Attore conferma l’operazione"),
    (
      descr: "L’Attore viene notificato dell’avvenuta connessione del Gateway non appena il dispositivo contatta il Cloud e riceve le credenziali",
    ),
  ),
)[#uml-schema("92", "Provisioning Gateway - Registrazione e associazione Tenant")]
