#import "template.typ": *

#uc_main("Recupero Password")
  *Attore principale:* Utente del Tenant\
  *Pre-condizioni:* \
  - L'utente non ricorda la password di accesso.\
  *Post-condizioni:* \
  - La password è stata aggiornata e l'utente può effettuare il login con le nuove credenziali.\
  *Scenario principale:* \
  + L'Utente richiede il reset della password inserendo la propria email $arrow$ Vedi [@UC31.1[UC31.1,]].
  + Il Sistema invia un link temporaneo via email.
  + L'Utente clicca sul link e inserisce la nuova password $arrow$ Vedi [@UC31.2[UC31.2,]].
  + Il Sistema aggiorna le credenziali nel database.\
  *Inclusioni:* \
  - [@UC31.1[UC31.1,]]
  - [@UC31.2[UC31.2,]]\
  *Trigger:* Smarrimento delle credenziali di accesso.\

  #uc_sub("Richiesta Reset Password")
  *Attore principale:* Utente del Tenant\
  *Pre-condizioni:* \
  - L'utente si trova nella pagina "Password Dimenticata".\
  *Post-condizioni:* \
  - Una email con il token di recupero viene accodata per l'invio.\
  *Scenario principale:* \
  + L'Utente inserisce l'email associata al proprio account.
  + Il Sistema verifica l'esistenza dell'account e genera un token di reset univoco.\
  *Trigger:* Necessità di avviare il processo di recupero.\

  #uc_sub("Impostazione Nuova Password")
  *Attore principale:* Utente del Tenant\
  *Pre-condizioni:* \
  - L'utente ha cliccato su un link di reset valido.\
  *Post-condizioni:* \
  - La nuova password è salvata cifrata nel database.\
  *Scenario principale:* \
  + L'Utente inserisce la nuova password rispettando i requisiti di complessità (lunghezza, caratteri speciali).
  + L'Utente conferma la nuova password nel campo di verifica.
  + Il Sistema valida la corrispondenza e aggiorna il record utente.\
  *Trigger:* Accesso alla pagina di reset tramite link sicuro.\