#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "eliminazione_tenant",
  system: CLOUD_SYS,
  title: "Eliminazione Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’Attore si trova nella sezione di Gestione Tenant",
    "L’Attore seleziona il Tenant di interesse",
    "L’Attore entra nella relativa sezione di Gestione",
    "Il Tenant di interesse si trova nello stato “sospeso” da un intervallo di tempo maggiore dell’intervallo minimo di sospensione pre-eliminazione selezionato",
  ),
  postconds: (
    "Il Tenant è stato eliminato correttamente",
    "L’Amministratore di Tenant riceve una notifica riguardante l’eliminazione del Tenant precedentemente ad esso associato",
  ),
  trigger: "Si desidera eliminare un Tenant",
  main-scen: (
    (descr: "L’Attore primario seleziona l’opzione di eliminazione del Tenant"),
    (
      descr: "L’Attore primario conferma la decisione di eliminare il Tenant selezionato",
      inc: "conferma_eliminazione_tenant",
    ),
    (descr: "L’Attore riceve una notifica di operazione avvenuta con successo"),
  ),
)[#uml-schema("90", "Eliminazione Tenant")]
