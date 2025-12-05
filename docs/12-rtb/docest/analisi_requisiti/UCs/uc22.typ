#import "template.typ": *

#uc_main("Errore Operazione Sensore")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - L'Amministratore tenta di modificare lo stato o eliminare un sensore.\
  *Post-condizioni:* \
  - L'operazione fallisce a causa di un errore tecnico.\
  *Scenario principale:* \
  + Il Sistema tenta di aggiornare il database o sincronizzare la configurazione.
  + Si verifica un errore interno (es. Database lock, Timeout).
  + Il Sistema notifica l'errore e non applica le modifiche.\
  *Trigger:* Guasto infrastrutturale momentaneo.\