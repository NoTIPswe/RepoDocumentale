#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "eliminazione_tenant",
  system: CLOUD_SYS,
  title: "Eliminazione Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il sistema mostra all’Attore primario la lista per la Gestione Tenant",
    "Il Tenant di interesse è stato selezionato",
    "Il sistema mostra la sezione di Gestione del tenant all'Attore primario",
    "Il Tenant di interesse si trova nello stato “sospeso” da un intervallo di tempo maggiore dell’intervallo minimo di sospensione pre-eliminazione selezionato",
  ),
  postconds: (
    "Il Tenant è stato eliminato correttamente",
    "L’Amministratore di Tenant riceve una notifica riguardante l’eliminazione del Tenant precedentemente ad esso associato",
  ),
  trigger: "",
  main-scen: (
    (descr: "L’Attore primario seleziona l’opzione di eliminazione del Tenant"),
    (
      descr: "L’Attore primario conferma la decisione di eliminare il Tenant selezionato",
      inc: "conferma_eliminazione_tenant",
    ),
    (descr: "L’Attore riceve una notifica di operazione avvenuta con successo"),
  ),
)[#uml-schema("91", "Eliminazione Tenant")]
