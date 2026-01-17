#import "../uc_lib.typ": CA, CLOUD_SYS, uc, uml-schema

#uc(
  id: "err_mail_gia_registrata",
  system: CLOUD_SYS,
  title: "Errore - Mail Duplicata",
  level: 1,
  prim-actors: (CA.authd-usr,),
  preconds: (
    "La mail fornita risulta già associata a un altro account registrato nel Tenant",
  ),
  postconds: (
    "L’indirizzo mail non viene memorizzato",
  ),
  trigger: "Una mail fornita dall'Attore in fase di creazione di un Utente è già presente nel Tenant",
  main-scen: (
    (
      descr: "L’Attore viene notificato che la mail è già presente all'interno del Tenant",
    ),
    (
      descr: "L'Attore viene invitato ad inserirne una nuova",
    ),
  ),
)[
  #uml-schema("15", "Mail Duplicata")

]
