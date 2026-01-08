#import "template.typ": *

#uc_main("Errore Dati Tenant Non Validi")
  *Attore principale:* Amministratore Sistema\
  *Pre-condizioni:* \
  - L'Amministratore sta inserendo o modificando i dati di un Tenant.\
  *Post-condizioni:* \
  - L'operazione non viene completata.
  - Il Sistema mostra un messaggio di errore relativo ai dati inseriti.\
  *Scenario principale:* \
  + Il Sistema esegue la validazione dei dati di input.
  + Il Sistema rileva una non conformità (es. Nome duplicato, Quote negative, Email admin non valida).
  + Il Sistema blocca il salvataggio e richiede la correzione dei campi evidenziati.\
  *Trigger:* Inserimento di dati non conformi alle regole di validazione durante Creazione o Configurazione.\