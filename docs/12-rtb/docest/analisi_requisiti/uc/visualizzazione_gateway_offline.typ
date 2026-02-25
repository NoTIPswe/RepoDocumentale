#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "visualizzazione_gateway_offline",
  system: CLOUD_SYS,
  title: "Visualizzazione Gateway Offline",
  gen-parent: "visualizzazione_stato_gateway",
  level: 2,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema presenta all’Attore la lista o il dettaglio di un Gateway",
    "Il Gateway è attualmente disconnesso, spento o irraggiungibile dalla rete",
  ),
  postconds: (
    "L'Attore visualizza l'indicatore di stato 'Offline'",
  ),
  trigger: "Necessità di verificare lo stato del dispositivo",
  main-scen: (
    (descr: "Il Sistema mostra visivamente che il Gateway è in stato 'Offline'"),
  ),
  uml-descr: none,
)

// bookmark - andare a promuoverlo a livello 1 quando sistemiamo la generazione dei grafici automatica
