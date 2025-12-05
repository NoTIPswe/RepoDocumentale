#import "template.typ": *

#uc_main("Creazione Utente")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - L'Admin Tenant vuole aggiungere un collaboratore al proprio team.\
  *Post-condizioni:* \
  - Il nuovo utente è creato e associato al Tenant.\
  *Scenario principale:* \
  + L'Admin seleziona "Aggiungi Utente" nella sezione gestione utenti.
  + L'Admin inserisce i dati anagrafici e le credenziali iniziali $arrow$ Vedi [@UC36.1[UC36.1,]].
  + L'Admin assegna il ruolo appropriato $arrow$ Vedi [@UC36.2[UC36.2,]].
  + Il Sistema salva il nuovo profilo e invia l'email di benvenuto.\
  *Scenari alternativi:* \
  - Email già presente o dati non validi $arrow$ Vedi [@UC40[UC40,]].\
  *Inclusioni:* \
  - [@UC36.1[UC36.1,]]
  - [@UC36.2[UC36.2,]]\
  *Estensioni:* \
  - [@UC40[UC40,]]\
  *Trigger:* Espansione del team operativo del cliente.\

  #uc_sub("Inserimento Dati Anagrafici")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Il form di creazione utente è aperto.\
  *Post-condizioni:* \
  - I dati identificativi sono inseriti.\
  *Scenario principale:* \
  + L'Admin inserisce il Nome e il Cognome del collaboratore.
  + L'Admin inserisce l'indirizzo Email (che fungerà da username).\
  *Trigger:* Definizione dell'identità del nuovo utente.\

  #uc_sub("Assegnazione Ruolo")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - I dati anagrafici sono stati inseriti.\
  *Post-condizioni:* \
  - I permessi di accesso sono definiti.\
  *Scenario principale:* \
  + L'Admin seleziona dal menu a tendina il livello di permessi (es. "Sola Lettura" per operatori, "Admin" per gestori) da assegnare al nuovo account.\
  *Trigger:* Necessità di limitare o concedere privilegi operativi.\