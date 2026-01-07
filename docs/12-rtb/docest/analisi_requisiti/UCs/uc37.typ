#import "template.typ": *

#uc_main("Modifica Utente")
*Attore principale:* Amministratore Tenant\
*Pre-condizioni:* \
- L'utente da modificare esiste nel Tenant.\
*Post-condizioni:* \
- I dati o i permessi dell'utente sono aggiornati.\
*Scenario principale:* \
+ L'Admin seleziona un utente dalla lista.
+ L'Admin modifica le informazioni (es. cambio ruolo, aggiornamento email).
+ L'Admin salva le modifiche.\
*Scenari alternativi:* \
- Errore nel salvataggio $arrow$ Vedi [@UC40[UC40,]].\
*Estensioni:* \
- [@UC40[UC40,]]\
*Trigger:* Necessità di cambiare privilegi o correggere dati anagrafici.\
