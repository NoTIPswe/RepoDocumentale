#import "template.typ": *

#uc_main("Gestione Stato Alert (Acknowledge/Risoluzione)")
  *Attore principale:* Amministratore del Tenant\
  *Pre-condizioni:* \
  - Esiste un allarme attivo.\
  *Post-condizioni:* \
  - Lo stato dell'allarme è aggiornato.\
  *Scenario principale:* \
  + L'Utente seleziona un allarme attivo.
  + L'Utente esegue l'azione di "Presa in carico" (Acknowledge) o "Risoluzione".
  + Il Sistema registra l'utente che ha gestito l'evento e l'orario.\
  *Scenari alternativi:* \
  - Errore durante l'aggiornamento $arrow$ Vedi [@UC44[UC44,]].\
  *Estensioni:* \
  - [@UC44[UC44,]]\
  *Trigger:* Gestione operativa di un incidente.\