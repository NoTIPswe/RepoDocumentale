#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "modifica_stato_gateway",
  system: CLOUD_SYS,
  title: "Modifica stato del Gateway",
  level: 1,
  prim-actors: CA.tenant-adm,
  sec-actors: CA.p-gway,
  preconds: (
    "Il Gateway appartiene al Tenant",
    "L'Attore ha precedentemente selezionato il Gateway su cui operare",
    "Il Gateway si trova in uno stato attivo/disabilitato",
  ),
  postconds: (
    "Il Gateway si trova nello stato impostato; se disabilitato, non invierà più dati al cloud",
  ),
  trigger: "L’Attore vuole abilitare/disabilitare lo stato di un Gateway",
  main-scen: (
    (
      descr: "L’Attore imposta lo stato desiderato (abilitato o disabilitato) per il Gateway",
      inc: "selezione_stato_gateway",
    ),
    (descr: "L’Attore conferma l’operazione idempotente di cambio di stato"),
  ),

  uml-descr: "Diagramma Modifica stato del Gateway",
)
