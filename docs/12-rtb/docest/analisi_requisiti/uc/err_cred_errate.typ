#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "err_cred_errate",
  system: CLOUD_SYS,
  title: "Errore credenziali errate",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "Le credenziali primarie fornite non risultano valide per alcun account registrato",
  ),
  postconds: ("Viene negato l'accesso al Sistema", "L'Attore viene informato dell'errore"),
  trigger: "L'Attore ha inserito delle credenziali non valide",
  main-scen: (
    (descr: "L'Attore viene informato del problema in fase di autenticazione"),
  ),
)[
  #uml-schema("2", "Diagramma Errore credenziali errate")
]

