#import "template.typ": *

#uc_main("Attivazione Gateway Pre-Provisionato")
  *Attore principale:* Amministratore Sistema\
  *Pre-condizioni:* \
  - Il Gateway è stato provisionato (vedi [@UC7[UC7,]]).
  - Esiste un Tenant a cui associare il Gateway.\
  *Post-condizioni:* \
  - Il Gateway è attivo e associato a un Tenant specifico.\
  *Scenario principale:* \
  + L'Amministratore seleziona un Gateway dalla lista dei dispositivi "In attesa".
  + L'Amministratore seleziona il Tenant a cui associare il Gateway.
  + L'Amministratore conferma l'attivazione.
  + Il Sistema valida l'associazione, attiva il Gateway e invia una notifica all'Amministratore del Tenant.\
  *Scenari alternativi:* \
  - Il Tenant selezionato non è valido $arrow$ Vedi [@UC14[UC14,]].
  - Il Gateway non è raggiungibile o non risponde al comando di attivazione $arrow$ Vedi [@UC15[UC15,]].\
  *Estensioni:* \
  - [@UC14[UC14,]]
  - [@UC15[UC15,]]\
  *Trigger:* Consegna del Gateway al cliente o messa in opera.\