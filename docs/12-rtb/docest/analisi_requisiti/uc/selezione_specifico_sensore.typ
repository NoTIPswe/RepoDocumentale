#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "selezione_specifico_sensore",
  system: CLOUD_SYS,
  title: "Selezione specifico sensore",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il Gateway relativo al sensore interessato è raggiungibile",
  ),
  postconds: (
    "Il sensore è selezionato correttamente",
  ),
  trigger: "L’attore principale vuole selezionare un sensore",
  main-scen: (
    (descr: "L’attore seleziona il gateway relativo al sensore"),
    (descr: "L’attore seleziona il sensore tra i sensori del gateway"),
  ),
)