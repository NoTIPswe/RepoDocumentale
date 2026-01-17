#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "modifica_intervallo_alert_gateway",
  system: CLOUD_SYS,
  title: "Modifica intervallo alert Gateway irraggiungibile",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "I Gateway appartengono allo stesso Tenant"
  ),
  postconds: (
    "Il nuovo intervallo viene applicato a tutti i Gateway",
  ),
  trigger: "L’Attore vuole cambiare il timeout applicato per determinare se un Gateway è irraggiungibile",
  main-scen: (
    (descr: "L’Attore visualizza l’intervallo attuale"),
    (
      descr: "L’Attore inserisce il nuovo valore (in secondi) che verrà applicato per tutti i Gateway",
      inc: "inserimento_valore_numerico",
    ),
    (descr: "L’Attore riceve la conferma della modifica apportata"),
  ),
)[#uml-schema("47", "Modifica intervallo alert Gateway irraggiungibile")]
