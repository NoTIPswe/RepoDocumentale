#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#uc(
  id: "inserimento_anagrafica_tenant",
  system: CLOUD_SYS,
  title: "Inserimento dati anagrafici Tenant",
  level: 2,
  prim-actors: CA.sys-adm,
  preconds: (
    "L’attore primario è nella procedura di creazione Tenant",
  ),
  postconds: (
    "L’attore primario inserisce dei dati anagrafici validi per il Tenant",
  ),
  trigger: "Il sistema richiede dei dati anagrafici da associare ad un Tenant",
  main-scen: (
    (descr: "L’attore inserisce il nome del Tenant"),
    // bookmark - chiedere all'azienda che informazioni è di interesse memorizzare per un tenant
    // PIVA
    // mail 
    // numero di telefono
    // ... (classici, nulla di più rispetto a info di contatto)
  ),
)
