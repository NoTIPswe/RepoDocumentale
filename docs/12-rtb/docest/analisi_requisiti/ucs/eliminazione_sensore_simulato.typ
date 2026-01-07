#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "eliminazione_sensore_simulato",
  level: 1,
  title: "Eliminazione sensore simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore si trova nella sezione di gestione dei Gateway simulati",
    "L’attore ha selezionato il Gateway simulato di interesse",
    "L’attore ha selezionato un sensore simulato",
  ),
  postconds: (
    "L’istanza di simulazione del sensore è stata eliminata",
  ),
  trigger: "Si desidera eliminare un sensore simulato",
  main-scen: (
    (descr: "L’attore seleziona l’opzione di eliminazione del sensore"),
    (descr: "L’attore conferma la decisione di eliminare il sensore selezionato"),
    (descr: "L’attore riceve una notifica di operazione avvenuta con successo"),
  ),
)