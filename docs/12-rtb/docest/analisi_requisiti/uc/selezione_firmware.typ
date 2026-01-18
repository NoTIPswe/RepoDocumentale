#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "selezione_firmware",
  system: CLOUD_SYS,
  title: "Selezione firmware",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il sistema mostra all'Attore primario la lista dei Gateway",
    "Esiste almeno un nuovo firmware valido nel sistema che possa essere caricato",
    "L’Attore primario ha selezionato dei Gateway da aggiornare",
  ),
  postconds: (
    "L’Attore ha selezionato con successo la versione firmware da installare",
  ),
  trigger: "L’Attore desidera installare una nuova versione del firmware sui dispositivi",
  main-scen: (
    (
      descr: "L’Attore visualizza la lista delle versioni del firmware tra quelle compatibili con tutti i Gateway selezionati",
    ),
    (descr: "L’Attore seleziona una versione tra quelle visualizzate"),
  ),
)[#uml-schema("66.1", "Selezione firmware")]
