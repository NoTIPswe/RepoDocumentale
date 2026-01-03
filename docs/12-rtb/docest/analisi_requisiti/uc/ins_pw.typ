#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "ins_pw",
  system: CLOUD_SYS,
  title: "Inserimento password",
  level: 2,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "L'attore non è autenticato nel sistema",
    "L'attore si trova in una sezione dedicata all'autenticazione",
    ),
  postconds: ("L'attore ha inserito una password",),
  trigger: "L'attore deve inserire una password per accedere",
  main-scen: (
    (descr: "L'attore inserisce la password"),
  ),
)
