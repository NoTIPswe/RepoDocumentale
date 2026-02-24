#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "modifica_range_sensore",
  system: CLOUD_SYS,
  title: "Modifica range alert sensore specifico",
  level: 1,
  prim-actors: CA.tenant-adm,
  sec-actors: CA.p-gway,
  preconds: (
    "Il sensore appartiene ad un Gateway attivo",
    "Il sensore risulta in funzione",
  ),
  postconds: (
    "Il sensore invierà alert per misurazioni al di fuori del range di valori selezionato",
  ),
  trigger: "L’Attore vuole cambiare il range dell’alert per un sensore specifico",
  main-scen: (
    (
      descr: "L’Attore seleziona il sensore",
      inc: "selezione_specifico_sensore",
    ),
    (descr: "L’Attore visualizza il range corrente"),
    (
      descr: "L’Attore seleziona il range numerico per le misurazioni attese",
      inc: "selezione_range_numerico",
    ),
    (
      descr: "L’Attore salva le modifiche",
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

  uml-descr: "Diagramma Modifica range alert sensore specifico",
)
