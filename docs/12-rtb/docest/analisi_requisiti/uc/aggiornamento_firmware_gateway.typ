#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "aggiornamento_firmware_gateway",
  system: CLOUD_SYS,
  title: "Aggiornamento del firmware Gateway",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’attore si trova nella sezione dedicata alla gestione dei Gateway",
    "Esiste almeno un nuovo firmware valido nel sistema che possa essere caricato",
  ),
  postconds: (
    "L’attore ha aggiornato con successo i dispositivi selezionati",
  ),
  trigger: "L’attore desidera installare una nuova versione del firmware sui dispositivi",
  main-scen: (
    (
      descr: "L’attore seleziona i Gateway sui quali vuole effettuare l’aggiornamento firmware",
      inc: "selezione_gateway",
    ),
    (
      descr: "L’attore sceglie la versione del firmware tra quelle compatibili con tutti i gateway selezionati",
      inc: "selezione_firmware",
    ),
    (descr: "L’attore conferma l’avvio della procedura di aggiornamento"),
    (descr: "L’attore viene informato del buon esito della procedura al completamento"),
  ),
)[#uml-schema("66", "Aggiornamento del firmware Gateway")]
