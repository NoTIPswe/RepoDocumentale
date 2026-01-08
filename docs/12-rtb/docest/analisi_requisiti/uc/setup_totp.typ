#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "setup_totp",
  system: CLOUD_SYS,
  title: "Setup TOTP",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "L'attore esegue il login per la prima volta",
    "L'account appartiene ad un " + CA.sys-adm + " o ad un tenant in cui la 2FA è abilitata",
  ),
  postconds: ("La TOTP per l'account è attiva e verificata",),
  trigger: "L'attore necessita di fare il setup del meccanismo di 2FA",
  main-scen: (
    (descr: "L'attore visualizza il QR-Code e il codice relativi alla TOTP"),
    (descr: "L'attore genera una TOTP con il suo meccanismo preferito"),
    (descr: "L'attore conferma la generazione del TOTP inserendo l'OTP", inc: "ins_otp"),
    (descr: "L'attore viene informato della buona riuscita del setup"),
  ),
)[
  #uml-schema("3", "Setup TOTP")
]

