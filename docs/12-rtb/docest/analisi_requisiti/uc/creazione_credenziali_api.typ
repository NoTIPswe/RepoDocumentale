#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "creazione_credenziali_api",
  system: CLOUD_SYS,
  title: "Creazione credenziali client API",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’Attore si trova nella sezione dedicata",
  ),
  postconds: (
    "Sono state generate e salvate nuove credenziali (Client ID e Secret) associate al Tenant",
  ),
  trigger: "L’Attore vuole abilitare un sistema esterno ad accedere ai dati del Tenant",
  main-scen: (
    (descr: "L’attore richiede la creazione di un nuovo accesso API"),
    (
      descr: "L’attore assegna un nome descrittivo al client",
      inc: "inserimento_nome_client_api",
    ),
    (
      descr: "L’attore visualizza il Client ID",
      inc: "visualizzazione_client_id",
    ),
    (
      descr: "L’attore visualizza per un’unica volta il Client Secret",
      inc: "visualizzazione_secret_api",
    ),
  ),
)