#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  system: SIM_SYS,
  id: "eliminazione_sensore_simulato",
  level: 1,
  title: "Eliminazione sensore simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Il Sistema si trova nella sezione di gestione dei Gateway simulati ed è stato selezionato un sensore appartenente ad un Gateway simulato",
  ),
  postconds: (
    "L'istanza di simulazione del sensore è stata eliminata",
  ),
  trigger: "Si desidera eliminare un sensore simulato",
  main-scen: (
    (descr: "L’Attore seleziona l’opzione di eliminazione del sensore"),
    (descr: "L’Attore conferma la decisione di eliminare il sensore selezionato"),
    (descr: "L’Attore riceve una notifica di operazione avvenuta con successo"),
  ),
)[
  #uml-schema("S9", "Diagramma Eliminazione sensore simulato")
]

