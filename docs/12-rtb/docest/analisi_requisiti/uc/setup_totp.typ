#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "setup_totp",
  system: CLOUD_SYS,
  title: "Setup TOTP",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "L'attore fa il login per la prima volta",
    "L'account appartiene ad un amministratore di sistema o ad un utente di Tenant in cui la 2FA è abilitata",
  ),
  postconds: ("La TOTP per l'account è attiva e verificata",),
  trigger: "L'attore primario ha inserito delle credenziali non valide",
  main-scen: (
    (descr: "L'attore visualizza il QR-Code e il codice relativi alla TOTP"),
    (descr: "L'attore genera un TOTP con il suo meccanismo preferito"),
    (descr: "L'attore conferma la generazione del TOTP inserendo l'OTP", inc: "ins_otp"),
    (descr: "L'attore viene informato del risultato del setup"),
  ),
)

