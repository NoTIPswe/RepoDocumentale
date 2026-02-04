#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "err_auth_gateway_fabbrica",
  system: CLOUD_SYS,
  title: "Errore autenticazione Gateway di fabbrica",
  level: 1,
  prim-actors: CA.np-gway,
  preconds: (
    "Il Sistema è stato contattato da un Gateway per la procedura di onboarding",
    "Le credenziali di fabbrica fornite dal gateway sono invalide",
  ),
  postconds: (
    "Il Gateway non procede con la procedura di onboarding",
  ),
  trigger: "Accensione del Gateway",
  main-scen: (
    (descr: "Il Gateway viene notificato dell'errore avvenuto"),
  ),
)[#uml-schema("99", "Diagramma Errore autenticazione Gateway di fabbrica")]
