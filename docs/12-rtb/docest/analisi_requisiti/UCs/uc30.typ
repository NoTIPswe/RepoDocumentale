#import "template.typ": *

#uc_main("Logout Utente")
  *Attore principale:* Utente del Tenant\
  *Pre-condizioni:* \
  - L'Utente è autenticato.\
  *Post-condizioni:* \
  - La sessione è terminata e l'utente è reindirizzato alla pagina di login.\
  *Scenario principale:* \
  + L'Utente seleziona l'opzione di disconnessione dal menu utente.
  + Il Sistema invalida il token di sessione lato server.
  + Il Sistema pulisce i dati locali sensibili (cookie/local storage).\
  *Trigger:* Termine delle operazioni o timeout di inattività.\