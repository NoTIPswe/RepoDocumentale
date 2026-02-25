#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "conferma_nuova_mail",
  system: CLOUD_SYS,
  title: "Conferma mail",
  level: 2,
  prim-actors: (CA.authd-usr,),
  preconds: (
    "L'Attore ha compilato il campo precedente con una mail valida e disponibile",
  ),
  postconds: (
    "La mail inserita come conferma coincide con la mail originale",
  ),
  trigger: "L'Attore compila il campo di conferma della mail",
  main-scen: (
    (
      descr: "L’Attore conferma l’indirizzo mail reinserendolo nel campo apposito",
      ep: "FallimentoValidazione",
    ),
  ),
  alt-scen: (
    (
      ep: "FallimentoValidazione",
      cond: "L’Attore inserisce due valori diversi nei due campi",
      uc: "err_campi_diversi",
    ),
  ),
)