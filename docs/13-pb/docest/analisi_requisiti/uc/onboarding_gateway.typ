#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "onboarding_gateway", // bookmark - use case o diagramma di attività
  system: CLOUD_SYS,
  title: "Provisioning Gateway - Onboarding",
  level: 1,
  prim-actors: CA.np-gway,
  preconds: (
    "Il Gateway possiede le proprie credenziali di fabbrica",
    "Il Gateway è stato registrato e associato ad un Tenant",
    "Il Gateway è nello stato “not provisioned”",
  ),
  postconds: (
    "Il Gateway viene provisionato correttamente",
    "Il Gateway è in stato “active”",
    "Il Gateway inizia a comunicare con il Sistema",
  ),
  trigger: "Connessione del Gateway e prima comunicazione con il Sistema",
  main-scen: (
    (
      descr: "Il Gateway contatta il Sistema attraverso un canale di comunicazione predefinito allegando le proprie credenziali di fabbrica",
      ep: "CredenzialiNonRiconosciute",
    ),
    (
      descr: "Il Gateway riceve un pacchetto di provisioning contenente le informazioni necessarie alla comunicazione autenticata e sicura",
    ),
    (
      descr: "Lo stato del Gateway passa da “not provisioned” a “active”",
    ),
  ),
  alt-scen: (
    (
      ep: "CredenzialiNonRiconosciute",
      cond: "Le credenziali fornite non corrispondono a quelle registrate",
      uc: "err_auth_gateway_fabbrica",
    ),
  ),

  uml-descr: "Diagramma Provisioning Gateway - Onboarding",
)
