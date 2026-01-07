#import "template.typ": *

#uc_main("Login Utente")
*Attore principale:* Utente non Autenticato\
*Pre-condizioni:* \
- Il Sistema è attivo e raggiungibile via Web Console.\
*Post-condizioni:* \
- L'Utente è autenticato e reindirizzato alla Home Page del proprio profilo.\
*Scenario principale:* \
+ L'Utente accede alla pagina di login.
+ L'Utente inserisce le credenziali (Email e Password) $arrow$ Vedi [@UC28.1[UC28.1,]].
+ Il Sistema verifica la validità delle credenziali.
+ Il Sistema genera una sessione attiva per l'utente.\
*Scenari alternativi:* \
- L'Utente ha l'autenticazione a due fattori (MFA) attiva $arrow$ Vedi [@UC29[UC29,]].
- Credenziali errate o account bloccato $arrow$ Vedi [@UC39[UC39,]].\
*Inclusioni:* \
- [@UC28.1[UC28.1,]]\
*Estensioni:* \
- [@UC29[UC29,]]
- [@UC39[UC39,]]\
*Trigger:* Necessità di accedere alle funzionalità riservate del portale.\

#uc_sub("Inserimento Credenziali")
*Attore principale:* Utente non Autenticato\
*Pre-condizioni:* \
- La pagina di login è visualizzata.\
*Post-condizioni:* \
- Le credenziali sono inviate al sistema per la verifica.\
*Scenario principale:* \
+ L'Utente digita il proprio indirizzo email nel campo username.
+ L'Utente digita la propria password sicura nel campo password.\
*Trigger:* Avvio della procedura di autenticazione.\
