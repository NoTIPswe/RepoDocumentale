#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "ins_mail",
  system: CLOUD_SYS,
  title: "Inserimento mail",
  level: 2,
  prim-actors: (CA.non-authd-usr,),
  preconds: (
    "L'attore non è autenticato nel sistema",
    "L'attore si trova in una sezione dedicata all'autenticazione",
    "L'attore è sconosciuto al sistema",
  ),
  postconds: ("L'attore ha inserito una mail",),
  trigger: "L'attore deve inserire una mail per il login",
  main-scen: (
    (descr: "L'attore inserisce la mail nel campo dedicato"),
  ),
)
