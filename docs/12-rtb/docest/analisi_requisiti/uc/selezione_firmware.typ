#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "selezione_firmware",
  system: CLOUD_SYS,
  title: "Selezione firmware",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’attore si trova nella sezione dedicata alla gestione dei Gateway",
    "Esiste almeno un nuovo firmware valido nel sistema che possa essere caricato",
    "L’attore ha selezionato dei gateway da aggiornare",
  ),
  postconds: (
    "L’attore ha selezionato con successo la versione firmware da installare",
  ),
  trigger: "L’attore desidera installare una nuova versione del firmware sui dispositivi",
  main-scen: (
    (
      descr: "L’attore visualizza la lista delle versioni del firmware tra quelle compatibili con tutti i gateway selezionati",
    ),
    (descr: "L’attore seleziona una versione tra quelle visualizzate"),
  ),
)
