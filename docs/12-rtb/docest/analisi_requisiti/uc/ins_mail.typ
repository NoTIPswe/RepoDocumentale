#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "ins_mail",
  system: CLOUD_SYS,
  title: "Inserimento mail",
  level: 2,
  prim-actors: (CA.non-authd-usr,),
  preconds: (
    "Esiste almeno un account registrato nel sistema",
    "L'Attore non è autenticato nel sistema",
    "Il sistema è nello stato di autenticazione iniziale",
  ),
  postconds: ("L'Attore ha inserito una mail",),
  trigger: "L'Attore deve inserire una mail per il login",
  main-scen: (
    (descr: "L'Attore inserisce la mail nel campo dedicato"),
  ),
)
