#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "selezione_range_numerico",
  system: CLOUD_SYS,
  title: "Selezione range numerico misurazioni",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il sistema ha recuperato i limiti minimi e massimi assoluti supportati dall'hardware del sensore",
    "L’attore ha selezionato un sensore specifico",
  ),
  postconds: (
    "L’attore ha inserito un range numerico valido (min <= max)",
  ),
  trigger: "L’attore principale vuole inserire un range su cui effettuare le misurazioni",
  main-scen: (
    (
      descr: "L’attore seleziona il valore minimo per le misurazioni",
      inc: "inserimento_valore_numerico",
    ),
    (
      descr: "L’attore seleziona il valore massimo per le misurazioni",
      inc: "inserimento_valore_numerico",
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
)