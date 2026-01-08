#import "template.typ": *

#uc_main("Registrazione Sensore")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - L'Amministratore Tenant è autenticato.
  - Esiste almeno un Gateway attivo associato al Tenant.
  - Il sensore è connesso fisicamente al Gateway.\
  *Post-condizioni:* \
  - Il nuovo sensore è registrato e associato al Gateway selezionato.
  - Il sistema è pronto a ricevere dati da tale sensore.\
  *Scenario principale:* \
  + L'Amministratore seleziona il Gateway a cui registrare il sensore.
  + L'Amministratore avvia la procedura di registrazione sensore.
  + L'Amministratore seleziona il tipo di sensore $arrow$ Vedi [@UC16.1[UC16.1,]].
  + L'Amministratore inserisce l'identificativo del sensore $arrow$ Vedi [@UC16.2[UC16.2,]].
  + Il Sistema valida l'univocità dell'ID e salva l'associazione nel database.\
  *Scenari alternativi:* \
  - L'ID del sensore è già presente o il tipo non è supportato $arrow$ Vedi [@UC21[UC21,]].
  - Errore durante il salvataggio nel database $arrow$ Vedi [@UC22[UC22,]].\
  *Inclusioni:* \
  - [@UC16.1[UC16.1,]]
  - [@UC16.2[UC16.2,]]\
  *Estensioni:* \
  - [@UC21[UC21,]]
  - [@UC22[UC22,]]\
  *Trigger:* Necessità di mappare un nuovo dispositivo fisico (simulato) sull'infrastruttura cloud.\

  #uc_sub("Selezione Tipo Sensore")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - La procedura di registrazione sensore è avviata.\
  *Post-condizioni:* \
  - Il tipo di sensore (es. Temperatura, Umidità) è selezionato.\
  *Scenario principale:* \
  + L'Amministratore visualizza la lista dei sensori supportati dal sistema.
  + L'Amministratore seleziona la tipologia corrispondente al dispositivo fisico.\
  *Trigger:* Necessità di specificare il modello dati del sensore.\

  #uc_sub("Inserimento ID Sensore")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Il tipo di sensore è stato selezionato.\
  *Post-condizioni:* \
  - L'identificativo univoco è inserito.\
  *Scenario principale:* \
  + L'Amministratore inserisce l'ID univoco (es. BLE MAC Address o UUID) che identifica il sensore fisico.\
  *Trigger:* Necessità di associare l'identità digitale a quella fisica.\