#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "modifica_impostazioni_impersonificazione",
  system: CLOUD_SYS,
  title: "Modifica impostazioni impersonificazione",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’attore si trova nella sezione dedicata alla modifica",
  ),
  postconds: (
    "Le modifiche apportate dall’Attore vengono salvate",
  ),
  trigger: "L’attore vuole modificare le impostazioni di impersonificazione relative al Tenant",
  main-scen: (
    (
      descr: "L’attore abilita o disabilita la facoltà dell'Amministratore di Sistema di accedere come (“impersonare”) un utente del tenant",
    ),
    (descr: "Le modifiche vengono salvate"),
    (descr: "L’Attore viene notificato del buon esito dell’operazione"),
  ),
)
