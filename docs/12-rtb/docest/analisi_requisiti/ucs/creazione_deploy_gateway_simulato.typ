#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  system: SIM_SYS,
  id: "creazione_deploy_gateway_simulato",
  level: 1,
  title: "Creazione e Deploy di un Gateway simulato",
  prim-actors: (SA.sym-usr),
  preconds: (
    "Il Sistema si trova nella sezione di gestione della simulazione",
  ),
  postconds: (
    "L’istanza del Gateway simulato è stata creata e deployata correttamente",
  ),
  trigger: "Si desidera creare un Gateway simulato",
  main-scen: (
    (descr: "L’Attore avvia la procedura di creazione"),
    (
      descr: "L’Attore inserisce i dati relativi alla configurazione della simulazione",
      inc: "inserimento_dati_config_sim_gateway",
    ),
    (descr: "L’Attore conferma l’operazione di creazione"),
    (
      descr: "L’Attore viene informato del successo dell’operazione",
      ep: "ErroreDeploy",
    ),
  ),
  alt-scen: (
    (
      ep: "ErroreDeploy",
      cond: "Errore di sistema nella creazione delle istanze",
      uc: "err_deploy_gateway_simulato",
    ),
  ),

  uml-descr: "Diagramma Creazione e deploy di un Gateway simulato",
)

