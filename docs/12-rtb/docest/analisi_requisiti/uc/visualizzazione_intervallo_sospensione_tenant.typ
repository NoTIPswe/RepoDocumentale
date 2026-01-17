#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_intervallo_sospensione_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione intervallo minimo di sospensione pre-eliminazione",
  level: 2,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’Attore primario si trova nella sezione dedicata alla visualizzazione dei Tenant",
  ),
  postconds: (
    "L’Attore visualizza l’intervallo temporale minimo di sospensione pre-eliminazione",
  ),
  trigger: "Necessità di conoscere l’intervallo minimo di sospensione pre-eliminazione di un Tenant",
  main-scen: (
    (descr: "L’Attore visualizza il valore (in giorni) dell’intervallo minimo di sospensione"),
  ),
)
