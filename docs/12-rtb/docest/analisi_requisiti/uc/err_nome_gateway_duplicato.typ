#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "err_nome_gateway_duplicato",
  system: CLOUD_SYS,
  title: "Errore nome Gateway duplicato",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il nome inserito dall’Attore risulta già assegnato ad un altro Gateway nel Tenant",
  ),
  postconds: (
    "L'Attore ricompila il campo nome Gateway",
  ),
  trigger: "Inserimento di un nome Gateway duplicato nel Tenant",
  main-scen: (
    (descr: "L’Attore viene notificato dell’invalidità del nome inserito"),
    (descr: "L’Attore viene invitato ad inserirne un altro valido"),
  ),
)[
  #uml-schema("41", "Diagramma Errore nome Gateway duplicato")
]
