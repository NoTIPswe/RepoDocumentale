#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "ins_pw",
  system: CLOUD_SYS,
  title: "Inserimento password",
  level: 2,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "Esiste almeno un account registrato nel sistema",
    "L'attore non è autenticato nel sistema",
    "Il sistema ha acquisito una mail associata a un account esistente",
  ),
  postconds: ("L'attore ha inserito una password",),
  trigger: "L'attore deve inserire una password per accedere",
  main-scen: (
    (descr: "L'attore inserisce la password"),
  ),
)
