#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "sospensione_tenant",
  system: CLOUD_SYS,
  title: "Sospensione Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’attore si trova nella sezione di Gestione Tenant",
  ),
  postconds: (
    "Il Tenant è stato sospeso correttamente",
    "L’Amministratore di Tenant riceve una notifica riguardante la sospensione del Tenant ad esso associato",
  ),
  trigger: "Si desidera sospendere un Tenant",
  main-scen: (
    (
      descr: "L’attore seleziona un Tenant",
      inc: "selezione_tenant",
    ),
    (descr: "L’attore seleziona l’opzione di sospensione del Tenant"),
    (descr: "L’attore conferma la decisione di sospendere il Tenant selezionato"),
    (descr: "L’attore riceve una notifica di operazione avvenuta con successo"),
  ),
)[#uml-schema("88", "Sospensione Tenant")]
