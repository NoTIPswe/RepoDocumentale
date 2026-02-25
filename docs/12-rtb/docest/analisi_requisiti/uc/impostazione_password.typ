#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "impostazione_password",
  system: CLOUD_SYS,
  title: "Impostazione password",
  level: 1,
  prim-actors: (CA.non-authd-usr, CA.authd-usr),
  preconds: (
    "Il Sistema richiede l’impostazione di una nuova password per l’account",
  ),
  postconds: (
    "Password validata e salvata",
  ),
  trigger: "L'Attore deve inserire e confermare una password",
  main-scen: (
    (
      descr: "L'Attore inserisce la password",
      inc: "inserimento_nuova_password",
    ),
    (
      descr: "L'Attore conferma la password",
      inc: "conferma_nuova_password",
    ),
  ),

  uml-descr: "Diagramma Inserimento e conferma password",
)
