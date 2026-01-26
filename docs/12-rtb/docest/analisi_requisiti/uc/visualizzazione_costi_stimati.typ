#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_costi_stimati",
  system: CLOUD_SYS,
  title: "Visualizzazione costi stimati",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il Gateway appartiene al Tenant e ha dei costi stimati associati",
  ),
  postconds: (
    "L’Attore visualizza i costi stimati relativi al Gateway",
  ),
  trigger: "L’Attore vuole visualizzare i costi stimati per il Tenant di cui è amministratore",
  main-scen: (
    (
      descr: "L'Attore seleziona uno o più Gateway di cui desidera monitorare i costi",
      inc: "selezione_gateway",
    ),
    (
      descr: "L'Attore visualizza il riepilogo dei costi stimati per storage dei Gateway selezionati",
      inc: "visualizzazione_costi_storage",
    ),
    (
      descr: "L'Attore visualizza il riepilogo dei costi stimati per banda dei Gateway selezionati",
      inc: "visualizzazione_costi_banda",
    ),
  ),
)[#uml-schema("49", "Visualizzazione costi stimati")]
