#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "modifica_nome_tenant",
  system: CLOUD_SYS,
  title: "Modifica Nome Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’attore ha selezionato un Tenant",
    "L’attore si trova nella sezione dedicata alla modifica relativa ad un Tenant",
  ),
  postconds: (
    "L’attore ha modificato correttamente il nome Tenant",
  ),
  trigger: "Volontà di cambiare il nome identificativo di un Tenant",
  main-scen: (
    (descr: "L’attore inserisce un nuovo nome descrittivo per il Tenant"),
    (descr: "L’attore salva le modifiche"),
  ),
)
