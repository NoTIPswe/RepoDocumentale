#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "setup_totp",
  system: CLOUD_SYS,
  title: "Setup TOTP",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "L'Attore esegue il login per la prima volta",
    "L'account appartiene ad un " + CA.sys-adm + " o ad un tenant in cui la 2FA è abilitata",
  ),
  postconds: ("La TOTP per l'account è attiva e verificata",),
  trigger: "L'Attore necessita di fare il setup del meccanismo di 2FA",
  main-scen: (
    (descr: "L'Attore visualizza il QR-Code e il codice relativi alla TOTP"),
    (descr: "L'Attore genera una TOTP con il suo meccanismo preferito"),
    (descr: "L'Attore conferma la generazione del TOTP inserendo l'OTP", inc: "ins_otp"),
    (descr: "L'Attore viene informato della buona riuscita del setup"),
  ),
)[
  #uml-schema("3", "Setup TOTP")
]

