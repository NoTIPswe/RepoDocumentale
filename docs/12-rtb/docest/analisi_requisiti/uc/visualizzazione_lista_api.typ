#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_lista_api",
  system: CLOUD_SYS,
  title: "Visualizzazione lista credenziali API del Tenant",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’Attore si trova nella sezione dedicata alla visualizzazione degli API token",
  ),
  postconds: (
    "L’attore visualizza le credenziali API relative al Tenant",
  ),
  trigger: "L’Attore vuole navigare gli API token",
  main-scen: (
    (
      descr: "L’attore visualizza la lista di tutte le credenziali API relative al Tenant",
      inc: "visualizzazione_singole_api",
    ),
  ),
)
