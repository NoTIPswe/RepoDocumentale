#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "visualizzazione_singolo_sensore",
  system: CLOUD_SYS,
  title: "Visualizzazione singolo sensore",
  level: 3,
  prim-actors: CA.tenant-usr,
  preconds: (
    "L'attore primario sta visualizzando la lista di sensori collegati ad un gateway",
  ),
  postconds: (
    "L’attore primario visualizza, nel singolo elemento della lista, ID sensore e timestamp ultimo invio dati",
  ),
  trigger: "Identificazione dei sensori nel campo",
  main-scen: (
    (
      descr: "L’attore primario visualizza identificativo sensore",
      inc: "visualizzazione_id_sensore",
    ),
    (
      descr: "L’attore primario visualizza timestamp dell'ultima lettura",
      inc: "visualizzazione_timestamp_ultimo_invio_dati_sensore",
    ),
  ),
)
