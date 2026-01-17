#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "inserimento_credenziali_fabbrica_gateway",
  system: CLOUD_SYS,
  title: "Inserimento credenziali di fabbrica Gateway",
  level: 2,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il Gateway esiste ed è operativo, ma non ancora configurato",
    "L’Attore possiede credenziali di fabbrica del Gateway",
    "Il Tenant a cui si desidera associare il Gateway è attivo",
  ),
  postconds: (
    "L’Attore ha inserito le credenziali di fabbrica del Gateway",
  ),
  trigger: "L’Attore vuole effettuare la registrazione di un nuovo Gateway",
  main-scen: (
    (descr: "L’Attore inserisce l’identificativo fisico del Gateway"),
    (descr: "L’Attore inserisce la chiave di fabbrica del Gateway"),
  ),
)
