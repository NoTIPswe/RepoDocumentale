#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "modifica_intervallo_sospensione_tenant",
  system: CLOUD_SYS,
  title: "Modifica intervallo minimo sospensione pre-eliminazione Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’attore si trova nella sezione dedicata alla visualizzazione dei Tenant",
  ),
  postconds: (
    "L’attore visualizza l’intervallo minimo di sospensione pre-eliminazione del Tenant",
  ),
  trigger: "Volontà di visualizzare o modificare l’intervallo minimo di sospensione pre-eliminazione di un Tenant",
  main-scen: (
    (descr: "L’attore visualizza l’intervallo temporale di sospensione (in giorni) minimo che deve trascorrere prima di poter eliminare il Tenant"),
  ),
)