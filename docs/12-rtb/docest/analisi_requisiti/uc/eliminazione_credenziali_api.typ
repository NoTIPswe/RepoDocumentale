#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "eliminazione_credenziali_api",
  system: CLOUD_SYS,
  title: "Eliminazione credenziali API",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il Sistema mostra le credenziali dell'API all'Attore primario",
  ),
  postconds: (
    "Le credenziali eliminate non sono più attive e valide all’interno del Sistema",
  ),
  trigger: "L'Attore vuole eliminare delle credenziali API",
  main-scen: (
    (
      descr: "L’Attore seleziona un API token da eliminare",
      inc: "selezione_credenziali_api",
    ),
    (descr: "L’Attore viene informato delle conseguenze dell’eliminazione"),
    (descr: "L’Attore conferma la volontà di eliminazione del token"),
  ),

  uml-descr: "Diagramma Eliminazione credenziali API",
)
