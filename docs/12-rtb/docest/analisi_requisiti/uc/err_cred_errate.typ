#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "err_cred_errate",
  system: CLOUD_SYS,
  title: "Errore - Credenziali errate",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "L'attore sta eseguendo una procedura di autenticazione",
    "L'attore ha fornito delle credenziali non corrette",
  ),
  postconds: ("Viene negato l'accesso al sistema", "L'attore viene informato dell'errore"),
  trigger: "L'attore ha inserito delle credenziali non valide",
  main-scen: (
    (descr: "L'attore viene informato del problema in fase di autenticazione"),
  ),
)

