#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "riattivazione_tenant",
  system: CLOUD_SYS,
  title: "Riattivazione Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’attore si trova nella sezione di Gestione Tenant",
  ),
  postconds: (
    "Il Tenant è stato riattivato correttamente",
    "L’Amministratore di Tenant riceve una notifica riguardante la riattivazione del Tenant ad esso associato",
  ),
  trigger: "Si desidera riattivare un Tenant",
  main-scen: (
    (
      descr: "L’attore seleziona un Tenant",
      inc: "selezione_tenant",
    ),
    (descr: "L’attore seleziona l’opzione di attivazione del Tenant"),
    (descr: "L’attore conferma la decisione di riattivare il Tenant selezionato"),
    (descr: "L’attore riceve una notifica di operazione avvenuta con successo"),
  ),
)
