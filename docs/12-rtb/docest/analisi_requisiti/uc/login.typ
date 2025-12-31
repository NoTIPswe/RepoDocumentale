#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "login",
  system: CLOUD_SYS,
  title: "Login",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: ("L'attore è sconosciuto al sistema",),
  postconds: ("L'attore è autenticato e riconosciuto correttamente",),
  trigger: "L'attore intende autenticarsi nel sistema per usufruire delle sue funzionalità",
  main-scen: (
    (descr: "L'attore inserisce la mail per l'accesso", inc: "ins_mail"),
    (descr: "L'attore inserisce la password per l'accesso", inc: "ins_pw"),
    (descr: "L'attore richiede l'esecuzione del login", ep: "PreLogin"),
  ),
  alt-scen: (
    (ep: "PreLogin", cond: "L'attore inserisce credenziali errate", uc: "err_cred_errate"),
    (
      ep: "PreLogin",
      cond: "L'attore fa il login per la prima volta e l'account appartiene ad un amministratore di sistema o ad un utente di Tenant in cui la 2FA è abilitata",
      uc: "setup_totp",
    ),
  ),
)

#uc(
  id: "ins_mail",
  system: CLOUD_SYS,
  title: "Inserimento mail",
  level: 2,
  prim-actors: CA.non-authd-usr,
  preconds: ("L'attore è sconosciuto al sistema",),
  postconds: ("L'attore ha inserito una mail",),
  trigger: "L'attore deve fornire una mail identificativa",
  main-scen: (
    (descr: "L'attore inserisce la email nel campo dedicato"),
  ),
)


#uc(
  id: "ins_pw",
  system: CLOUD_SYS,
  title: "Inserimento password",
  level: 2,
  prim-actors: CA.non-authd-usr,
  preconds: ("L'attore è sconosciuto al sistema",),
  postconds: ("L'attore si trova in una sezione dedicata all'autenticazione",),
  trigger: "L'attore deve inserire una password per accedere",
  main-scen: (
    (descr: "L'attore inserisce la password"),
  ),
)
