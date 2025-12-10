#import "template.typ": *

#uc_main("Autenticazione Client API")
  *Attore principale:* Client Esterno\
  *Pre-condizioni:* \
  - L'Applicazione Esterna possiede una API Key valida (o credenziali Client ID/Secret).\
  *Post-condizioni:* \
  - L'Applicazione ottiene un Token di accesso (es. JWT) per effettuare chiamate successive.\
  *Scenario principale:* \
  + L'Applicazione invia le credenziali all'endpoint di autenticazione.
  + Il Sistema valida le credenziali.
  + Il Sistema genera un Token di sessione con scadenza temporale e permessi associati (Scope).
  + Il Sistema restituisce il Token all'Applicazione.\
  *Scenari alternativi:* \
  - Credenziali errate o revocate $arrow$ Vedi [@UC26[UC26,]].\
  *Estensioni:* \
  - [@UC26[UC26,]]\
  *Trigger:* Necessità di accedere ai dati protetti del sistema.\