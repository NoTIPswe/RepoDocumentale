#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "err_intervallo_temporale_invalido",
  system: CLOUD_SYS,
  title: "Errore intervallo Temporale Invalido",
  level: 1,
  prim-actors: CA.api-client,
  preconds: (
    "Il Sistema riceve un token di autenticazione valido dall'Attore",
    "L’intervallo temporale fornito nella richiesta non è valido",
  ),
  postconds: (
    "L’Attore non può procedere con la richiesta",
    "L’Attore riceve una risposta di errore",
  ),
  trigger: "",
  main-scen: (
    (descr: "L’Attore riceve una risposta di errore che segnala l’intervallo temporale non valido"),
  ),

  uml-descr: "Diagramma Errore intervallo temporale invalido",
)
