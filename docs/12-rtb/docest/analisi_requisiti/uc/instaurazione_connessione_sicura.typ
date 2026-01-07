#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "instaurazione_connessione_sicura",
  system: CLOUD_SYS,
  title: "Instaurazione connessione sicura",
  level: 2,
  prim-actors: CA.np-gway,
  preconds: (
    "L’attore dispone delle credenziali crittografiche",
  ),
  postconds: (
    "L’autenticazione ha esito positivo",
    "È attivo un canale cifrato e autenticato tra Gateway e Cloud",
  ),
  trigger: "L’attore vuole aprire un canale di comunicazione sicuro per la comunicazione",
  main-scen: (
    (descr: "L'attore richiede l'apertura di una connessione sicura"),
    (descr: "L'attore verifica la validità del certificato che gli viene fornito"),
    (
      descr: "L'attore presenta il proprio certificato",
      ep: "CertificatoRifiutato",
    ),
    (descr: "Il canale sicuro viene stabilito con successo"),
  ),
  alt-scen: (
    (
      ep: "CertificatoRifiutato",
      cond: "Il Cloud rifiuta il certificato del gateway",
      uc: "err_autenticazione_gateway",
    ),
  ),
)