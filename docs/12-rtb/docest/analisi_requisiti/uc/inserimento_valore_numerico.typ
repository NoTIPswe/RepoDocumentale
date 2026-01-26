#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "inserimento_valore_numerico",
  system: CLOUD_SYS,
  title: "Inserimento valore numerico",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il Sistema necessita dell’inserimento di un valore numerico",
  ),
  postconds: (
    "L’Attore ha inserito un valore numerico valido",
  ),
  trigger: "L’Attore vuole inserire un valore numerico",
  main-scen: (
    (descr: "L’Attore inserisce un valore numerico"),
  ),
)[#uml-schema("45", "Inserimento valore numerico")]
