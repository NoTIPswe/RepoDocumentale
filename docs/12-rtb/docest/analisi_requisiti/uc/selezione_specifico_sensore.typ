#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "selezione_specifico_sensore",
  system: CLOUD_SYS,
  title: "Selezione specifico sensore",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il sensore appartiene ad un Gateway attivo",
    "Il sensore risulta in funzione",
  ),
  postconds: (
    "Il sensore è selezionato correttamente",
  ),
  trigger: "L’Attore vuole selezionare un sensore",
  main-scen: (
    (descr: "L’Attore seleziona il Gateway relativo al sensore"),
    (descr: "L’Attore seleziona il sensore tra i sensori del Gateway"),
  ),
)
