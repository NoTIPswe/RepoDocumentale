#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "err_otp_errato",
  system: CLOUD_SYS,
  title: "Errore - OTP Errato",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "L'OTP inserito non viene riconosciuto come valido dal sistema",
  ),
  postconds: (
    "L'Attore non può procedere con l'operazione che richiede l'inserimento di OTP",
  ),
  trigger: "L'Attore ha inserito un codice OTP errato nel sistema",
  main-scen: (
    (descr: "L'Attore primario viene informato dell'errore riscontrato"),
    (descr: "L'Attore primario viene invitato a riprovare"),
  ),
)[
  #uml-schema("6", "OTP Errato")

]
