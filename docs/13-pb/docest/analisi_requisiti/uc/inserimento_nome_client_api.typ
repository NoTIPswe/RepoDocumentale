#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "inserimento_nome_client_api",
  system: CLOUD_SYS,
  title: "Inserimento nome Client API",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste almeno un Tenant",
    "Il Tenant risulta attivo",
    "Il Sistema sta attendendo che l'Attore inserisca il nome Client API",
  ),
  postconds: (
    "Il Sistema ha acquisito il nome descrittivo per il nuovo Client",
  ),
  trigger: "L’Attore deve fornire un riferimento mnemonico per il Client API",
  main-scen: (
    (descr: "L’Attore inserisce una stringa di testo identificativa nel campo dedicato"),
  ),
)
