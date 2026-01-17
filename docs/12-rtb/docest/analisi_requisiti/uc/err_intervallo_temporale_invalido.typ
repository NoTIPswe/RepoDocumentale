#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "err_intervallo_temporale_invalido",
  system: CLOUD_SYS,
  title: "Intervallo Temporale Invalido",
  level: 1,
  prim-actors: CA.api-client,
  preconds: (
    "L’Attore ha allegato un token di autenticazione valido",
    "L’intervallo temporale fornito nella richiesta non è valido",
  ),
  postconds: (
    "L’Attore non può procedere con la richiesta",
    "L’Attore riceve una risposta di errore",
  ),
  trigger: "L’intervallo temporale fornito dall’Attore primario non è valido",
  main-scen: (
    (descr: "L’Attore riceve una risposta di errore che segnala l’intervallo temporale non valido"),
  ),
)[#uml-schema("76", "Errore intervallo temporale invalido")]
