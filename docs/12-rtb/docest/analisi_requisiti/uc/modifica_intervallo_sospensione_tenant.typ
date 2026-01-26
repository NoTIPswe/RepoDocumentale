#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "modifica_intervallo_sospensione_tenant",
  system: CLOUD_SYS,
  title: "Modifica intervallo minimo sospensione pre-eliminazione Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il sistema mostra all’Attore primario la lista dei Tenant",
  ),
  postconds: (
    "L’Attore modifica l’intervallo minimo di sospensione pre-eliminazione del Tenant",
  ),
  trigger: "",
  main-scen: (
    (
      descr: "L’Attore visualizza l’intervallo temporale di sospensione (in giorni) minimo che deve trascorrere prima di poter eliminare il Tenant",
    ),
  ),
)[#uml-schema("84", "Modifica intervallo minimo sospensione pre-eliminazione Tenant")]
