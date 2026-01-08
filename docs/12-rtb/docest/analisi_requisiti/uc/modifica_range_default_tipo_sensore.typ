#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "modifica_range_default_tipo_sensore",
  system: CLOUD_SYS,
  title: "Modifica range alert default per tipo sensore",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’attore primario si trova nella sezione dedicata alla modifica",
    "Esiste almeno un tipo di sensore configurato nel sistema per il quale è possibile modificare il range di default",
  ),
  postconds: (
    "Ogni nuovo sensore del tipo selezionato, di default, invierà alert per misurazioni al di fuori del range impostato",
  ),
  trigger: "L’attore principale vuole cambiare il range dell’alert di default per tutti i sensori di un certo tipo",
  main-scen: (
    (
      descr: "L’attore primario seleziona il tipo di sensore",
      inc: "selezione_tipo_sensore",
    ),
    (descr: "L’Attore visualizza il range corrente"),
    (
      descr: "L’attore seleziona il range numerico per le misurazioni attese",
      inc: "selezione_range_numerico",
    ),
    (descr: "L’attore salva le modifiche"),
  ),
)
