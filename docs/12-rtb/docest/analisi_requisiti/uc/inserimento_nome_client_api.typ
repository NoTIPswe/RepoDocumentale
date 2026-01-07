#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "inserimento_nome_client_api",
  system: CLOUD_SYS,
  title: "Inserimento nome client API",
  level: 2,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’Attore si trova nella schermata di creazione delle credenziali API",
  ),
  postconds: (
    "Il sistema ha acquisito il nome descrittivo per il nuovo client",
  ),
  trigger: "L’attore deve fornire un riferimento mnemonico per il client API",
  main-scen: (
    (descr: "L’attore inserisce una stringa di testo identificativa nel campo dedicato"),
  ),
)