#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "login",
  system: CLOUD_SYS,
  title: "Login",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: ("Esiste almeno un account registrato nel Sistema", "L'Attore non è autenticato nel Sistema"),
  postconds: ("L'Attore è autenticato correttamente", "L'Attore è autorizzato correttamente"),
  trigger: "L'Attore intende autenticarsi nel Sistema per usufruire delle sue funzionalità",
  main-scen: (
    (descr: "L'Attore inserisce la mail per l'accesso", inc: "ins_mail"),
    (descr: "L'Attore inserisce la password per l'accesso", inc: "ins_pw"),
    (descr: "L'Attore richiede l'esecuzione del login", ep: "PreLogin"),
    (descr: "L'Attore accede correttamente al Sistema"),
  ),
  alt-scen: (
    (ep: "PreLogin", cond: "L'Attore inserisce credenziali errate", uc: "err_cred_errate"),
  ),
  specialized-by: "login_2fa",

  uml-descr: "Diagramma Login",
)
