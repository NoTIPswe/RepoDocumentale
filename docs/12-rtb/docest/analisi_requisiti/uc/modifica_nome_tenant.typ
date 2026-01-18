#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "modifica_nome_tenant",
  system: CLOUD_SYS,
  title: "Modifica Nome Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’Attore primario ha selezionato un Tenant",
    "Il sistema mostra all’Attore primario la lista dei Tenant modificabili",
  ),
  postconds: (
    "L’Attore ha modificato correttamente il nome Tenant",
  ),
  trigger: "",
  main-scen: (
    (descr: "L’Attore inserisce un nuovo nome descrittivo per il Tenant"),
    (descr: "L’Attore salva le modifiche"),
  ),
)[#uml-schema("84", "Modifica Nome Tenant")]
