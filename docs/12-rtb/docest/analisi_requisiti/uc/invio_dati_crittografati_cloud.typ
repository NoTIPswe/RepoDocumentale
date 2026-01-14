#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "invio_dati_crittografati_cloud",
  system: CLOUD_SYS,
  title: "Invio Dati Crittografati al Cloud",
  level: 1,
  prim-actors: CA.p-gway,
  preconds: (
    "Esistono dati pronti per essere inviati al Cloud",
  ),
  postconds: (
    "I dati sono stati inviati correttamente al Cloud in forma sicura",
  ),
  trigger: "Scadenza del timer di invio dati al cloud del gateway",
  main-scen: (
    (
      descr: "L’attore stabilisce una connessione sicura verso l'Endpoint del Cloud",
      inc: "instaurazione_connessione_sicura",
    ),
    (descr: "L’attore invia i dati in maniera sicura al Cloud"),
    (descr: "L’attore riceve la notifica dell’esito dell’operazione"),
  ),
)[#uml-schema("99", "Invio dati crittografati al Cloud")]
