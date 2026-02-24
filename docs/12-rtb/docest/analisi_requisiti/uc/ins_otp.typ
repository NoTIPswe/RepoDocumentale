#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "ins_otp",
  system: CLOUD_SYS,
  title: "Inserimento OTP",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "Le credenziali primarie dell'Attore sono state validate",
    "Il Sistema è in attesa del codice di verifica temporaneo",
  ),
  postconds: (
    "L'Attore ha inserito un codice OTP valido",
  ),
  trigger: "Necessità di fornire il secondo fattore di autenticazione",
  main-scen: (
    (descr: "L'Attore inserisce il codice numerico nel Sistema", ep: "OtpErrato"),
    (descr: "L'Attore viene informato della correttezza del codice inserito"),
  ),
  alt-scen: (
    (
      ep: "OtpErrato",
      cond: "L'OTP inserito non viene riconosciuto come valido dal Sistema",
      uc: "err_otp_errato",
    ),
  ),

  uml-descr: "Diagramma Inserimento OTP",
)
