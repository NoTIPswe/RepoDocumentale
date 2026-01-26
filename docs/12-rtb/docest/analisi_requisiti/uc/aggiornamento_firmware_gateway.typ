#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "aggiornamento_firmware_gateway",
  system: CLOUD_SYS,
  title: "Aggiornamento del firmware Gateway",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il sistema mostra all'Attore primario la lista dei Gateway",
    "Esiste almeno un nuovo firmware valido nel sistema che possa essere caricato",
  ),
  postconds: (
    "L’Attore ha aggiornato con successo i dispositivi selezionati",
  ),
  trigger: "L’Attore desidera installare una nuova versione del firmware sui dispositivi",
  main-scen: (
    (
      descr: "L’Attore seleziona i Gateway sui quali vuole effettuare l’aggiornamento firmware",
      inc: "selezione_gateway",
    ),
    (
      descr: "L’Attore sceglie la versione del firmware tra quelle compatibili con tutti i Gateway selezionati",
      inc: "selezione_firmware",
    ),
    (descr: "L’Attore conferma l’avvio della procedura di aggiornamento"),
    (descr: "L’Attore viene informato del buon esito della procedura al completamento"),
  ),
)[#uml-schema("67", "Aggiornamento del firmware Gateway")]
