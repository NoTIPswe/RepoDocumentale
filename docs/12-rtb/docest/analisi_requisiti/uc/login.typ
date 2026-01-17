#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema



#uc(
  id: "login",
  system: CLOUD_SYS,
  title: "Login",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: ("Esiste almeno un account registrato nel sistema", "L'Attore non è autenticato nel sistema"),
  postconds: ("L'Attore è autenticato correttamente", "L'Attore è autorizzato correttamente"),
  trigger: "L'Attore intende autenticarsi nel sistema per usufruire delle sue funzionalità",
  main-scen: (
    (descr: "L'Attore inserisce la mail per l'accesso", inc: "ins_mail"),
    (descr: "L'Attore inserisce la password per l'accesso", inc: "ins_pw"),
    (descr: "L'Attore richiede l'esecuzione del login", ep: "PreLogin"),
    (descr: "L'Attore accede correttamente al sistema"),
  ),
  alt-scen: (
    (ep: "PreLogin", cond: "L'Attore inserisce credenziali errate", uc: "err_cred_errate"),
    (
      ep: "PreLogin",
      cond: "L'Attore fa il login per la prima volta e l'account appartiene a un "
        + CA.sys-adm
        + " o a un tenant in cui la 2FA è abilitata",
      uc: "setup_totp",
    ),
  ),
)[
  #uml-schema("1", "Diagramma Login")
]
