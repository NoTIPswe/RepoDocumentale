#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "err_nome_gateway_duplicato",
  system: CLOUD_SYS,
  title: "Nome Gateway Duplicato",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il nome inserito dall’attore principale è già assegnato ad un altro gateway nel Tenant",
  ),
  postconds: (
    "Il sistema richiede l’immissione di un nuovo nome",
  ),
  trigger: "L’attore principale ha inserito un nome duplicato ad un Gateway",
  main-scen: (
    (descr: "L’attore principale viene notificato dell’invalidità del nome inserito"),
    (descr: "L’attore principale viene invitato ad inserirne un altro valido"),
  ),
)