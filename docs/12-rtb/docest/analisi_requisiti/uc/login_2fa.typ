#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "login_2fa",
  system: CLOUD_SYS,
  title: "Login 2FA",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "Le credenziali primarie dell’account dell'attore sono valide",
    "Il tenant, a cui l'account relativo alle credenziali afferisce, richiede 2FA",
  ),
  postconds: (
    "L'attore primario è autenticato e riconosciuto correttamente",
  ),
  trigger: "Policy opzionale di sicurezza che richiede un secondo fattore di autenticazione per completare l'accesso",
  main-scen: (
    (descr: "Il sistema richiede l'inserimento del codice OTP"),
    (descr: "L'attore primario inserisce il codice", inc: "ins_otp"),
  ),
)[
  #uml-schema("4", "Login 2FA")
]
