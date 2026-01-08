#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema



#uc(
  id: "login",
  system: CLOUD_SYS,
  title: "Login",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: ("L'attore non è autenticato nel sistema", "L'attore si trova in una sezione dedicata all'autenticazione"),
  postconds: ("L'attore è autenticato correttamente", "L'attore è autorizzato correttamente"),
  trigger: "L'attore intende autenticarsi nel sistema per usufruire delle sue funzionalità",
  main-scen: (
    (descr: "L'attore inserisce la mail per l'accesso", inc: "ins_mail"),
    (descr: "L'attore inserisce la password per l'accesso", inc: "ins_pw"),
    (descr: "L'attore richiede l'esecuzione del login", ep: "PreLogin"),
    (descr: "L'attore accede correttamente al sistema"),
  ),
  alt-scen: (
    (ep: "PreLogin", cond: "L'attore inserisce credenziali errate", uc: "err_cred_errate"),
    (
      ep: "PreLogin",
      cond: "L'attore fa il login per la prima volta e l'account appartiene ad un "
        + CA.sys-adm
        + " o ad un tenant in cui la 2FA è abilitata",
      uc: "setup_totp",
    ),
  ),
)[
 #uml-schema("1", "Diagramma Login")
]
