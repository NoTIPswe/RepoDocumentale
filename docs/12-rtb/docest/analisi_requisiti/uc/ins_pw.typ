#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "ins_pw",
  system: CLOUD_SYS,
  title: "Inserimento password",
  level: 2,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "Esiste almeno un account registrato nel Sistema",
    "L'Attore non è autenticato nel Sistema",
    "Il Sistema ha acquisito una mail associata a un account esistente",
  ),
  postconds: ("L'Attore ha inserito una password",),
  trigger: "L'Attore deve inserire una password per accedere",
  main-scen: (
    (descr: "L'Attore inserisce la password"),
  ),
)
