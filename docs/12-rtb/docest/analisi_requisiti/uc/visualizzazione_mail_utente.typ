#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "visualizzazione_mail_utente",
  system: CLOUD_SYS,
  title: "Visualizzazione mail dell’utente",
  level: 3,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L'indirizzo email associato all'account dell'utente è disponibile nel contesto corrente",
  ),
  postconds: (
    "L'indirizzo email dell'utente è visibile",
  ),
  trigger: "Necessità di conoscere i recapiti digitali dell'utente",
  main-scen: (
    (descr: "L’attore visualizza l'indirizzo email primario utilizzato dall'utente per la comunicazione e il login"),
  ),
)