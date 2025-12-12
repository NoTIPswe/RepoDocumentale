#import "template.typ": *

#uc_main("Fallimento Caricamento o Salvataggio Dati")
  *Attore principale:* Utente del Tenant\
  *Pre-condizioni:* \
  - L'utente sta interagendo con la dashboard o i form di gestione.\
  *Post-condizioni:* \
  - L'azione non viene completata e viene notificato un errore.\
  *Scenario principale:* \
  + Il Sistema tenta di caricare dati o salvare modifiche via API.
  + Si verifica un errore (Timeout server, Dati non trovati, Errore validazione form, Conflitto).
  + Il Sistema mostra un avviso visivo (Toast notification o Modale) spiegando il problema e suggerendo azioni correttive (es. "Riprova").\
  *Trigger:* Fallimento caricamento dati, timeout di rete o input non valido.\