#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "selezione_lista_utenti",
  system: CLOUD_SYS,
  title: "Selezione lista utenti",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Utente associato al Tenant",
    "Il Sistema sta mostrando la lista di Utenti associati al Tenant",
  ),
  postconds: (
    "Uno o più utenti sono stati selezionati",
  ),
  trigger: "L’Attore desidera compiere un'operazione massiva su più account",
  main-scen: (
    (descr: "L’Attore seleziona uno o più utenti del Tenant"),
  ),
)
