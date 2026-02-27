#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "visualizzazione_gateway_sospeso",
  system: CLOUD_SYS,
  title: "Visualizzazione Gateway Sospeso",
  gen-parent: "visualizzazione_stato_gateway",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Il Sistema presenta all’Attore la lista o il dettaglio di un Gateway",
    "Il Gateway è stato precedentemente disabilitato o sospeso tramite il Sistema",
  ),
  postconds: (
    "L'Attore visualizza l'indicatore di stato Sospeso",
  ),
  trigger: "Necessità di verificare lo stato del dispositivo",
  main-scen: (
    (descr: "Il Sistema mostra visivamente che il Gateway è in stato Sospeso"),
  ),
  uml-descr: none,
)
