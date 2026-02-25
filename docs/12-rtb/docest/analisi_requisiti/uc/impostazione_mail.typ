#import "../uc_lib.typ": CA, CLOUD_SYS, uc

#uc(
  id: "impostazione_mail",
  system: CLOUD_SYS,
  title: "Impostazione mail",
  level: 1,
  prim-actors: (CA.authd-usr,),
  preconds: (
    "Il Sistema richiede l’inserimento di una nuova mail per l’account",
  ),
  postconds: (
    "L’indirizzo mail inserito è stato validato",
  ),
  trigger: "L'Attore ha la necessità di definire un nuovo indirizzo mail",
  main-scen: (
    (
      descr: "L'Attore inserisce la mail nel campo dedicato",
      inc: "inserimento_nuova_mail",
    ),
    (
      descr: "L'Attore conferma la mail reinserendolo nel campo apposito",
      inc: "conferma_nuova_mail",
    ),
  ),
  uml-descr: "Diagramma Impostazione mail",
)