#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_dati_stream",
  system: CLOUD_SYS,
  title: "Visualizzazione dati Stream",
  level: 1,
  prim-actors: CA.tenant-usr,
  sec-actors: CA.p-gway,
  preconds: (
    "Esiste almeno un sensore associato al Gateway di un Tenant gestito dall’Attore primario",
  ),
  postconds: (
    "L’Attore ha visualizzato lo stream di suo interesse",
  ),
  trigger: "L’Attore vuole visualizzare i dati sullo Stream",
  main-scen: (
    (
      descr: "L’Attore accede alla sezione “Visualizzazione dati Stream”",
    ),
    (
      descr: "L’Attore visualizza i dati richiesti in formato tabellare",
      inc: "visualizzazione_tabellare_dati_stream",
    ),
    (
      descr: "L’Attore visualizza i dati richiesti in formato grafico",
      inc: "visualizzazione_grafico_dati_stream",
      ep: "NessunDato",
    ),
  ),
  alt-scen: (
    (
      ep: "NessunDato",
      cond: "Non ci sono dati da visualizzare",
      uc: "err_dati_non_disponibili",
    ),
  ),
)[
  #uml-schema("24", "Diagramma Visualizzazione dati Stream")
]
