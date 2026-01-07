#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_dettagli_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione dettagli Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’attore si trova nella sezione dedicata alla visualizzazione dei Tenant",
  ),
  postconds: (
    "L’attore visualizza tutte le informazioni di dettaglio del Tenant selezionato",
  ),
  trigger: "L’attore vuole esaminare in profondità lo stato e i dati di uno specifico Tenant",
  main-scen: (
    (
      descr: "L’attore seleziona un Tenant dalla lista",
      inc: "selezione_tenant",
    ),
    (
      descr: "L’attore visualizza il nome del Tenant",
      inc: "visualizzazione_nome_tenant",
    ),
    (
      descr: "L’attore visualizza lo stato del Tenant",
      inc: "visualizzazione_stato_tenant",
    ),
    (
      descr: "L’attore visualizza l’identificativo del Tenant",
      inc: "visualizzazione_id_tenant",
    ),
    (
      descr: "L’attore visualizza l’intervallo minimo di sospensione pre-eliminazione",
      inc: "visualizzazione_intervallo_sospensione_tenant",
    ),
    // bookmark - ulteriori campi 
  ),
)