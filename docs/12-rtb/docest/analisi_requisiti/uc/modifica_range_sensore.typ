#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "modifica_range_sensore",
  system: CLOUD_SYS,
  title: "Modifica range alert sensore specifico",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il Gateway relativo al sensore interessato è raggiungibile",
  ),
  postconds: (
    "Il sensore invierà alert per misurazioni al di fuori del range di valori selezionato",
  ),
  trigger: "L’attore principale vuole cambiare il range dell’alert per un sensore specifico",
  main-scen: (
    (
      descr: "L’attore seleziona il sensore",
      inc: "selezione_specifico_sensore",
    ),
    (descr: "L’Attore visualizza il range corrente"),
    (
      descr: "L’attore seleziona il range numerico per le misurazioni attese",
      inc: "selezione_range_numerico",
    ),
    (
      descr: "L’attore salva le modifiche",
      ep: "RangeInvalido",
    ),
  ),
  alt-scen: (
    (
      ep: "RangeInvalido",
      cond: "Il range inserito non è valido (min > max)",
      uc: "err_range_invalido",
    ),
  ),
)[#uml-schema("42", "Modifica range alert sensore specifico")]
