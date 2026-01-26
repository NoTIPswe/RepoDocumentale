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
  trigger: "Scadenza del timer di invio dati al cloud del Gateway",
  main-scen: (
    (
      descr: "L’Attore stabilisce una connessione sicura verso l'Endpoint del Cloud",
      inc: "instaurazione_connessione_sicura",
    ),
    (descr: "L’Attore invia i dati in maniera sicura al Cloud"),
    (descr: "L’Attore riceve la notifica dell’esito dell’operazione"),
  ),
)[#uml-schema("100", "Invio dati crittografati al Cloud")]
