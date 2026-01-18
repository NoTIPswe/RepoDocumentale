#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "creazione_credenziali_api",
  system: CLOUD_SYS,
  title: "Creazione credenziali client API",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Tenant",
    "Il Tenant risulta attivo",
  ),
  postconds: (
    "Sono state generate e salvate nuove credenziali (Client ID e Secret) associate al Tenant",
  ),
  trigger: "L’Attore vuole abilitare un sistema esterno ad accedere ai dati del Tenant",
  main-scen: (
    (descr: "L’Attore richiede la creazione di un nuovo accesso API"),
    (
      descr: "L’Attore assegna un nome descrittivo al client",
      inc: "inserimento_nome_client_api",
    ),
    (
      descr: "L’Attore visualizza il Client ID",
      inc: "visualizzazione_client_id",
    ),
    (
      descr: "L’Attore visualizza per un’unica volta il Client Secret",
      inc: "visualizzazione_secret_api",
    ),
  ),
)[#uml-schema("58", "Creazione credenziali Client API")]
