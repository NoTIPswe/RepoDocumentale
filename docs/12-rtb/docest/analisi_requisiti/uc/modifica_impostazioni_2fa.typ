#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "modifica_impostazioni_2fa",
  system: CLOUD_SYS,
  title: "Modifica impostazioni 2FA login dashboard",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’Attore si trova nella sezione di impostazioni della 2FA",
  ),
  postconds: (
    "Le impostazioni di 2FA per il login nel tenant sono state aggiornate",
  ),
  trigger: "L’Attore desidera modificare le impostazioni di 2FA per garantire il corretto livello di sicurezza agli account del tenant",
  main-scen: (
    (descr: "L’Attore abilita/disabilita la 2FA per gli account afferenti al Tenant"),
  ),
)[#uml-schema("62", "Modfica impostazioni 2FA login dashboard")]
