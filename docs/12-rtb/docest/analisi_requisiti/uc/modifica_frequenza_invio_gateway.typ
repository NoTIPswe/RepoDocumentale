#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "modifica_frequenza_invio_gateway",
  system: CLOUD_SYS,
  title: "Modifica frequenza invio dati Gateway specifico",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il sistema mostra all’Attore primario l'attuale configurazione di un Gateway",
  ),
  postconds: (
    "La frequenza d’invio è stata correttamente aggiornata",
  ),
  trigger: "",
  main-scen: (
    (
      descr: "L’Attore sceglie un Gateway tramite il suo identificativo",
      inc: "selezione_gateway",
    ),
    (
      descr: "L’Attore inserisce un nuovo valore valido (in millisecondi) per la frequenza di invio dati",
      inc: "inserimento_valore_numerico",
    ),
    (descr: "L’Attore salva la nuova configurazione"),
    (descr: "L’Attore viene informato dell’avvenuta modifica"),
  ),
)[#uml-schema("68", "Modifica frequenza invio dati al Gateway specifico")]
