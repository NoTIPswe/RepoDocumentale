#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  id: "modifica_impostazioni_2fa",
  system: CLOUD_SYS,
  title: "Modifica impostazioni 2FA login dashboard",
  level: 1,
  prim-actors: CA.tenant-adm,
  preconds: (
    "Il Sistema mostra all’Attore primario le impostazioni della 2FA",
  ),
  postconds: (
    "Le impostazioni di 2FA per il login nel tenant sono state aggiornate",
  ),
  trigger: "L'Attore vuole abilitare/disabilitare la 2FA per il Tenant",
  main-scen: (
    (descr: "L’Attore abilita/disabilita la 2FA per gli account afferenti al Tenant"),
  ),
)[#uml-schema("63", "Diagramma Modifica impostazioni 2FA login dashboard")]
