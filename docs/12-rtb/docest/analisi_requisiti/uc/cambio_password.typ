#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "cambio_password",
  system: CLOUD_SYS,
  title: "Cambio password",
  level: 1,
  prim-actors: CA.non-authd-usr,
  preconds: (
    "Il Sistema ha validato il token di recupero password associato all’account",
  ),
  postconds: (
    "La nuova password è salvata nel database",
  ),
  trigger: "Accesso alla pagina di impostazione tramite token di sicurezza",
  main-scen: (
    (
      descr: "L'Attore inserisce la nuova password",
      inc: "impostazione_password",
    ),
  ),

  uml-descr: none,
  // bookmark - manca da aggiungere questo diagramma
)
