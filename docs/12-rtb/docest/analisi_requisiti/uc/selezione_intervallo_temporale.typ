#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "selezione_intervallo_temporale",
  system: CLOUD_SYS,
  title: "Selezione intervallo temporale",
  level: 2,
  prim-actors: (CA.tenant-adm, CA.sys-adm),
  preconds: (
    "L’attore si trova nella sezione dedicata alla visualizzazione dei log",
  ),
  postconds: (
    "L’Attore ha selezionato un intervallo temporale valido",
  ),
  trigger: "L’attore desidera inserire un intervallo temporale nel sistema",
  main-scen: (
    (descr: "L’attore seleziona un timestamp minimo"),
    (descr: "L’attore seleziona un timestamp massimo (maggiore del minimo)"),
  ),
)