#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "ins_otp",
  system: CLOUD_SYS,
  title: "Inserimento OTP",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "Le credenziali primarie sono state validate",
    "Il sistema è in attesa del codice di verifica temporaneo",
  ),
  postconds: (
    "L'attore ha inserito un codice OTP valido",
  ),
  trigger: "Necessità di fornire il secondo fattore di autenticazione",
  main-scen: (
    (descr: "L'attore inserisce il codice numerico nel sistema", ep: "OtpErrato"),
    (descr: "L'attore viene informato della correttezza del codice inserito"),
  ),
  alt-scen: (
    (
      ep: "OtpErrato",
      cond: "L'OTP inserito non viene riconosciuto come valido dal sistema",
      uc: "err_otp_errato",
    ),
  ),
)[
  #uml-schema("5", "Inserimento OTP")
  
]
