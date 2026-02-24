#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "login_2fa",
  system: CLOUD_SYS,
  title: "Login 2FA",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "Le credenziali primarie dell’account dell'Attore sono valide",
    "Il Tenant, a cui l'account relativo alle credenziali afferisce, richiede 2FA",
  ),
  postconds: (
    "L'Attore è autenticato e riconosciuto correttamente",
  ),
  trigger: "Policy opzionale di sicurezza che richiede un secondo fattore di autenticazione per completare l'accesso",
  main-scen: (
    (descr: "Il Sistema richiede l'inserimento del codice OTP"),
    (descr: "L'Attore inserisce il codice", inc: "ins_otp"),
  ),

  uml-descr: "Diagramma Login 2FA",
)
