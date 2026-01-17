#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "selezione_intervallo_temporale",
  system: CLOUD_SYS,
  title: "Selezione intervallo temporale",
  level: 2,
  prim-actors: (CA.tenant-adm, CA.sys-adm),
  preconds: (
    "L’Attore si trova nella sezione dedicata alla visualizzazione dei log",
  ),
  postconds: (
    "L’Attore ha selezionato un intervallo temporale valido",
  ),
  trigger: "L’Attore desidera inserire un intervallo temporale nel sistema",
  main-scen: (
    (descr: "L’Attore seleziona un timestamp minimo"),
    (descr: "L’Attore seleziona un timestamp massimo (maggiore del minimo)"),
  ),
)[#uml-schema("64.1", "Selezione intervallo temporale")]
