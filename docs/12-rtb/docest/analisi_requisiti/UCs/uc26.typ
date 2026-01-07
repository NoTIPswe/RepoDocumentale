#import "template.typ": *

#uc_main("Errore Autenticazione API")
*Attore principale:* Client Esterno\
*Pre-condizioni:* \
- Un Client tenta di accedere a una risorsa protetta.\
*Post-condizioni:* \
- L'accesso è negato.
- Il Client riceve un codice di errore (HTTP 401/403).\
*Scenario principale:* \
+ Il Client invia una richiesta includendo un Token o API Key.
+ Il Sistema rileva che le credenziali sono mancanti, scadute, revocate o insufficienti.
+ Il Sistema rifiuta la richiesta restituendo un messaggio di errore di autenticazione.\
*Trigger:* Utilizzo di credenziali invalide o scadute da parte del client.\
