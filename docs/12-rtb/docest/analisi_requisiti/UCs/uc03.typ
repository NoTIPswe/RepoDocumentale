#import "template.typ": *

#uc_main("Configurazione Tenant")
  *Attore principale:* Amministratore Sistema\
  *Pre-condizioni:* \
  - L'Amministratore di Sistema è autenticato.
  - Esiste almeno un Tenant attivo nel sistema.\
  *Post-condizioni:* \
  - Le configurazioni del Tenant sono state aggiornate.\
  *Scenario principale:* \
  + L'Amministratore seleziona un Tenant dalla lista.
  + L'Amministratore modifica le quote risorse $arrow$ Vedi [@UC3.1[UC3.1,]].
  + L'Amministratore configura i permessi globali $arrow$ Vedi [@UC3.2[UC3.2,]].
  + (Opzionale) L'Amministratore configura le opzioni di sicurezza $arrow$ Vedi [@UC3.3[UC3.3,]].
  + L'Amministratore salva le modifiche.\
  *Scenari alternativi:* \
  - I nuovi parametri inseriti non sono validi $arrow$ Vedi [@UC2[UC2,]].
  - Errore di sistema durante il salvataggio $arrow$ Vedi [@UC6[UC6,]].\
  *Inclusioni:* \
  - [@UC3.1[UC3.1,]]
  - [@UC3.2[UC3.2,]]
  - [@UC3.3[UC3.3,]]\
  *Estensioni:* \
  - [@UC2[UC2,]]
  - [@UC6[UC6,]]\
  *Trigger:* Necessità di aggiornare i parametri contrattuali o tecnici di un cliente.\

  #uc_sub("Modifica Quote Risorse")
  *Attore principale:* Amministratore Sistema\
  *Pre-condizioni:* \
  - Pannello di configurazione Tenant aperto.\
  *Post-condizioni:* \
  - Nuovi limiti di risorse applicati.\
  *Scenario principale:* \
  + L'Amministratore modifica i valori massimi di risorse utilizzabili (es. Storage, N. Gateway).\
  *Trigger:* Aggiornamento del piano contrattuale del cliente.\

  #uc_sub("Configurazione Permessi Globali Tenant")
  *Attore principale:* Amministratore Sistema\
  *Pre-condizioni:* \
  - Pannello di configurazione Tenant aperto.\
  *Post-condizioni:* \
  - Permessi aggiornati.\
  *Scenario principale:* \
  + L'Amministratore abilita o disabilita moduli funzionali specifici per il Tenant.\
  *Trigger:* Abilitazione di nuove feature per il cliente.\

  #uc_sub("Configurazione Opzioni di Sicurezza")
  *Attore principale:* Amministratore Sistema\
  *Pre-condizioni:* \
  - Pannello di configurazione Tenant aperto.\
  *Post-condizioni:* \
  - Policy di sicurezza applicate.\
  *Scenario principale:* \
  + L'Amministratore imposta regole di sicurezza avanzate (es. MFA obbligatoria, IP whitelist).\
  *Trigger:* Richiesta di maggiore sicurezza o compliance.\