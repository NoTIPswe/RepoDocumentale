#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "modifica_range_default_tipo_sensore",
  system: CLOUD_SYS,
  title: "Modifica range alert default per tipo sensore",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Esiste un sensore di tipologia disponibile a modifiche nel Sistema",
  ),
  postconds: (
    "Ogni nuovo sensore del tipo selezionato, di default, invierà alert per misurazioni al di fuori del range impostato",
  ),
  trigger: "L’Attore vuole cambiare il range dell’alert di default per tutti i sensori di un certo tipo",
  main-scen: (
    (
      descr: "L’Attore seleziona il tipo di sensore",
      inc: "selezione_tipo_sensore",
    ),
    (descr: "L’Attore visualizza il range corrente"),
    (
      descr: "L'Attore seleziona il range numerico per le misurazioni attese",
      inc: "selezione_range_numerico",
    ),
    (descr: "L’Attore salva le modifiche"),
  ),
)[#uml-schema("46", "Modifica range alert default per tipo sensore")]
