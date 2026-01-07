#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_costi_stimati",
  system: CLOUD_SYS,
  title: "Visualizzazione costi stimati",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’attore primario si trova nella sezione dedicata ai costi del Tenant",
  ),
  postconds: (
    "L’attore visualizza i costi stimati relativi al Gateway",
  ),
  trigger: "L’attore vuole visualizzare i costi stimati per il Tenant di cui è amministratore",
  main-scen: (
    (
      descr: "L'attore seleziona uno o più Gateway di cui desidera monitorare i costi",
      inc: "selezione_gateway",
    ),
    (
      descr: "L'attore visualizza il riepilogo dei costi stimati per storage dei gateway selezionati",
      inc: "visualizzazione_costi_storage",
    ),
    (
      descr: "L'attore visualizza il riepilogo dei costi stimati per banda dei gateway selezionati",
      inc: "visualizzazione_costi_banda",
    ),
  ),
)