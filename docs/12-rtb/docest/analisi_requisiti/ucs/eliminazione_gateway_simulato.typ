#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "eliminazione_gateway_simulato",
  level: 1,
  title: "Eliminazione Gateway simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "L’Attore si trova nella sezione di gestione dei Gateway simulati",
    "L’Attore ha selezionato il Gateway simulato di interesse",
    "L’Attore entra nella relativa sezione di Gestione",
  ),
  postconds: (
    "L’istanza di simulazione del Gateway è stata eliminata",
    "Il Gateway non comunica più i dati al Sistema Cloud",
  ),
  trigger: "Si desidera eliminare un Gateway simulato",
  main-scen: (
    (descr: "L’Attore seleziona l’opzione di eliminazione del Gateway"),
    (descr: "L’Attore conferma la decisione di eliminare il Gateway selezionato"),
    (descr: "L’Attore riceve una notifica di operazione avvenuta con successo"),
  ),
)
