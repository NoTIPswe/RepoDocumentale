#import "template.typ": *

#uc_main("Configurazione Gateway")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Il Gateway è attivo e associato al Tenant.
  - L'Amministratore Tenant è autenticato.\
  *Post-condizioni:* \
  - I parametri operativi del Gateway sono aggiornati.\
  *Scenario principale:* \
  + L'Amministratore Tenant accede alla pagina di configurazione del Gateway.
  + L'Amministratore gestisce la lista dei sensori collegati.
  + L'Amministratore imposta la frequenza di invio dati $arrow$ Vedi [@UC9.1[UC9.1,]].
  + L'Amministratore configura i parametri di sicurezza locali $arrow$ Vedi [@UC9.2[UC9.2,]].
  + L'Amministratore salva la configurazione.\
  *Scenari alternativi:* \
  - L'Amministratore decide di registrare un nuovo sensore non presente in lista $arrow$ Vedi [@UC16[UC16,]].
  - L'Amministratore decide di aggiornare il firmware (opzionale) $arrow$ Vedi [@UC10[UC10,]].
  - I parametri inseriti (es. frequenza negativa) non sono validi $arrow$ Vedi [@UC14[UC14,]].
  - Il Gateway non conferma la ricezione della configurazione (Timeout) $arrow$ Vedi [@UC15[UC15,]].\
  *Inclusioni:* \
  - [@UC9.1[UC9.1,]]
  - [@UC9.2[UC9.2,]]\
  *Estensioni:* \
  - [@UC16[UC16,]]
  - [@UC10[UC10,]]
  - [@UC14[UC14,]]
  - [@UC15[UC15,]]\
  *Trigger:* Necessità di modificare il comportamento del Gateway o aggiornare i sensori.\

  #uc_sub("Configurazione Frequenza Invio Dati")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - La configurazione del Gateway è in corso.\
  *Post-condizioni:* \
  - Il valore della frequenza di trasmissione è impostato.\
  *Scenario principale:* \
  + L'Amministratore inserisce l'intervallo di tempo (es. in secondi) tra due invii consecutivi di dati al Cloud.\
  *Trigger:* Necessità di bilanciare la freschezza del dato con il consumo di banda/risorse.\

  #uc_sub("Configurazione Parametri di Sicurezza")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - La configurazione del Gateway è in corso.\
  *Post-condizioni:* \
  - Le opzioni di sicurezza locale sono definite.\
  *Scenario principale:* \
  + L'Amministratore abilita o disabilita opzioni specifiche come la cifratura del buffer locale o il blocco delle porte fisiche inutilizzate.\
  *Trigger:* Adeguamento ai requisiti di sicurezza del Tenant.\