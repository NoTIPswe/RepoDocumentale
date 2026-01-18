#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_intervallo_sospensione_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione intervallo minimo di sospensione pre-eliminazione",
  level: 2,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il sistema mostra all’Attore primario la lista dei Tenant",
  ),
  postconds: (
    "L’Attore visualizza l’intervallo temporale minimo di sospensione pre-eliminazione",
  ),
  trigger: "",
  main-scen: (
    (descr: "L’Attore visualizza il valore (in giorni) dell’intervallo minimo di sospensione"),
  ),
)
