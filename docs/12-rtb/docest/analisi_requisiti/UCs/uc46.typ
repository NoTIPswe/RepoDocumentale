#import "template.typ": *

#uc_main("Accesso Audit e Tracciamento")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - L'utente ha i permessi di audit.\
  *Post-condizioni:* \
  - I log delle operazioni sono consultati.\
  *Scenario principale:* \
  + L'Admin accede al registro di Audit.
  + L'Admin consulta le operazioni svolte (chi ha fatto cosa e quando) $arrow$ Vedi [@UC46.1[UC46.1,]].
  + (Opzionale) L'Admin esporta i log per conformità legale $arrow$ Vedi [@UC46.2[UC46.2,]].\
  *Inclusioni:* \
  - [@UC46.1[UC46.1,]]
  - [@UC46.2[UC46.2,]]\
  *Trigger:* Indagine di sicurezza o compliance.\

  #uc_sub("Consultazione Log Audit")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Il registro audit è aperto.\
  *Post-condizioni:* \
  - I dati visualizzati sono filtrati.\
  *Scenario principale:* \
  + L'Admin filtra i log per utente, tipo di azione (es. Cancellazione) o intervallo temporale.\
  *Trigger:* Ricerca di eventi specifici.\

  #uc_sub("Esportazione Log Audit")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - I log sono visualizzati.\
  *Post-condizioni:* \
  - File di log scaricato.\
  *Scenario principale:* \
  + L'Admin richiede il download dei log in formato CSV/PDF certificato.\
  *Trigger:* Necessità di archiviazione esterna.\