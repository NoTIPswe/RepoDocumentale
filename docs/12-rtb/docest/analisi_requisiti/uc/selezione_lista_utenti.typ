#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "selezione_lista_utenti",
  system: CLOUD_SYS,
  title: "Selezione lista utenti",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’Attore principale sta visualizzando la lista di Utenti del Tenant",
  ),
  postconds: (
    "Uno o più utenti sono stati selezionati",
  ),
  trigger: "L’attore principale desidera compiere un'operazione massiva su più account",
  main-scen: (
    (descr: "L’Attore principale seleziona uno o più utenti del Tenant"),
  ),
)
