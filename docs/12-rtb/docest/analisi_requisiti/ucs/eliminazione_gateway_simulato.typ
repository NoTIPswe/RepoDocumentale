#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "eliminazione_gateway_simulato",
  level: 1,
  title: "Eliminazione Gateway simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’attore si trova nella sezione di gestione dei Gateway simulati",
    "L’attore ha selezionato il Gateway simulato di interesse",
    "L’attore entra nella relativa sezione di Gestione",
  ),
  postconds: (
    "L’istanza di simulazione del Gateway è stata eliminata",
    "Il Gateway non comunica più i dati al Sistema Cloud",
  ),
  trigger: "Si desidera eliminare un Gateway simulato",
  main-scen: (
    (descr: "L’attore seleziona l’opzione di eliminazione del Gateway"),
    (descr: "L’attore conferma la decisione di eliminare il Gateway selezionato"),
    (descr: "L’attore riceve una notifica di operazione avvenuta con successo"),
  ),
)
