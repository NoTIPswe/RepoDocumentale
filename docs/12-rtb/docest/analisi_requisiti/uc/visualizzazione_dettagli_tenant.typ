#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "visualizzazione_dettagli_tenant",
  system: CLOUD_SYS,
  title: "Visualizzazione dettagli Tenant",
  level: 1,
  prim-actors: CA.sys-adm,
  preconds: (
    "Il Sistema mostra all’Attore primario la lista dei Tenant",
  ),
  postconds: (
    "L’Attore visualizza tutte le informazioni di dettaglio del Tenant selezionato",
  ),
  trigger: "",
  main-scen: (
    (
      descr: "L’Attore seleziona un Tenant dalla lista",
      inc: "selezione_tenant",
    ),
    (
      descr: "L’Attore visualizza il nome del Tenant",
      inc: "visualizzazione_nome_tenant",
    ),
    (
      descr: "L’Attore visualizza lo stato del Tenant",
      inc: "visualizzazione_stato_tenant",
    ),
    (
      descr: "L’Attore visualizza l’identificativo del Tenant",
      inc: "visualizzazione_id_tenant",
    ),
    (
      descr: "L’Attore visualizza l’intervallo minimo di sospensione pre-eliminazione",
      inc: "visualizzazione_intervallo_sospensione_tenant",
    ),
    // bookmark
    // consumi leagti ad i Gateway associati
  ),
)[#uml-schema("80", "Diagramma Visualizzazione dettagli Tenant")]
