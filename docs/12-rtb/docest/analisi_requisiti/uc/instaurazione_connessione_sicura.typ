#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "instaurazione_connessione_sicura",
  system: CLOUD_SYS,
  title: "Instaurazione connessione sicura",
  level: 2,
  prim-actors: CA.np-gway,
  preconds: (
    "L’Attore dispone delle credenziali crittografiche",
  ),
  postconds: (
    "L’autenticazione ha esito positivo",
    "È attivo un canale cifrato e autenticato tra Gateway e Cloud",
  ),
  trigger: "L’Attore vuole aprire un canale di comunicazione sicuro per la comunicazione",
  main-scen: (
    (descr: "L'Attore richiede l'apertura di una connessione sicura"),
    (descr: "L'Attore verifica la validità del certificato che gli viene fornito"),
    (
      descr: "L'Attore presenta il proprio certificato",
      ep: "CertificatoRifiutato",
    ),
    (descr: "Il canale sicuro viene stabilito con successo"),
  ),
  alt-scen: (
    (
      ep: "CertificatoRifiutato",
      cond: "Il Cloud rifiuta il certificato del Gateway",
      uc: "err_autenticazione_gateway",
    ),
  ),
)[#uml-schema("100.1", "Diagramma Instaurazione connessione sicura")]
