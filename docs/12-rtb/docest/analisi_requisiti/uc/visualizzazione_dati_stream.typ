#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_dati_stream",
  system: CLOUD_SYS,
  title: "Visualizzazione dati Stream",
  level: 1,
  prim-actors: CA.tenant-usr,
  preconds: (
    "Esiste almeno un sensore associato al Gateway di un Tenant gestito dall’attore primario",
  ),
  postconds: (
    "L’Attore primario ha visualizzato lo stream di suo interesse",
  ),
  trigger: "L’Attore primario vuole visualizzare i dati sullo Stream",
  main-scen: (
    (
      descr: "L’attore primario accede alla sezione “Visualizzazione dati Stream”",
      ep: "Filtraggio",
    ),
    (
      descr: "L’attore primario visualizza i dati richiesti in formato tabellare",
      inc: "visualizzazione_tabellare_dati_stream",
    ),
    (
      descr: "L’attore primario visualizza i dati richiesti in formato grafico",
      inc: "visualizzazione_grafico_dati_stream",
      ep: "NessunDato",
    ),
  ),
  alt-scen: (
    (
      ep: "Filtraggio",
      cond: "L’attore primario decide di filtrare i dati per gateway",
      uc: "filtraggio_gateway",
    ),
    (
      ep: "Filtraggio",
      cond: "L’attore primario decide di filtrare i dati per intervallo temporale",
      uc: "filtraggio_intervallo_temporale",
    ),
    (
      ep: "NessunDato",
      cond: "Non ci sono dati da visualizzare",
      uc: "err_dati_non_disponibili",
    ),
  ),
)
