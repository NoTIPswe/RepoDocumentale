#import "template.typ": *

#uc_main("Errore Gestione Alert")
*Attore principale:* Amministratore Tenant\
*Pre-condizioni:* \
- L'Admin sta configurando o gestendo un alert.\
*Post-condizioni:* \
- L'operazione è annullata.\
*Scenario principale:* \
+ Il Sistema rileva parametri incoerenti (es. soglia impossibile) o un errore di database.
+ Il Sistema mostra un messaggio di errore e impedisce il salvataggio.\
*Trigger:* Input non valido o errore tecnico.\
