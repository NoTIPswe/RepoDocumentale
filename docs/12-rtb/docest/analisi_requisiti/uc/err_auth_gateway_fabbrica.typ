#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "err_auth_gateway_fabbrica",
  system: CLOUD_SYS,
  title: "Errore autenticazione gateway di fabbrica",
  level: 1,
  prim-actors: CA.np-gway,
  preconds: (
    "Il Gateway ha contattato il sistema per la procedura di onboarding",
    "Le credenziali di fabbrica fornite dal gateway sono invalide",
  ),
  postconds: (
    "Il Gateway non procede con la procedura di onboarding",
    "Il Gateway riceve una risposta di errore",
  ),
  trigger: "Accensione del gateway",
  main-scen: (
    (descr: "Il Gateway riceve una risposta di errore"),
  ),
)[#uml-schema("98", "Errore autenticazone Gateway di fabbrica")]
