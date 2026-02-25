#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "filtraggio_dati",
  system: CLOUD_SYS,
  title: "Filtraggio dati",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema dispone di un insieme di dati da comunicare all'Attore",
  ),
  postconds: (
    "Il Sistema filtra l'insieme di dati secondo richiesta",
  ),
  main-scen: (
    (
      descr: "L'Attore definisce i parametri di filtraggio",
    ),
    (
      descr: "L'attore ottiene l'insieme filtrato dei dati di partenza",
    ),
  ),
  specialized-by: ("filtraggio_sensore", "filtraggio_sensore", "filtraggio_intervallo_temporale"),

  uml-descr: "Diagramma Filtraggio dati",
)
