#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "modifica_impostazioni_impersonificazione",
  system: CLOUD_SYS,
  title: "Modifica impostazioni impersonificazione",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il sistema mostra le impostazioni di impersonificazione relative al Tenant",
  ),
  postconds: (
    "Le modifiche apportate dall’Attore vengono salvate",
  ),
  trigger: "",
  main-scen: (
    (
      descr: "L’Attore abilita o disabilita la facoltà dell'Amministratore di Sistema di accedere come (“impersonare”) un Utente del tenant",
    ),
    (descr: "Le modifiche vengono salvate"),
    (descr: "L’Attore viene notificato del buon esito dell’operazione"),
  ),
)[#uml-schema("65", "Modifica impostazioni impersonificazione")]
