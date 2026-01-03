#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "visualizzazione_nome_gateway",
  system: CLOUD_SYS,
  title: "Visualizzazione nome gateway",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L'attore primario sta visualizzando una lista di gateway, i dettagli di uno di essi o un alert riguardante un gateway",
  ),
  postconds: (
    "L'attore primario visualizza il nome identificativo del gateway",
  ),
  trigger: "Necessità di distinguere univocamente il gateway",
  main-scen: (
    (descr: "Viene visualizzato il nome del gateway"),
  ),
)
