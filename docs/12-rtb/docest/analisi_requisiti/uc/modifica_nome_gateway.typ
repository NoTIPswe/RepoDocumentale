#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "modifica_nome_gateway",
  system: CLOUD_SYS,
  title: "Modifica nome gateway",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il gateway selezionato appartiene al Tenant",
    "L’attore si trova in una sezione dedicata alla modifica del gateway",
  ),
  postconds: (
    "Il nuovo nome è stato assegnato al gateway",
  ),
  trigger: "L’attore principale vuole cambiare il nome di un gateway proprietario",
  main-scen: (
    (
      descr: "L’attore principale inserisce il nuovo nome da associare al gateway",
      ep: "NomeDuplicato",
    ),
    (descr: "L’attore salva le modifiche"),
  ),
  alt-scen: (
    (
      ep: "NomeDuplicato",
      cond: "Il nome inserito è già assegnato ad un altro gateway nel Tenant",
      uc: "err_nome_gateway_duplicato",
    ),
  ),
)
