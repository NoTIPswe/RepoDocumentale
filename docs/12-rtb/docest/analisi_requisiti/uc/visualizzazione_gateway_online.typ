#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "visualizzazione_gateway_online",
  system: CLOUD_SYS,
  title: "Visualizzazione Gateway Online",
  gen-parent: "visualizzazione_stato_gateway",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema presenta all’Attore la lista o il dettaglio di un Gateway",
    "Il Gateway è attualmente connesso e operativo",
  ),
  postconds: (
    "L'Attore visualizza l'indicatore di stato Online",
  ),
  trigger: "Necessità di verificare lo stato del dispositivo",
  main-scen: (
    (descr: "Il Sistema mostra visivamente che il Gateway è in stato Online"),
  ),
  uml-descr: none,
)
