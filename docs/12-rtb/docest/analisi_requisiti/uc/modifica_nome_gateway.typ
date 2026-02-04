#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "modifica_nome_gateway",
  system: CLOUD_SYS,
  title: "Modifica nome Gateway",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il Gateway appartiene al Tenant",
    "L'Attore risulta admin del Tenant",
  ),
  postconds: (
    "Il nuovo nome è stato assegnato al Gateway",
  ),
  trigger: "L’Attore vuole cambiare il nome di un Gateway proprietario",
  main-scen: (
    (
      descr: "L’Attore inserisce il nuovo nome da associare al Gateway",
      ep: "NomeDuplicato",
    ),
    (descr: "L’Attore salva le modifiche"),
  ),
  alt-scen: (
    (
      ep: "NomeDuplicato",
      cond: "Il nome inserito è già assegnato ad un altro Gateway nel Tenant",
      uc: "err_nome_gateway_duplicato",
    ),
  ),
)[
  #uml-schema("40", "Diagramma Modifica nome Gateway")
]
