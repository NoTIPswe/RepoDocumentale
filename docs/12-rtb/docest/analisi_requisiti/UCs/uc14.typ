#import "template.typ": *

#uc_main("Dati Gateway Non Validi")
  *Attore principale:* Amministratore Sistema / Amministratore Tenant\
  *Pre-condizioni:* \
  - L'Amministratore sta inserendo dati per provisionare, configurare o attivare un Gateway.\
  *Post-condizioni:* \
  - L'operazione non viene completata.
  - Viene mostrato un messaggio di errore relativo ai dati inseriti.\
  *Scenario principale:* \
  + Il Sistema valida i dati di input ricevuti (es. ID Gateway, Frequenza, Soglie).
  + Il Sistema rileva un formato non valido, un duplicato o un valore fuori range.
  + Il Sistema blocca il salvataggio e richiede la correzione dei campi evidenziati.\
  *Trigger:* Inserimento di dati non conformi alle regole di validazione.\