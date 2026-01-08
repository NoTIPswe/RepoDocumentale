#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_costi_storage",
  system: CLOUD_SYS,
  title: "Visualizzazione costi stimati per storage",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’attore primario si trova nella sezione dedicata ai costi del Tenant",
    "L’attore ha selezionato uno o più Gateway",
  ),
  postconds: (
    "L’attore visualizza i costi stimati relativi allo storage del Gateway selezionato",
  ),
  trigger: "L’attore vuole visualizzare i costi stimati per un Tenant di cui è proprietario",
  main-scen: (
    (descr: "L'attore visualizza il riepilogo dei costi stimati per storage dei dati relativi ai Gateway selezionati"),
  ),
)
