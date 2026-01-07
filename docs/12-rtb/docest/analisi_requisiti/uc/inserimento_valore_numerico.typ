#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "inserimento_valore_numerico",
  system: CLOUD_SYS,
  title: "Inserimento valore numerico",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il sistema necessita dell’inserimento di un valore numerico",
  ),
  postconds: (
    "L’attore ha inserito un valore numerico valido",
  ),
  trigger: "L’attore principale vuole inserire un valore numerico",
  main-scen: (
    (descr: "L’attore inserisce un valore numerico"),
  ),
)
