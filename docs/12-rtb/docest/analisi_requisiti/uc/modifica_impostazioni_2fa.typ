#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "modifica_impostazioni_2fa",
  system: CLOUD_SYS,
  title: "Modifica impostazioni 2FA login dashboard",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "L’attore si trova nella sezione di impostazioni della 2FA",
  ),
  postconds: (
    "Le impostazioni di 2FA per il login nel tenant sono state aggiornate",
  ),
  trigger: "L’attore desidera modificare le impostazioni di 2FA per garantire il corretto livello di sicurezza agli account del tenant",
  main-scen: (
    (descr: "L’attore abilita/disabilita la 2FA per gli account afferenti al Tenant"),
  ),
)
