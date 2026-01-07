#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "err_intervallo_temporale_invalido",
  system: CLOUD_SYS,
  title: "Intervallo Temporale Invalido",
  level: 1,
  prim-actors: CA.api-client,
  preconds: (
    "L’attore ha allegato un token di autenticazione valido",
    "L’intervallo temporale fornito nella richiesta non è valido",
  ),
  postconds: (
    "L’attore non può procedere con la richiesta",
    "L’attore riceve una risposta di errore",
  ),
  trigger: "L’intervallo temporale fornito dall’attore primario non è valido",
  main-scen: (
    (descr: "L’attore riceve una risposta di errore che segnala l’intervallo temporale non valido"),
  ),
)