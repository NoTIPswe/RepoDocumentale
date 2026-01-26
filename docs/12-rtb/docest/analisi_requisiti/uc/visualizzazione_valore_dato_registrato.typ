#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_valore_dato_registrato",
  system: CLOUD_SYS,
  title: "Visualizzazione valore del dato registrato",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Esiste un'irregolarità nelle misurazioni del sensore",
    "Il Sistema sta mostrando un alert relativo a dati fuori range",
  ),
  postconds: (
    "L’Attore visualizza il dato fuori range registrato",
  ),
  trigger: "Un valore registrato dal sensore risulta fuori dal range previsto",
  main-scen: (
    (descr: "L’Attore visualizza il valore del dato registrato"),
  ),
)
