#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "visualizzazione_nome_gateway",
  system: CLOUD_SYS,
  title: "Visualizzazione nome Gateway",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema presenta all’Attore una lista di Gateway, i dettagli di un Gateway oppure un alert relativo a un Gateway.",
  ),
  postconds: (
    "L'Attore visualizza il nome identificativo del Gateway",
  ),
  trigger: "Necessità di distinguere univocamente il Gateway",
  main-scen: (
    (descr: "Viene visualizzato il nome del Gateway"),
  ),

  uml-descr: "Diagramma Visualizzazione nome Gateway",
)
