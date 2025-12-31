#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "err_cred_errate",
  system: CLOUD_SYS,
  title: "Errore - Credenziali errate",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "L'attore primario si trova in una sezione dedicata all'autenticazione",
    "L'attore primario ha fornito delle credenziali non corrette",
  ),
  postconds: ("L'attore primario viene informato del mancato accesso ed invitato a tentare nuovamente",),
  trigger: "L'attore primario ha inserito delle credenziali non valide",
  main-scen: (
    (descr: "L'attore primario ha inserito email e/o password e/o OTP errata/e"),
    (descr: "L'attore primario viene informato del problema in fase di autenticazione"),
  ),
)

