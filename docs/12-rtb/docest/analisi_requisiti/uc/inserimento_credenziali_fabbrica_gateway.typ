#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "inserimento_credenziali_fabbrica_gateway",
  system: CLOUD_SYS,
  title: "Inserimento credenziali di fabbrica Gateway",
  level: 2,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il Gateway esiste ed è operativo, ma non ancora configurato",
    "L’Attore possiede le credenziali di fabbrica del gateway",
    "Il Tenant a cui si desidera associare il gateway è attivo",
  ),
  postconds: (
    "L’Attore ha inserito le credenziali di fabbrica del Gateway",
  ),
  trigger: "L'Attore vuole effettuare la registrazione di un nuovo Gateway",
  main-scen: (
    (descr: "L’Attore inserisce l’identificativo fisico del gateway"),
    (descr: "L’Attore inserisce la chiave di fabbrica del gateway"),
  ),
)
