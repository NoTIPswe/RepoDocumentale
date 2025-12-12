#import "template.typ": *

#uc_main("Attivazione/Disattivazione Sensore")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Il sensore è registrato.\
  *Post-condizioni:* \
  - Lo stato del sensore cambia in "Attivo" o "Inattivo".
  - Se inattivo, i dati ricevuti vengono scartati o archiviati senza processing.\
  *Scenario principale:* \
  + L'Amministratore seleziona il sensore dalla lista.
  + L'Amministratore modifica lo stato operativo (Abilita/Disabilita).
  + Il Sistema richiede una conferma dell'operazione.
  + L'Amministratore conferma.
  + Il Sistema aggiorna lo stato nel registro centrale.\
  *Scenari alternativi:* \
  - Errore durante l'aggiornamento dello stato $arrow$ Vedi [@UC22[UC22,]].\
  *Estensioni:* \
  - [@UC22[UC22,]]\
  *Trigger:* Manutenzione del sensore, sostituzione batterie o dismissione temporanea.\