#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "riattivazione_tenant",
  system: CLOUD_SYS,
  title: "Riattivazione Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il Sistema mostra all’Attore primario la lista per la Gestione Tenant",
  ),
  postconds: (
    "Il Tenant è stato riattivato correttamente",
    "L’Amministratore di Tenant riceve una notifica riguardante la riattivazione del Tenant ad esso associato",
  ),
  trigger: "",
  main-scen: (
    (
      descr: "L’Attore seleziona un Tenant",
      inc: "selezione_tenant",
    ),
    (descr: "L’Attore seleziona l’opzione di attivazione del Tenant"),
    (descr: "L’Attore conferma la decisione di riattivare il Tenant selezionato"),
    (descr: "L’Attore riceve una notifica di operazione avvenuta con successo"),
  ),

  uml-descr: "Diagramma Riattivazione Tenant",
)
