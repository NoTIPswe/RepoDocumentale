#import "template.typ": *

#uc_main("Dati Sensore Non Validi")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Un'operazione di gestione sensore (Registrazione, Configurazione) è in corso.\
  *Post-condizioni:* \
  - L'operazione viene annullata e le modifiche non sono salvate.\
  *Scenario principale:* \
  + Il Sistema rileva un errore di validazione (es. ID Sensore duplicato nello stesso Gateway, Soglie Min > Max, Tipo sensore non compatibile).
  + L'operazione di salvataggio viene bloccata.
  + Il Sistema mostra un messaggio di errore specifico e evidenzia il campo non valido.\
  *Trigger:* Input dati errato o conflitto di configurazione.\