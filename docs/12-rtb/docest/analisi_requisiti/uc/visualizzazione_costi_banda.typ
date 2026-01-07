#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_costi_banda",
  system: CLOUD_SYS,
  title: "Visualizzazione costi stimati per banda",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’attore primario si trova nella sezione dedicata ai costi del Tenant",
    "L’attore ha selezionato uno o più gateway",
  ),
  postconds: (
    "L’Attore visualizza correttamente i costi stimati raggruppati in base alla banda",
  ),
  trigger: "L’attore principale vuole visualizzare i costi stimati dei Gateway associati al Tenant per banda",
  main-scen: (
    (descr: "L'attore visualizza il riepilogo dei costi stimati per banda dei dati relativi ai Gateway selezionati"),
  ),
)
